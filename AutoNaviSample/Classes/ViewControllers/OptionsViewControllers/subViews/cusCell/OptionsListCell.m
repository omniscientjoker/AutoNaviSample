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
    [self addSubview:_cusSwitch];
    
    _arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    [self addSubview:_arrowImg];
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(self.mas_centerY);
         make.right.equalTo(self.mas_right).with.offset(-15);
     }];
    
}

- (void)setUpCellWithModels:(NSString *) content section:(NSInteger) section row:(NSInteger ) row{
    if(section==0&&row==0){
        _arrowImg.hidden=YES;
        _cusSwitch.frame=CGRectMake(SCREENWIDTH-68, kOptionsListCellHeight/2-14, 60, 28);
    }else{
        _arrowImg.hidden=NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
