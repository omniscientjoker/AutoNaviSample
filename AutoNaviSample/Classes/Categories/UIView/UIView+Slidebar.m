//
//  UIView+Slidebar.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/14.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIView+Slidebar.h"

@implementation UIView (Slidebar)

-(UIView *)lastSubviewOnX{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        for(UIView *v in self.subviews)
            if(v.frame.origin.x > outView.frame.origin.x)
                outView = v;
        return outView;
    }
    return nil;
}

-(UIView *)lastSubviewOnY{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        for(UIView *v in self.subviews)
            if(v.frame.origin.y > outView.frame.origin.y)
                outView = v;
        return outView;
    }
    return nil;
}
@end
