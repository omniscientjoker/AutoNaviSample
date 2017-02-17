//
//  AmapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapViewController.h"
@interface AmapViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MAMapViewDelegate>
@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)AMapNaviDriveManager  *driveManager;
@property (nonatomic,strong)AMapNaviDriveView     *driveView;


@property (nonatomic,assign)BOOL                   TrafficoN;
@property (nonatomic,strong)NSArray               *endPoints;
@property (nonatomic,strong)NSArray               *startPoints;
@end

@implementation AmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initpoint];
    [self initMapView];
    

    [self initDriveManager];
    [self calculateRoute];
}



- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [self.driveManager startEmulatorNavi];
    NSLog(@"%@",self.driveManager.naviRoutes);
}
- (void)configDriveNavi
{
    [self.driveManager addDataRepresentative:self.driveView];
    [self.view addSubview:self.driveView];
}


//chushihua
- (void)initpoint{
    AMapNaviPoint * start = [AMapNaviPoint locationWithLatitude:39.99 longitude:116.47];
    AMapNaviPoint * end   = [AMapNaviPoint locationWithLatitude:39.90 longitude:116.32];
    self.startPoints = [NSArray arrayWithObjects:start, nil];
    self.endPoints   = [NSArray arrayWithObjects:end, nil];
}
- (void)initMapView{
    if (self.mapView == nil){
        //初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        [self.view addSubview:_mapView];
        
        //地图logo控件
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, SCREENHEIGHT-40);
        //显示指南针
        _mapView.showsCompass= YES;
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
        //显示定位
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //显示比例尺
        _mapView.showsScale= YES;
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
        //地图的缩放级别
        _mapView.zoomEnabled = YES;
        [_mapView setZoomLevel:17.5 animated:YES];
        //开启平移（滑动）手势
        _mapView.scrollEnabled = YES;
        //    [_mapView setCenterCoordinate:_mapView.center animated:YES];
        //旋转手势
        _mapView.rotateEnabled= NO;
    }
}
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

//
- (void)calculateRoute
{
    [self.driveManager calculateDriveRouteWithStartPoints:self.startPoints
                                                endPoints:self.endPoints
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategyMultipleAvoidCostAndCongestion];
}

//
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mapView.showTraffic = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.showTraffic = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
