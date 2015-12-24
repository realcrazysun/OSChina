# 开源中国之庖丁解牛

一、开源中国主界面搭建
====
1、cocoapod & git
---
管理第三方库 pod install --verbose --no-repo-update<br>
git pull origin master  更新<br>
git push origin master  提交<br>
VVDocument--好用的注释插件<br>

2、第三方库ReSideMenu简单使用<br>
---
```c++
- (void)awakeFromNib
{
    //这段还没具体看
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    //设置主View
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    //设置侧边栏
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    
}

```
3、侧边栏SideMenuViewController
---
headerView中图像与名称布局<br>
```cpp
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    

```

4、主界面 OSCTabBarController
---
tabbar设置 通过占位形式添加中间的加号  也可以自定义tabbar
```
self.viewControllers = @[
                             [self addNavigationItemForViewController:controller1],
                             [self addNavigationItemForViewController:controller2],
                             [UIViewController new],
                             [self addNavigationItemForViewController:controller4],
                             [self addNavigationItemForViewController:controller5]
                             ];
    
    //定义tabbar样式  ---- enumerateObjectsUsingBlock 中设置各controller得tabItem  通过占位来实现
    NSArray *titles = @[@"综合", @"动弹", @"", @"发现", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    //中心的加号
    [self.tabBar.items[2] setEnabled:NO];//禁止加号按钮事件
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
```

点击加号出现底部弹出框(原代码难以理解。。用了个现成的SGActionView)<br>
一句话搞定 比较好用<br>
```
 [SGActionView showGridMenuWithTitle:@"Grid View"
                             itemTitles:buttonTitles
                                 images:buttonImages
                         selectedHandle:handler];

```



二、 SwipableViewController--横向滚动视图封装
---
SwipableViewController 用来是新闻内容的导航容器 由标题栏和横向滚动视图组成

  - TitleBarView
  - HorizonalTableViewController


### TitleBarView

继承自UIView(原代码继承自UIScrollViewController)
```
@interface TitleBarView : UIView
@property(nonatomic,strong) NSMutableArray* titleBtns;
@property(nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);//block代替协议
-(instancetype)initWithFrameAndTitles:(CGRect)frame andTitles: (NSArray*) titles;
@end
```
初始化方法
```
-(instancetype)initWithFrameAndTitles:(CGRect)frame andTitles: (NSArray*) titles
{
    self = [super initWithFrame:frame];
    _currentIndex = 0;
    _titleBtns = [NSMutableArray new];
    
    CGFloat btnWidth  = self.frame.size.width/titles.count;
    CGFloat btnHeight = self.frame.size.height;
    [titles enumerateObjectsUsingBlock:^(NSString* title,NSUInteger index,BOOL* stop){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth*index, 0, btnWidth, btnHeight);
        btn.backgroundColor = [UIColor titleBarColor];
        btn.tag = index;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithNormalTitleBar] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleBtns addObject:btn];
        [self addSubview:btn];
        //        [self sendSubviewToBack:btn];
    }];
    UIButton *firstTitle = _titleBtns[0];
    [firstTitle setTitleColor:[UIColor colorWithClickedTitleBar] forState:UIControlStateNormal];
    firstTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    return self;
}

```



### HorizonTableViewController

HorizonTableViewController是通过继承自UITableViewController来实现<br>
原作者这里写的有点奇怪 继承了UITableViewController但是又在ViewDidLoad中self.tableView = [UITableView new];<br>
核心思想是在ViewDidLoad中将tableView逆时针旋转90度 再在cellForRowAtIndexPath 将ViewController旋转回来  这样就实现了横向转动<br>
在滚动的同时对应的标题要有滚动效果<br>
```
- (void)scrollStop:(BOOL)didScrollStop
{
    CGFloat horizonalOffset = self.tableView.contentOffset.y;
    CGFloat screenWidth = self.tableView.frame.size.width;
    CGFloat offsetRatio = (NSUInteger)horizonalOffset % (NSUInteger)screenWidth / screenWidth;
    NSUInteger focusIndex = (horizonalOffset + screenWidth / 2) / screenWidth;
    
    
    NSLog(@"horizonalOffset---%d",horizonalOffset == focusIndex * screenWidth);//存在相等的情况
    if (horizonalOffset != focusIndex * screenWidth) {
        NSUInteger animationIndex = horizonalOffset > focusIndex * screenWidth ? focusIndex + 1: focusIndex - 1;
        if (focusIndex > animationIndex) {offsetRatio = 1 - offsetRatio;}
        if (_scrollView) {
            
            _scrollView(offsetRatio, focusIndex, animationIndex);
        }
    }
    if (didScrollStop) {

        _currentIndex = focusIndex;
        
        if (_changeIndex) {_changeIndex(focusIndex);}
    }

```
在SwipableViewController中实现scrollView block定义<br>


三、开源中国通用内容展示界面
---
这部分涉及的内容相当多，也做了很久 其中设计思路比较值得学习  如何通过继承和block来实现封装和多态
---
## - 网络通信
## - 通用内容展示MVC
### - model部分
- OSCBaseObject
- xml解析 ONO XML解析
- 重写isEqual方法 来避免重复加载数据<br>
### view部分
- 自定义TableViewCell 
- 代码VFL布局 参考SoftwareCell
                                                              

### - controller部分:OSCObjViewController
###这部分是封装内容展示的最主要部分 有些内容跟原代码有点区别<br>
MJRefresh的使用
```
 // 下拉刷新
    self.tableView.mj_header =   [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchMore];
    }];


```
GCD使用
```
#pragma mark --获取数据并放入object中  如果refresh则清空当前数据
-(void)fetchObjects:(NSUInteger)page refresh:(BOOL)refresh
{
    [_manager GET:self.generateURL(page)
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {

              NSArray *objectsXML = [self parseXML:responseDocument];
              
              if (refresh) {
                  _pageNum = 1;
                  [_objects removeAllObjects];//如果加载第0页则会清空当前_objects

              }else{
                  _pageNum++;
              }
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
              
         
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (objectsXML.count == 0 || (objectsXML.count < 20)){
                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                      }
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

              [self.tableView reloadData];
          }
     ];

```

图文混排 NSMutableAttributedString NSTextAttachment 使用
```
- (NSMutableAttributedString *)attributedTittle
{
    if (!_attributedTittle) {
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        if (_documentType == 0) {
            textAttachment.image = [UIImage imageNamed:@"widget_repost"];
        } else {
            textAttachment.image = [UIImage imageNamed:@"widget-original"];
        }
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        _attributedTittle = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:_title]];
    }
    
    return _attributedTittle;
}
```




