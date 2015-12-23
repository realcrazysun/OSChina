//
//  UIButton+TitleBar.m
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "UIButton+TitleBar.h"
#import "UIColor+Util.h"
@implementation UIButton (TitleBar)
+(instancetype)createTitleBarButton:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor titleBarColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithNormalTitleBar] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
@end
