//
//  BaseViewController.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
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
//need override
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

#pragma mark - view
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.SlidebarVC setPanEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.SlidebarVC setPanEnabled:YES];
}
@end
