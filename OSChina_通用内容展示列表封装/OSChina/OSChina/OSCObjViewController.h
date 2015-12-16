//
//  OSCObjViewController.h
//  OSChina
//
//  Created by polyent on 15/12/6.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ono.h"
#import <MJRefresh.h>
#import "LastCell.h"
@interface OSCObjViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray * objects;//要展示的数据Models
@property(nonatomic,strong) Class objClass;
@property(nonatomic,copy) NSString * (^generateURL)(NSUInteger page);
@property(nonatomic,strong)LastCell* lastCell;
- (NSArray *)parseXML:(ONOXMLDocument *)xml;

@end
