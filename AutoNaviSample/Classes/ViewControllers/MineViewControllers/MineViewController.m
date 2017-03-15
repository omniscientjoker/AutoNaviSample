//
//  MineViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "MineViewController.h"
#import "UIViewController+SlidebarMenu.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_btn_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
