//
//  EmojiPageViewController.m
//  OSChina
//
//  Created by polyent on 15/12/22.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "EmojiPageViewController.h"
#import "UIColor+Util.h"
#import "EmojiViewController.h"

@interface EmojiPageViewController ()<UIPageViewControllerDataSource>
@property(nonatomic,strong)UITextView *textView;
@end

/**
 表情输入框
 
 - returns:
 */
@implementation EmojiPageViewController
/**
 *  用textView 初始化
 *
 *  @param textView 传入要更改的textView
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithTextView:(UITextView *)textView{
    if(self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                     options:nil]){
        
        _textView = textView;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化第一个view
    EmojiViewController * emojiViewController = [self emojiViewControllerForIndex:0];
    if (emojiViewController != nil) {
        self.dataSource = self;
        [self setViewControllers:@[emojiViewController]
                       direction:UIPageViewControllerNavigationDirectionReverse
                        animated:NO
                      completion:nil];
    }
    
}


- (EmojiViewController *) emojiViewControllerForIndex:(int)index{
    EmojiViewController *emojiViewController = [[EmojiViewController alloc] initWithIndex:0 andTextView:_textView];
    
    return emojiViewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EmojiViewController *)viewController{
    
    //    return nil;
    if (viewController.pageIndex == 0) {
        return nil;
    }
    
    int index = viewController.pageIndex - 1;
    
    EmojiViewController * emojiViewController = [[EmojiViewController alloc] initWithIndex:index andTextView:_textView];
    
    return emojiViewController;
}

- ( UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EmojiViewController *)viewController{
    
    if (viewController.pageIndex == 6) {
        return nil;
    }
    
    
    EmojiViewController * emojiViewController = [[EmojiViewController alloc] initWithIndex:viewController.pageIndex + 1 andTextView:_textView];
    
    return emojiViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 7;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
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
