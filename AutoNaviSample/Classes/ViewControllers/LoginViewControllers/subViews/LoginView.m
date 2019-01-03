//
//  LoginView.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "LoginView.h"
#import "UIToolViewTextField.h"
#import "LoginHandle.h"
#import "UIView+HUDExtensions.h"
@interface LoginView()<UITextFieldDelegate,LoginHandleDelegate>{
    NSString * password;
    NSString * username;
    LoginHandle         * handle;
}
@property(nonatomic,strong)UIToolViewTextField * PassFiled;
@property(nonatomic,strong)UIToolViewTextField * UserFiled;
@end

@implementation LoginView
@synthesize UserFiled,PassFiled;
-(instancetype)initWithUser:(NSString *)user Pass:(NSString *)pass
{
    self = [super init];
    if (self) {
        username = user;
        password = pass;
        [self drawUI];
    }
    return self;
}
-(void)drawUI{
    handle = [[LoginHandle alloc] init];
    handle.delegate = self;
    
    UserFiled = [self filedState];
    UserFiled.placeholder = @"  手机号码";
    if (username) {
        UserFiled.text = username;
    }
    UserFiled.secureTextEntry = NO;
    UserFiled.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:UserFiled];
    [UserFiled mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.mas_top).with.offset(10);
         make.left.equalTo(self.mas_left).with.offset(10);
         make.right.equalTo(self.mas_right).with.offset(-10);
         make.height.mas_equalTo(@44);
     }];
    
    
    PassFiled = [self filedState];
    PassFiled.placeholder = @"  请输入密码";
    if (password) {
        PassFiled.text = password;
    }
    PassFiled.secureTextEntry = YES;
    UIView * seeBtnView = [[UIView alloc] init];
    seeBtnView.backgroundColor = [UIColor clearColor];
    seeBtnView.frame = CGRectMake(0, 0, 36, 44);
    UIButton * seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.backgroundColor = [UIColor clearColor];
    [seeBtn setImage:[UIImage imageNamed:@"icon_eye_unselected"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"icon_eye_selected"] forState:UIControlStateSelected];
    [seeBtn addTarget:self action:@selector(clickCanSeeButton:) forControlEvents:UIControlEventTouchUpInside];
    [seeBtnView addSubview:seeBtn];
    [seeBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(seeBtnView.mas_centerY);
         make.left.equalTo(seeBtnView.mas_left);
         make.right.equalTo(seeBtnView.mas_right).with.offset(-4);
         make.height.mas_equalTo(@20);
         make.width.mas_equalTo(@32);
     }];
    PassFiled.rightView = seeBtnView;
    PassFiled.rightViewMode=UITextFieldViewModeAlways;
    PassFiled.keyboardType = UIKeyboardTypeDefault;
    PassFiled.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:PassFiled];
    [PassFiled mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.equalTo(self.mas_bottom).with.offset(-49);
         make.left.equalTo(self.mas_left).with.offset(10);
         make.right.equalTo(self.mas_right).with.offset(-10);
         make.height.mas_equalTo(@44);
     }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(200, 200, 200, 1.0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.equalTo(self.mas_bottom).with.offset(-40);
         make.left.equalTo(self);
         make.right.equalTo(self);
         make.height.mas_equalTo(@1);
     }];
    
    UIButton * LogBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    LogBtn.backgroundColor = [UIColor clearColor];
    [LogBtn setTitleColor:RGB(37, 193, 206) forState:UIControlStateNormal];
    [LogBtn addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    LogBtn.backgroundColor = [UIColor clearColor];
    LogBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [LogBtn setTitleColor:RGB(243, 101, 28) forState:UIControlStateNormal];
    [LogBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    LogBtn.tag = 10002;
    [self addSubview:LogBtn];
    [LogBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(lineView.mas_bottom);
         make.centerX.equalTo(self.mas_centerX);
         make.width.mas_equalTo(SCREENWIDTH-40);
         make.height.mas_equalTo(@40);
     }];
    
}
#pragma mark btnclick
-(void)clickCanSeeButton:(id)sender
{
    UIButton * btn = sender;
    if (btn.selected == NO ) {
        btn.selected = YES;
        PassFiled.secureTextEntry = NO;
    }else{
        btn.selected = NO;
        PassFiled.secureTextEntry = YES;
    }
}
-(void)clickLoginButton:(id)sender
{
    [UserFiled resignFirstResponder];
    [PassFiled resignFirstResponder];
    //进行数据验证
    if ([self.delegate conformsToProtocol:@protocol(LoginViewDelegate)] && [self.delegate respondsToSelector:@selector(loginViewWillStarted)]) {
        [self.delegate loginViewWillStarted];
    }
    [handle loginHandleWithUserName:UserFiled.text PassWord:PassFiled.text];
}
#pragma mark handele
-(void)setfiledresignFirstResponder{
    [UserFiled resignFirstResponder];
    [PassFiled resignFirstResponder];
}
-(void)loginSuccessed{
    if ([self.delegate conformsToProtocol:@protocol(LoginViewDelegate)] && [self.delegate respondsToSelector:@selector(loginViewSuccessed)]) {
        [self.delegate loginViewSuccessed];
    }
}
-(void)loginFailed{
    if ([self.delegate conformsToProtocol:@protocol(LoginViewDelegate)] && [self.delegate respondsToSelector:@selector(loginViewFailed)]) {
        [self.delegate loginViewFailed];
    }
}
#pragma mark stateUI
-(UIToolViewTextField *)filedState
{
    UIToolViewTextField * Filed = [[UIToolViewTextField alloc] init];
    Filed.backgroundColor = RGB(242, 242, 242);
    Filed.textColor = RGBA(100, 100, 100, 1.0);
    Filed.font = [UIFont systemFontOfSize:17.0];
    Filed.clipsToBounds = YES;
    Filed.textAlignment = NSTextAlignmentLeft;
    Filed.keyboardType= UIKeyboardTypePhonePad;
    [Filed setValue:RGBA(100, 100, 100, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [Filed setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    Filed.delegate = self;
    Filed.layer.cornerRadius = 5.0f;
    return Filed;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1)
    {
        [UserFiled resignFirstResponder];
        [PassFiled resignFirstResponder];
    }
}
@end
