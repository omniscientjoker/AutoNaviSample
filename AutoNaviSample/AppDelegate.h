//
//  AppDelegate.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SlidebarMenu.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) UINavigationController *rootNaviController;
@end

