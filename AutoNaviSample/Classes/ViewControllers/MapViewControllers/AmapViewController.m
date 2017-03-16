//
//  AmapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapViewController.h"
#import "arriveAlertView.h"
#include <objc/runtime.h>
#import "NaviMapHelp.h"
#import "MBProgressHUD.h"
#import "notificationCenter.h"
#import "AmapRouteNaviViewController.h"
#import "UIViewController+SlidebarMenu.h"
#import "LoginUser.h"


@interface AmapViewController ()<MAMapViewDelegate,AMapGeoFenceManagerDelegate,AMapLocationManagerDelegate,MBProgressHUDDelegate>
{
    BOOL  showCurrentLocation;
}
@property (nonatomic,strong)MBProgressHUD         *HUD;
@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)MACircle              *geoFenceCircle;
@property (nonatomic,strong)AMapLocationManager   *locationManager;
@property (nonatomic,strong)AMapGeoFenceManager   *geoFenceManager;
@property (nonatomic,assign)CLLocationCoordinate2D nowPoint;
@property (nonatomic,strong)MAPointAnnotation     *destinationPoint;

@end

@implementation AmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [LoginUser parseLoginUserInfoFromUserDefaults];
    
    [LoginUser sharedInstance].setSlidebarIndex = 1;
    [LoginUser sharedInstance].uId = @"000";
    if (showCurrentLocation) {
        showCurrentLocation = YES;
    }

    self.title = @"地图";
//    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
}


-(void)setButton{
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_btn_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIButton * locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, SCREENHEIGHT-90, 24, 24)];
    [locationBtn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(setlocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    UIButton * destinationBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-50, SCREENHEIGHT-90, 24, 24)];
    [destinationBtn setImage:[UIImage imageNamed:@"icon_destination"] forState:UIControlStateNormal];
    [destinationBtn addTarget:self action:@selector(setdestinationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:destinationBtn];
    
    UIButton * clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, SCREENHEIGHT-38, SCREENWIDTH-4, 36)];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    clickBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    clickBtn.backgroundColor =COMMON_COLOR_BUTTON_BG;
    clickBtn.layer.masksToBounds = YES;
    clickBtn.layer.cornerRadius  = 4.0f;
    [clickBtn setTitle:@"规划路径" forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
}
#pragma mark - 创建地图页面
- (void)initMapView{
    if (self.mapView == nil){
        _mapView = [NaviMapHelp shareMAMapView];
        
        _mapView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40);
        
        [self.mapView setDelegate:self];
        
        _mapView.scrollEnabled = YES;
        _mapView.showTraffic   = YES;
        
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.frame)-55, 0);
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.showsCompass= YES;
        
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
        _mapView.showsScale= NO;
        
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:15.5 animated:YES];
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;
        [self.view addSubview:_mapView];
    }
    [self setButton];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation){
        self.nowPoint = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        if (showCurrentLocation == YES) {
            [_mapView setCenterCoordinate:self.nowPoint animated:YES];
        }
        [self initgeoFence];
    }
}

#pragma mark - 获取定位信息
- (void)setlocation
{
    if (self.locationManager == nil) {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.locationTimeout  = 6;
    self.locationManager.reGeocodeTimeout = 6;
    __weak __typeof(&*self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        showCurrentLocation = YES;
        if (error){
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        weakSelf.nowPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [_mapView setCenterCoordinate:weakSelf.nowPoint animated:YES];
        if (regeocode){
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}

#pragma mark - 电子围栏
- (void)initgeoFence
{
    if (self.geoFenceManager == nil) {
        self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
        self.geoFenceManager.delegate = self;
        self.geoFenceManager.activeAction = AMapGeoFenceActiveActionOutside;
        self.geoFenceManager.allowsBackgroundLocationUpdates = YES;
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:self.nowPoint radius:150 customID:@"destination"];
    }
}
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        self.geoFenceManager = nil;
    } else {
        _geoFenceCircle = [MACircle circleWithCenterCoordinate:self.nowPoint radius:150];
        [_mapView addOverlay: _geoFenceCircle];
    }
}
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        [notificationCenter setNoticeWithTitile:@"" Subtitle:@"" Body:@""];
    }
}
-(void)setalertview
{
    arriveAlertView *view = [[arriveAlertView alloc]initWithCarID:@"009090"];
    view.frame = self.view.bounds;
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
}



#pragma mark - MAMapView Delegate
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState
   fromOldState:(MAAnnotationViewDragState)oldState
{
    if (oldState == MAAnnotationViewDragStateStarting) {
        showCurrentLocation = NO;
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = NO;
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleRenderer.fillColor    = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        return circleRenderer;
    }
    
    return nil;
}


#pragma mark - btnclick
-(void)clickBtn:(UIButton *)btn
{
    AmapRouteNaviViewController * nav  =[[AmapRouteNaviViewController alloc] initWithStartPoint:self.nowPoint EndPoint:self.destinationPoint.coordinate];
    [self.navigationController pushViewController:nav animated:YES];
}
-(void)setlocationBtn:(UIButton *)btn
{
    [_mapView setZoomLevel:15.5 animated:YES];
    showCurrentLocation = YES;
    [self setlocation];
}
-(void)setdestinationBtn:(UIButton *)btn
{
    [_mapView setZoomLevel:15.5 animated:YES];
    showCurrentLocation = NO;
    [_mapView setCenterCoordinate:self.destinationPoint.coordinate animated:YES];
    
}

//页面周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initMapView];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.destinationPoint = [[MAPointAnnotation alloc] init];
    self.destinationPoint.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    self.destinationPoint.title = @"方恒国际";
    self.destinationPoint.subtitle = @"阜通东大街6号";
    [_mapView addAnnotation:self.destinationPoint];
    if (_geoFenceCircle) {
        [_mapView addOverlay: _geoFenceCircle];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
    [_mapView removeOverlay:_geoFenceCircle];
    [_mapView removeAnnotation:self.destinationPoint];
    self.mapView.showsUserLocation = NO;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mapView.delegate=nil;
    self.mapView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
