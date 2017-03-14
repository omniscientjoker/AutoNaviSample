//
//  AmapRouteNaviViewController.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmapRouteNaviViewController : BaseViewController

-(instancetype)initWithStartPoint:(CLLocationCoordinate2D)start EndPoint:(CLLocationCoordinate2D)end;

@end
