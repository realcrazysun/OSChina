//
//  HorizonTableViewController.h
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *controllers;
@property(nonatomic,assign)NSUInteger currentIndex;
@property (nonatomic, copy) void (^scrollView)(CGFloat offsetRatio, NSUInteger focusIndex, NSUInteger animationIndex);
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;
@end
