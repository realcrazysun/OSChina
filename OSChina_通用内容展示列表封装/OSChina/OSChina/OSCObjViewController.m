//
//  OSCObjViewController.m
//  OSChina
//
//  Created by polyent on 15/12/6.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCObjViewController.h"
#import "AFHTTPRequestOperationManager+Util.h"
#import "OSCBaseObject.h"
#import "MBProgressHUD.h"
#import "Utils.h"

@interface OSCObjViewController ()
@property(nonatomic,strong) AFHTTPRequestOperationManager * manager;
@property(nonatomic,assign) int pageNum;
@end

@implementation OSCObjViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _objects = [NSMutableArray new];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _pageNum = 1;
    __unsafe_unretained __typeof(self) weakSelf = self;
 
    // 马上进入刷新状态

    self.tableView.mj_header =   [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchMore];
    }];
    
    _lastCell = [[LastCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
//    [_lastCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fetchMore)]];
//    self.tableView.tableFooterView = _lastCell;

    [self.tableView.mj_header beginRefreshing];
    
    _manager = [AFHTTPRequestOperationManager OSCManager];
    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",_objects.count);
    return _objects.count;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    NSAssert("fale", @"override in subclass");
    return nil;
}

-(void)refresh
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_async here");
      
        [self fetchObjects:0 refresh:YES];
    });
   
}
-(void)fetchMore{
    [self fetchObjects:_pageNum refresh:NO];
}
#pragma mark - 上拉加载更多

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

#pragma mark --获取数据并放入object中  如果refresh则清空当前数据
-(void)fetchObjects:(NSUInteger)page refresh:(BOOL)refresh
{
    [_manager GET:self.generateURL(page)
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
//              _allCount = [[[responseDocument.rootElement firstChildWithTag:@"allCount"] numberValue] intValue];
//              
              NSArray *objectsXML = [self parseXML:responseDocument];
              
              if (refresh) {
                  _pageNum = 1;
                  [_objects removeAllObjects];//如果加载第0页则会清空当前_objects
//                  if (_didRefreshSucceed) {_didRefreshSucceed();} //消息中心
              }else{
                  _pageNum++;
              }
              
//              if (_parseExtraInfo) {_parseExtraInfo(responseDocument);}
              
              //这里并不是很好  每个数据都要进行判断
              for (ONOXMLElement *objectXML in objectsXML) {
                  BOOL shouldBeAdded = YES;
                  id obj = [[_objClass alloc] initWithXML:objectXML];
                  
                  for (OSCBaseObject *baseObj in _objects) {
                      if ([obj isEqual:baseObj]) {
                          shouldBeAdded = NO;
                          break;
                      }
                  }
                  if (shouldBeAdded) {
                      [_objects addObject:obj];
                  }
              }
              
//              if (_needAutoRefresh) {
//                  [_userDefaults setObject:_lastRefreshTime forKey:_kLastRefreshTime];
//              }
//              
              dispatch_async(dispatch_get_main_queue(), ^{
//                  if (self.tableWillReload) {self.tableWillReload(objectsXML.count);}
//                  else {
                  if (objectsXML.count == 0 || (objectsXML.count < 20)) {
//                          _lastCell.status = LastCellStatusFinished;
                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                      }
//                  }
//
                  
                  if (self.tableView.mj_header.isRefreshing) {
                      [self.tableView.mj_header endRefreshing];
                  }
                  if(self.tableView.mj_footer.isRefreshing){
                        [self.tableView.mj_footer endRefreshing];
                  }
                  
                  [self.tableView reloadData];
              });
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"http request failed");
              MBProgressHUD *HUD = [Utils createHUD];
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
              
              [HUD hide:YES afterDelay:1];
//
//              _lastCell.status = LastCellStatusError;
//              if (self.tableView.header.isRefreshing) {
//                  [self.tableView.header endRefreshing];
//              }
              [self.tableView reloadData];
          }
     ];

    //
}



@end
