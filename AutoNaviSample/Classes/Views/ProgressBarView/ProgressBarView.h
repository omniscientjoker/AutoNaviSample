//
//  ProgressBarView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/27.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat labelProgress;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIColor *color UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *background UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) NSNumber *flat UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *animate UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *showStroke UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *showText UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *showBackground UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *showBackgroundInnerShadow UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *outerStrokeWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *progressInset UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSNumber *borderRadius UI_APPEARANCE_SELECTOR;

- (void)overrideProgressText:(NSString *)progressText;
- (void)overrideProgressTextColor:(UIColor *)progressTextColor;

@end
