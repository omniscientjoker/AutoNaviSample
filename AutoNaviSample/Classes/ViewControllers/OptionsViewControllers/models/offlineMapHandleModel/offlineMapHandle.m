//
//  offlineMapHandle.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "offlineMapHandle.h"

NSString const *DownloadStageIsRunningKey = @"DownloadStageIsRunningKey";
NSString const *DownloadStageStatusKey    = @"DownloadStageStatusKey";
NSString const *DownloadStageInfoKey      = @"DownloadStageInfoKey";

@implementation offlineMapHandle
-(NSString *)convertFileSizeWithSize:(long long)size
{
    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    if (size >= gb) {
        return [NSString stringWithFormat:@"%.1f GB", (float) size / gb];
    } else if (size >= mb) {
        float f = (float) size / mb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0f MB", f];
        }else{
            return [NSString stringWithFormat:@"%.1f MB", f];
        }
    } else if (size >= kb) {
        float f = (float) size / kb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0f KB", f];
        }else{
            return [NSString stringWithFormat:@"%.1f KB", f];
        }
    } else
        return [NSString stringWithFormat:@"%lld B", size];
}

-(NSString *)returnMapStateForItem:(MAOfflineItem *)item
{
    NSString *labelText = nil;
    if (item.itemStatus == MAOfflineItemStatusInstalled){
        labelText = [item.name stringByAppendingString:@"(已安装)"];
    }
    else if (item.itemStatus == MAOfflineItemStatusExpired){
        labelText = [item.name stringByAppendingString:@"(有更新)"];
    }
    else if (item.itemStatus == MAOfflineItemStatusCached){
        labelText = [item.name stringByAppendingString:@"(缓存)"];
    }
    else{
        labelText = item.name;
    }
    return labelText;
}

-(NSString *)returnMapStateDetailForItem:(MAOfflineItem *)item DownItems:(NSMutableSet *)downloadingItems DownStage:(NSMutableDictionary *)downloadStages
{
    if ([item isKindOfClass:[MAOfflineProvince class]]){
        
        return [NSString stringWithFormat:@"大小:%@", [self convertFileSizeWithSize:item.size]];
    }
    
    NSString *detailText = nil;
    if (![downloadingItems containsObject:item]){
        if (item.itemStatus == MAOfflineItemStatusCached){
            detailText = [NSString stringWithFormat:@"%@/%@", [self convertFileSizeWithSize:item.downloadedSize], [self convertFileSizeWithSize:item.size]];
        }else{
            detailText = [NSString stringWithFormat:@"大小:%@", [self convertFileSizeWithSize:item.size]];
        }
    }else{
        NSMutableDictionary *stage  = [downloadStages objectForKey:item.adcode];
        MAOfflineMapDownloadStatus status = [[stage objectForKey:DownloadStageStatusKey] intValue];
        switch (status){
            case MAOfflineMapDownloadStatusWaiting:{
                detailText = @"等待";
                break;
            }
            case MAOfflineMapDownloadStatusStart:{
                detailText = @"开始";
                break;
            }
            case MAOfflineMapDownloadStatusProgress:{
                NSDictionary *progressDict = [stage objectForKey:DownloadStageInfoKey];
                long long recieved = [[progressDict objectForKey:MAOfflineMapDownloadReceivedSizeKey] longLongValue];
                long long expected = [[progressDict objectForKey:MAOfflineMapDownloadExpectedSizeKey] longLongValue];
                detailText = [NSString stringWithFormat:@"%@/%@(%.1f%%)", [self convertFileSizeWithSize:recieved], [self convertFileSizeWithSize:expected], recieved/(float)expected*100];
                break;
            }
            case MAOfflineMapDownloadStatusCompleted:{
                detailText = @"下载完成";
                break;
            }
            case MAOfflineMapDownloadStatusCancelled:{
                detailText = @"取消";
                break;
            }
            case MAOfflineMapDownloadStatusUnzip:{
                detailText = @"解压中";
                break;
            }
            case MAOfflineMapDownloadStatusFinished:{
                detailText = @"结束";
                break;
            }
            default:{
                detailText = @"错误";
                break;
            }
        }
    }
    return detailText;
}




