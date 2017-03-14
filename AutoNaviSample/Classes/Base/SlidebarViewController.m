//
//  SlidebarViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "SlidebarViewController.h"

@interface SlidebarViewController ()<UIGestureRecognizerDelegate>{
    CGFloat _scalef;
}
@property (nonatomic,assign) CGFloat         leftTableviewW;
@property (nonatomic,strong) UIView         *contentView;
@property (nonatomic,strong) UITableView    *leftTableview;
@end


@implementation SlidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC
{
    if(self = [super init]){
        self.speedf = vSpeedFloat;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
    
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        [self.view addSubview:self.leftVC.view];
        
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVC.view addSubview:view];
        
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)obj;
            }
        }
        
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(0, 0, SCREENWIDTH - kMainPageDistance, SCREENHEIGHT);
        self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftTableview.center = CGPointMake(kLeftCenterX, SCREENHEIGHT * 0.5);
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}

#pragma mark - 控制左视图
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2);
    self.closed = YES;
    self.leftTableview.center = CGPointMake(kLeftCenterX, SCREENHEIGHT * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    [UIView commitAnimations];
    [self removeSingleTap];
}

- (void)openLeftView;
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    self.leftTableview.center = CGPointMake((SCREENWIDTH - kMainPageDistance) * 0.5, SCREENHEIGHT * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 控制器
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);
    BOOL needMoveWithTap = YES;
    if (((self.mainVC.view.frame.origin.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.frame.origin.x >= (SCREENWIDTH - kMainPageDistance )) && (_scalef >= 0))){
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (SCREENWIDTH - kMainPageDistance))){
        CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
        if (recCenterX < SCREENWIDTH * 0.5 - 2) {
            recCenterX = SCREENWIDTH * 0.5;
        }
        CGFloat recCenterY = rec.view.center.y;
        rec.view.center = CGPointMake(recCenterX,recCenterY);
        CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (SCREENWIDTH - kMainPageDistance));
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        CGFloat leftTabCenterX = kLeftCenterX + ((SCREENWIDTH - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (SCREENWIDTH - kMainPageDistance));
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (SCREENWIDTH - kMainPageDistance));
        self.leftTableview.center = CGPointMake(leftTabCenterX, SCREENHEIGHT * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (SCREENWIDTH - kMainPageDistance));
        self.contentView.alpha = tempAlpha;
    }else{
        if (self.mainVC.view.frame.origin.x < 0){
            [self closeLeftView];
            _scalef = 0;
        }else if (self.mainVC.view.frame.origin.x > (SCREENWIDTH - kMainPageDistance)){
            [self openLeftView];
            _scalef = 0;
        }
    }
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance){
            if (self.closed){
                [self openLeftView];
            }else{
                [self closeLeftView];
            }
        }else{
            if (self.closed){
                [self closeLeftView];
            }else{
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
}
-(void)handeTap:(UITapGestureRecognizer *)tap{
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        self.leftTableview.center = CGPointMake(kLeftCenterX, SCREENHEIGHT * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
}
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews]){
        [tempButton setUserInteractionEnabled:NO];
    }
    if (!self.sideslipTapGes){
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

- (void) removeSingleTap{
    for (UIButton *tempButton in [self.mainVC.view  subviews]){
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}


- (void)setPanEnabled: (BOOL) enabled{
    [self.pan setEnabled:enabled];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if(touch.view.tag == vDeckCanNotPanViewTag){
        return NO;
    }else{
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
