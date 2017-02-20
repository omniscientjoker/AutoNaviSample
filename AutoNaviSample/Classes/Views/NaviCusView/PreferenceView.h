//
//  PreferenceView.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferenceView : UIView
//根据路径偏好状态获取路径计算策略
- (AMapNaviDrivingStrategy)strategyWithIsMultiple:(BOOL)isMultiple;
@end
