//
//  PlaceHolderTextView.m
//  OSChina
//
//  Created by polyent on 15/12/23.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "PlaceHolderTextView.h"

@interface PlaceHolderTextView ()
@property(nonatomic,strong)UITextView* placeHolderView;
@end

@implementation PlaceHolderTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpPlaceholderView];
    }
    return self;
}

- (void)setUpPlaceholderView
{
    _placeHolderView = [UITextView new];
    _placeHolderView.editable = NO;
    _placeHolderView.scrollEnabled = NO;
    _placeHolderView.showsHorizontalScrollIndicator = NO;
    _placeHolderView.showsVerticalScrollIndicator = NO;
    _placeHolderView.userInteractionEnabled = NO;
    _placeHolderView.font = self.font;
    _placeHolderView.contentInset = self.contentInset;
    _placeHolderView.contentOffset = self.contentOffset;
    _placeHolderView.textContainerInset = self.textContainerInset;
    _placeHolderView.textColor = [UIColor lightGrayColor];
    _placeHolderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeHolderView];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(textDidChange:)
                          name:UITextViewTextDidChangeNotification object:self];
    
}

- (void)textDidChange:(NSNotification *)notification
{
    _placeHolderView.hidden = [self hasText];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderView.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    _placeHolderView.textAlignment = textAlignment;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:contentInset];
    _placeHolderView.contentInset = contentInset;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    _placeHolderView.contentOffset = contentOffset;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    _placeHolderView.textContainerInset = textContainerInset;
}

#pragma mark placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeHolderView.text = placeholder;
}

- (NSString *)placeholder
{
    return _placeHolderView.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
