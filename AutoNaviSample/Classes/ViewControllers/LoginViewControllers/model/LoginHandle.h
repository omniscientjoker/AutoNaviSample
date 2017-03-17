//
//  LoginHandle.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUser.h"

@protocol LoginHandleDelegate;

@protocol LoginHandleDelegate <NSObject>
@optional
- (void)autoLoginSuccessed;
- (void)autoLoginFailed;
- (void)loginSuccessed;
- (void)loginFailed;
- (void)VerifySuccessed;
- (void)VerifyFailed;
@end


@interface LoginHandle : NSObject
@property (weak, readwrite, nonatomic) id<LoginHandleDelegate> delegate;
-(void)autoLoginHandleWithUserName:(NSString *)name PassWord:(NSString *)pass;
-(void)loginHandleWithUserName:(NSString *)name PassWord:(NSString *)pass;
-(void)VerifyHandleWithUserName:(NSString *)name VerifyCode:(NSString *)code;
@end
