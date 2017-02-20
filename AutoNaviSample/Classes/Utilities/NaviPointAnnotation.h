//
//  NaviPointAnnotation.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
typedef NS_ENUM(NSInteger, NaviPointAnnotationType)
{
    NaviPointAnnotationStart,
    NaviPointAnnotationWay,
    NaviPointAnnotationEnd
};
@interface NaviPointAnnotation : MAPointAnnotation
@property (nonatomic, assign) NaviPointAnnotationType navPointType;
@end
