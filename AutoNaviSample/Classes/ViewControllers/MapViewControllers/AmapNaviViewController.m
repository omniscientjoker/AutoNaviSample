//
//  AmapNaviViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AmapNaviViewController.h"
#import "NaviMoreView.h"

@interface AmapNaviViewController ()<NaviMoreMenuViewDelegate,AMapNaviDriveViewDelegate>
@property(nonatomic,strong)NaviMoreView * moreMenu;
@end

@implementation AmapNaviViewController
- (instancetype)init
{
    if (self = [super init])
    {
        [self initDriveView];
        [self initMoreMenu];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.driveView setFrame:self.view.bounds];
    [self.view addSubview:self.driveView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] init];
        self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
    }
}

- (void)initMoreMenu
{
    if (self.moreMenu == nil)
    {
        self.moreMenu = [[NaviMoreView alloc] init];
        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.moreMenu setDelegate:self];
    }
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        [self.driveView setIsLandscape:NO];
    }else if (UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [self.driveView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DriveView Delegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(driveNaviViewCloseButtonClicked)]){
        [self.delegate driveNaviViewCloseButtonClicked];
    }
}

- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    [self.moreMenu setTrackingMode:self.driveView.trackingMode];
    [self.moreMenu setShowNightType:self.driveView.showStandardNightType];
    [self.moreMenu setFrame:self.view.bounds];
    [self.view addSubview:self.moreMenu];
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeNormal];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];
    }
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}

#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked
{
    [self.moreMenu removeFromSuperview];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType
{
    [self.driveView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode
{
    [self.driveView setTrackingMode:trackingMode];
}
@end
