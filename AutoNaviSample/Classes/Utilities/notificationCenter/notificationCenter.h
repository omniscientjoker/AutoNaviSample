//
//  notificationCenter.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface notificationCenter : NSObject
@property(nonatomic,strong)NSString * noticeTitle;
@property(nonatomic,strong)NSString * noticeSubtitle;
@property(nonatomic,strong)NSString * noriceBody;

+(void)setNoticeWithTitile:(NSString *)titile Subtitle:(NSString *)subtitle Body:(NSString *)body;

@end
