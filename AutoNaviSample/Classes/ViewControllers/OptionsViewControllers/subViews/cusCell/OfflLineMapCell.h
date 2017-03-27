//
//  OfflLineMapCell.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/27.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OfflLineMapCellDelegate <NSObject>
@optional
- (void)pauseItem:(id)sender;
- (void)downloadItem:(id)sender;
- (void)startItem:(id)sender;
- (void)cancleItem:(id)sender;
@end

@interface OfflLineMapCell : UITableViewCell
@property(nonatomic,weak,readwrite)id<OfflLineMapCellDelegate>  delegate;
@property(nonatomic,strong)UIButton * acctionBtn;
@property(nonatomic,strong)UILabel  * titleLable;
@property(nonatomic,strong)UILabel  * sizeLable;
@property(nonatomic,strong)UILabel  * stateLable;
-(void)updatecellviewWith:(MAOfflineItem *)item;
-(void)updateProcessViewWithItem:(MAOfflineItem *)item;
- (void)changeValue:(float)sender;
- (void)hideProgressView;
- (void)showProgressView;
@end
