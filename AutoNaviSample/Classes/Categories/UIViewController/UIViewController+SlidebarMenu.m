//
//  UIViewController+SlidebarMenu.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIViewController+SlidebarMenu.h"
#import "SlidebarMenu.h"
@implementation UIViewController (SlidebarMenu)

- (SlidebarMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[SlidebarMenu class]]) {
            return (SlidebarMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}
- (void)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
