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
- (void)configUIAppearance;
- (void)animatedPopViewController;

- (void)registerKeyBordChangeFrameAction;
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view;
@end
