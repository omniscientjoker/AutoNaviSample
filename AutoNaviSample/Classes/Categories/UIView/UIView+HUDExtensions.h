//
//  UIView+HUDExtensions.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewPopupMessageType) {
    UIViewPopupMessageTypeOK,
    UIViewPopupMessageTypeError
};

@interface UIView (HUDExtensions)

#pragma mark - Popup Loading
- (void)showPopupLoading;
- (void)showPopupLoadingWithText:(NSString *)text;
- (void)showPopupLoadingWithText:(NSString *)text hideAfterDelay:(float)delay;
- (void)hidePopupLoading;
- (void)hidePopupLoadingAnimated:(BOOL)animated;

#pragma mark - Popup Message
- (void)showPopupOKMessage:(NSString *)message;
- (void)showPopupErrorMessage:(NSString *)message;
- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type;
- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type completion:(void(^)(void))completion;

@end
