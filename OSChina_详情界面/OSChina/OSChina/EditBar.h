//
//  EditBar.h
//  OSChina
//
//  Created by polyent on 15/12/20.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"
@interface EditBar : UIToolbar
@property(nonatomic,strong)UIButton* switchButton;
@property(nonatomic,strong)GrowingTextView* inputView;
@property(nonatomic,strong)UIButton* emojButton;
@property(nonatomic,copy)void (^sendContent)(NSString* content);
-(instancetype)initWithSwitchBtn:(BOOL)switchBtn;
@end
