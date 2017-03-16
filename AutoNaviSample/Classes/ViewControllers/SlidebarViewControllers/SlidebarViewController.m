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

#import "AmapViewController.h"
#import "MineViewController.h"

@interface SlidebarViewController()<UIGestureRecognizerDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSArray                 *classNames;
@property (strong, nonatomic)NSArray                 *viewTitles;
@property (strong, nonatomic)NSArray                 *titleImgs;
@property (strong, nonatomic)UITapGestureRecognizer  *tapGesture;
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
    self.viewTitles = [NSArray arrayWithObjects:@"我的",@"地图",nil];
    self.titleImgs  = [NSArray arrayWithObjects:@"head_portrait_icon",@"map_portrait_icon",nil];
    self.classNames = [NSArray arrayWithObjects:@"MineViewController", @"AmapViewController",nil];
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
    return (SCREENHEIGHT-54*self.classNames.count)/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (SCREENHEIGHT-54*self.classNames.count)/2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/7*3, (SCREENHEIGHT-54*self.classNames.count)/2)];
    headView.contentView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView * footView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/7*3, (SCREENHEIGHT-54*self.classNames.count)/2)];
    footView.contentView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
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
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = self.viewTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.titleImgs[indexPath.row]];
    return cell;
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
