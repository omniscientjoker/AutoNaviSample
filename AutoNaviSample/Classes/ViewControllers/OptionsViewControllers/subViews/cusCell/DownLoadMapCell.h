//
//  DownLoadMapCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/31.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kdownLoadMapMangerCellHeight     60

@protocol DownLoadMapCellDelegate;
@protocol DownLoadMapCellDelegate <NSObject>
@optional
- (void)selectAttribution:(id)sender;
@end

@interface DownLoadMapCell : UITableViewCell
@property(nonatomic,weak,readwrite)id<DownLoadMapCellDelegate>  delegate;
@property(nonatomic,strong)UIButton * acctionBtn;
@property(nonatomic,strong)UILabel  * titleLable;
@property(nonatomic,strong)UILabel  * sizeLable;
@property(nonatomic,strong)UILabel  * stateLable;
-(void)updateCellViewForItem:(MAOfflineItem *)item;
@end
