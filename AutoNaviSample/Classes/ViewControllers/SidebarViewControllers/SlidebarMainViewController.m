//
//  SlidebarMainViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "SlidebarMainViewController.h"
#import "AppDelegate.h"
#import "MineViewController.h"
#import "AmapViewController.h"
@interface SlidebarMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectSlidebarNum;
}
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@end

@implementation SlidebarMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectSlidebarNum = 0;
    
    
    [self initClassNames];
    [self initTitles];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}
- (void)initClassNames
{
    self.classNames = [NSArray arrayWithObjects:@"AmapViewController",@"MineViewController",nil];
}
- (void)initTitles
{
    self.sections = [NSArray arrayWithObjects:@"地图",@"我的",nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.sections[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.SlidebarVC closeLeftView];
    if (indexPath.row != selectSlidebarNum) {
        selectSlidebarNum = indexPath.row;
        NSString *className = self.classNames[indexPath.row];
        UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
        subViewController.title = self.sections[indexPath.row];
        [tempAppDelegate.mainNaviController pushViewController:subViewController animated:NO];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(CGRectGetWidth(view.frame)/2-25, 40, 50, 50);
    imageButton.layer.cornerRadius = 25;
    [imageButton setBackgroundImage:[UIImage imageNamed:@"mine_photo_icon"] forState:UIControlStateNormal];
    [view addSubview:imageButton];
    [imageButton addTarget:self action:@selector(imgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageButton.frame)+5, tableView.bounds.size.width, 20)];
    nameLabel.text = @"AUTONAVI";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:nameLabel];
    
    return view;
}


- (void)imgButtonAction {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MineViewController *vc = [[MineViewController alloc] init];
    [tempAppDelegate.mainNaviController presentViewController:vc animated:YES completion:^{
        [tempAppDelegate.SlidebarVC closeLeftView];
    }];
}
@end
