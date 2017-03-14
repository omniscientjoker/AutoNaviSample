//
//  UIView+Slidebar.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Slidebar)
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

+ (void)showSlidebarView:(NSString*)title Message:(NSString *)message;
+ (void)showSlidebarView:(NSString*) title
                 Message:(NSString *) message
                Delegate:(UIViewController<UIAlertViewDelegate> *)delegate;
@end
