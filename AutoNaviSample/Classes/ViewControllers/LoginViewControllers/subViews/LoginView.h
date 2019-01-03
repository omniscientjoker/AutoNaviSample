//
//  LoginView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate;

@protocol LoginViewDelegate <NSObject>
@optional
- (void)loginViewWillStarted;
- (void)loginViewSuccessed;
- (void)loginViewFailed;
@end

@interface LoginView : UIView
@property (weak, readwrite, nonatomic) id<LoginViewDelegate> delegate;
-(instancetype)initWithUser:(NSString *)user Pass:(NSString *)pass;
-(void)setfiledresignFirstResponder;
@end
