//
//  offlineMapViewController.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "offlineMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "offlineMapHeadView.h"
#import "offlineMapHandle.h"
#import "ProgressBarView.h"
#import "OfflLineMapCell.h"

#define kDefaultSearchkey       @"bj"
#define kOffLineMapDownLoadCell @"kOffLineMapDownLoadCell"
#define kSectionHeaderMargin    15.f
#define kSectionHeaderHeight    22.f
#define kTableCellHeight        66.f
#define kTagDownloadButton      100000
#define kTagPauseButton         100001
#define kTagDeleteButton        100002
#define kButtonSize             30.f
#define kButtonCount            3

@interface offlineMapViewController ()<UITableViewDataSource, UITableViewDelegate, offlineMapHeadViewDelegate,offlineMapHandleDelegate,OfflLineMapCellDelegate>
{
    char    *_expandedSections;
    UIImage *_download;
    UIImage *_pause;
    UIImage *_delete;
}
@property (nonatomic, strong) UITableView *TableView;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSArray     *sectionTitles;
@property (nonatomic, assign) BOOL         needReloadWhenDisappear;
@end

@implementation offlineMapViewController
@synthesize mapView,TableView,predicate,sectionTitles,needReloadWhenDisappear;

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self){
        [self setupCities];
        [self setupPredicate];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [offlineMapHandle sharedInstance].delegate = self;
    [[offlineMapHandle sharedInstance] setupOffLineMap];
    [self initNavigationBar];
    [self initTableView];
}
- (void)initNavigationBar
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消全部"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cancelAllAction)];
}

- (void)initTableView{
    self.TableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.TableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.TableView.delegate   = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
}

- (void)setupCities{
    self.sectionTitles = @[@"全国", @"直辖市", @"省份"];
    if (_expandedSections != NULL){
        free(_expandedSections);
        _expandedSections = NULL;
    }
    _expandedSections = (char *)malloc((self.sectionTitles.count + [offlineMapHandle sharedInstance].provinces.count) * sizeof(char));
    memset(_expandedSections, 0, (self.sectionTitles.count + [offlineMapHandle sharedInstance].provinces.count) * sizeof(char));
}
- (void)setupPredicate{
    self.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] $KEY OR cityCode CONTAINS[cd] $KEY OR jianpin CONTAINS[cd] $KEY OR pinyin CONTAINS[cd] $KEY OR adcode CONTAINS[cd] $KEY"];
}

