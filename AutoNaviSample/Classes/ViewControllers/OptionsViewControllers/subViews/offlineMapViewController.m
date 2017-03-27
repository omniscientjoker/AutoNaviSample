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

#define kDefaultSearchkey       @"bj"
#define kSectionHeaderMargin    15.f
#define kSectionHeaderHeight    22.f
#define kTableCellHeight        42.f
#define kTagDownloadButton      100000
#define kTagPauseButton         100001
#define kTagDeleteButton        100002
#define kButtonSize             30.f
#define kButtonCount            3

@interface offlineMapViewController ()<UITableViewDataSource, UITableViewDelegate, offlineMapHeadViewDelegate,offlineMapHandleDelegate>
{
    char    *_expandedSections;
    UIImage *_download;
    UIImage *_pause;
    UIImage *_delete;
}
@property (nonatomic, strong) UITableView *TableView;
@property (nonatomic, strong) NSArray     *cities;
@property (nonatomic, strong) NSPredicate *predicate;

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *municipalities;

@property (nonatomic, strong) NSMutableSet        *downloadingItems;
@property (nonatomic, strong) NSMutableDictionary *downloadStages;

@property (nonatomic, strong) offlineMapHandle    *offMapHandle;
@property (nonatomic, assign) BOOL                needReloadWhenDisappear;
@end

@implementation offlineMapViewController
@synthesize mapView,TableView,cities,predicate,sectionTitles,provinces,municipalities,downloadingItems,downloadStages,needReloadWhenDisappear;

#pragma mark - Utility
//检查地图版本
- (void)checkNewestVersionAction
{
    [[MAOfflineMap sharedOfflineMap] checkNewestVersion:^(BOOL hasNewestVersion) {
        if (!hasNewestVersion){
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupCities];
            [self.TableView reloadData];
        });
    }];
}

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

//更新界面
- (void)updateAccessoryViewForCell:(UITableViewCell *)cell item:(MAOfflineItem *)item
{
    UIButton *delete = nil;
    UIButton *download = nil;
    UIButton *pause = nil;
    for (UIButton * but in cell.accessoryView.subviews){
        switch (but.tag){
            case kTagDeleteButton:
                delete = but;
                break;
            case kTagPauseButton:
                pause = but;
                break;
            case kTagDownloadButton:
                download = but;
                break;
            default:
                break;
        }
    }
    CGPoint right = CGPointMake(kButtonSize * (kButtonCount - 0.5), kButtonSize * 0.5);
    CGFloat leftMove = -kButtonSize;
    CGPoint center = right;
    if (item.itemStatus == MAOfflineItemStatusInstalled || item.itemStatus ==MAOfflineItemStatusCached){
        delete.hidden = NO;
        delete.center = center;
        center.x += leftMove;
    }else{
        delete.hidden = YES;
        delete.center = right;
    }
    
    if ([[MAOfflineMap sharedOfflineMap] isDownloadingForItem:item]){
        pause.hidden = NO;
        pause.center = center;
        center.x += leftMove;
        download.hidden = YES;
        download.center = right;
    }else{
        pause.hidden = YES;
        pause.center = right;
        if (item.itemStatus != MAOfflineItemStatusInstalled){
            download.hidden = NO;
            download.center = center;
        }else{
            download.hidden = YES;
            download.center = right;
        }
    }
}

- (void)updateUIForItem:(MAOfflineItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.TableView cellForRowAtIndexPath:indexPath];
    if (cell != nil){
        [self updateCell:cell forItem:item];
    }
    
    if ([item isKindOfClass:[MAOfflineItemCommonCity class]]){
        UITableViewCell * provinceCell = [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        if (provinceCell != nil){
            [self updateCell:provinceCell forItem:((MAOfflineItemCommonCity *)item).province];
        }
        return;
    }
    
    if ([item isKindOfClass:[MAOfflineProvince class]]){
        MAOfflineProvince * province = (MAOfflineProvince *)item;
        [province.cities enumerateObjectsUsingBlock:^(MAOfflineItemCommonCity * obj, NSUInteger idx, BOOL *  stop) {
            UITableViewCell * cityCell = [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx+1 inSection:indexPath.section]];
            [self updateCell:cityCell forItem:obj];
        }];
        return;
    }
}

- (void)updateCell:(UITableViewCell *)cell forItem:(MAOfflineItem *)item{
    [self updateAccessoryViewForCell:cell item:item];
    cell.textLabel.text = [self.offMapHandle returnMapStateForItem:item];
    cell.detailTextLabel.text = [self.offMapHandle returnMapStateDetailForItem:item DownItems:self.downloadingItems DownStage:self.downloadStages];
}

