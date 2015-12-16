//
//  SoftwareViewController.m
//  OSChina
//
//  Created by polyent on 15/12/16.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "SoftwareViewController.h"
#import "OSCAPI.h"
#import "Software.h"
#import "SoftwareCell.h"

static NSString* const kSoftwareCellId = @"SoftwareCellId";

@interface SoftwareViewController ()

@end

@implementation SoftwareViewController

-(instancetype)initWithSoftwaresType:(SoftwaresType)softwareType{
    if (self = [super init]) {
        NSString *searchTag;
        switch (softwareType) {
            case SoftwaresTypeRecommended:
                searchTag = @"recommend"; break;
            case SoftwaresTypeNewest:
                searchTag = @"time"; break;
            case SoftwaresTypeHottest:
                searchTag = @"view"; break;
            case SoftwaresTypeCN:
                searchTag = @"list_cn"; break;
        }
        
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?searchTag=%@&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_LIST, searchTag, (unsigned long)page, OSCAPI_SUFFIX];
            
        };
    }
    self.objClass = [Software class];
    return self;
}

- (instancetype)initWIthSearchTag:(int)searchTag
{
    if (self = [super init]) {
        self.generateURL = ^NSString * (NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?searchTag=%d&pageIndex=%lu&%@", OSCAPI_PREFIX, OSCAPI_SOFTWARETAG_LIST, searchTag, (unsigned long)page, OSCAPI_SUFFIX];
        };
        
        self.objClass = [Software class];
    }
    
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"softwares"] childrenWithTag:@"software"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[SoftwareCell class] forCellReuseIdentifier:kSoftwareCellId];
}

-(UIView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SoftwareCell* cell = [tableView dequeueReusableCellWithIdentifier:kSoftwareCellId forIndexPath:indexPath];
    Software* software = self.objects[indexPath.row];
    cell.nameLabel.text = software.name;
    cell.descriptionLabel.text = software.des;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
