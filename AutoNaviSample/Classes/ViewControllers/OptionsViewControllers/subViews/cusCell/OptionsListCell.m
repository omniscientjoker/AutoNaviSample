//
//  OptionsListCell.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "OptionsListCell.h"

@implementation OptionsListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self commitInit];
    }
    return self;
}
- (void)commitInit
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    _titleLabel.textColor = RGB(97, 97, 97);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(18);
         make.centerY.equalTo(self.contentView.mas_centerY);
     }];
    
    _cusSwitch = [[UISwitch alloc] init];
    _cusSwitch.onTintColor=COMMON_COLOR_BUTTON_BG;
    [self.contentView addSubview:_cusSwitch];
    [_cusSwitch mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.right.equalTo(self.contentView.mas_right).with.offset(-10);
         make.width.mas_equalTo(@60);
         make.height.mas_equalTo(@28);
     }];
}

- (void)setUpCellWithModels:(NSString *) content section:(NSInteger) section row:(NSInteger ) row{
    if(section==0&&row==0){
        _arrowImg.hidden=YES;
    }else{
        _arrowImg.hidden=NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
