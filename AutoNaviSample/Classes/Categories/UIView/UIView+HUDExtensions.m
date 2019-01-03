//
//  UIView+HUDExtensions.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIView+HUDExtensions.h"
#import "MBProgressHUD.h"

static const NSInteger kHUDPopLoadingViewTag    = 1412301511;


@interface HUDCustomLoadingView : UIView
@property (nonatomic, weak) UIImageView *loadingView;
@property (nonatomic, assign) BOOL shouldRestoreAnimation;
@property (weak, nonatomic) UIImageView *gifView;
@property (nonatomic,strong) NSArray *imgRefreshArr;

+ (instancetype)loadingView;
- (void)stopLoadingAnimation;
- (void)startLoadingAnimation;
@end

@implementation HUDCustomLoadingView
- (void)dealloc {
    [self stopLoadingAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)loadingView {
    CGRect rect = CGRectMake(0, 0, 45, 45);
    return [[self alloc] initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _addLoadingView];
        [self _registerAppStateNotifications];
        [self startLoadingAnimation];
    }
    return self;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (void)_addLoadingView {
    NSArray *imageArray = @[@"loading"];
    
    [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = [UIImage imageNamed:obj];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        view.frame = self.bounds;
        [self addSubview:view];
        if (idx == 0) {
            self.loadingView = view;
        }
    }];
}

- (BOOL)_isInLoadingAnimation {
    return ([self.loadingView.layer animationForKey:@"loading"] != nil);
}

- (void)stopLoadingAnimation {
    if (![self _isInLoadingAnimation]) {
        return;
    }
    [self.loadingView.layer removeAnimationForKey:@"loading"];
}

- (void)startLoadingAnimation {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"loading"];
}

#pragma mark - AppStateNotification
- (void)_registerAppStateNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)_appDidEnterBackground:(NSNotification *)notification {
    self.shouldRestoreAnimation = [self _isInLoadingAnimation];
    [self stopLoadingAnimation];
}

- (void)_appWillEnterForeground:(NSNotification *)notification {
    if (!self.shouldRestoreAnimation) {
        return;
    }
    
    [self startLoadingAnimation];
}

@end



@implementation UIView (HUDExtensions)

#pragma mark - Popup Loading
- (MBProgressHUD *)_createAndShowHUDForPopupLoadingWithTxt:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.tag = kHUDPopLoadingViewTag;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.customView = [HUDCustomLoadingView loadingView];
    return hud;
}

- (void)showPopupLoading {
    [self showPopupLoadingWithText:nil];
}

- (void)showPopupLoadingWithText:(NSString *)text {
    [self _createAndShowHUDForPopupLoadingWithTxt:text];
}

- (void)showPopupLoadingWithText:(NSString *)text hideAfterDelay:(float)delay {
    MBProgressHUD *hud = [self _createAndShowHUDForPopupLoadingWithTxt:text];
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)hidePopupLoading {
    [self hidePopupLoadingAnimated:YES];
}

- (void)hidePopupLoadingAnimated:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - Popup Message
- (void)showPopupOKMessage:(NSString *)message {
    [self showPopupMessage:message type:UIViewPopupMessageTypeOK];
}

- (void)showPopupErrorMessage:(NSString *)message {
    [self showPopupMessage:message type:UIViewPopupMessageTypeError];
}

- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type {
    [self showPopupMessage:message type:type completion:nil];
}

- (void)showPopupMessage:(NSString *)message
                    type:(UIViewPopupMessageType)type
              completion:(void(^)(void))completion {
    
    if ([message length] <= 0) {
        if (completion) {
            completion();
        }
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    UIImage *iconImage = nil;
    switch (type) {
        case UIViewPopupMessageTypeError:
            iconImage = [UIImage imageNamed:@"hud_icon_error"];
            break;
        case UIViewPopupMessageTypeOK:
        default:
            iconImage = [UIImage imageNamed:@"hud_icon_ok"];
            break;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:iconImage];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];
    
    if (completion) {
        hud.completionBlock = completion;
    }
    
    NSTimeInterval delay = [message length] / (400/60);
    [hud hideAnimated:YES afterDelay:MAX(1.5f, delay)];
    
    //handle tap
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(_handleHUDTap:)]];
}

- (void)_handleHUDTap:(UITapGestureRecognizer *)recognizer {
    [MBProgressHUD hideHUDForView:self animated:YES];
}
@end
