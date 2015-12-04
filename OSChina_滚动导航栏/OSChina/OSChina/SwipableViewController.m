//
//  SwipableViewController.m
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "SwipableViewController.h"

@interface SwipableViewController ()

@end

@implementation SwipableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;//ios7向上漂移44px
        
        if(title){
            [self setTitle:title];
        }
        CGFloat titleBarHeight = 36;
        _titleBar = [[TitleBarView alloc] initWithFrameAndTitles:CGRectMake(0, 0, self.view.bounds.size.width, titleBarHeight)  andTitles:subTitles];
        [self.view addSubview:_titleBar];
        
        CGFloat horizonViewControllerHeight = self.view.bounds.size.height - titleBarHeight;
        _horizonViewController = [[HorizonTableViewController alloc] initWithViewControllers:controllers];
        _horizonViewController.view.frame = CGRectMake(0, titleBarHeight, self.view.bounds.size.width, horizonViewControllerHeight);
        [self.view addSubview:_horizonViewController.view];
        [self addChildViewController:_horizonViewController];
        
        __weak TitleBarView *weakTitleBar = _titleBar;
        __weak HorizonTableViewController *weakViewPager = _horizonViewController;
        
        
        _horizonViewController.changeIndex = ^(NSUInteger index) {
            [weakTitleBar setTitleButtonsColor:index];
            [weakViewPager scrollToViewAtIndex:index];
        };
        
        _horizonViewController.scrollView = ^(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex) {
            NSLog(@"scrollView scrollView scrollView");
            UIButton *titleFrom = weakTitleBar.titleBtns[animationIndex];
            UIButton *titleTo = weakTitleBar.titleBtns[focusIndex];
            CGFloat colorValue = (CGFloat)0x90 / (CGFloat)0xFF;
            
            [UIView transitionWithView:titleFrom duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [titleFrom setTitleColor:[UIColor colorWithRed:colorValue*(1-offsetRatio) green:colorValue blue:colorValue*(1-offsetRatio) alpha:1.0]
                                forState:UIControlStateNormal];
                titleFrom.transform = CGAffineTransformMakeScale(1 + 0.2 * offsetRatio, 1 + 0.2 * offsetRatio);
            } completion:nil];
            
            
            [UIView transitionWithView:titleTo duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [titleTo setTitleColor:[UIColor colorWithRed:colorValue*offsetRatio green:colorValue blue:colorValue*offsetRatio alpha:1.0]
                              forState:UIControlStateNormal];
                titleTo.transform = CGAffineTransformMakeScale(1 + 0.2 * (1-offsetRatio), 1 + 0.2 * (1-offsetRatio));
            } completion:nil];
        };
        
        _titleBar.titleButtonClicked = ^(NSUInteger index) {
            [weakTitleBar setTitleButtonsColor:index];
            [weakViewPager scrollToViewAtIndex:index];
        };
    }
    return self;
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
