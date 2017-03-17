//
//  LoginViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "LoginViewController.h"
#import "UIToolViewTextField.h"
#import "LoginUser.h"
#import "SlidebarMenu.h"
#import "AmapViewController.h"
#import "LoginView.h"
#import "VerifyView.h"

#define kLoginLogoTopHeight   80
#define kLoginLogoHeight ([Common getResolutionType]*10+60)
#define kLoginViewHeight ([Common getResolutionType]*10+20)
#define kLoginMessageHeight 60

#define max_get_code_times  3
#define max_get_next_code_duration 60

@interface LoginViewController ()<UITextFieldDelegate,LoginViewDelegate,VerifyViewDelegate>
{
    CGFloat VerifyViewHeight;
    CGFloat LoginViewHeight;
    BOOL    show;
    NSString * verifyCode;
    BOOL    firstVerify;
}

@property(nonatomic,strong)UIView          * backView;

@property(nonatomic,strong)UIButton        * showLogin;
@property(nonatomic,strong)UIButton        * veriBtn;
@property(nonatomic,strong)UIButton        * closeBtn;

@property (nonatomic, strong) LoginView           * Login;

@property (nonatomic, strong) VerifyView          * verifyView;
@property (nonatomic, strong) UILabel             * VerifyLab;
@property (nonatomic, assign) int                   getCodeTimes;//获取验证码次数
@property (nonatomic, strong) NSTimer             * timer;
@property (nonatomic, assign) NSInteger             seconds;
@property (nonatomic, assign) CGFloat               shifting;
@property (nonatomic, strong) UIImageView         * launchImageView;
@end

@implementation LoginViewController
@synthesize veriBtn,Login,verifyView,showLogin,closeBtn,backView;


- (void)viewDidLoad {
    [super viewDidLoad];
    [LoginUser parseLoginUserInfoFromUserDefaults];
    [self initLoginUI];
}
-(void) initLoginUI{
    self.view.backgroundColor = RGB(253, 103, 0);
    
    CGFloat imgHeight =  210;
    
    UIImageView * logoImg = [[UIImageView alloc] init];
    logoImg.image = [UIImage imageNamed:@"Logo_img"];
    [self.view addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.view).with.offset(SCREENHEIGHT/4);
         make.centerX.equalTo(self.view.mas_centerX);
         make.width.mas_equalTo(imgHeight);
         make.height.mas_equalTo(imgHeight);
     }];
    
    if([LoginUser sharedInstance].isAutoLogin){
        [self autoLoginHandle];
    }else{
        [self.launchImageView removeFromSuperview];
        showLogin = [[UIButton alloc] init];
        showLogin.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        showLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
        showLogin.backgroundColor = RGB(255, 251, 248);
        showLogin.layer.masksToBounds = YES;
        showLogin.layer.cornerRadius  = 5.0f;
        [showLogin setTitleColor:RGB(243, 101, 28) forState:UIControlStateNormal];
        [showLogin setTitle:@"登录" forState:UIControlStateNormal];
        [showLogin addTarget:self action:@selector(clickButtonToLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:showLogin];
        [showLogin mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
             make.centerX.equalTo(self.view.mas_centerX);
             make.width.mas_equalTo(@250);
             make.height.mas_equalTo(@49);
         }];
        
        backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        backView.backgroundColor = RGBA(75, 31, 0, 0.6);
        [self.view addSubview:backView];
        backView.hidden = YES;
        
        [self initLoginView];
        [self initVerifyCodeView];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close_btn_img"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(0, 0, 31, 31);
        closeBtn.center = CGPointMake(30, -LoginViewHeight);
        closeBtn.layer.cornerRadius = closeBtn.bounds.size.width;
        [closeBtn addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
}
#pragma mark initUI界面
//密码登录
-(void)initLoginView
{
    LoginViewHeight = 153.0f;
    Login = [[LoginView alloc] initWithUser:@"" Pass:@""];
    Login.frame = CGRectMake(30, -LoginViewHeight, SCREENWIDTH-60, LoginViewHeight);
    Login.backgroundColor = [UIColor whiteColor];
    Login.layer.cornerRadius  = 10.0f;
    Login.layer.masksToBounds = NO;
    Login.delegate = self;
    [self.view addSubview:Login];
}
//短信码登录
-(void)initVerifyCodeView
{
    VerifyViewHeight = 137.0f;
    
    verifyView = [[VerifyView alloc] initWithFrame:CGRectMake(30, -VerifyViewHeight, SCREENWIDTH-60, VerifyViewHeight)];
    verifyView.delegate = self;
    verifyView.backgroundColor = [UIColor whiteColor];
    verifyView.layer.cornerRadius  = 10.0f;
    verifyView.layer.masksToBounds = NO;
    [self.view addSubview:verifyView];
}

#pragma mark buttonClick
-(void)clickButtonToLogin
{
    if (!Login){
        [self initLoginView];
    }
    self.showLogin.hidden = YES;
    CGPoint ViewPoint = CGPointMake(SCREENWIDTH/2, 140+LoginViewHeight/2);
    CGPoint btnPoint  = CGPointMake(30, 140);
    [self positionAnimationLableView:Login Point:ViewPoint];
    [self positionAnimationLableView:closeBtn Point:btnPoint];
    backView.hidden = NO;
}
-(void)clickCloseButton:(id)sender
{
    self.showLogin.hidden = NO;
    [self removeViewFromWindow];
}
-(void)Actiondo{
    [self.view endEditing:YES];
}

#pragma mark - 登录验证
-(void) loginHandle{
    //进行数据验证
    self.Login.hidden = YES;
    self.closeBtn.hidden  = YES;
    if (Login) {
        AmapViewController *subViewController = [[AmapViewController alloc] init];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        self.Login.hidden = NO;
        self.closeBtn.hidden  = NO;
    }
}
-(void) autoLoginHandle{
    if (![@"" isEqualToString:[LoginUser sharedInstance].telphone]&&![@"" isEqualToString:[LoginUser sharedInstance].token]) {
        [LoginUser sharedInstance].isLogin=YES;
        [LoginUser sharedInstance].isAutoLogin=YES;
        [LoginUser sharedInstance].isNotFirstLogin=NO;
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0.8;
        } completion:^(BOOL finished) {
            AmapViewController *subViewController = [[AmapViewController alloc] init];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }];
    }else{
        [LoginUser sharedInstance].isAutoLogin=NO;
        [self initLoginUI];
        return;
    }
}
#pragma mark handle 
-(void)loginViewWillStarted{
    Login.hidden = YES;
    closeBtn.hidden = YES;
}
-(void)loginViewSuccessed{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0.8;
    } completion:^(BOOL finished) {
        AmapViewController *subViewController = [[AmapViewController alloc] init];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }];
}
-(void)loginViewFailed{
    Login.hidden = NO;
    closeBtn.hidden = NO;
}

