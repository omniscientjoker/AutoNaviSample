//
//  RouteCollectionViewCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCollectionViewInfo : NSObject

@property (nonatomic, assign) NSInteger routeID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

@interface RouteCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) RouteCollectionViewInfo *info;

@property (nonatomic, assign) BOOL shouldShowPrevIndicator;
@property (nonatomic, assign) BOOL shouldShowNextIndicator;

@end
