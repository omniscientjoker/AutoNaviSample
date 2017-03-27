//
//  CarNumCell.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/23.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "CarNumCell.h"

@implementation CarNumCell
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
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor = RGB(97, 97, 97);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView.mas_left).with.offset(18);
         make.centerY.equalTo(self.contentView.mas_centerY);
     }];
    
    _selectBtn = [[UIButton alloc] init];
    _selectBtn.backgroundColor = [UIColor whiteColor];
    _selectBtn.layer.cornerRadius = 2.0f;
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _selectBtn.layer.borderWidth = 2.0f;
    [_selectBtn setTitle:@"苏" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_arrowdown_img"] forState:UIControlStateNormal];
    _selectBtn.imageView.size = CGSizeMake(15, 10);
    _selectBtn.titleLabel.size = CGSizeMake(25, 20);
    [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -38)];
    [_selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -38, 0, 0)];
    
    [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(_titleLabel.mas_right).with.offset(8);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.height.mas_equalTo(@28);
         make.width.mas_equalTo(@50);
     }];
    
    
    
    _inputField = [[UIToolViewTextField alloc] init];
    _inputField.backgroundColor = RGB(242, 242, 242);
    _inputField.textColor = RGBA(100, 100, 100, 1.0);
    _inputField.font = [UIFont systemFontOfSize:17.0];
    _inputField.clipsToBounds = YES;
    _inputField.textAlignment = NSTextAlignmentLeft;
    [_inputField setValue:RGBA(100, 100, 100, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [_inputField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _inputField.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:_inputField];
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.left.equalTo(_selectBtn.mas_right).with.offset(10);
         make.height.mas_equalTo(@40);
         make.right.equalTo(self.contentView.mas_right).with.offset(-10);
     }];
}
-(void)clickSelectBtn:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(CarNumCellDelegate)] && [self.delegate respondsToSelector:@selector(selectAttributionBtnClicked:)]) {
        [self.delegate selectAttributionBtnClicked:sender];
    }
}
-(void)updatecellUIWithSize:(CGFloat)size{
    CGFloat weight = size + 3;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView.mas_left).with.offset(18);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.width.mas_equalTo(weight);
     }];
    [_selectBtn mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(_titleLabel.mas_right).with.offset(8);
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.height.mas_equalTo(@28);
         make.width.mas_equalTo(@50);
     }];
    [_inputField mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(self.contentView.mas_centerY);
         make.left.equalTo(_selectBtn.mas_right).with.offset(10);
         make.height.mas_equalTo(@40);
         make.right.equalTo(self.contentView.mas_right).with.offset(-10);
     }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
