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
- (void)offlineMapDowningWithModel:(OffLineItemHandelModel *)model;
- (void)offlineMapDowningFinished;
@end

@interface offlineMapHandle : NSObject
{
    char    *_expandedSections;
}
@property (weak, readwrite, nonatomic) id<offlineMapHandleDelegate> delegate;

//数据
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *municipalities;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSMutableSet        *downloadingItems;
@property (nonatomic, strong) NSMutableDictionary *downloadStages;

//方法
+(offlineMapHandle *)sharedInstance;
-(NSString *)convertFileSizeWithSize:(long long)size;
//获取离线地图状态
-(NSString *)returnMapStateForItem:(MAOfflineItem *)item;
//返回地图数据
-(NSString *)returnMapStateDetailForItem:(MAOfflineItem *)item DownItems:(NSMutableSet *)downloadingItems DownStage:(NSMutableDictionary *)downloadStages;
//返回cell数据
- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath Municipalities:(NSArray *)municipalities Provinces:(NSArray *)provinces;
//暂停 删除
- (void)pauseDownloading:(MAOfflineItem *)item;
- (void)deleteFile:(MAOfflineItem *)item;
- (void)downloadFile:(MAOfflineItem *)item DownItems:(NSMutableSet *)downloadingItems DownStage:(NSMutableDictionary *)downloadStages atIndexPath:(NSIndexPath *)indexPath;
//搜索匹配
- (NSArray *)citiesFilterWithKey:(NSString *)key Predicate:(NSPredicate *)predicate Cities:(NSArray *)cities;
@end
