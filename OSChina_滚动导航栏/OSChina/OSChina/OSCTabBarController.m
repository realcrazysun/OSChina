//
//  OSCTabBarController.m
//  OSChina1
//
//  Created by polyent on 15/11/29.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCTabBarController.h"
#import <RESideMenu/RESideMenu.h>
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "SGActionView.h"
#import "SwipableViewController.h"
@interface OSCTabBarController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)UIButton* centerButton;
@property(nonatomic,strong)UIView* tabbarView;

@end

@implementation OSCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController* controller1 = [[UIViewController alloc] init];
    controller1.view.backgroundColor = [UIColor redColor];
    
    UIViewController* controller2 = [[UIViewController alloc] init];
    controller2.view.backgroundColor = [UIColor blueColor];
    
    UIViewController* controller3 = [[UIViewController alloc] init];
    controller3.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController* controller4 = [[UIViewController alloc] init];
    controller4.view.backgroundColor = [UIColor grayColor];
    
    UIViewController* controller5 = [[UIViewController alloc] init];
    controller5.view.backgroundColor = [UIColor greenColor];
    
    UIViewController* controller6 = [[UIViewController alloc] init];
    controller6.view.backgroundColor = [UIColor greenColor];
    UIViewController* controller7 = [[UIViewController alloc] init];
    controller7.view.backgroundColor = [UIColor greenColor];
    UIViewController* controller8 = [[UIViewController alloc] init];
    controller8.view.backgroundColor = [UIColor greenColor];
    UIViewController* controller9 = [[UIViewController alloc] init];
    controller9.view.backgroundColor = [UIColor greenColor];
    SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"综合"
                                                                       andSubTitles:@[@"资讯", @"热点", @"博客", @"推荐"]
                                                                     andControllers:@[controller6, controller7, controller8,controller9]
                                                                        underTabbar:YES];

    self.viewControllers = @[
                             [self addNavigationItemForViewController:newsSVC],
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
}



-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

-(void)buttonPressed
{
    NSArray *buttonTitles = @[@"文字", @"相册", @"拍照", @"语音", @"扫一扫", @"找人"];
    NSArray *buttonImages = @[
                              [UIImage imageNamed:@"tweetEditing"],
                              [UIImage imageNamed:@"picture"],
                              [UIImage imageNamed:@"shooting"],
                              [UIImage imageNamed:@"sound"],
                              [UIImage imageNamed:@"scan"],
                              [UIImage imageNamed:@"search"],
                              ];
    
    void(^handler)(NSInteger) = ^(NSInteger index)
    {
        NSLog(@"index---: %d",(int)index);
        switch (index) {
            case 0: {
                
                break;
            }
            case 1: {
                break;
            }
            case 2: {
                
                break;
            }
            case 3: {
                break;
            }
            case 4: {
                break;
            }
            case 5: {
                break;
            }
            default: break;
        }
        
            
    };
    
    [SGActionView showGridMenuWithTitle:@"Grid View"
                             itemTitles:buttonTitles
                                 images:buttonImages
                         selectedHandle:handler];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark -  构造 UINavigationController

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    //
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                     target:self
                                                                                                     action:@selector(pushSearchViewController)];
    
    
    
    return navigationController;
}
-(void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}
-(void)pushSearchViewController
{
    NSLog(@"pushSearchViewController");
}
@end
