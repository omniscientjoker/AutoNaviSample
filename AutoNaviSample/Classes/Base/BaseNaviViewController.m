//
//  BaseNaviViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "UIViewController+SlidebarMenu.h"
@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 10,28, 20);
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setImage:[UIImage imageNamed:@"menu_btn_icon"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"menu_btn_icon"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
