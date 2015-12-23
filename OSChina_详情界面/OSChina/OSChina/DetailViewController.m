//
//  DetailViewController.m
//  OSChina
//
//  Created by polyent on 15/12/23.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+Util.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import "AFHTTPRequestOperationManager+Util.h"
#import <Ono.h>
#import <TBXML.h>
#import "OSCBaseObject.h"
#import "Software.h"
#import "OSCAPI.h"
#import "OSCSoftwareDetails.h"
@interface DetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) NSString *detailsURL;//详情url
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) Class detailsClass;
@property(nonatomic,assign) SEL loadMethod;//SEL 指向
@end

@implementation DetailViewController


/**
 *  软件详情展示
 *
 *  @param software tableView传入软件简略信息
 *
 *  @return 详情信息
 */
- (instancetype)initWithSoftware:(Software *)software
{
    self = [super initWithSwitchMode:YES];
    if (!self) {return nil;}
    
    //    _commentType = CommentTypeSoftware;
    //    _favoriteType = FavoriteTypeSoftware;
    
    // self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"软件详情";
    _detailsURL = [NSString stringWithFormat:@"%@%@?ident=%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_DETAIL, software.url.absoluteString.lastPathComponent];
    _tag = @"software";
    //    _softwareName = software.name;
    _detailsClass = [OSCSoftwareDetails class];
    _loadMethod = @selector(loadSoftwareDetails:);
    
    return self;
}


- (void)loadSoftwareDetails:(OSCSoftwareDetails*)details{
    NSLog(@"%@",[[NSBundle mainBundle] resourceURL]);
    [_detailsView loadHTMLString:details.html baseURL:[[NSBundle mainBundle] resourceURL]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _detailsView = [UIWebView new];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.opaque = NO;
    _detailsView.backgroundColor = [UIColor themeColor];
    [self.view addSubview:_detailsView];
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"detailsView": _detailsView, @"bottomBar": self.editBar};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailsView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailsView][bottomBar]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
    
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    
    _manager = [AFHTTPRequestOperationManager OSCManager];
    
    [self fetchDetails];
    //    [self loadWebPageWithString:@"http://www.baidu.com"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}


/**
 *  加载一个url
 *
 *  @param urlString 网址
 */
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    //NSLog(urlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_detailsView loadRequest:request];
    [_HUD hide:YES afterDelay:1];
}

/**
 *  获取详情
 */
- (void)fetchDetails{
    [_manager GET:_detailsURL parameters:nil success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {
        NSString *response = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        TBXML *XML = [[TBXML alloc]initWithXMLString:response error:nil];
        ONOXMLElement *onoXML = [responseDocument.rootElement firstChildWithTag:_tag];
        if (!onoXML || onoXML.children.count <= 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            id details;
            if ([_tag isEqualToString:@"blog"] || [_tag isEqualToString:@"post"]) {     //tbxml
                //                TBXMLElement *element = XML.rootXMLElement;
                //                TBXMLElement *subElement = [TBXML childElementNamed:_tag parentElement:element];
                //                details = [[_detailsClass alloc] initWithTBXMLElement:subElement];
            }else {     //onoxml
                ONOXMLElement *XML = [responseDocument.rootElement firstChildWithTag:_tag];
                details = [[_detailsClass alloc] initWithXML:XML];
            }
            
            
            
            [self performSelector:_loadMethod withObject:details];
            
            //
            //            self.operationBar.isStarred = _isStarred;
            //
            //            UIBarButtonItem *commentsCountButton = self.operationBar.items[4];
            //            commentsCountButton.shouldHideBadgeAtZero = YES;
            //            commentsCountButton.badgeValue = [NSString stringWithFormat:@"%i", _commentCount];
            //            commentsCountButton.badgePadding = 1;
            //            commentsCountButton.badgeBGColor = [UIColor colorWithHex:0x24a83d];
            //
            //            if (_commentType == CommentTypeSoftware) {_objectID = ((OSCSoftwareDetails *)details).softwareID;}
            //
            //            [self setBlockForOperationBar];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_HUD hide:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
