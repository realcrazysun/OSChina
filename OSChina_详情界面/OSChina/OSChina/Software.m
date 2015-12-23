//
//  Software.m
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "Software.h"

static NSString * const kName = @"name";
static NSString * const kDescription = @"description";
static NSString * const kURL = @"url";

@implementation Software
-(instancetype)initWithXML:(ONOXMLElement *)xml{
    self = [super init];
    if (self) {
        _name = [[xml firstChildWithTag:kName] stringValue];
        _des = [[xml firstChildWithTag:kDescription] stringValue] ;
        _url = [NSURL URLWithString:[[xml firstChildWithTag:kURL] stringValue]];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Software class]]) {
        return [[(Software*)object name] isEqualToString:self.name];
    }
    return NO;
}
@end
