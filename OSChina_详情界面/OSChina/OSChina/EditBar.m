//
//  EditBar.m
//  OSChina
//
//  Created by polyent on 15/12/20.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "EditBar.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
@implementation EditBar

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithSwitchBtn:(BOOL)switchBtn{
    if(self = [super init]){
//        self.backgroundColor = [UIColor themeColor];
        [self setBarTintColor:[UIColor themeColor]]; //修改backgroundcolor 没有用
        [self addBorder];//添加边界线
        [self initSubViews:switchBtn];//添加子控件
    }
    return self;
}

-(void)initSubViews:(BOOL)switchBtn{
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setImage:[UIImage imageNamed:@"toolbar-barSwitch"] forState:UIControlStateNormal];
    _emojButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
    
    _inputView                  = [[GrowingTextView alloc] initWithPlaceHolder:@"说点啥呢..."];
    _inputView.backgroundColor  = [UIColor themeColor];
    _inputView.returnKeyType    = UIReturnKeyDone;
    [_inputView setCornerRadius:5.0];
    
    NSArray* arr = @[_switchButton,_emojButton,_inputView];
    for (UIView* view in  arr) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_switchButton,_emojButton,_inputView);
    if (switchBtn) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_switchButton(22)]-5-[_inputView]-8-[_emojButton(25)]-10-|"
                                                                     options: 0
                                                                     metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_switchButton]-5-|"
                                                                     options: 0
                                                                     metrics:nil views:views]];

    }else{
        [_switchButton removeFromSuperview];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_inputView]-8-[_emojButton(25)]-10-|"
                                                                     options: 0
                                                                     metrics:nil views:views]];
    }
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emojButton]|"
                                                                 options: 0
                                                                 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_inputView]-5-|"
                                                                 options: 0
                                                                 metrics:nil views:views]];
    

        [_inputView setBorderWidth:1.0f andColor:[UIColor borderColor]];
}


-(void)addBorder{
    UIView* upView = [UIView new];
    upView.backgroundColor = [UIColor borderColor];
    upView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:upView];
    
    UIView* bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor borderColor];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(upView, bottomView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[upView]|"
                                                                 options:0
                                                                 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomView]|"
                                                                 options:0
                                                                 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upView(1)]->=0-[bottomView(1)]|"
                                                                 options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                 metrics:nil views:views]];
    
    

}
@end
