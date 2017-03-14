//
//  SlidebarViewController.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kMainPageDistance   100     //中视图(右视图)露出的宽度
#define kMainPageScale      0.8     //中视图(右视图）缩放比例
#define kLeftScale          0.7     //左侧初始缩放比例
#define kLeftAlpha          0.9     //左侧蒙版的最大值
#define kLeftCenterX        30      //左侧初始偏移量

#define vSpeedFloat         0.7     //滑动速度

#define kMainPageCenter  CGPointMake(SCREENWIDTH + SCREENWIDTH * kMainPageScale / 2.0 - kMainPageDistance, SCREENHEIGHT / 2)
#define vCouldChangeDeckStateDistance  (SCREENWIDTH - kMainPageDistance) / 2.0 - 40
#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag

@interface SlidebarViewController : UIViewController

//滑动速度系数
@property (nonatomic, assign) CGFloat speedf;
//左侧窗控制器
@property (nonatomic, strong) UIViewController *leftVC;
//主视图控制器
@property (nonatomic, strong) UIViewController *mainVC;
//点击手势控制器
@property (nonatomic, strong) UITapGestureRecognizer *sideslipTapGes;
//滑动手势控制器
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
//侧滑窗是否关闭(关闭时显示为主页)
@property (nonatomic, assign) BOOL closed;

- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC;

- (void)closeLeftView;

- (void)openLeftView;

- (void)setPanEnabled: (BOOL) enabled;

@end
