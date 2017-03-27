//
//  attributionView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/22.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol attributionViewDelegate;
@protocol attributionViewDelegate <NSObject>
@optional
- (void)selectAttribution:(NSString *)str;
@end

@interface attributionView : UIView
@property(nonatomic,strong)NSArray  *attributionArr;
@property(weak, readwrite, nonatomic) id <attributionViewDelegate>  delegate;
-(instancetype)initWithAttName:(NSString *)name;
@end
