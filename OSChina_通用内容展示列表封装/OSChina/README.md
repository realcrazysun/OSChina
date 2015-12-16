开源中国通用内容展示界面
====
这部分涉及的内容相当多，也做了很久 其中设计思路比较值得学习  如何通过继承和block来实现封装和多态
---
## - 网络通信
## - 通用内容展示MVC
### - model部分
- OSCBaseObject
- xml解析 ONO XML解析
- 重写isEqual方法 来避免重复加载数据
### - view部分
- 自定义TableViewCell 
- 代码VFL布局 参考SoftwareCell
                                                              

### - controller部分:OSCObjViewController
###这部分是封装内容展示的最主要部分 有些内容跟原代码有点区别<br>
MJRefresh的使用
```
 // 下拉刷新
    self.tableView.mj_header =   [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf fetchMore];
    }];


```
GCD使用
```
#pragma mark --获取数据并放入object中  如果refresh则清空当前数据
-(void)fetchObjects:(NSUInteger)page refresh:(BOOL)refresh
{
    [_manager GET:self.generateURL(page)
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, ONOXMLDocument *responseDocument) {

              NSArray *objectsXML = [self parseXML:responseDocument];
              
              if (refresh) {
                  _pageNum = 1;
                  [_objects removeAllObjects];//如果加载第0页则会清空当前_objects

              }else{
                  _pageNum++;
              }
              for (ONOXMLElement *objectXML in objectsXML) {
                  BOOL shouldBeAdded = YES;
                  id obj = [[_objClass alloc] initWithXML:objectXML];
                  
                  for (OSCBaseObject *baseObj in _objects) {
                      if ([obj isEqual:baseObj]) {
                          shouldBeAdded = NO;
                          break;
                      }
                  }
                  if (shouldBeAdded) {
                      [_objects addObject:obj];
                  }
              }
              
         
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (objectsXML.count == 0 || (objectsXML.count < 20)){
                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                      }
                  if (self.tableView.mj_header.isRefreshing) {
                      [self.tableView.mj_header endRefreshing];
                  }
                  if(self.tableView.mj_footer.isRefreshing){
                        [self.tableView.mj_footer endRefreshing];
                  }
                  
                  [self.tableView reloadData];
              });
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"http request failed");
              MBProgressHUD *HUD = [Utils createHUD];
              HUD.mode = MBProgressHUDModeCustomView;
              HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
              HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
              
              [HUD hide:YES afterDelay:1];

              [self.tableView reloadData];
          }
     ];

```

图文混排 NSMutableAttributedString NSTextAttachment 使用
```
- (NSMutableAttributedString *)attributedTittle
{
    if (!_attributedTittle) {
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        if (_documentType == 0) {
            textAttachment.image = [UIImage imageNamed:@"widget_repost"];
        } else {
            textAttachment.image = [UIImage imageNamed:@"widget-original"];
        }
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        _attributedTittle = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [_attributedTittle appendAttributedString:[[NSAttributedString alloc] initWithString:_title]];
    }
    
    return _attributedTittle;
}
```




