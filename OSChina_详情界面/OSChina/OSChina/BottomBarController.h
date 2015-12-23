//
//  BottomBarController.h
//  OSChina
//
//  Created by polyent on 15/12/20.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditBar.h"
@interface BottomBarController : UIViewController
@property(nonatomic,strong)EditBar* editBar;
@property (nonatomic, strong) NSLayoutConstraint *editBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editBarHeightConstraint;

-(instancetype)initWithSwitchMode:(BOOL)hasSwitch;
@end
