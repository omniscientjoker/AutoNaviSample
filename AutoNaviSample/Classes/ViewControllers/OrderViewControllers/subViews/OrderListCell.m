//
//  OrderListCell.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderListModel.h"
@implementation OrderListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = RGB(245, 250, 250);
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(20, 15, self.frame.size.width-40, self.frame.size.height-30)];
        backView.backgroundColor = RGB(125, 125, 125);
        [self addSubview:backView];
        
        
        
       
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setUpCellWithModels:(OrderListInfoModel*) model{
    self.titleLab.text=model.rId;
    self.infoLab.text =model.content;
}
@end
