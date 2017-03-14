//
//  AppDelegate.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidebarViewController.h"
#import "AmapViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SlidebarViewController        *SlidebarVC;//侧滑视图VC
@property (strong, nonatomic) UINavigationController        *mainNaviController;//主视图NaviVC

@end

