//
//  LoginUser.m
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "LoginUser.h"
#import <objc/runtime.h>
@implementation LoginUser
+(LoginUser *)sharedInstance{
    static LoginUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc]init];
        [sharedInstance localSaveInit];
    });
    return sharedInstance;
}
//本地存储开启
- (void)localSaveInit{
    unsigned int propertyCount = 0;
    objc_property_t *propertyties = class_copyPropertyList([LoginUser class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++ ) {
        objc_property_t property = propertyties[i];
        const char * name = property_getName(property);
        [self addObserver:self forKeyPath:[NSString stringWithUTF8String:name] options:NSKeyValueObservingOptionNew context:NULL];
    }
}
@end
