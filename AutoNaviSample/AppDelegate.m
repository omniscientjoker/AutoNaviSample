//
//  AppDelegate.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AppDelegate.h"
#import "SlidebarMainViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // 高德地图
    [AMapServices sharedServices].apiKey = KEYAMAPKEY;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    //通知
    if (CurrentSystemVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];
    }
    
    
//    self.window.rootViewController  = [[UINavigationController alloc] initWithRootViewController:[[AmapViewController alloc] init]];
    
    self.mainNaviController = [[UINavigationController alloc] initWithRootViewController:[[AmapViewController alloc] init]];
    
    SlidebarMainViewController *slideMainView = [[SlidebarMainViewController alloc] init];
    self.SlidebarVC = [[SlidebarViewController alloc] initWithLeftView:slideMainView andMainView:self.mainNaviController];
    
    self.window.rootViewController = self.SlidebarVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    completionHandler();
    NSLog(@"userInfo--%@",response.notification.request.content.userInfo);
    [center getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
        for (UNNotificationCategory *category in categories) {
            if ([category.identifier isEqualToString:arriveDefinition] && [response.notification.request.content.categoryIdentifier isEqualToString:arriveDefinition]) {
                for (UNNotificationAction *action_sende in category.actions) {
                    if ([action_sende.identifier isEqualToString:@"action_sende"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"收货信息已发送" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                    }
                }
            }
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
