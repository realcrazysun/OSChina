//
//  OSCTabBarController.m
//  OSChina1
//
//  Created by polyent on 15/11/29.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCTabBarController.h"
#import <RESideMenu/RESideMenu.h>

@interface OSCTabBarController ()<UINavigationControllerDelegate>

@end

@implementation OSCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController* controller1 = [[UIViewController alloc] init];
    controller1.view.backgroundColor = [UIColor redColor];
    
    UIViewController* controller2 = [[UIViewController alloc] init];
    controller2.view.backgroundColor = [UIColor blueColor];
    

    self.viewControllers = @[
                             [self addNavigationItemForViewController:controller1],
                             [self addNavigationItemForViewController:controller2],
                          
                             ];

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