-(void)VerifyViewWillStarted{
    verifyView.hidden = YES;
    closeBtn.hidden = YES;
}
-(void)VerifyViewSuccessed{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0.8;
    } completion:^(BOOL finished) {
        AmapViewController *subViewController = [[AmapViewController alloc] init];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }];
}
-(void)VerifyViewFailed{
    verifyView.hidden = NO;
    closeBtn.hidden = NO;
}


#pragma UIView实现动画
-(void)removeViewFromWindow
{
    if (Login){
        if (Login.frame.origin.y>0){
            CGPoint ViewPoint = CGPointMake(SCREENWIDTH/2, -LoginViewHeight/2);
            [self positionAnimationLableView:Login Point:ViewPoint];
            CGPoint btnPoint  = CGPointMake(30, -LoginViewHeight);
            [self positionAnimationLableView:closeBtn Point:btnPoint];
            backView.hidden = YES;
        }
    }
    if (verifyView){
        if (verifyView.frame.origin.y>0){
            CGPoint ViewPoint = CGPointMake(SCREENWIDTH/2, -VerifyViewHeight/2);
            [self positionAnimationLableView:verifyView Point:ViewPoint];
            CGPoint btnPoint  = CGPointMake(30, -VerifyViewHeight);
            [self positionAnimationLableView:closeBtn Point:btnPoint];
            CGPoint ViewPointOr = CGPointMake(SCREENWIDTH/2, 140+LoginViewHeight/2);
            CGPoint btnPointOr  = CGPointMake(30, 140);
            [self positionAnimationLableView:Login Point:ViewPointOr];
            [self positionAnimationLableView:closeBtn Point:btnPointOr];
        }
    }
}
-(void)positionAnimationLableView:(UIView *)view Point:(CGPoint)point
{
    [UIView beginAnimations:@"PositionAnition" context:NULL];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    view.center = CGPointMake(point.x, point.y);
    [UIView commitAnimations];
}
- (void) animationWithView:(UIView *)view WithAnimationTransition:(UIViewAnimationTransition) transition
{
    [UIView animateWithDuration:1.0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}


#pragma mark system
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