//返回cell数据
- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath Municipalities:(NSArray *)municipalities Provinces:(NSArray *)provinces
{
    if(indexPath == nil){
        return nil;
    }
    
    MAOfflineItem *item = nil;
    switch (indexPath.section){
        case 0:{
            item = [MAOfflineMap sharedOfflineMap].nationWide;
            break;
        }
        case 1:{
            item = municipalities[indexPath.row];
            break;
        }
        case 2:{
            item = nil;
            break;
        }
        default:{
            MAOfflineProvince *pro = provinces[indexPath.section - 3];
            if (indexPath.row == 0){
                item = pro; // 添加整个省
            }else{
                item = pro.cities[indexPath.row - 1]; // 添加市
            }
            break;
        }
    }
    return item;
}

//暂停 删除 下载
- (void)pauseDownloading:(MAOfflineItem *)item{
    [[MAOfflineMap sharedOfflineMap] pauseItem:item];
}
- (void)deleteFile:(MAOfflineItem *)item{
    [[MAOfflineMap sharedOfflineMap] deleteItem:item];
}
- (void)downloadFile:(MAOfflineItem *)item DownItems:(NSMutableSet *)downloadingItems DownStage:(NSMutableDictionary *)downloadStages atIndexPath:(NSIndexPath *)indexPath
{
    if (item == nil || item.itemStatus == MAOfflineItemStatusInstalled){
        return;
    }
    [[MAOfflineMap sharedOfflineMap] downloadItem:item shouldContinueWhenAppEntersBackground:YES downloadBlock:^(MAOfflineItem * downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
        if (![downloadingItems containsObject:downloadItem]){
            [downloadingItems addObject:downloadItem];
            [downloadStages setObject:[NSMutableDictionary dictionary] forKey:downloadItem.adcode];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *stage  = [downloadStages objectForKey:downloadItem.adcode];
            if (downloadStatus == MAOfflineMapDownloadStatusWaiting){
                [stage setObject:[NSNumber numberWithBool:YES] forKey:DownloadStageIsRunningKey];
            }else if(downloadStatus == MAOfflineMapDownloadStatusProgress){
                [stage setObject:info forKey:DownloadStageInfoKey];
            }else if(downloadStatus == MAOfflineMapDownloadStatusCancelled
                     || downloadStatus == MAOfflineMapDownloadStatusError
                     || downloadStatus == MAOfflineMapDownloadStatusFinished){
                [stage setObject:[NSNumber numberWithBool:NO] forKey:DownloadStageIsRunningKey];
                [downloadingItems removeObject:downloadItem];
                [downloadStages removeObjectForKey:downloadItem.adcode];
            }
            [stage setObject:[NSNumber numberWithInt:downloadStatus] forKey:DownloadStageStatusKey];
            
            OffLineItemHandelModel * model = [[OffLineItemHandelModel alloc] init];
            model.MAOfflineItem = item;
            model.indexPath     = indexPath;
            if ([self.delegate conformsToProtocol:@protocol(offlineMapHandleDelegate)] && [self.delegate respondsToSelector:@selector(offlineMapDowningWithModel:)]) {
                [self.delegate offlineMapDowningWithModel:model];
            }
            
            if (downloadStatus == MAOfflineMapDownloadStatusFinished)
            {
                if ([self.delegate conformsToProtocol:@protocol(offlineMapHandleDelegate)] && [self.delegate respondsToSelector:@selector(offlineMapDowningFinished)]) {
                    [self.delegate offlineMapDowningFinished];
                }
            }
        });
    }];
}
//搜索匹配
- (NSArray *)citiesFilterWithKey:(NSString *)key Predicate:(NSPredicate *)predicate Cities:(NSArray *)cities
{
    if (key.length == 0){
        return nil;
    }
    NSPredicate *keyPredicate = [predicate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:key forKey:@"KEY"]];
    return [cities filteredArrayUsingPredicate:keyPredicate];
}
@end