- (UIView *)accessoryView{
    UIView * accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize * kButtonCount, kButtonSize)];
    UIButton * downloadButton = [self buttonWithImage:[self downloadImage] tag:kTagDownloadButton];
    UIButton * pauseButton = [self buttonWithImage:[self pauseImage] tag:kTagPauseButton];
    UIButton * deleteButton = [self buttonWithImage:[self deleteImage] tag:kTagDeleteButton];
    [accessory addSubview:downloadButton];
    [accessory addSubview:pauseButton];
    [accessory addSubview:deleteButton];
    return accessory;
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section < self.sectionTitles.count ? kSectionHeaderHeight : kTableCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitles.count + self.provinces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section){
        case 0:{
            number = 1;
            break;
        }
        case 1:{
            number = self.municipalities.count;
            break;
        }
        default:{
            if (_expandedSections[section]){
                MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
                number = pro.cities.count + 1;
            }
            break;
        }
    }
    return number;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *theTitle = nil;
    if (section < self.sectionTitles.count){
        theTitle = self.sectionTitles[section];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.TableView.bounds), kSectionHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(headerView.bounds), CGRectGetHeight(headerView.bounds))];
        lb.backgroundColor = [UIColor clearColor];
        lb.text = theTitle;
        lb.textColor = [UIColor whiteColor];
        
        [headerView addSubview:lb];
        
        return headerView;
    }else{
        MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
        theTitle = pro.name;
        
        offlineMapHeadView *headerView = [[offlineMapHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.TableView.bounds), kTableCellHeight) expanded:_expandedSections[section]];
        headerView.section = section;
        headerView.text = theTitle;
        headerView.delegate = self;
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityCellIdentifier = @"cityCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [self accessoryView];
    }
    MAOfflineItem *item = [self.offMapHandle itemForIndexPath:indexPath Municipalities:municipalities Provinces:provinces];
    [self updateCell:cell forItem:item];
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.sectionTitles.count){
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - ImageResource
- (UIButton *)buttonWithImage:(UIImage *)image tag:(NSUInteger)tag{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
    [button setImage:image forState:UIControlStateNormal];
    button.tag = tag;
    button.center = CGPointMake((kButtonCount - tag + 0.5) * kButtonSize, kButtonSize * 0.5);
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (UIImage *)downloadImage{
    if (_download == nil){
        _download = [UIImage imageNamed:@"icon_download_img"];
    }
    return _download;
}

- (UIImage *)pauseImage{
    if (_pause == nil){
        _pause = [UIImage imageNamed:@"icon_pause_img"];
    }
    return _pause;
}

- (UIImage *)deleteImage{
    if (_delete == nil){
        _delete = [UIImage imageNamed:@"icon_delete_img"];
    }
    return _delete;
}


#pragma mark - MAHeaderViewDelegate
- (void)headerView:(offlineMapHandle *)headerView section:(NSInteger)section expanded:(BOOL)expanded{
    _expandedSections[section] = expanded;
    
    [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
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
#pragma mark - Handle Action
- (void)checkButtonTapped:(id)sender event:(id)event{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event];
    MAOfflineItem *item = [self.offMapHandle itemForIndexPath:indexPath Municipalities:municipalities Provinces:provinces];
    if (item == nil){
        return;
    }
    
    UIButton * button = sender;
    switch (button.tag){
        case kTagDeleteButton:
            [self.offMapHandle deleteFile:item];
            [self updateUIForItem:item atIndexPath:indexPath];
            break;
        case kTagPauseButton:
            [self.offMapHandle pauseDownloading:item];
            break;
        case kTagDownloadButton:
            [self.offMapHandle downloadFile:item DownItems:downloadingItems DownStage:downloadStages atIndexPath:indexPath];
            break;
        default:
            break;
    }
}

- (void)backAction{
    [self cancelAllAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAllAction{
    [[MAOfflineMap sharedOfflineMap] cancelAll];
}

- (void)searchAction{
    NSString *key = kDefaultSearchkey;
    NSArray *result = [_offMapHandle citiesFilterWithKey:key Predicate:predicate Cities:cities];
    [result enumerateObjectsUsingBlock:^(MAOfflineCity *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"idx = %d, cityName = %@, cityCode = %@, adCode = %@, pinyin = %@, jianpin = %@, size = %lld", (int)idx, obj.name, obj.cityCode,obj.adcode, obj.pinyin, obj.jianpin, obj.size);
    }];
}

#pragma mark - Initialization
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
    
    self.cities = [MAOfflineMap sharedOfflineMap].cities;
    self.provinces = [MAOfflineMap sharedOfflineMap].provinces;
    self.municipalities = [MAOfflineMap sharedOfflineMap].municipalities;
    
    self.downloadingItems = [NSMutableSet set];
    self.downloadStages = [NSMutableDictionary dictionary];
    
    if (_expandedSections != NULL){
        free(_expandedSections);
        _expandedSections = NULL;
    }
    
    _expandedSections = (char *)malloc((self.sectionTitles.count + self.provinces.count) * sizeof(char));
    memset(_expandedSections, 0, (self.sectionTitles.count + self.provinces.count) * sizeof(char));
}

- (void)setupPredicate{
    self.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] $KEY OR cityCode CONTAINS[cd] $KEY OR jianpin CONTAINS[cd] $KEY OR pinyin CONTAINS[cd] $KEY OR adcode CONTAINS[cd] $KEY"];
}

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self){
        [self setupCities];
        [self setupPredicate];
        [self checkNewestVersionAction];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.offMapHandle = [[offlineMapHandle alloc] init];
    self.offMapHandle.delegate = self;
    [self initNavigationBar];
    [self initTableView];
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
