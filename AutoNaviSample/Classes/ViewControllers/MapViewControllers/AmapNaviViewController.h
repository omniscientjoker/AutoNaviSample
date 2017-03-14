//
//  AmapNaviViewController.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@protocol AmapNaviViewControllerDelegate;

@interface AmapNaviViewController : BaseViewController
@property (nonatomic, weak) id <AmapNaviViewControllerDelegate> delegate;
@property (nonatomic, strong)  AMapNaviDriveView *driveView;
@end

@protocol AmapNaviViewControllerDelegate <NSObject>
- (void)driveNaviViewCloseButtonClicked;
@end
