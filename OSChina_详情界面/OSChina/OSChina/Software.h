//
//  Software.h
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCBaseObject.h"

@interface Software : OSCBaseObject
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* des;
@property(nonatomic,copy)NSURL* url;
@end
