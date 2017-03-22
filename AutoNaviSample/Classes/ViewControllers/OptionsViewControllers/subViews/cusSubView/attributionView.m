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
@property(nonatomic, strong)UIView      * hudContentView;
@end

@implementation attributionView

-(instancetype)initWithCarID:(NSString *)CarId
{
    self = [super init];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    [self setDataArr];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(20, 36);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 9.f, 0);
    
    UICollectionView *momentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    momentCollectionView.delegate = self;
    momentCollectionView.dataSource =self;
    momentCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:momentCollectionView];
    [momentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:KAttributionCellIdentifier];
}
-(void)setDataArr{
    if (self.attributionArr) {
        return;
    }
    self.attributionArr = @[@"京",@"津",@"翼",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"川",@"贵",@"云",@"渝",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"港",@"澳",@"台"];
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
    static NSString *identify = KAttributionCellIdentifier;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = _attributionArr[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = RGB(97, 97, 97);
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(cell.contentView.mas_centerY);
         make.centerX.equalTo(cell.contentView.mas_centerX);
         make.height.mas_equalTo(@20);
         make.width.mas_equalTo(@10);
         
     }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@(indexPath.row).description);
    if ([self.delegate conformsToProtocol:@protocol(attributionViewDelegate)] && [self.delegate respondsToSelector:@selector(selectAttribution:)]) {
        [self.delegate selectAttribution:_attributionArr[indexPath.row]];
    }
}

#pragma mark -- UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(20, 36);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}
//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;    
}
@end
