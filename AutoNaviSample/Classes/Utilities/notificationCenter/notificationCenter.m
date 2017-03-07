//
//  notificationCenter.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "notificationCenter.h"
#import <UserNotifications/UserNotifications.h>
@implementation notificationCenter
+(void)setNoticeWithTitile:(NSString *)titile Subtitle:(NSString *)subtitle Body:(NSString *)body{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"到达目的地";
    content.subtitle = @"车ID:70707";
    content.body = @"即将到达目的地！通知收货方准备接货。";
    content.badge = @1;
    
    UNNotificationAction *action_cancel = [UNNotificationAction actionWithIdentifier:@"action_cancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_sende = [UNNotificationAction actionWithIdentifier:@"action_sende" title:@"发送" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:arriveDefinition actions:@[action_cancel,action_sende] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [center setNotificationCategories:setting];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    NSString *requestIdentifier = arriveDefinition;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                          content:content
                                                                          trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}
@end
