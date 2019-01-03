//
//  VerifyView.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "VerifyView.h"
#import "LoginHandle.h"
#import "UIToolViewTextField.h"

#import "UIView+HUDExtensions.h"

#define max_get_code_times  3
#define max_get_next_code_duration 60

@interface VerifyView()<UITextFieldDelegate,LoginHandleDelegate>{
    UIToolViewTextField * UserFiled;
    UIToolViewTextField * VerifyCodeField;
    LoginHandle         * handle;
    UIButton            * veriBtn;
    BOOL                  firstVerify;
    NSTimer             * timer;
    int                   getCodeTimes;
    NSInteger             seconds;
}
@end
@implementation VerifyView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self drawUI];
    }
    return self;
}
-(void)drawUI{
    handle = [[LoginHandle alloc] init];
    handle.delegate = self;
    
    getCodeTimes = 1;
    
//    NSMutableString * str = [[NSMutableString alloc] initWithString:@"13389897897"];
//    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    UILabel * VerifyLab = [[UILabel alloc] init];
//    VerifyLab.text = [NSString stringWithFormat:@"验证码已经发送到%@",str];
//    VerifyLab.textAlignment =NSTextAlignmentCenter;
//    VerifyLab.backgroundColor = [UIColor clearColor];
//    VerifyLab.textColor       = [UIColor blackColor];
//    VerifyLab.font            = [UIFont systemFontOfSize:13.0f];
//    [self addSubview:VerifyLab];
//    [VerifyLab mas_makeConstraints:^(MASConstraintMaker *make)
//     {
//         make.top.equalTo(self.mas_top).with.offset(13);
//         make.centerX.equalTo(self.mas_centerX);
//         make.height.mas_equalTo(@15);
//     }];
    
    UserFiled = [self filedState];
    UserFiled.placeholder = @"  手机号码";
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
    
    
    VerifyCodeField = [self filedState];
    VerifyCodeField.placeholder = @"  请输入验证码";
    VerifyCodeField.secureTextEntry = NO;
    VerifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    UIView * VerifyBtnView = [[UIView alloc] init];
    VerifyBtnView.backgroundColor = [UIColor clearColor];
    VerifyBtnView.frame = CGRectMake(0, 0, 85, 44);
    UIImageView * lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Portrait_Line_Img"]];
    [VerifyBtnView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(VerifyBtnView).with.offset(5);
         make.left.equalTo(VerifyBtnView);
         make.height.mas_equalTo(@34);
         make.width.mas_equalTo(@1);
     }];
    
    veriBtn = [[UIButton alloc] init];
    [veriBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [veriBtn setTitleColor:RGB(252, 101, 0) forState:UIControlStateNormal];
    veriBtn.backgroundColor = [UIColor clearColor];
    veriBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [veriBtn addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [VerifyBtnView addSubview:veriBtn];
    [veriBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(VerifyBtnView).with.offset(0);
         make.left.equalTo(VerifyBtnView).with.offset(1);
         make.right.equalTo(VerifyBtnView).with.offset(0);
         make.height.mas_equalTo(@44);
     }];
    VerifyCodeField.rightView = VerifyBtnView;
    VerifyCodeField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:VerifyCodeField];
    [VerifyCodeField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(UserFiled.mas_bottom).with.offset(10);
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
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn setTitleColor:RGB(37, 193, 206) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickVerifyLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor clearColor];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [confirmBtn setTitleColor:RGB(243, 101, 28) forState:UIControlStateNormal];
    [confirmBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [self addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(lineView.mas_bottom);
         make.centerX.equalTo(self.mas_centerX);
         make.left.equalTo(self).with.offset(20);
         make.height.mas_equalTo(@40);
     }];
}

#pragma mark - 验证码
-(void)clickSendButton:(UIButton*)sender
{
    if (getCodeTimes > max_get_code_times) {
        if ([self.delegate conformsToProtocol:@protocol(VerifyViewDelegate)] && [self.delegate respondsToSelector:@selector(VerifyViewSendCodeIsMax)]) {
            [self.delegate VerifyViewSendCodeIsMax];
        }
    }else{
       [self startTiming];
    }
}
- (void)startTiming
{
    if (firstVerify == YES) {
        getCodeTimes++;
        seconds = max_get_next_code_duration;
        veriBtn.enabled = NO;
        [veriBtn setTitle:[NSString stringWithFormat:@"%@秒后启用",@(seconds)] forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDecrease) userInfo:nil repeats:YES];
        firstVerify = NO;
    }else{
        getCodeTimes++;
        seconds = max_get_next_code_duration;
        veriBtn.enabled = NO;
        [veriBtn setTitle:[NSString stringWithFormat:@"%@秒后启用",@(seconds)] forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeDecrease) userInfo:nil repeats:YES];
    }
}
- (void)timeDecrease
{
    seconds--;
    if (seconds > 0){
        [veriBtn setTitle:[NSString stringWithFormat:@"%@秒后启用",@(seconds)] forState:UIControlStateNormal];
    }else{
        veriBtn.enabled = YES;
        [timer invalidate];
        [veriBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)clickVerifyLoginButton:(UIButton *)btn{
    [VerifyCodeField resignFirstResponder];
    if ([self.delegate conformsToProtocol:@protocol(VerifyViewDelegate)] && [self.delegate respondsToSelector:@selector(VerifyViewWillStarted)]) {
        [self.delegate VerifyViewWillStarted];
    }
    [handle VerifyHandleWithUserName:@"" VerifyCode:VerifyCodeField.text];
   
}


#pragma mark handele
-(void)setfiledresignFirstResponder{
    [VerifyCodeField resignFirstResponder];
}
-(void)VerifySuccessed{
    if ([self.delegate conformsToProtocol:@protocol(VerifyViewDelegate)] && [self.delegate respondsToSelector:@selector(VerifyViewSuccessed)]) {
        [self.delegate VerifyViewSuccessed];
    }
}
-(void)VerifyFailed{
    if ([self.delegate conformsToProtocol:@protocol(VerifyViewDelegate)] && [self.delegate respondsToSelector:@selector(VerifyViewFailed)]) {
        [self.delegate VerifyViewFailed];
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
        [VerifyCodeField resignFirstResponder];
    }
}
@end
