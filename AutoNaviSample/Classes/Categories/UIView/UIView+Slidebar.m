//
//  UIView+Slidebar.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIView+Slidebar.h"

@implementation UIView (Slidebar)

-(UIView *)lastSubviewOnX{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        for(UIView *v in self.subviews)
            if(v.frame.origin.x > outView.frame.origin.x)
                outView = v;
        return outView;
    }
    return nil;
}

-(UIView *)lastSubviewOnY{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        for(UIView *v in self.subviews)
            if(v.frame.origin.y > outView.frame.origin.y)
                outView = v;
        return outView;
    }
    return nil;
}

+ (void)showSlidebarView:(NSString*)title Message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue() , ^{
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = title;
        alert.message = message;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        alert = nil;
    });
}

+ (void)showSlidebarView:(NSString*)title
                 Message:(NSString *)message
                Delegate:(UIViewController<UIAlertViewDelegate> *)delegate
{
    dispatch_async(dispatch_get_main_queue() , ^{
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = title;
        alert.message = message;
        alert.delegate = delegate;
        alert.tag = 100001012;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        alert = nil;
    });
}

-(UIAlertController *)setAlertViewWithTitle:(NSString *)title Message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
    }]];
    return alertController;
}

@end
