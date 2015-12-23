//
//  GrowingTextView.m
//  OSChina
//
//  Created by polyent on 15/12/23.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "GrowingTextView.h"

@implementation GrowingTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithPlaceHolder:(NSString *)placeHolder{
    
    self = [super init];
    if (self) {
        self.placeHolder = placeHolder;
        self.font = [UIFont systemFontOfSize:16];
        self.scrollEnabled = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.enablesReturnKeyAutomatically = YES;
        self.textContainerInset = UIEdgeInsetsMake(7.5, 3.5, 7.5, 0);
        //NSLog(@"%@, %f", self.font, self.font.lineHeight);
        _maxLines = 4;
        _maxHeight = ceilf(self.font.lineHeight * _maxLines + 15 + 4 * (_maxLines - 1));
    }
    
    return self;

}

- (CGFloat)measureHeight
{
    //[self layoutIfNeeded];
    //NSLog(@"frameHeight: %f", self.frame.size.height);
    //NSLog(@"lineHeight: %f", self.font.lineHeight);
    //NSLog(@"contentSize:(height): %f, (width):%f", self.contentSize.height, self.contentSize.width);
    //NSLog(@"Height: %f", [self sizeThatFits:self.frame.size].height + 15);
    
    
    return ceilf([self sizeThatFits:self.frame.size].height + 10);
}
@end
