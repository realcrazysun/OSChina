//
//  SoftwareViewController.h
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "OSCObjViewController.h"


typedef NS_ENUM(int, SoftwaresType)
{
    SoftwaresTypeRecommended,
    SoftwaresTypeNewest,
    SoftwaresTypeHottest,
    SoftwaresTypeCN,
};
@interface SoftwareViewController : OSCObjViewController
- (instancetype)initWithSoftwaresType:(SoftwaresType)softwareType;
- (instancetype)initWIthSearchTag:(int)searchTag;
@end
