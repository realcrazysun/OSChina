//
//  SoftwareCategory.m
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "SoftwareCategory.h"
static NSString*  const kName = @"name";
static NSString*  const kTag = @"tag";

@implementation SoftwareCategory
- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    if (self) {
        _name = [[xml firstChildWithTag:kName] stringValue];
        _tag  = [[[xml firstChildWithTag:kTag] numberValue] intValue];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    return NO;
}
@end
