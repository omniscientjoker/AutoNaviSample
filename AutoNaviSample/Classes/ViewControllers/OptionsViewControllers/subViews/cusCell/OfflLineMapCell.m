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
#define TagUIbuttonDelete       100000000001
#define TagUIbuttonPause        100000000002
#define TagUIbuttonStart        100000000003
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
-(void)updateCellViewForItem:(MAOfflineItem *)item
{
    self.titleLable.text = item.name;
    self.sizeLable.text  = [NSString stringWithFormat:@"大小:%@", [[offlineMapHandle sharedInstance]convertFileSizeWithSize:item.size]];
    [self updateCellUiForItem:item];
}

#pragma mark changeUI
-(void)updateCellUiForItem:(MAOfflineItem *)item{
    if (item.itemStatus == MAOfflineItemStatusInstalled) {
        //已安装
        [self hideProgressView];
        [self hideAcctionBtn];
        [self showStateLableWithItem:item];
    }else if (item.itemStatus == MAOfflineItemStatusNone){
        //未安装
        [self hideProgressView];
        [self hideStateLable];
        [self showAcctionBtn];
        self.acctionBtn.tag = TagUIbuttonDowanLoad;
    }else if (item.itemStatus == MAOfflineItemStatusCached){
        //已缓存
        [self showProgressView];
        [self showAcctionBtn];
        [self showStateLableWithItem:item];
        self.stateLable.frame = CGRectMake(SCREENWIDTH-40-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18);
        
        if ([[MAOfflineMap sharedOfflineMap] isDownloadingForItem:item]) {
            //正在下载
            [self changeProgressValueWithItem:item];
            [_acctionBtn setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
            self.acctionBtn.tag = TagUIbuttonPause;
            
        }else{
            [self ProgressValueWithItem:item];
            [_acctionBtn setImage:[UIImage imageNamed:@"icon_startmap_img"] forState:UIControlStateNormal];
            self.acctionBtn.tag = TagUIbuttonStart;
        }
        
    }else if (item.itemStatus == MAOfflineItemStatusExpired){
        [self hideProgressView];
        [self showAcctionBtn];
        [self showStateLableWithItem:item];
        self.stateLable.frame = CGRectMake(SCREENWIDTH-40-SCREENWIDTH/3, (kOffLineMapCellHeight-18)/2, SCREENWIDTH/3, 18);
        [_acctionBtn setImage:[UIImage imageNamed:@"icon_download_img"] forState:UIControlStateNormal];
        self.acctionBtn.tag = TagUIbuttonDowanLoad;
    }
}

#pragma mark ClickBtn
-(void)cliclActionBtn:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == TagUIbuttonDowanLoad) {
        [sender setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
        btn.tag = TagUIbuttonPause;
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(downloadItem:)]) {
            [self.delegate downloadItem:sender];
        }
    }else if (btn.tag == TagUIbuttonStart){
        btn.tag = TagUIbuttonPause;
        [sender setImage:[UIImage imageNamed:@"icon_pause_img"] forState:UIControlStateNormal];
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(startItem:)]) {
            [self.delegate startItem:sender];
        }
    }else if (btn.tag == TagUIbuttonPause){
        btn.tag = TagUIbuttonDowanLoad;
        [sender setImage:[UIImage imageNamed:@"icon_startmap_img"] forState:UIControlStateNormal];
        if ([self.delegate conformsToProtocol:@protocol(OfflLineMapCellDelegate)] && [self.delegate respondsToSelector:@selector(pauseItem:)]) {
            [self.delegate pauseItem:sender];
        }
    }else{
        NSLog(@"00");
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
    self.progressView = [[ProgressBarView alloc] initWithFrame:CGRectMake(10, kOffLineMapCellHeight-10, SCREENWIDTH-20, 10)];
    self.progressView.color = [UIColor colorWithRed:0.73f green:0.10f blue:0.00f alpha:1.00f];
    self.progressView.progress = 0.40;
    self.progressView.animate = @YES;
    self.progressView.background = [self.progressView.color colorWithAlphaComponent:0.8];
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
