//
//  UIViewController+SlidebarMenu.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlidebarMenu;
@interface UIViewController (SlidebarMenu)
@property (strong, readonly, nonatomic) SlidebarMenu *sideMenuViewController;
- (void)presentLeftMenuViewController:(id)sender;
@end
