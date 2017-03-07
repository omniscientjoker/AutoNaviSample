//
//  arriveAlertView.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "arriveAlertView.h"
#import "UIView+HUDExtensions.h"
#import "MBProgressHUD.h"
@interface arriveAlertView()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property(nonatomic, strong)UIView      * hudContentView;
@end

@implementation arriveAlertView
-(instancetype)initWithCarID:(NSString *)CarId
{
    self = [super init];
    if (self) {
        self.CarId = CarId;
        [self setView];
    }
    return self;
}

- (void)setView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView * aleart = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT/2-100, SCREENWIDTH-20, 200)];
    [self addSubview:aleart];
    
    CGFloat w = (SCREENWIDTH-50)/2;
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"即将到达目的地，是否发送准备接货通知?";
    titleLab.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor     = [UIColor blackColor];
    titleLab.numberOfLines = 0;
    [aleart addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(aleart).with.offset(5);
         make.left.equalTo(aleart).with.offset(20);
         make.right.equalTo(aleart).with.offset(-20);
         make.height.mas_equalTo(@60);
     }];
    
    
    UIButton * sendBtn = [[UIButton alloc] init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = COMMON_COLOR_BUTTON_BG;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [aleart addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(titleLab.mas_bottom).with.offset(10);
         make.left.equalTo(aleart).with.offset(10);
         make.width.mas_equalTo(w);
         make.height.mas_equalTo(@55);
     }];
    
    UIButton * cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelBtn.backgroundColor = COMMON_COLOR_BUTTON_BG;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius  = 4.0f;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [aleart addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(titleLab.mas_bottom).with.offset(10);
         make.width.mas_equalTo(w);
         make.right.equalTo(aleart).with.offset(-10);
         make.height.mas_equalTo(@55);
     }];
    
    
}


#pragma mark button
-(void)clickCancelButton:(UIButton *)sender
{
    [self removeFromSuperview];
}

-(void)clickSendButton:(UIButton*)sender
{
    
}

- (UIView *)hudContentView
{
    if (_hudContentView) {
        return _hudContentView;
    }
    _hudContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    _hudContentView.backgroundColor = [UIColor clearColor];
    return _hudContentView;
}
- (void)alertMessage:(NSString *)message
{
    [self addSubview:self.hudContentView];
    [HUD hideAnimated:YES];
    if (IsStrEmpty(message))
    {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    hud.label.textColor=COMMON_COLOR;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    hud.detailsLabel.text=message;
    hud.detailsLabel.textColor = COMMON_COLOR;
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0f];
    [hud hideAnimated:YES afterDelay:2.0];
    [self hidePopupLoading];
}
- (void)loading
{
    [self addSubview:self.hudContentView];
    [self.hudContentView showPopupLoading];
}
- (void)closeLoading
{
    [self.hudContentView removeFromSuperview];
    [self.hudContentView hidePopupLoading];
}
@end
