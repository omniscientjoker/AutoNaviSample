//
//  OrderListModel.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListInfoModel : BaseModel
@property (nonatomic, retain) NSString * rId;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * number;
@end

@interface OrderListModel : BaseModel
@property (nonatomic, strong) NSMutableArray *list;
@end

