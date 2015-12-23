//
//  SwipableViewController.h
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBarView.h"
#import "HorizonTableViewController.h"
@interface SwipableViewController : UIViewController
@property(nonatomic,strong) TitleBarView* titleBar;
@property(nonatomic,strong) HorizonTableViewController* horizonViewController;
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar;
- (void)scrollToViewAtIndex:(NSUInteger)index;
@end
