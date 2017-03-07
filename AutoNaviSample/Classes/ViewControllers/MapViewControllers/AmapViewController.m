//
//  AmapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapViewController.h"
#import "arriveAlertView.h"
#import "UIView+HUDExtensions.h"
#import "MBProgressHUD.h"
#import "notificationCenter.h"

@interface AmapViewController ()<MAMapViewDelegate,AMapGeoFenceManagerDelegate,AMapLocationManagerDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong)MBProgressHUD         *HUD;
@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)AMapLocationManager   *locationManager;
@property (nonatomic,strong)AMapGeoFenceManager   *geoFenceManager;
@property(nonatomic, strong)UIView                *hudContentView;
@property (nonatomic,assign)CLLocationCoordinate2D nowPoint;

@end

@implementation AmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initMapView];
    [self setlocation];
    [self firstlocation];
}

#pragma mark - 创建地图页面
- (void)initMapView{
    if (self.mapView == nil){
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, SCREENHEIGHT-40);
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.showsCompass= YES;
        
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
        _mapView.showsScale= NO;
        
        _mapView.zoomEnabled   = YES;
        _mapView.scrollEnabled = YES;
        _mapView.rotateEnabled = YES;
        
        _mapView.showTraffic   = YES;
        
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:15.5 animated:YES];
        [self.view addSubview:_mapView];
    }
}

#pragma mark - 获取定位信息
- (void)setlocation
{
    if (self.locationManager == nil) {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
}
- (void)firstlocation
{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.locationTimeout =8;
    self.locationManager.reGeocodeTimeout = 8;
    [self HUDshow];
    __weak __typeof(&*self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [weakSelf HUDhide];
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        weakSelf.nowPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [_mapView setCenterCoordinate:weakSelf.nowPoint animated:YES];
        [weakSelf initgeoFence];
        [weakSelf startLocation];
        if (regeocode){
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}
- (void)startLocation
{
    self.locationManager.distanceFilter = 10;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.locatingWithReGeocode = YES;
    [self.locationManager startUpdatingLocation];
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (location.horizontalAccuracy > 200  || location.horizontalAccuracy == -1 ) {
        NSLog(@"定位不准");
    }else{
        self.nowPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [_mapView setCenterCoordinate:self.nowPoint animated:YES];
    }
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
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
        MACircle *circle = [MACircle circleWithCenterCoordinate:self.nowPoint radius:150];
        [_mapView addOverlay: circle];
    }
}
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
        [self setalertview];
        [notificationCenter setNoticeWithTitile:@"" Subtitle:@"" Body:@""];
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

#pragma mark - view
- (void)HUDshow{
    [self.view addSubview:self.hudContentView];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.margin = 15.f;
    self.HUD.removeFromSuperViewOnHide = YES;
    self.HUD.delegate = self;
    [self.HUD showAnimated:YES];
}
- (void)HUDhide{
    if (self.HUD != nil) {
        [self.hudContentView removeFromSuperview];
        [self.HUD hideAnimated:YES];
    }
}
- (UIView *)hudContentView
{
    
    if (_hudContentView) {
        
        return _hudContentView;
    }
    _hudContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    _hudContentView.backgroundColor = [UIColor clearColor];
    return _hudContentView;
}

#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
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


//页面周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
