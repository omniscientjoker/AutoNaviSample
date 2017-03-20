//
//  BaseViewController.h
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockDefine.h"
#import "MBProgressHUD.h"
@interface BaseViewController : UIViewController
- (BOOL)navigationControllerIsWillDealloc;
- (void)configUIAppearance;
- (void)animatedPopViewController;
- (void)registerKeyBordChangeFrameAction;
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view;
#pragma mark - aleartmessage
//message
- (void)showSuccessAlertWithMessage:(NSString *)message;
- (void)showErrorAlertWithMessage:(NSString *)message;
- (void)showAlertWithMessage:(NSString *)message hideAfterDelay:(float)delay;
//loading
- (void)loading;
- (BOOL)isloading;
- (void)loading:(NSString *)text;
//解决连续发送两个请求的问题
- (void)loadingBlock:(Block)operationBlock;
- (void)loading:(NSString *)text operationBlock:(Block)operationBlock;
- (void)closeLoading;
@end
