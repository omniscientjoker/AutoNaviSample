//
//  SlidebarFunctions.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/15.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef REUIKitIsFlatMode
#define REUIKitIsFlatMode() RESideMenuUIKitIsFlatMode()
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_6_1
#define kCFCoreFoundationVersionNumber_iOS_6_1 793.00
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS7_OR_GREATER(...)
#endif
BOOL RESideMenuUIKitIsFlatMode(void);
