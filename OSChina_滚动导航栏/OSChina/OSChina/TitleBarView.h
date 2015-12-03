//
//  TitleBarView.h
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBarView : UIView
@property(nonatomic,strong) NSMutableArray* titleBtns;
@property(nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);//block代替协议 用copy放在堆中
-(instancetype)initWithFrameAndTitles:(CGRect)frame andTitles: (NSArray*) titles;
-(void)setTitleButtonsColor;
@end
