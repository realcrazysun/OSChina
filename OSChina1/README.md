开源中国主界面搭建
====
1、cocoapod & git
---
管理第三方库 pod install --verbose --no-repo-update<br>
git pull origin master  更新<br>
git push origin master  提交<br>

2、第三方库ReSideMenu简单使用<br>
---
```c++
- (void)awakeFromNib
{
    //这段还没具体看
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    //设置主View
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    //设置侧边栏
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    
}

```
3、侧边栏SideMenuViewController
---
headerView中图像与名称布局
```cpp
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    

```

4、主界面 OSCTabBarController
