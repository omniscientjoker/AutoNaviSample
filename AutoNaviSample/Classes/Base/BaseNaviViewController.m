//
//  BaseNaviViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface BaseNaviViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MAMapViewDelegate>
@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)AMapNaviDriveManager  *driveManager;
@property (nonatomic,strong)AMapNaviDriveView     *driveView;

@property (nonatomic,strong)NSArray               *endPoints;
@property (nonatomic,strong)NSArray               *startPoints;
@property (nonatomic,strong)NSMutableArray        *routeIndicatorInfoArray;
@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - init地图相关控件
- (void)initMapView{
    if (self.mapView == nil){
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        [self.view addSubview:_mapView];
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, SCREENHEIGHT-40);
        _mapView.showsCompass= YES;
        _mapView.showTraffic = YES;
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = MAUserTrackingModeNone;
        _mapView.showsScale= YES;
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
        _mapView.zoomEnabled = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled= NO;
    }
}
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
        [self.driveManager setAllowsBackgroundLocationUpdates:YES];
        [self.driveManager setPausesLocationUpdatesAutomatically:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
