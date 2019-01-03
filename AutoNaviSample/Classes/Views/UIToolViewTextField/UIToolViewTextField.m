//
//  UIToolViewTextField.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIToolViewTextField.h"

@implementation UIToolViewTextField
- (UIView *)inputAccessoryView{
    return self.inputAccessoryViewInit;
}

- (UIToolbar *)inputAccessoryViewInit{
    
    if (self.customInputAccessoryView) {
        return self.customInputAccessoryView;
    }
    
    self.customInputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.inputAccessoryView.width - 60, 0, 60, self.inputAccessoryView.height)];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customInputAccessoryView addSubview:completeButton];
    
    return self.customInputAccessoryView;
}
- (void)closeKeyBoard{
    [self resignFirstResponder];
}

@end
