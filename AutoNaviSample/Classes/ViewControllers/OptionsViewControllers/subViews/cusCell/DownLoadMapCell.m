//
//  DownLoadMapCell.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/31.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "DownLoadMapCell.h"
#import "offlineMapHandle.h"
@implementation DownLoadMapCell
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
    _acctionBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, (kdownLoadMapMangerCellHeight-20)/2, 20, 20)];
    [_acctionBtn setImage:[UIImage imageNamed:@"icon_unselected_round"] forState:UIControlStateNormal];
    [_acctionBtn setImage:[UIImage imageNamed:@"icon_selected_round"] forState:UIControlStateSelected];
    [_acctionBtn addTarget:self action:@selector(clickSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_acctionBtn];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, SCREENWIDTH/3, 20)];
    _titleLable.font = [UIFont systemFontOfSize:16.0f];
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLable];
    
    
    _sizeLable = [[UILabel alloc] initWithFrame:CGRectMake(38, 40, SCREENWIDTH/4, 10)];
    _sizeLable.font = [UIFont systemFontOfSize:12.0f];
    _sizeLable.textColor = [UIColor blackColor];
    _sizeLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_sizeLable];
    
    _stateLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-10-SCREENWIDTH/3, (kdownLoadMapMangerCellHeight-18)/2, SCREENWIDTH/3, 18)];
    _stateLable.font = [UIFont systemFontOfSize:15.0f];
    _stateLable.textColor = [UIColor blackColor];
    _stateLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateLable];
}
-(void)clickSelectedBtn:(id)sender{
    UIButton * btn = (UIButton*)sender;
    if (btn.selected) {
        self.acctionBtn.selected = NO;
    }else{
        self.acctionBtn.selected = YES;
    }
    if ([self.delegate conformsToProtocol:@protocol(DownLoadMapCellDelegate)] && [self.delegate respondsToSelector:@selector(selectAttribution:)]) {
        [self.delegate selectAttribution:sender];
    }
}
-(void)updateCellViewForItem:(MAOfflineItem *)item{
    self.titleLable.text = item.name;
    self.sizeLable.text  = [NSString stringWithFormat:@"大小:%@", [[offlineMapHandle sharedInstance]convertFileSizeWithSize:item.size]];
    self.stateLable.text = [[offlineMapHandle sharedInstance] returnMapStateForItem:item];
}

@end