#pragma mark - Utility
//更新界面
- (void)updateUIForItem:(MAOfflineItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    OfflLineMapCell * cell = [self.TableView cellForRowAtIndexPath:indexPath];
    if (cell != nil){
        [cell updateCellUiForItem:item];
    }
    
    if ([item isKindOfClass:[MAOfflineItemCommonCity class]]){
        OfflLineMapCell * provinceCell = [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        if (provinceCell != nil){
            [provinceCell updateCellUiForItem:((MAOfflineItemCommonCity *)item).province];
        }
        return;
    }
    
    if ([item isKindOfClass:[MAOfflineProvince class]]){
        MAOfflineProvince * province = (MAOfflineProvince *)item;
        [province.cities enumerateObjectsUsingBlock:^(MAOfflineItemCommonCity * obj, NSUInteger idx, BOOL *  stop) {
            OfflLineMapCell * cityCell = [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx+1 inSection:indexPath.section]];
            [cityCell updateCellUiForItem:obj];
        }];
        return;
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitles.count + [offlineMapHandle sharedInstance].provinces.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section){
        case 0:{
            number = 1;
            break;
        }
        case 1:{
            number = [offlineMapHandle sharedInstance].municipalities.count;
            break;
        }
        default:{
            if (_expandedSections[section]){
                MAOfflineProvince *pro = [offlineMapHandle sharedInstance].provinces[section - self.sectionTitles.count];
                number = pro.cities.count;
            }
            break;
        }
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section < self.sectionTitles.count ? kSectionHeaderHeight : kTableCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.sectionTitles.count){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kSectionHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(headerView.bounds), CGRectGetHeight(headerView.bounds))];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = self.sectionTitles[section];;
        lb.textColor = [UIColor whiteColor];
        [headerView addSubview:lb];
        return headerView;
    }else{
        MAOfflineProvince *pro = [offlineMapHandle sharedInstance].provinces[section - self.sectionTitles.count];
        offlineMapHeadView *headerView = [[offlineMapHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.TableView.bounds), kTableCellHeight) expanded:_expandedSections[section]];
        headerView.section = section;
        headerView.text = pro.name;
        headerView.delegate = self;
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfflLineMapCell *cell = [tableView dequeueReusableCellWithIdentifier:kOffLineMapDownLoadCell];
    if (cell == nil){
        cell = [[OfflLineMapCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kOffLineMapDownLoadCell];
        cell.delegate       = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MAOfflineItem *item = [[offlineMapHandle sharedInstance] itemForIndexPath:indexPath];
    [cell updateCellViewForItem:item];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        MAOfflineItem *item = [[offlineMapHandle sharedInstance] itemForIndexPath:indexPath];
        [[offlineMapHandle sharedInstance] deleteFile:item];
        [self updateUIForItem:item atIndexPath:indexPath];
    }else{
        [tableView setEditing:NO animated:YES];
    }
    [tableView setEditing:NO animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - cellDelegate
-(void)pauseItem:(id)sender{
    OfflLineMapCell * editcell = (OfflLineMapCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.TableView indexPathForCell:editcell];
    MAOfflineItem *item = [[offlineMapHandle sharedInstance] itemForIndexPath:indexPath];
    [[offlineMapHandle sharedInstance] pauseDownloading:item];
    
}
-(void)downloadItem:(id)sender{
    OfflLineMapCell * editcell = (OfflLineMapCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.TableView indexPathForCell:editcell];
    MAOfflineItem *item = [[offlineMapHandle sharedInstance] itemForIndexPath:indexPath];
    [[offlineMapHandle sharedInstance] downloadFile:item IndexPath:indexPath];
}
-(void)startItem:(id)sender{
    OfflLineMapCell * editcell = (OfflLineMapCell *)[[sender superview] superview];
    NSIndexPath * indexPath = [self.TableView indexPathForCell:editcell];
    MAOfflineItem *item = [[offlineMapHandle sharedInstance] itemForIndexPath:indexPath];
    [[offlineMapHandle sharedInstance] downloadFile:item IndexPath:indexPath];
}
#pragma mark - offLineMapHandleDelegate
-(void)offlineMapDowningWithModel:(OffLineItemHandelModel *)model
{
    [self updateUIForItem:model.MAOfflineItem atIndexPath:model.indexPath];
}
-(void)offlineMapDowningFinished
{
    self.needReloadWhenDisappear = YES;
}
-(void)getOffLineMapSourceSuccessed{
    [self setupCities];
    [self.TableView reloadData];
}
-(void)getOffLineMapSourceFailed{
    [[offlineMapHandle sharedInstance] setupOffLineMap];
}

#pragma mark - MAHeaderViewDelegate
- (void)headerView:(offlineMapHandle *)headerView section:(NSInteger)section expanded:(BOOL)expanded{
    _expandedSections[section] = expanded;
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Handle Action
- (void)cancelAllAction{
    [[MAOfflineMap sharedOfflineMap] cancelAll];
}
- (void)searchAction{
    NSString *key = kDefaultSearchkey;
    NSArray *result = [[offlineMapHandle sharedInstance] citiesFilterWithKey:key Predicate:predicate];
    [result enumerateObjectsUsingBlock:^(MAOfflineCity *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"idx = %d, cityName = %@, cityCode = %@, adCode = %@, pinyin = %@, jianpin = %@, size = %lld", (int)idx, obj.name, obj.cityCode,obj.adcode, obj.pinyin, obj.jianpin, obj.size);
    }];
}

#pragma mark - unit
//获取点击的cell
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton*)sender;
    UITouch *touch = [[event allTouches] anyObject];
    if (![button pointInside:[touch locationInView:button] withEvent:event]){
        return nil;
    }
    CGPoint touchPosition = [touch locationInView:self.TableView];
    return [self.TableView indexPathForRowAtPoint:touchPosition];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needReloadWhenDisappear){
        [self.mapView reloadMap];
        self.needReloadWhenDisappear = NO;
    }
}
- (void)dealloc{
    free(_expandedSections);
    _expandedSections = NULL;
}
@end
