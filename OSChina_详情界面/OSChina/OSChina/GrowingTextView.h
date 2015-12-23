//
//  GrowingTextView.h
//  OSChina
//
//  Created by polyent on 15/12/23.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "PlaceHolderTextView.h"

@interface GrowingTextView : PlaceHolderTextView
@property(nonatomic,assign)NSUInteger maxLines;
@property(nonatomic,assign)CGFloat maxHeight;
-(instancetype)initWithPlaceHolder:(NSString*)placeHolder;
-(CGFloat)measureHeight;
@end
