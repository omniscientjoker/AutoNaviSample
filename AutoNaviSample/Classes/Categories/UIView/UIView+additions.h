//
//  UIView+additions.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (additions)
@property(nonatomic,readwrite) CGFloat x,y;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property (nonatomic,assign)CGFloat centerx;
@property (nonatomic,assign)CGFloat centery;

@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;
- (UIViewController *)viewController;
- (void)removeAllSubviews;
- (void)removeAllGestureRecognizer;

@end

@interface UIView(ViewHiarachy)
@property (nonatomic,readonly)UIViewController *viewController;
- (void)removeAllSubviews;
@end

@interface UIView (gesture)
- (void)addTapAction:(SEL)tapAction target:(id)target;
@end

@interface UIView (sepLine)
+(UIView*) sepLineWithRect:(CGRect)rect;
+(UIView*) twoLayerSepLineWithRect:(CGRect)rect;
@end
