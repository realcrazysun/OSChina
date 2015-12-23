//
//  EmojiViewController.m
//  OSChina
//
//  Created by polyent on 15/12/22.
//  Copyright © 2015年 crazysun. All rights reserved.
//

#import "EmojiViewController.h"
#import "UIColor+Util.h"
#import "Utils.h"
#import <objc/runtime.h>
@interface EmojiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UITextView *textView;
@end

@implementation EmojiViewController

-(instancetype)initWithIndex:(int)pageIndex andTextView:(UITextView*)textView{
    if (self = [super init]) {
        _pageIndex = pageIndex;
        _textView  = textView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加CollectionView
    UICollectionViewFlowLayout* layout  = [UICollectionViewFlowLayout new];
    CGFloat screenWidth                 = [UIScreen mainScreen].bounds.size.width;
    layout.minimumInteritemSpacing      = (screenWidth - 40 - 30*7)/7;
    layout.minimumLineSpacing           = 25;
    layout.sectionInset                 = UIEdgeInsetsMake(15, 0, 5, 0);
    
    _collectionView             = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate    = self;
    _collectionView.dataSource  = self;
    _collectionView.bounces     = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor themeColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_collectionView]-20-|" options:0 metrics:nil views:views]];

    
    __block typeof(_textView)textViewBlock = _textView;
    _didSelectEmoji =  ^(NSTextAttachment *textAttachment) {
        NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:textViewBlock.attributedText];
        [mutableAttributeString replaceCharactersInRange:textViewBlock.selectedRange withAttributedString:emojiAttributedString];
        textViewBlock.attributedText = mutableAttributeString;
        textViewBlock.textColor = [UIColor titleColor];
        [textViewBlock insertText:@""];
        textViewBlock.font = [UIFont systemFontOfSize:16];
    };
    
    _deleteEmoji    = ^ {
        [textViewBlock deleteBackward];
    };

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger left = 123 - _pageIndex * 20;
    return left >= 20 ? 3 : (left + 7) / 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger left = 123 - _pageIndex * 20 - section * 7;
    return left >= 7? 7 : left + 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(30,30);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if (section == [self numberOfSectionsInCollectionView:collectionView] - 1&&
        row == [self collectionView:collectionView numberOfItemsInSection:section] - 1) {
        UIImage* delete =[UIImage imageNamed:@"delete"];
        [delete setAccessibilityIdentifier:@"delete"];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:delete]];
        
    } else {
        NSInteger emojiNum = _pageIndex * 20 + section * 7 + row + 1;
        NSString *emojiImageName;
        if (emojiNum >= 106) {
            emojiImageName = [Utils.emojiDict[@(emojiNum).stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        } else {
            emojiImageName = [NSString stringWithFormat:@"%03ld", (long)emojiNum];
        }
        UIImage* image =[UIImage imageNamed:emojiImageName];
        [image setAccessibilityIdentifier:emojiImageName];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:image]];
    }
    
    return cell;


}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView* imageView = (UIImageView*)[cell backgroundView];
    //如果为删除
    if ([[imageView.image accessibilityIdentifier] isEqualToString:@"delete"]) {
        _deleteEmoji();
    }else{
        NSInteger emojiNum = _pageIndex * 20 + indexPath.section * 7 + indexPath.row + 1;
        NSString *emojiImageName, *emojiStr;
        if (emojiNum >= 106) {
            emojiStr = Utils.emojiDict[@(emojiNum).stringValue];
            emojiImageName = [emojiStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        } else {
            emojiStr = [NSString stringWithFormat:@"[%ld]", emojiNum - 1];
            emojiImageName = [NSString stringWithFormat:@"%03ld", emojiNum];
        }
        
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed:emojiImageName];
        [textAttachment adjustY:-3];
        
        objc_setAssociatedObject(textAttachment, @"emoji", emojiStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        _didSelectEmoji(textAttachment);

    }
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
