//
//  NaviMapHelp.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/8.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "NaviMapHelp.h"

@implementation NaviMapHelp

static MAMapView *_mapView = nil;

+ (MAMapView *)shareMAMapView {
    @synchronized(self) {
        if (_mapView == nil) {
            _mapView = [[MAMapView alloc] init];
            _mapView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _mapView.rotateEnabled = YES;
            _mapView.rotateCameraEnabled = YES;
            _mapView.zoomEnabled = YES;
        }
        return _mapView;
    }
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_mapView == nil) {
            _mapView = [super allocWithZone:zone];
            return _mapView;
        }
    }
    return nil;
}

+ (id)copyWithZone:(NSZone *)zone {
    return _mapView;
}
@end