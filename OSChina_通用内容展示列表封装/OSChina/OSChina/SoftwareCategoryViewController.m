//
//  SoftwareCategoryViewController.m
//  OSChina
//
//  Created by polyent on 15/12/10.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "SoftwareCategoryViewController.h"
#import "OSCAPI.h"
#import "SoftwareCategory.h"
#import "UIColor+Util.h"
static NSString * const kSoftwareCatalogCellID = @"SoftwareCatalogCell";


@interface SoftwareCategoryViewController ()
@property(nonatomic,assign)int tag;
@end

@implementation SoftwareCategoryViewController
- (instancetype)initWithTag:(int)tag
{
    self=[super init];
    if (self) {
        _tag = tag;
        self.generateURL = ^(NSUInteger idx){
            return [NSString stringWithFormat:@"%@%@?tag=%d", OSCAPI_PREFIX, OSCAPI_SOFTWARECATALOG_LIST, tag];
        };
        self.objClass = [SoftwareCategory class];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSoftwareCatalogCellID];
    
}
- (NSArray *)parseXML:(ONOXMLDocument *)xml
{
    return [[xml.rootElement firstChildWithTag:@"softwareTypes"] childrenWithTag:@"softwareType"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSoftwareCatalogCellID forIndexPath:indexPath];

    SoftwareCategory* category =   self.objects[indexPath.row];
    cell.backgroundColor = [UIColor themeColor];
    cell.textLabel.text = category.name;
    
    cell.textLabel.textColor = [UIColor titleColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
