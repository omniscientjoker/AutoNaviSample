//
//  LoginHandle.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "LoginHandle.h"

@implementation LoginHandle
-(void)autoLoginHandleWithUserName:(NSString *)name PassWord:(NSString *)pass
{
    if ([name isEqualToString:@""] && [pass isEqualToString:@""] ) {
        [LoginUser sharedInstance].isLogin=YES;
        [LoginUser sharedInstance].isAutoLogin=YES;
        [LoginUser sharedInstance].isNotFirstLogin=NO;
        [LoginUser sharedInstance].telphone = name;
        [LoginUser sharedInstance].password = pass;
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(autoLoginSuccessed)]) {
            [self.delegate autoLoginSuccessed];
        }
    }else{
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(autoLoginFailed)]) {
            [self.delegate autoLoginFailed];
        }
    }
}
-(void)loginHandleWithUserName:(NSString *)name PassWord:(NSString *)pass
{
    if ([name isEqualToString:@""] && [pass isEqualToString:@""] ) {
        [LoginUser sharedInstance].isLogin=YES;
        [LoginUser sharedInstance].isAutoLogin=YES;
        [LoginUser sharedInstance].isNotFirstLogin=NO;
        [LoginUser sharedInstance].telphone = name;
        [LoginUser sharedInstance].password = pass;
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(loginSuccessed)]) {
            [self.delegate loginSuccessed];
        }
    }else{
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(loginFailed)]) {
            [self.delegate loginFailed];
        }
    }
}
-(void)VerifyHandleWithUserName:(NSString *)name VerifyCode:(NSString *)code
{
    if ([name isEqualToString:@""] && [code isEqualToString:@""] ) {
        [LoginUser sharedInstance].isLogin=YES;
        [LoginUser sharedInstance].isAutoLogin=YES;
        [LoginUser sharedInstance].isNotFirstLogin=NO;
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(VerifySuccessed)]) {
            [self.delegate VerifySuccessed];
        }
    }else{
        if ([self.delegate conformsToProtocol:@protocol(LoginHandleDelegate)] && [self.delegate respondsToSelector:@selector(VerifyFailed)]) {
            [self.delegate VerifyFailed];
        }
    }
}
@end
