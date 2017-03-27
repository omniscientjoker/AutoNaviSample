//
//  OfflLineMapCell.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/27.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "OfflLineMapCell.h"
#import "ProgressBarView.h"
#import "offlineMapHandle.h"

#define TagUIbuttonDowanLoad    100000000000
#define TagUIbuttonCancel       100000000001
#define TagUIbuttonPause        100000000002
#define TagUIbuttonStart        100000000003
@interface OfflLineMapCell ()
@property(nonatomic,strong)ProgressBarView * progressView;
@end
@implementation OfflLineMapCell
-(instancetype)init{
    self = [super init];
    if (self) {
        [self updateUI];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self updateUI];
    }
    return self;
}
- (void)updateUI{
    _titleLable = [[UILabel alloc] init];
    _titleLable.font = [UIFont systemFontOfSize:16.0f];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.backgroundColor = [UIColor redColor];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView.mas_left).with.offset(18);
         make.top.equalTo(self.contentView.mas_top).with.offset(10);
         make.height.mas_equalTo(@20);
     }];
    
    _sizeLable = [[UILabel alloc] init];
    _sizeLable.font = [UIFont systemFontOfSize:12.0f];
    _sizeLable.textColor = [UIColor lightGrayColor];
    _sizeLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_sizeLable];
    [_sizeLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView.mas_left).with.offset(18);
         make.top.equalTo(_titleLable.mas_bottom).with.offset(10);
         make.height.mas_equalTo(@10);
     }];
    
    
    _stateLable = [[UILabel alloc] init];
    _stateLable.font = [UIFont systemFontOfSize:15.0f];
    _stateLable.textColor = [UIColor lightGrayColor];
    _stateLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_stateLable];
    [_stateLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.contentView.mas_right).with.offset(-10);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.height.mas_equalTo(@18);
     }];
    
    _acctionBtn = [[UIButton alloc] init];
    [_acctionBtn addTarget:self action:@selector(cliclActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_acctionBtn];
    [_acctionBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.contentView.mas_right).with.offset(-10);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.height.mas_equalTo(@30);
         make.width.mas_equalTo(@30);
     }];
    
    _progressView = [[ProgressBarView alloc] initWithFrame:CGRectMake(10, self.contentView.frame.size.height-16, SCREENWIDTH-20, 16)];
    _progressView.backgroundColor = [UIColor blackColor];
    _progressView.color = [UIColor colorWithRed:0.73f green:0.10f blue:0.00f alpha:1.00f];
    _progressView.progress = 0.40;
    _progressView.animate = @YES;
    _progressView.background = [_progressView.color colorWithAlphaComponent:0.8];
    [self.contentView addSubview:_progressView];
    _progressView.hidden = YES;
}
#pragma mark changeUI
-(void)updatecellviewWith:(MAOfflineItem *)item{
    offlineMapHandle * handle = [offlineMapHandle sharedInstance];
    self.titleLable.text = [handle returnMapStateForItem:item];
    self.sizeLable.text  = [handle returnItemSizeForItem:item];
    
    //地图已下载
    if ([handle returnItmeIsAlerdayDownLoadForItem:item]) {
        //地图已下载
        _progressView.hidden = YES;
        _acctionBtn.hidden = YES;
        _stateLable.text = [handle returnMapStateForItem:item];
        [_stateLable mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView.mas_right).with.offset(-10);
             make.centerY.equalTo(self.contentView.mas_centerY);
             make.height.mas_equalTo(@18);
         }];
    }else{
        //地图未下载 或 未完成下载
        if (item.itemStatus == MAOfflineItemStatusNone) {
            _stateLable.hidden = YES;
            _progressView.hidden = YES;
            _acctionBtn.tag = TagUIbuttonDowanLoad;
            [_acctionBtn setImage:[UIImage imageNamed:@"icon_downloadmap_img"] forState:UIControlStateNormal];
            [_acctionBtn mas_updateConstraints:^(MASConstraintMaker *make)
             {
                 make.right.equalTo(self.contentView.mas_right).with.offset(-10);
                 make.centerY.equalTo(self.contentView.mas_centerY);
                 make.height.mas_equalTo(@30);
                 make.width.mas_equalTo(@30);
             }];
        }else{
            NSString * imgName = [handle returnBtnImg:item];
            if ([imgName isEqualToString:@"icon_startmap_img"]) {
                _acctionBtn.tag = TagUIbuttonStart;
            }else if ([imgName isEqualToString:@"icon_cancelmap_img"]){
                _acctionBtn.tag = TagUIbuttonCancel;
            }else{
                _acctionBtn.tag = TagUIbuttonPause;
            }
            _stateLable.text = [handle returnMapStateDetailForItem:item];
            [_acctionBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [_acctionBtn mas_updateConstraints:^(MASConstraintMaker *make)
             {
                 make.right.equalTo(self.contentView.mas_right).with.offset(-10);
                 make.centerY.equalTo(self.contentView.mas_centerY);
                 make.height.mas_equalTo(@30);
                 make.width.mas_equalTo(@30);
             }];
            [_stateLable mas_updateConstraints:^(MASConstraintMaker *make)
             {
                 make.right.equalTo(_acctionBtn.mas_left).with.offset(-10);
                 make.centerY.equalTo(self.contentView.mas_centerY);
                 make.height.mas_equalTo(@18);
             }];
            _progressView.hidden = NO;
            float cont = item.downloadedSize/item.size;
            [self changeValue:cont];
        }
    }
}
-(void)updateProcessViewWithItem:(MAOfflineItem *)item{
    float cont = item.downloadedSize/item.size;
    [self changeValue:cont];
}
#pragma mark ClickBtn
-(void)cliclActionBtn:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == TagUIbuttonDowanLoad) {
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(downloadItem:)]) {
            [self.delegate downloadItem:sender];
        }
    }else if (btn.tag == TagUIbuttonStart){
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(startItem:)]) {
            [self.delegate startItem:sender];
        }
    }else if (btn.tag == TagUIbuttonPause){
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(pauseItem:)]) {
            [self.delegate pauseItem:sender];
        }
    }else if (btn.tag == TagUIbuttonCancel){
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(cancleItem:)]) {
            [self.delegate cancleItem:sender];
        }
    }else{
        NSLog(@"00");
    }
}

#pragma mark Progress
- (void)hideProgressView{
    
}
- (void)showProgressView{
    
}
- (void)changeValue:(float)sender{
    _progressView.progress = sender;
}



- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
