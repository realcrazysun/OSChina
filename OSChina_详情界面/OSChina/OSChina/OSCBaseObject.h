//
//  OSCBaseObject.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-15.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono.h>
//#import <TBXML.h>

@interface OSCBaseObject : NSObject

- (instancetype)initWithXML:(ONOXMLElement *)xml;

//- (instancetype)initWithTBXMLElement:(TBXMLElement*)element;

@end
