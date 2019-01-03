//
//  OptionsListCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOptionsListCellHeight 56
@interface OptionsListCell : UITableViewCell
@property (nonatomic,strong)UILabel       *titleLabel;
@property (nonatomic,strong)UISwitch      *cusSwitch;
@property (nonatomic,strong)UIImageView   *arrowImg;

- (void)setUpCellWithModels:(NSString *) content section:(NSInteger) section row:(NSInteger ) row;
@end
