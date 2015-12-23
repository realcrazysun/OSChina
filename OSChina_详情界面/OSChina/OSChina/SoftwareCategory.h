//
//  SoftwareCategory.h
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCBaseObject.h"

@interface SoftwareCategory : OSCBaseObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) int tag;
@end
