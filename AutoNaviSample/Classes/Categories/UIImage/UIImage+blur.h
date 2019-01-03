//
//  UIImage+blur.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (blur)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
