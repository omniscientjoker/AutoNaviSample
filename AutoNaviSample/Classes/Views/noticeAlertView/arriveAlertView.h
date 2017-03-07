//
//  arriveAlertView.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface arriveAlertView : UIView
@property(nonatomic,strong)NSString     * CarId;
-(instancetype)initWithCarID:(NSString *)CarId;
@end
