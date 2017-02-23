//
//  NaviMoreView.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviCommonObj.h>

@protocol NaviMoreMenuViewDelegate;
@interface NaviMoreView : UIView
@property (nonatomic, assign) id<NaviMoreMenuViewDelegate> delegate;
@property (nonatomic, assign) AMapNaviViewTrackingMode trackingMode;
@property (nonatomic, assign) BOOL showNightType;
@end
@protocol NaviMoreMenuViewDelegate <NSObject>
@optional
- (void)moreMenuViewFinishButtonClicked;
- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode;
- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType;
@end
