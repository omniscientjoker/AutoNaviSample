//
//  NaviMapHelp.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/8.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface NaviMapHelp : MAMapView
+ (MAMapView *)shareMAMapView;
+ (id)allocWithZone:(NSZone *)zone;
+ (id)copyWithZone:(NSZone *)zone;
@end
