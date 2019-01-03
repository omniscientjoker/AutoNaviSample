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
    unsigned int propertyCount, i;
    objc_property_t *propertyties = class_copyPropertyList([LoginUser class], &propertyCount);
    for (i = 0; i < propertyCount; i++ ) {
        objc_property_t property = propertyties[i];
        const char * name = property_getName(property);
        [self addObserver:self forKeyPath:[NSString stringWithUTF8String:name] options:NSKeyValueObservingOptionNew context:NULL];
    }
    free(propertyties);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //    WYLog(@"wushihai_%@:%@",keyPath,change);
    if ([change isKindOfClass:[NSDictionary class]]){
        id obj = [change objectForKey:@"new"];
        [self updateLoginUserInfoDictionary:keyPath value:obj];
    }
}
- (void)updateLoginUserInfoDictionary:(NSString *)key value:(id)value{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loginUserInfoMutableDictionary = [standardUserDefaults objectForKey:@"kLoginUserUserDefaultsKey"];
    if (!loginUserInfoMutableDictionary) {
        loginUserInfoMutableDictionary = [[NSMutableDictionary alloc] init];
    }else{
        loginUserInfoMutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:loginUserInfoMutableDictionary];
    }
    if (value != nil && value !=[NSNull null] && ![value isKindOfClass:[NSError class]] && [value isKindOfClass:[NSObject class]]) {
        
        [loginUserInfoMutableDictionary setObject:value forKey:key];
        [standardUserDefaults setObject:loginUserInfoMutableDictionary forKey:@"kLoginUserUserDefaultsKey"];
        [standardUserDefaults synchronize];
    }
}

+ (void)parseLoginUserInfoFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loginUserInfoMutableDictionary = [standardUserDefaults objectForKey:@"kLoginUserUserDefaultsKey"];
    if (loginUserInfoMutableDictionary) {
        BOOL isLogin = [[loginUserInfoMutableDictionary objectForKeyedSubscript:@"isLogin"] boolValue];
        if (isLogin){
            unsigned int propertyCount = 0;
            objc_property_t *propertyties = class_copyPropertyList([LoginUser class], &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++ ) {
                objc_property_t property = propertyties[i];
                const char * name = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:name];
                id obj = [loginUserInfoMutableDictionary objectForKeyedSubscript:propertyName];
                if (![propertyName isEqualToString:@"isLogin"] && obj) {
                    [[LoginUser sharedInstance] setValue:obj forKey:propertyName];
                }
            }
             free(propertyties);
        }
    }
}
@end
