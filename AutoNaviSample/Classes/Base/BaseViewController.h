//
//  BaseViewController.h
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (BOOL)navigationControllerIsWillDealloc;
- (void)configUIAppearance;//需要更换主题的UI部分都需要viewController继承,并写在该函数中
- (void)animatedPopViewController;
//键盘
- (void)registerKeyBordChangeFrameAction;
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view;
@end
