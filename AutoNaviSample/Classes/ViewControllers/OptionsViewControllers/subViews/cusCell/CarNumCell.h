//
//  CarNumCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/23.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToolViewTextField.h"
#define kCarNumCellHeight 56

@protocol CarNumCellDelegate <NSObject>
@optional
- (void)selectAttributionBtnClicked:(id)sender;
@end

@interface CarNumCell : UITableViewCell
@property (nonatomic,strong)UILabel             *titleLabel;
@property (nonatomic,strong)UIButton            *selectBtn;
@property (nonatomic,strong)UIToolViewTextField *inputField;
@property (weak, readwrite , nonatomic)id<CarNumCellDelegate> delegate;
-(void)updatecellUIWithSize:(CGFloat)size;
@end
