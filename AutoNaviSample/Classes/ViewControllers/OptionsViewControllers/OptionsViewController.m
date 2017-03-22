//
//  OptionsViewControllers.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/17.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "OptionsViewController.h"
#import "offlineMapViewController.h"
#import "carInfoViewController.h"
#import "OptionsListCell.h"
#import "NaviMapHelp.h"
@interface OptionsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic, strong)UITableView   * tableView;
@property(nonatomic, strong)NSArray       * titleArray;

@end

@implementation OptionsViewController
static NSString *const kOptionsCellIdentifier = @"settingCellIndentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    [self initDataSoure];
    [self initTableView];
    
}
- (void)initDataSoure
{
    _titleArray = @[@[@"离线地图管理",@"车辆信息"],
                    @[@"常见问题",@"功能介绍",@"去评分",@"关于"]];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREENDEFAULTHEIGHT, SCREENWIDTH, SCREENRESULTHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = RGB(245, 245, 245);
    [self.view addSubview:_tableView];
    [_tableView registerClass:[OptionsListCell class] forCellReuseIdentifier:kOptionsCellIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
#pragma mark - tableview dataSoure and  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOptionsListCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _titleArray[section];
    return arr.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kOptionsCellIdentifier];
    NSArray *arr = _titleArray[indexPath.section];
    cell.titleLabel.text = arr[indexPath.row];
    [cell setUpCellWithModels:arr[indexPath.row] section:indexPath.section row:indexPath.row];
    cell.cusSwitch.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        if(indexPath.row==0){
            offlineMapViewController *detailViewController = [[offlineMapViewController alloc] init];
            detailViewController.mapView = [NaviMapHelp shareMAMapView];
            detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailViewController];
            
            [self presentViewController:navi animated:YES completion:nil];
        }
        if(indexPath.row==1){
        }
    }else if(indexPath.section==1){
        NSLog(@"%ld==%ld",indexPath.section,indexPath.row);
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
