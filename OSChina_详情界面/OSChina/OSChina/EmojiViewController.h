//
//  EmojiViewController.h
//  OSChina
//
//  Created by polyent on 15/12/22.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiViewController : UIViewController
@property(nonatomic,assign)int pageIndex;
-(instancetype)initWithIndex:(int)pageIndex andTextView:(UITextView*)textView;

@property (nonatomic, copy) void (^didSelectEmoji)(NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end
