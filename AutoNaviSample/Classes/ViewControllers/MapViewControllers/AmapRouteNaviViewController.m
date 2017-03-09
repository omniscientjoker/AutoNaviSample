//
//  AmapRouteNaviViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapRouteNaviViewController.h"
#import "NaviMapHelp.h"
#import "PreferenceView.h"
#import "RouteCollectionViewCell.h"
#import "SelectableOverlay.h"
#import "NaviPointAnnotation.h"
#import "AmapNaviViewController.h"

#define kRoutePlanInfoViewHeight    130.f
#define kRouteIndicatorViewHeight   64.f
#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

@interface AmapRouteNaviViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MAMapViewDelegate,AmapNaviViewControllerDelegate,AMapGeoFenceManagerDelegate,AMapLocationManagerDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL issuccessed;
}

@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)AMapNaviDriveManager  *driveManager;
@property (nonatomic,strong)AMapNaviDriveView     *driveView;
@property (nonatomic,strong)AMapLocationManager   *locationManager;
@property (nonatomic,strong)AMapGeoFenceManager   *geoFenceManager;


@property (nonatomic,assign)BOOL                   trafficON;
@property (nonatomic,strong)NSArray               *endPoints;
@property (nonatomic,strong)NSArray               *startPoints;
@property (nonatomic,assign)CLLocationCoordinate2D nowPoint;

@property (nonatomic,strong)UICollectionView *routeIndicatorView;
@property (nonatomic,strong)NSMutableArray   *routeIndicatorInfoArray;
@property (nonatomic,strong)PreferenceView   *preferenceView;

@property (nonatomic,assign)BOOL isMultipleRoutePlan;

@end

@implementation AmapRouteNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [self initMapView];
    [self initDriveManager];
    [self setPoint];
    
    [self calculateRoute];
    [self initRouteIndicatorView];
}

#pragma mark - 创建地图页面
- (void)initMapView{
    if (self.mapView == nil){
        _mapView = [NaviMapHelp shareMAMapView];
        _mapView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [self.mapView setDelegate:self];
        _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, SCREENHEIGHT-40);
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.showsCompass= YES;
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
        _mapView.showsScale= NO;
        
        _mapView.showTraffic   = YES;
        [_mapView setZoomLevel:15.5 animated:YES];
        
        [self.view addSubview:_mapView];
    }
}
- (void)setPoint{
    AMapNaviPoint * start =  [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    AMapNaviPoint * end   =  [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
    self.startPoints = [NSArray arrayWithObjects:start, nil];
    self.endPoints   = [NSArray arrayWithObjects:end, nil];
    self.routeIndicatorInfoArray = [NSMutableArray array];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((start.latitude + end.latitude)/2, (start.longitude + end.longitude)/2);
    MACoordinateSpan  span = MACoordinateSpanMake( fabs(start.latitude - end.latitude)+0.01, fabs(start.longitude - end.longitude)+0.01);
    MACoordinateRegion Region = MACoordinateRegionMake(center, span);
    [_mapView setRegion:Region animated:YES];
}
- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    AMapNaviPoint * startpoint = [self.startPoints objectAtIndex:0];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(startpoint.latitude, startpoint.longitude)];
    beginAnnotation.title = @"起始点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;
    [self.mapView addAnnotation:beginAnnotation];
    
    
    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    AMapNaviPoint * endpoint = [self.endPoints objectAtIndex:0];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(endpoint.latitude, endpoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;
    [self.mapView addAnnotation:endAnnotation];
}

#pragma mark - 路径规划
//路径规划
- (void)calculateRoute
{
    self.isMultipleRoutePlan = YES;
    
    issuccessed = [self.driveManager calculateDriveRouteWithStartPoints:self.startPoints
                                                endPoints:self.endPoints
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategyMultiplePrioritiseHighwayAvoidCongestion];
}
//处理返回数据显示路径
- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0){
        return;
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    //将路径显示到地图上
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        [self.mapView addOverlay:selectablePolyline];
        free(coords);
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)[self.preferenceView strategyWithIsMultiple:self.isMultipleRoutePlan]];
        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
        
        [self.routeIndicatorInfoArray addObject:info];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    [self.routeIndicatorView reloadData];
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID){
                 selectableOverlay.selected = YES;
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }else{
                 selectableOverlay.selected = NO;
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             [overlayRenderer glRender];
         }
     }];
}


#pragma mark - 控制导航
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
- (void)driveNaviViewCloseButtonClicked
{
    [self.driveManager stopNavi];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    [self showNaviRoutes];
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode{
    NSLog(@"开始导航");
}

//出错提示信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager{
    NSLog(@"needRecalculateRouteForYaw");
}
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager{
    NSLog(@"needRecalculateRouteForTrafficJam");
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
}
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    NSLog(@"didEndEmulatorNavi");
}
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager{
    NSLog(@"onArrivedDestination");
}


#pragma mark - 导航路径选择
//创建路径页面
- (void)initRouteIndicatorView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _routeIndicatorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kRouteIndicatorViewHeight, CGRectGetWidth(self.view.bounds), kRouteIndicatorViewHeight) collectionViewLayout:layout];
    _routeIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _routeIndicatorView.backgroundColor = [UIColor clearColor];
    _routeIndicatorView.pagingEnabled = YES;
    _routeIndicatorView.showsVerticalScrollIndicator = NO;
    _routeIndicatorView.showsHorizontalScrollIndicator = NO;
    _routeIndicatorView.delegate = self;
    _routeIndicatorView.dataSource = self;
    [_routeIndicatorView registerClass:[RouteCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [self.view addSubview:_routeIndicatorView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    RouteCollectionViewCell *cell = [[self.routeIndicatorView visibleCells] firstObject];
    if (cell.info){
        [self selectNaviRouteWithID:cell.info.routeID];
    }
}
//选择路径
- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    if ([self.driveManager selectNaviRouteWithRouteID:routeID]){
        [self selecteOverlayWithRouteID:routeID];
    }else{
        NSLog(@"路径选择失败!");
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AmapNaviViewController *driveVC = [[AmapNaviViewController alloc] init];
    [driveVC setDelegate:self];
    [self.driveManager addDataRepresentative:driveVC.driveView];
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startEmulatorNavi];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.routeIndicatorInfoArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    cell.shouldShowPrevIndicator = (indexPath.row > 0 && indexPath.row < _routeIndicatorInfoArray.count);
    cell.shouldShowNextIndicator = (indexPath.row >= 0 && indexPath.row < _routeIndicatorInfoArray.count-1);
    cell.info = self.routeIndicatorInfoArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 10, CGRectGetHeight(collectionView.bounds) - 5);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[NaviPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"NaviPointAnnotationIdentifier";
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        NaviPointAnnotation *navAnnotation = (NaviPointAnnotation *)annotation;
        if (navAnnotation.navPointType == NaviPointAnnotationStart){
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }else if (navAnnotation.navPointType == NaviPointAnnotationEnd){
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        return pointAnnotationView;
    }
    return nil;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        return polylineRenderer;
    }
    return nil;
}


//页面周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initAnnotations];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
