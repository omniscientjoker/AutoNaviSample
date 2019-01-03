//
//  attributionView.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/22.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "attributionView.h"

#define KAttributionCellIdentifier  @"KAttributionCellIdentifier"
@interface attributionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString * selectedAtt;
    NSInteger selectedIndex;
}
@end

@implementation attributionView

-(instancetype)initWithAttName:(NSString *)name
{
    self = [super init];
    if (self) {
        selectedAtt = name;
        [self setView];
    }
    return self;
}

-(void)setView{
    [self setDataArr];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *AttCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT/2-10) collectionViewLayout:layout];
    AttCollectionView.delegate = self;
    AttCollectionView.dataSource =self;
    AttCollectionView.backgroundColor = [UIColor lightGrayColor];
    
    [AttCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KAttributionCellIdentifier];
    [self addSubview:AttCollectionView];
}
-(void)setDataArr{
    if (self.attributionArr) {
        return;
    }
    self.attributionArr = @[@"京",@"津",@"翼",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"渝",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"港",@"澳",@"台"];
    
    [self.attributionArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:selectedAtt]) {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
}

#pragma mark collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.attributionArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KAttributionCellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(5, 10, 30, 30);
    titleLabel.center = cell.contentView.center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius  = 2.0f;
    titleLabel.layer.borderWidth   = 1.0f;
    titleLabel.layer.borderColor   = [UIColor grayColor].CGColor;
    titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.attributionArr[indexPath.row];
    [cell.contentView addSubview:titleLabel];
    
    if (indexPath.row == selectedIndex) {
        titleLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@(indexPath.row).description);
    [self removeFromSuperview];
    if ([self.delegate conformsToProtocol:@protocol(attributionViewDelegate)] && [self.delegate respondsToSelector:@selector(selectAttribution:)]) {
        [self.delegate selectAttribution:_attributionArr[indexPath.row]];
    }
}

#pragma mark -- UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40,50);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2, 0, 0,0);
}
//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;    
}
@end
