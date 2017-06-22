//
//  NaviMapHelp.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/8.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "NaviMapHelp.h"
#import <objc/runtime.h>

@implementation NaviMapHelp
static id _instance;
//static MAMapView *_mapView = nil;

+ (MAMapView *)shareMAMapView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MAMapView * mapView = [[MAMapView alloc] init];
        mapView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        mapView.rotateEnabled = YES;
        mapView.rotateCameraEnabled = YES;
        mapView.zoomEnabled = YES;
        _instance = mapView;
    });
    return _instance;
}
+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
//@end
//
//
//@implementation MAMapView (solideView)
//+ (void)init{
//    Method allocWithZone = class_getInstanceMethod(self, @selector(allocWithZone:));
//    Method allocWithNewZone = class_getInstanceMethod(self, @selector(allocWithNewZone:));
//    method_exchangeImplementations(allocWithZone, allocWithNewZone);
//}
//+ (MAMapView *)allocWithNewZone:(NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _mapView = [super allocWithZone:zone];
//    });
//    return _mapView;
//}
@end

