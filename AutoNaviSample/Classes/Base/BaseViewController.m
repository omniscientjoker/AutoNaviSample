//
//  BaseViewController.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+HUDExtensions.h"
@interface BaseViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic, assign) BOOL           isLoadingRequest;
@property (nonatomic, strong) Block          block;
@property (nonatomic, strong) UIView        *hudContentView;
@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - nav
- (BOOL)navigationControllerIsWillDealloc{
    if (![self.navigationController.viewControllers containsObject:self]) {
        return YES;
    }else{
        return NO;
    }
}
- (void)configUIAppearance{
    NSLog(@"base config ui ");
}
- (void)animatedPopViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIKeyBoard
- (void)registerKeyBordChangeFrameAction{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(base_keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)base_keyboardFrameWillChange:(NSNotification *)notification{
    [self base_willKeyboardChageFrame:notification view:nil];
}
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view{
    NSDictionary *userInfo = notification.userInfo;
    CGRect toFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        CGRect rect = [view convertRect:view.frame toView:self.view];
        
        if (beginFrame.origin.y == SCREENHEIGHT){//开始编辑
            CGFloat moveDistance = toFrame.size.height  - (SCREENHEIGHT - (rect.origin.y + rect.size.height)) - 64;
            if ( moveDistance > 0) {
                [self changeSelfViewYPosition:moveDistance];
            }
        }
        else if (toFrame.origin.y == SCREENHEIGHT){//结束编辑
            [self changeSelfViewYPosition:0];
        }
        else{
            CGFloat bottom = (SCREENHEIGHT - (rect.origin.y + rect.size.height));
            CGFloat moveDistance = toFrame.size.height - bottom;
            if ( moveDistance > 0) {
                [self changeSelfViewYPosition:moveDistance];
            }else{
                [self changeSelfViewYPosition:0];
            }
        }
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}
- (void)changeSelfViewYPosition:(CGFloat)yPosition{
    CGRect frame = self.view.frame;
    if (yPosition == 0){
        frame.origin.y = 64;
    }else{
        frame.origin.y -= yPosition;
    }
    self.view.frame = frame;
}

#pragma mark hud
- (UIView *)hudContentView{
    if (_hudContentView) {
        return _hudContentView;
    }
    _hudContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENDEFAULTHEIGHT, SCREENWIDTH, SCREENRESULTHEIGHT)];
    _hudContentView.backgroundColor = [UIColor clearColor];
    return _hudContentView;
}
//success
- (void)showSuccessAlertWithMessage:(NSString *)message{
    [self.view addSubview:self.hudContentView];
    HUD = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    UIImage *image = [UIImage imageNamed:@"success_alert_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake( 100/2 - image.size.width/2 , 70/2 - image.size.height/2, image.size.width, image.size.height);
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [customView addSubview:imageView];
    HUD.customView = customView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}
//error
- (void)showErrorAlertWithMessage:(NSString *)message{
    [self.view addSubview:self.hudContentView];
    HUD = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    UIImage *image = [UIImage imageNamed:@"error_alert_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake( 100/2 - image.size.width/2 , 70/2 - image.size.height/2, image.size.width, image.size.height);
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [customView addSubview:imageView];
    HUD.customView = customView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.label.text = nil;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:20];
}
//message
- (void)showAlertWithMessage:(NSString *)message hideAfterDelay:(float)delay{
    [self.view addSubview:self.hudContentView];
    //弹出信息的时候 加载效果要消失
    [HUD hideAnimated:YES];
    if (IsStrEmpty(message)) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    hud.detailsLabel.text=message;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0f];
    if (delay) {
        [hud hideAnimated:YES afterDelay:delay];
    }else{
        [hud hideAnimated:YES afterDelay:2.0];
    }
    [self.view hidePopupLoading];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

//loading
- (void)loading{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoading];
}
- (BOOL)isloading{
    if (HUD != nil && !HUD.isHidden) {
        return YES;
    }
    HUD.delegate = nil;
    [HUD removeFromSuperview];
    HUD = nil;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor colorWithRed:68.0/255.0 green:184.0/255.0 blue:159.0/255.0 alpha:1.0];
    HUD.delegate = self;
    HUD.minSize = CGSizeMake(80.f, 80.f);
    [HUD showAnimated:YES];
    return NO;
}
- (void)loading:(NSString *)text{
    if (IsStrEmpty(text)) {
        return;
    }
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoadingWithText:text];
}

- (void)loadingBlock:(Block)operationBlock{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoading];
    if (operationBlock) {
        operationBlock();
    }
}
- (void)loading:(NSString *)text operationBlock:(Block)operationBlock{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoadingWithText:text];
    if (operationBlock) {
        operationBlock();
    }
}
- (void)closeLoading
{
    self.isLoadingRequest = NO;
    [self.hudContentView removeFromSuperview];
    [self.hudContentView hidePopupLoading];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [self.hudContentView removeFromSuperview];
    [hud removeFromSuperview];
    hud = nil;
}

- (void)dealloc{
    NSLog(@"释放 %s",object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HUD removeFromSuperview];
    HUD.delegate = nil;
    HUD = nil;
}

@end
