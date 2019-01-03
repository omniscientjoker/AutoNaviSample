//
//  UIColor+RGBValues.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/27.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBValues)
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;
@end
