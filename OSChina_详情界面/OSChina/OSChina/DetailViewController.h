//
//  DetailViewController.h
//  OSChina
//
//  Created by polyent on 15/12/23.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "BottomBarController.h"
#import "Software.h"
@interface DetailViewController : BottomBarController

@property(nonatomic,strong)UIWebView * detailsView;//网页内容展示
- (instancetype)initWithSoftware:(Software *)software;
@end
