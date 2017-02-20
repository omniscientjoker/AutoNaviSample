//
//  SelectableOverlay.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@interface SelectableOverlay : NSObject<MAOverlay>
@property (nonatomic, assign) NSInteger routeID;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIColor * regularColor;
@property (nonatomic, strong) id<MAOverlay> overlay;
- (id)initWithOverlay:(id<MAOverlay>) overlay;
@end
