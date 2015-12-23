//
//  SideMenuTableViewController.m
//  OSChina1
//
//  Created by polyent on 15/11/29.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "SoftwareCategoryViewController.h"
#import "RESideMenu.h"
#import "SwipableViewController.h"
#import "SoftwareViewController.h"
@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.bounces = NO;//禁止拖动
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//表格分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma -- mark herderView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //    OSCUser *myProfile = [Config myProfile];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    //圆角头像
    UIImageView *avatar = [UIImageView new];
    avatar.contentMode = UIViewContentModeScaleAspectFit;
    [avatar setCornerRadius:30];
    avatar.userInteractionEnabled = YES;
    
    //禁止autoresizing自动转换autolayout
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:avatar];
    avatar.image = [UIImage imageNamed:@"default-portrait"];
    
    //姓名标签
    UILabel *nameLabel = [UILabel new];
    
#warning 应该从OSCUser中读取
    nameLabel.text = @"crazysun";
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    //垂直方向  宽度 高度都为60 难怪上面 setCornerRadius写了 30  不要写顶部  headerView高度 160 控制住了
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    //水平方向
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    
    
    //触摸事件 点击登陆
    avatar.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    
    return headerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"appear");
    
}

-(void)pushLoginPage
{
    NSLog(@"登陆页面");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
 
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_QA", @"sidemenu-software", @"sidemenu_blog", @"sidemenu_setting", @"sidemenu-night"][indexPath.row]];
    cell.textLabel.text = @[@"技术问答", @"开源软件", @"博客区", @"设置", @"夜间模式", @"注销"][indexPath.row];
    

    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];

    
    return cell;
    
}

//跳转连接 注意didSelectRowAtIndexPath 与 didDeSelectRowAtIndexPath区别  选中行 与 取消选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
    NSLog(@"indexPath.row:%ld",indexPath.row);
    switch (indexPath.row) {
        case 0:{
            //跳转到技术问答
            [self gotoTechQuestionAndAnswer];
            break;
        }
        case 1:
        {
            //跳转到开源软件
            [self gotoOpenSourceSoftware];
            break;
        }
        case 2:
        {
            //跳转到博客
            [self gotoBlog];
            break;
        }
        case 3:
        {
            //设置页面
            [self gotoSettingPage];
            break;
        }
        case 4:
        {
            //日夜模式
            [self changeMode];
            break;
        }
        default: break;

    }
}

-(void)gotoTechQuestionAndAnswer
{
    NSLog(@"gotoTechQuestionAndAnswer");
}

-(void)gotoOpenSourceSoftware
{
    NSLog(@"gotoOpenSourceSoftware");
    SoftwareCategoryViewController* softwareCategory = [[SoftwareCategoryViewController alloc] initWithTag:0];
    SoftwareViewController * recommend = [[SoftwareViewController alloc] initWithSoftwaresType:SoftwaresTypeRecommended];
    
    
    SwipableViewController* controller = [[SwipableViewController alloc] initWithTitle:@"软件" andSubTitles:@[@"分类",@"推荐"] andControllers:@[softwareCategory,recommend] underTabbar:YES];

    [self setContentViewController:controller];
}

-(void)gotoBlog
{
    NSLog(@"gotoBlog");
}
-(void)gotoSettingPage
{
    NSLog(@"gotoSettingPage");
}
-(void)changeMode
{
    NSLog(@"changeMode");
}


- (void)setContentViewController:(UIViewController *)viewController
{
//    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    //UIViewController *vc = nav.viewControllers[0];
    //vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [nav pushViewController:viewController animated:NO];
    
    [self.sideMenuViewController hideMenuViewController];
}
@end
