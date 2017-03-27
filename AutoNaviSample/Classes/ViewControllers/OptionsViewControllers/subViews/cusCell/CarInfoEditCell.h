//
//  CarInfoEditCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/22.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCarInfoListCellHeight 56
#import "UIToolViewTextField.h"

@interface CarInfoEditCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong)UILabel             *titleLabel;
@property (nonatomic,strong)UIToolViewTextField *inputField;
-(void)updatecellUIWithSize:(CGFloat)size;
@end
