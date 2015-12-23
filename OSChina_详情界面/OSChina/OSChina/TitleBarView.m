//
//  TitleBarView.m
//  OSChina
//
//  Created by polyent on 15/12/3.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "TitleBarView.h"
#import "UIButton+TitleBar.h"
#import "UIColor+Util.h"

@implementation TitleBarView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrameAndTitles:(CGRect)frame andTitles: (NSArray*) titles
{
    self = [super initWithFrame:frame];
    
    _currentIndex = 0;
    _titleBtns = [NSMutableArray new];
    
    CGFloat btnWidth  = self.frame.size.width/titles.count;
    CGFloat btnHeight = self.frame.size.height;
    [titles enumerateObjectsUsingBlock:^(NSString* title,NSUInteger index,BOOL* stop){
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth*index, 0, btnWidth, btnHeight);
        btn.backgroundColor = [UIColor titleBarColor];
        btn.tag = index;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithNormalTitleBar] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleBtns addObject:btn];
        [self addSubview:btn];
        //        [self sendSubviewToBack:btn];
    }];
    UIButton *firstTitle = _titleBtns[0];
    [firstTitle setTitleColor:[UIColor colorWithClickedTitleBar] forState:UIControlStateNormal];
    firstTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    return self;
}

//按钮点击事件
-(void)click:(UIButton*) btn
{
    if (_currentIndex == btn.tag) {
        return;
    }
    
    //原来按钮还远
    UIButton *preBtn = _titleBtns[_currentIndex];
    [preBtn setTitleColor:[UIColor colorWithNormalTitleBar] forState:UIControlStateNormal];
    preBtn.transform = CGAffineTransformIdentity;// 重置大小
    
    //点击按钮变大
    UIButton *curBtn = _titleBtns[btn.tag];
    [curBtn setTitleColor:[UIColor colorWithClickedTitleBar] forState:UIControlStateNormal];
    curBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    _currentIndex = btn.tag;
    if (_titleButtonClicked) {
        _titleButtonClicked(btn.tag);
    }
    
}

-(void)setTitleButtonsColor:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    for (UIButton *button in _titleBtns) {
        if (button.tag != currentIndex) {
            [button setTitleColor:[UIColor colorWithNormalTitleBar] forState:UIControlStateNormal];
            button.transform = CGAffineTransformIdentity;
        } else {
            [button setTitleColor:[UIColor colorWithClickedTitleBar] forState:UIControlStateNormal];
            button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    }
    
}
@end
