	//
//  DownLoadMapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/31.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "DownLoadMapViewController.h"
#import "offlineMapHeadView.h"
#import "offlineMapHandle.h"
#import "DownLoadMapCell.h"

#define kdownLoadMapMangerCell  @"kdownLoadMapMangerCell"
#define kSectionHeaderMargin                15.f
#define kSectionHeaderHeight                22.f

@interface DownLoadMapViewController ()<UITableViewDelegate,UITableViewDataSource,offlineMapHeadViewDelegate,DownLoadMapCellDelegate>{
    NSArray        * municipalities;
    NSArray        * provinces;
    NSMutableArray * sectionTitles;
    NSMutableArray * expandedSections;
    NSMutableArray * selectedSections;
    NSMutableArray * selectedItems;
}
@property (nonatomic, strong) UITableView    *TableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation DownLoadMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDataSource];
    
    [self initTableView];
    [self initTableHeadView];
    [self initTableFootView];
}
- (void)initDataSource{
    if (municipalities) {
        municipalities = nil;
    }
    if (provinces) {
        provinces = nil;
    }
    if (sectionTitles) {
        sectionTitles = nil;
    }
    self.dataArr     = [[NSMutableArray alloc] init];
    sectionTitles    = [[NSMutableArray alloc] init];
    selectedItems    = [[NSMutableArray alloc] init];
    selectedSections = [[NSMutableArray alloc] init];
    
    municipalities = [NSArray arrayWithArray:[[offlineMapHandle sharedInstance] returnDownLoadMunicipalities]];
    provinces      = [NSArray arrayWithArray:[[offlineMapHandle sharedInstance] returnDownLoadProvinces]];
    
    if ([MAOfflineMap sharedOfflineMap].nationWide.itemStatus == MAOfflineItemStatusInstalled) {
        [self.dataArr addObject:@[[MAOfflineMap sharedOfflineMap].nationWide]];
        [sectionTitles addObject:@"全国"];
    }
    if (municipalities.count > 0) {
        [self.dataArr addObject:municipalities];
        [sectionTitles addObject:@"直辖市"];
    }
    if (provinces.count > 0) {
        [self.dataArr addObject:provinces];
        [sectionTitles addObject:@"省份"];
    }
    if (expandedSections) {
        expandedSections = nil;
    }
    expandedSections = [[NSMutableArray alloc] init];
}
- (void)initTableView{
    if (self.TableView) {
        [self.TableView removeFromSuperview];
        self.TableView = nil;
    }
    self.TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREENDEFAULTHEIGHT, SCREENWIDTH, SCREENRESULTHEIGHT-50) style:UITableViewStylePlain];
    self.TableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.TableView.delegate   = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
}
-(void)initTableHeadView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 4, 60, 36)];
    btn.layer.shadowColor  = [UIColor blackColor].CGColor;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.layer.masksToBounds= YES;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDismissView) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-160)/2, 4, 160, 36)];
    titleLab.text = @"离线地图管理";
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:19.0f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLab];
}
-(void)initTableFootView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-160)/2, 4, 160, 36)];
    btn.layer.shadowColor  = [UIColor blackColor].CGColor;
    btn.layer.masksToBounds= YES;
    btn.layer.cornerRadius = 4.0f;
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitles.count + provinces.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger number = 0;
    if (section < sectionTitles.count) {
        NSArray * arr = self.dataArr[section];
        if (section == sectionTitles.count-1 ) {
            if (provinces.count > 0) {
                number = 0;
            }else{
                number = arr.count;
            }
        }else{
            number = arr.count;
        }
    }else{
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        if ([expandedSections containsObject:string]){
            NSArray * cityArr  = provinces[section-sectionTitles.count];
            number = cityArr.count - 1;
        }
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section < sectionTitles.count ? kSectionHeaderHeight : kdownLoadMapMangerCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kdownLoadMapMangerCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < sectionTitles.count){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kSectionHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(headerView.bounds), CGRectGetHeight(headerView.bounds))];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = sectionTitles[section];;
        lb.textColor = [UIColor whiteColor];
        [headerView addSubview:lb];
        return headerView;
    }else{
        NSArray *pro = provinces[section - sectionTitles.count];
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        BOOL espanded;
        if ([expandedSections containsObject:string]){
            espanded = YES;
        }else{
            espanded = NO;
        }
        offlineMapHeadView *headerView = [[offlineMapHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.TableView.bounds), kdownLoadMapMangerCellHeight) expanded:espanded isManager:YES];
        headerView.section = section;
        MAOfflineProvince * prv = pro[0];
        headerView.text = prv.name;
        headerView.delegate = self;
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownLoadMapCell *cell = [tableView dequeueReusableCellWithIdentifier:kdownLoadMapMangerCell];
    if (cell == nil){
        cell = [[DownLoadMapCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kdownLoadMapMangerCell];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MAOfflineItem * item = [[MAOfflineItem alloc] init];
    if (provinces.count > 0) {
        if (indexPath.section < sectionTitles.count ) {
            item = self.dataArr[indexPath.section][indexPath.row];
        }else{
            NSArray * arr = [self.dataArr lastObject];
            NSArray * cityArr = [arr objectAtIndex:indexPath.section - sectionTitles.count ];
            item = cityArr[indexPath.row+1];
        }
    }else{
        item = self.dataArr[indexPath.section][indexPath.row];
    }
    [cell updateCellViewForItem:item];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownLoadMapCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MAOfflineItem * item = [[MAOfflineItem alloc] init];
    if (provinces.count > 0) {
        if (indexPath.section < sectionTitles.count ) {
            item = self.dataArr[indexPath.section][indexPath.row];
        }else{
            NSArray * arr = [self.dataArr lastObject];
            NSArray * cityArr = [arr objectAtIndex:indexPath.section - sectionTitles.count ];
            item = cityArr[indexPath.row+1];
        }
    }else{
        item = self.dataArr[indexPath.section][indexPath.row];
    }
    if (cell.acctionBtn.selected) {
        cell.acctionBtn.selected = NO;
        [selectedItems removeObject:item];
    }else{
        cell.acctionBtn.selected = YES;
        [selectedItems addObject:item];
    }
}


-(void)selectAttribution:(id)sender{
    DownLoadMapCell * editcell = (DownLoadMapCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.TableView indexPathForCell:editcell];
    MAOfflineItem * item = [[MAOfflineItem alloc] init];
    if (provinces.count > 0) {
        if (indexPath.section < sectionTitles.count ) {
            item = self.dataArr[indexPath.section][indexPath.row];
        }else{
            NSArray * arr = [self.dataArr lastObject];
            NSArray * cityArr = [arr objectAtIndex:indexPath.section - sectionTitles.count ];
            item = cityArr[indexPath.row+1];
        }
    }else{
        item = self.dataArr[indexPath.section][indexPath.row];
    }
    if (editcell.acctionBtn.selected) {
        [selectedItems addObject:item];
    }else{
        [selectedItems removeObject:item];
    }
}

- (void)headerView:(offlineMapHandle *)headerView section:(NSInteger)section expanded:(BOOL)expanded{
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if (expanded == YES) {
        [expandedSections addObject:string];
    }else{
         [expandedSections removeObject:string];
    }
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)headerView:(offlineMapHeadView *)headerView section:(NSInteger)section selected:(BOOL)selected{
    if (selected) {
        headerView.selected = NO;
        headerView.selectedImageView.highlighted = NO;
        NSArray *pro = provinces[section - sectionTitles.count];
        MAOfflineProvince * prv = pro[0];
        [selectedSections removeObject:prv];
    }else{
        headerView.selected = YES;
        headerView.selectedImageView.highlighted = YES;
        NSArray *pro = provinces[section - sectionTitles.count];
        MAOfflineProvince * prv = pro[0];
        [selectedSections addObject:prv];
    }
}
-(void)clickDismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickDeleteBtn{
    if (selectedSections.count > 0) {
        [[offlineMapHandle sharedInstance] deleteFilesWithSections:selectedSections];
    }
    if (selectedItems) {
        for (int i = 0 ; i < selectedItems.count ; i ++ ) {
            MAOfflineItem * item = selectedItems[i];
            [[offlineMapHandle sharedInstance] deleteFile:item];
        }
    }
    [self initDataSource];
    [self.TableView reloadData];
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
