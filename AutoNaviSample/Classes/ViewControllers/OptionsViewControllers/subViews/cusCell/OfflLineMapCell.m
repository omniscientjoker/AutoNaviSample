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

#define TagUIbuttonDowanLoad    10000000
#define TagUIbuttonDelete       10000001
#define TagUIbuttonPause        10000002
#define TagUIbuttonStart        10000003
@interface OfflLineMapCell ()
@property(nonatomic,strong)ProgressBarView * progressView;
@end
@implementation OfflLineMapCell
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
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, SCREENWIDTH/3, 20)];
    _titleLable.font = [UIFont systemFontOfSize:16.0f];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLable];
   
    
    _sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 40, SCREENWIDTH/4, 10)];
    _sizeLable.font = [UIFont systemFontOfSize:12.0f];
    _sizeLable.textColor = [UIColor blackColor];
    _sizeLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_sizeLable];
}

#pragma mark updateUI
-(void)updateCellViewForItem:(MAOfflineItem *)item{
    self.titleLable.text = item.name;
    self.sizeLable.text  = [NSString stringWithFormat:@"大小:%@", [[offlineMapHandle sharedInstance]convertFileSizeWithSize:item.size]];
    [self updateCellUiForItem:item];
}

#pragma mark changeUI
-(void)updateCellUiForItem:(MAOfflineItem *)item{
    [self hideProgressView];
    [self hideAcctionBtn];
    [self hideStateLable];
    if (item.itemStatus == MAOfflineItemStatusInstalled) {
        [self showStateLableWithItem:item];
    }else if (item.itemStatus == MAOfflineItemStatusNone){
        [self showAcctionBtn];
        self.acctionBtn.tag = TagUIbuttonDowanLoad;
    }else if (item.itemStatus == MAOfflineItemStatusCached){
        [self showProgressView];
        [self showAcctionBtn];
        [self showStateLableWithItem:item];
        self.stateLable.frame = CGRectMake(SCREENWIDTH-40-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18);
        if ([[MAOfflineMap sharedOfflineMap] isDownloadingForItem:item]) {
            [self changeProgressValueWithItem:item];
            [_acctionBtn setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
            self.acctionBtn.tag = TagUIbuttonPause;
        }else{
            [self ProgressValueWithItem:item];
            [_acctionBtn setImage:[UIImage imageNamed:@"icon_startmap_img"] forState:UIControlStateNormal];
            self.acctionBtn.tag = TagUIbuttonStart;
        }
    }else if (item.itemStatus == MAOfflineItemStatusExpired){
        [self showAcctionBtn];
        [self showStateLableWithItem:item];
        self.stateLable.frame = CGRectMake(SCREENWIDTH-40-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18);
        [_acctionBtn setImage:[UIImage imageNamed:@"icon_download_img"] forState:UIControlStateNormal];
        self.acctionBtn.tag = TagUIbuttonDowanLoad;
    }
}

-(void)updateCellDateSourcessWith:(MAOfflineItem *)item
{
    if ([[MAOfflineMap sharedOfflineMap] isDownloadingForItem:item]){
        [self showProgressView];
        [self showAcctionBtn];
        [self showStateLableWithItem:item];
        self.stateLable.frame = CGRectMake(SCREENWIDTH-40-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18);
        [self changeProgressValueWithItem:item];
        [_acctionBtn setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
        self.acctionBtn.tag = TagUIbuttonPause;
    }else{
        [self hideProgressView];
        [self hideAcctionBtn];
        [self hideStateLable];
        [self updateCellUiForItem:item];
    }
}

#pragma mark ClickBtn
-(void)cliclActionBtn:(id)sender{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case TagUIbuttonStart:{
            btn.tag = TagUIbuttonPause;
            [sender setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
            if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(downloadItem:)]) {
                [self.delegate downloadItem:sender];
            }
        }
            break;
        case TagUIbuttonPause:{
            btn.tag = TagUIbuttonDowanLoad;
            [sender setImage:[UIImage imageNamed:@"icon_startmap_img"] forState:UIControlStateNormal];
            if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(pauseItem:)]) {
                [self.delegate pauseItem:sender];
            }
        }
            break;
        case TagUIbuttonDowanLoad:{
            btn.tag = TagUIbuttonPause;
            [sender setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
            if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(downloadItem:)]) {
                [self.delegate downloadItem:sender];
            }
        }
            break;
        default:{
            NSLog(@"cancel");
        }
            break;
    }
}

#pragma mark stateLab
- (void)hideStateLable{
    if (self.stateLable) {
        [self.stateLable removeFromSuperview];
        self.stateLable = nil;
    }
}
- (void)showStateLableWithItem:(MAOfflineItem *)item{
    if (self.stateLable) {
        _stateLable.text = [[offlineMapHandle sharedInstance] returnMapStateForItem:item];
        return;
    }
    _stateLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-10-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18)];
    _stateLable.font = [UIFont systemFontOfSize:15.0f];
    _stateLable.textColor = [UIColor blackColor];
    _stateLable.textAlignment = NSTextAlignmentRight;
    _stateLable.text = [[offlineMapHandle sharedInstance] returnMapStateForItem:item];
    [self.contentView addSubview:_stateLable];
}

#pragma mark Button
- (void)hideAcctionBtn{
    if (self.acctionBtn) {
        [self.acctionBtn removeFromSuperview];
        self.acctionBtn = nil;
    }
}
- (void)showAcctionBtn{
    if (self.acctionBtn) {
        return;
    }
    _acctionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-40, (kOffLineMapCellHeight-30)/2, 30, 30)];
    [_acctionBtn setImage:[UIImage imageNamed:@"icon_download_img"] forState:UIControlStateNormal];//下载
    [_acctionBtn addTarget:self action:@selector(cliclActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_acctionBtn];
}

#pragma mark Progress
- (void)hideProgressView{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
}
- (void)showProgressView{
    if (self.progressView) {
        return;
    }
    self.progressView = [[ProgressBarView alloc] initWithFrame:CGRectMake(2, kOffLineMapCellHeight-12, SCREENWIDTH-4, 10)];
    self.progressView.color = [UIColor colorWithRed:0.73f green:0.10f blue:0.00f alpha:1.00f];
    self.progressView.progress = 0.40;
    self.progressView.animate = @YES;
    self.progressView.borderRadius = @0;
    self.progressView.background = [UIColor whiteColor];
    [self.contentView addSubview:self.progressView];
}
-(void)changeProgressValueWithItem:(MAOfflineItem *)item{
    _progressView.progress = [[offlineMapHandle sharedInstance] returnDownloadPerfencet:item];
}
-(void)ProgressValueWithItem:(MAOfflineItem *)item{
    _progressView.progress = (CGFloat)item.downloadedSize/(CGFloat)item.size;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
