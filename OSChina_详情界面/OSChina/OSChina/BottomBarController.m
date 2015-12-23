//
//  BottomBarController.m
//  OSChina
//
//  Created by polyent on 15/12/20.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "BottomBarController.h"
#import "UIColor+Util.h"
#import "MMPlaceHolder.h"
#import "EmojiPageViewController.h"
@interface BottomBarController ()<UITextViewDelegate>
@property (nonatomic, strong) EmojiPageViewController *emojiPageVC;


@end

@implementation BottomBarController

-(instancetype)initWithSwitchMode:(BOOL)hasSwitch{
    if(self = [super init]){
        _editBar = [[EditBar alloc] initWithSwitchBtn:hasSwitch];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor themeColor];
    [self setup];
    [self addEmojiPanel];
    //    [self.view showPlaceHolderWithAllSubviews:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidUpdate:)    name:UITextViewTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //    _emojiPageVC.view.hidden = YES;
    //    _isEmojiPageOnScreen = NO;
    
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _editBarYConstraint.constant = keyboardBounds.size.height;
    [self hideEmojiPageVC];
    [self updateConstrain];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _editBarYConstraint.constant = 0;
    [self updateConstrain];
}

-(void)showEmojiPageVC{
    _emojiPageVC.view.hidden = NO;
    [_editBar.emojButton setImage:[UIImage imageNamed:@"toolbar-text"] forState:UIControlStateNormal];
}
-(void)hideEmojiPageVC{
    _emojiPageVC.view.hidden = YES;
    [_editBar.emojButton setImage:[UIImage imageNamed:@"toolbar-emoji2"] forState:UIControlStateNormal];
}
/**
 *  constrains更改动画
 */
- (void)updateConstrain
{
    [self.view setNeedsUpdateConstraints];
    [UIView animateKeyframesWithDuration:0.25       //animationDuration
                                   delay:0
                                 options:7 << 16    //animationOptions
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:nil];
}

-(void)setup{
    
    _editBar.translatesAutoresizingMaskIntoConstraints = NO;//一定要加这一句 否则代码写autolayout不起作用
    [self.view addSubview:_editBar];
    _editBarYConstraint = [NSLayoutConstraint constraintWithItem:self.view    attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual
                                                          toItem:_editBar  attribute:NSLayoutAttributeBottom   multiplier:1.0 constant:0];
    
    _editBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_editBar attribute:NSLayoutAttributeHeight         relatedBy:NSLayoutRelationEqual
                                                               toItem:nil         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
    
    [self.view addConstraint:_editBarYConstraint];
    [self.view addConstraint:_editBarHeightConstraint];
    NSDictionary *views = NSDictionaryOfVariableBindings(_editBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_editBar]|"
                                                                      options: 0
                                                                      metrics:nil views:views]];
    
    _editBar.inputView.delegate = self;
    
    //绑定事件
    [_editBar.emojButton addTarget:self action:@selector(clickEmojiBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textDidUpdate:(NSNotification *)notification
{
    //    [self updateInputBarHeight];
    CGFloat inputbarHeight = [self appropriateInputbarHeight];
    
    if (inputbarHeight != _editBarHeightConstraint.constant) {
        _editBarHeightConstraint.constant = inputbarHeight;
        
        [self.view layoutIfNeeded];
    }
    
}

/**
 *  计算GrowingTextView高度
 *
 *  @return <#return value description#>
 */
- (CGFloat)appropriateInputbarHeight
{
    CGFloat height = 0;
    CGFloat minimumHeight = [self minimumInputbarHeight];
    CGFloat newSizeHeight = [_editBar.inputView measureHeight];
    CGFloat maxHeight     = _editBar.inputView.maxHeight;
    
    _editBar.inputView.scrollEnabled = newSizeHeight >= maxHeight;
    
    if (newSizeHeight < minimumHeight) {
        height = minimumHeight;
    } else if (newSizeHeight < _editBar.inputView.maxHeight) {
        height = newSizeHeight;
    } else {
        height = _editBar.inputView.maxHeight;
    }
    
    return roundf(height);
}


-(void)clickEmojiBtn{
    if(_emojiPageVC.view.hidden){
        
        [_editBar.inputView resignFirstResponder];
        _editBarYConstraint.constant = 216;
        [self showEmojiPageVC];
        [self updateConstrain];
        
    }else{
        [self hideEmojiPageVC];
        [_editBar.inputView becomeFirstResponder];
    }
}

/**
 *  增加表情panel
 */
-(void)addEmojiPanel{
    _emojiPageVC = [[EmojiPageViewController alloc] initWithTextView:_editBar.inputView];
    [self.view addSubview:_emojiPageVC.view];
    _emojiPageVC.view.hidden = YES;
    _emojiPageVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"emojiPage": _emojiPageVC.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emojiPage(216)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[emojiPage]|" options:0 metrics:nil views:views]];
    
}


- (CGFloat)minimumInputbarHeight
{
    NSLog(@"_editBar ---%f",_editBar.intrinsicContentSize.height);
    return _editBar.intrinsicContentSize.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 发送留言什么的要先登录
    if ([text isEqualToString: @"\n"]) {
        //            if ([Config getOwnID] == 0) {
        //                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        //                LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //                [self.navigationController pushViewController:loginVC animated:YES];
        //            } else {
        //                [self sendContent];
        //                [textView resignFirstResponder];
        //            }
        [textView resignFirstResponder];
        _emojiPageVC.view.hidden = YES;
        return NO;
    }
    return YES;
}


- (void)sendContent{
    NSAssert(false, @"override in subclass");
}
@end
