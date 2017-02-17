//
//  AmapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapViewController.h"

@interface AmapViewController ()
@property (nonatomic,strong)MAMapView *mapView;
@end

@implementation AmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    ///把地图添加至view
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
