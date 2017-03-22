//
//  offlineMapHeadView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol offlineMapHeadViewDelegate;

@interface offlineMapHeadView : UIView
@property (nonatomic, assign, readonly) BOOL expanded;
@property (nonatomic, assign) id<offlineMapHeadViewDelegate> delegate;
@property (nonatomic, copy)   NSString  *text;
@property (nonatomic, assign) NSInteger section;
- (id)initWithFrame:(CGRect)frame expanded:(BOOL)expanded;
@end

@protocol offlineMapHeadViewDelegate <NSObject>
@optional
- (void)headerView:(offlineMapHeadView *)headerView section:(NSInteger)section expanded:(BOOL)expanded;
@end
