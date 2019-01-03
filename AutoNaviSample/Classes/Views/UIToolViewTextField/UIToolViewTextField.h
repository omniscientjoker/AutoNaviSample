//
//  UIToolViewTextField.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolViewTextField : UITextField
@property (nonatomic, strong) UIToolbar *customInputAccessoryView;
-(void)closeKeyBoard;
@end
