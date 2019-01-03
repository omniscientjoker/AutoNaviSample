//
//  OrderListModel.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/21.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"rId":@"rid",
             @"content":@"value",
             @"code":@"code",
             @"photo":@"photo",
             @"number":@"number"
             };
}
@end

@implementation OrderListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"list":@"list"
             };
}
+ (NSValueTransformer *)listJSONTransformer {
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[OrderListInfoModel class] fromJSONArray:value error:nil];
    }];
}
@end
