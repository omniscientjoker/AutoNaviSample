//
//  VerifyView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VerifyViewDelegate;

@protocol VerifyViewDelegate <NSObject>
@optional
- (void)VerifyViewWillStarted;
- (void)VerifyViewSuccessed;
- (void)VerifyViewFailed;


@end
@interface VerifyView : UIView
@property (weak, readwrite, nonatomic) id<VerifyViewDelegate> delegate;
@end
