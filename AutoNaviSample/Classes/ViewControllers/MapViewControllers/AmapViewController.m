//
//  AmapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapViewController.h"
#import "PreferenceView.h"
#import "RouteCollectionViewCell.h"
#import "SelectableOverlay.h"

#define kRoutePlanInfoViewHeight    130.f
#define kRouteIndicatorViewHeight   64.f
#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

@interface AmapViewController ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MAMapViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)MAMapView             *mapView;
@property (nonatomic,strong)AMapNaviDriveManager  *driveManager;
@property (nonatomic,strong)AMapNaviDriveView     *driveView;


@property (nonatomic,assign)BOOL                   TrafficoN;
@property (nonatomic,strong)NSArray               *endPoints;
@property (nonatomic,strong)NSArray               *startPoints;

@property (nonatomic, strong) UICollectionView *routeIndicatorView;
@property (nonatomic, strong) NSMutableArray   *routeIndicatorInfoArray;
@property (nonatomic, strong) PreferenceView   *preferenceView;

@property (nonatomic, assign) BOOL isMultipleRoutePlan;

@end

@implementation AmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
- (void)initAnnotations
{
    MAPointAnnotation *beginAnnotation = [[MAPointAnnotation alloc] init];
    AMapNaviPoint * startpoint = [self.startPoints objectAtIndex:0];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(startpoint.latitude, startpoint.longitude)];
    beginAnnotation.title = @"起始点";
    [self.mapView addAnnotation:beginAnnotation];
    
    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    AMapNaviPoint * endpoint = [self.endPoints objectAtIndex:0];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(endpoint.latitude, endpoint.longitude)];
    endAnnotation.title = @"终点";
    [self.mapView addAnnotation:endAnnotation];
}

//
- (void)calculateRoute
{
    //进行多路径规划
    self.isMultipleRoutePlan = YES;
    [self.driveManager calculateDriveRouteWithStartPoints:self.startPoints
                                                endPoints:self.endPoints
                                                wayPoints:nil
                                          drivingStrategy:[self.preferenceView strategyWithIsMultiple:self.isMultipleRoutePlan]];
}

#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
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
        
        //更新CollectonView的信息
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)[self.preferenceView strategyWithIsMultiple:self.isMultipleRoutePlan]];
        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
        
        [self.routeIndicatorInfoArray addObject:info];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    [self.routeIndicatorView reloadData];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}
- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    //在开始导航前进行路径选择
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}
- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
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
