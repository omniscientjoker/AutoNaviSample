//
//  offlineMapHandle.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "OffLineItemHandelModel.h"

@protocol offlineMapHandleDelegate <NSObject>
@optional
- (void)removeOffLineMapSuccessed;
- (void)getOffLineMapSourceSuccessed;
- (void)getOffLineMapSourceFailed;
- (void)offlineMapDowningWithModel:(OffLineItemHandelModel *)model;
- (void)offlineMapDowningFinished;
@end

@interface offlineMapHandle : NSObject
@property (weak, readwrite, nonatomic) id<offlineMapHandleDelegate> delegate;
//数据
@property (nonatomic, strong) NSArray *cities;          //市
@property (nonatomic, strong) NSArray *provinces;       //省
@property (nonatomic, strong) NSArray *municipalities;  //直辖市
@property (nonatomic, strong) NSMutableSet        *downloadingItems;
@property (nonatomic, strong) NSMutableDictionary *downloadStages;
//单例创建
+(offlineMapHandle *)sharedInstance;
-(void)updateDateSourcesForOffLineMap;
//工具方法
-(BOOL)mapFileIsExist;
-(NSString *)convertFileSizeWithSize:(long long)size;

#pragma mark offlineMap
//获取地图更新
- (void)setupOffLineMap;
//获取离线地图状态
-(NSString *)returnMapStateForItem:(MAOfflineItem *)item;
//返回地图下载状态
-(CGFloat)returnDownloadPerfencet:(MAOfflineItem *)item;
-(NSString *)returnMapStateDetailForItem:(MAOfflineItem *)item;
//返回cell数据
- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath;
//暂停 删除
- (void)deleteFilesWithSections:(NSArray *)items;
- (void)pauseDownloading:(MAOfflineItem *)item;
- (void)deleteFile:(MAOfflineItem *)item;
- (void)downloadFile:(MAOfflineItem *)item IndexPath:(NSIndexPath *)indexPath;
//
-(NSArray *)returnDownLoadMunicipalities;
-(NSArray *)returnDownLoadProvinces;
-(NSArray *)returnDownLoadCitiesWithSession:(NSInteger)session;
//搜索匹配
- (NSArray *)citiesFilterWithKey:(NSString *)key Predicate:(NSPredicate *)predicate;
@end
