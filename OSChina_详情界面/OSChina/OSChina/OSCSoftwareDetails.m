//
//  OSCSoftwareDetails.m
//  iosapp
//
//  Created by chenhaoxiang on 11/3/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCSoftwareDetails.h"
#import "Utils.h"


@implementation OSCSoftwareDetails

- (instancetype)initWithXML:(ONOXMLElement *)xml
{
    self = [super init];
    
    if (self) {
        _authorID = [xml firstChildWithTag:@"authorid"].numberValue.integerValue;
        _author = [xml firstChildWithTag:@"author"].stringValue ?: @"";
        _softwareID = [[[xml firstChildWithTag:@"id"] numberValue] longLongValue];
        _isRecommended = [xml firstChildWithTag:@"recommended"].numberValue.boolValue;
        _title = [[xml firstChildWithTag:@"title"] stringValue];
        _extensionTitle = [[xml firstChildWithTag:@"extensionTitle"] stringValue];
        _license = [[xml firstChildWithTag:@"license"] stringValue];
        _body = [[xml firstChildWithTag:@"body"] stringValue];
        _os = [[xml firstChildWithTag:@"os"] stringValue];
        _language = [[xml firstChildWithTag:@"language"] stringValue];
        _recordTime = [[xml firstChildWithTag:@"recordtime"] stringValue];
        _url = [NSURL URLWithString:[[xml firstChildWithTag:@"url"] stringValue]];
        _homepageURL = [[xml firstChildWithTag:@"homepage"] stringValue];
        _documentURL = [[xml firstChildWithTag:@"document"] stringValue];
        _downloadURL = [[xml firstChildWithTag:@"download"] stringValue];
        _logoURL = [[xml firstChildWithTag:@"logo"] stringValue];
        _isFavorite = [[[xml firstChildWithTag:@"favorite"] numberValue] boolValue];
        _tweetCount = [[[xml firstChildWithTag:@"tweetCount"] numberValue] intValue];
    }
    
    return self;
}


/**
 *  模板生成本地html数据展示
 *
 *  @return 本地html字符串
 */
- (NSString *)html
{
    if (!_html) {        
        NSDictionary *data = @{
                               @"title": [NSString stringWithFormat:@"%@ %@", _extensionTitle, _title],
                               @"authorID": @(_authorID),
                               @"author": _author,
                               @"recommended": @(_isRecommended),
                               @"logoURL": _logoURL,
                               @"content": _body,
                               @"license": _license,
                               @"language": _language,
                               @"os": _os,
                               @"recordTime": _recordTime,
                               @"homepageURL": _homepageURL,
                               @"documentURL": _documentURL,
                               @"downloadURL": _downloadURL,
                               };
        
        _html = [Utils HTMLWithData:data usingTemplate:@"software"];
    }
    
    return _html;
}

@end
