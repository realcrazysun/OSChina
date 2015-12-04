# SwipableViewController--横向滚动视图封装

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
