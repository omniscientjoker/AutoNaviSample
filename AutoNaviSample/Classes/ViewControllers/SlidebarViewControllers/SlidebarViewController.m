//
//  SlidebarViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "SlidebarViewController.h"
#import "UIImage+blur.h"
#import "UIView+instrument.h"
#import "LoginUser.h"
#import "LoginViewController.h"

#import "OrderViewController.h"
#import "AmapViewController.h"
#import "OptionsViewController.h"
#import "MineViewController.h"

#define kSlideBarCellHeight             64

@interface SlidebarViewController()<UIGestureRecognizerDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSArray                 *classNames;
@property (strong, nonatomic)NSArray                 *viewTitles;
@property (strong, nonatomic)NSArray                 *titleImgs;
@property (strong, nonatomic)UITapGestureRecognizer  *tapGesture;
@property (strong, nonatomic)UIButton                *headPhotoBtn;
@end

@implementation SlidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitles];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/7*3, SCREENHEIGHT) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}
- (void)initTitles
{
    self.viewTitles = [NSArray arrayWithObjects:@"订单",@"地图",@"设置",nil];
    self.titleImgs  = [NSArray arrayWithObjects:@"order_portrait_icon",@"map_portrait_icon",@"options_portrait_icon",nil];
    self.classNames = [NSArray arrayWithObjects:@"OrderViewController", @"AmapViewController",@"OptionsViewController",nil];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([NSStringFromClass([touch.view class])isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (location.x>SCREENWIDTH/7*3) {
        [self.sideMenuViewController hideMenuViewController];
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([LoginUser sharedInstance].setSlidebarIndex  == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
    }else{
        [LoginUser sharedInstance].setSlidebarIndex = indexPath.row;
        NSString *className = self.classNames[indexPath.row];
        UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (SCREENHEIGHT-kSlideBarCellHeight*self.classNames.count)/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (SCREENHEIGHT-kSlideBarCellHeight*self.classNames.count)/2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/7*3, (SCREENHEIGHT-kSlideBarCellHeight*self.classNames.count)/2)];
    headView.contentView.backgroundColor = [UIColor clearColor];
    
    self.headPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headPhotoBtn.frame = CGRectMake(0, 0, SCREENWIDTH/14*3, SCREENWIDTH/14*3);
    self.headPhotoBtn.center = headView.center;
    [self.headPhotoBtn setImage:[UIImage imageNamed:@"head_portrait_icon"] forState:UIControlStateNormal];
    [self.headPhotoBtn addTarget:self action:@selector(cleckHeadPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.headPhotoBtn];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView * footView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/7*3, (SCREENHEIGHT-kSlideBarCellHeight*self.classNames.count)/2)];
    footView.contentView.backgroundColor = [UIColor clearColor];
    UIButton * shutDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shutDownBtn setImage:[UIImage imageNamed:@"shutdown_portrait_icon"] forState:UIControlStateNormal];
    [shutDownBtn addTarget:self action:@selector(clickShotDownBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:shutDownBtn];
    [shutDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@60);
        make.bottom.equalTo(footView.mas_bottom).with.offset(-10);
    }];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSlideBarCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:23];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = self.viewTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.titleImgs[indexPath.row]];
    return cell;
}

#pragma mark animated
-(void)clickShotDownBtn:(id)sender
{
    LoginViewController *subViewController = [[LoginViewController alloc] init];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)cleckHeadPhotoBtn:(id)sender
{
    [LoginUser sharedInstance].setSlidebarIndex = 10;
    UIViewController *subViewController = [[MineViewController alloc] init];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:subViewController] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
