//
//  common.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "common.h"
#import "constants.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
@implementation common
#pragma mark - 获取设备相关信息
+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)platformString{
    NSString *platform = [self platform];
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"iPod1,1"   :@"iPod_Touch1",
                              @"iPod2,1"   :@"iPod_Touch2",
                              @"iPod3,1"   :@"iPod_Touch3",
                              @"iPod4,1"   :@"iPod_Touch4",
                              @"iPod5,1"   :@"iPod_Touch5",
                              @"iPad1,1" :@"iPad1",
                              @"iPad2,1" :@"iPad2",
                              @"iPad2,2" :@"iPad2",
                              @"iPad2,3"   :@"iPad2",
                              @"iPad2,4"   :@"iPad2",
                              @"iPad2,5"   :@"iPad_mini",
                              @"iPad2,6" :@"iPad_mini",
                              @"iPad2,7" :@"iPad_mini",
                              @"iPad3,1" :@"iPad3",
                              @"iPad3,2" :@"iPad3",
                              @"iPad3,3"   :@"iPad3",
                              @"iPad3,4"   :@"iPad4",
                              @"iPad3,5" :@"iPad4",
                              @"iPad3,6" :@"iPad4",
                              @"iPad4,1" :@"iPad_Air",
                              @"iPad4,2" :@"iPad_Air",
                              @"iPad4,3"   :@"iPad_Air",
                              @"iPad4,4"   :@"iPad_mini",
                              @"iPad4,5"   :@"iPad_mini",
                              @"iPad4,6"   :@"iPad_mini",
                              @"iPhone1,1"   :@"iPhone1G_GSM",
                              @"iPhone1,2"   :@"iPhone3G_GSM",
                              @"iPhone2,1"   :@"iPhone3GS_GSM",
                              @"iPhone3,1"   :@"iPhone4_GSM",
                              @"iPhone3,3"   :@"iPhone4_CDMA",
                              @"iPhone4,1"   :@"iPhone4S",
                              @"iPhone5,1"   :@"iPhone5",
                              @"iPhone5,2"   :@"iPhone5",
                              @"iPhone5,3"   :@"iPhone5C",
                              @"iPhone5,4"   :@"iPhone5C",
                              @"iPhone6,1"   :@"iPhone5S",
                              @"iPhone6,2"   :@"iPhone5S",
                              @"i386"   :@"iPhone_Simulator",
                              @"x86_64" :@"iPhone_Simulator",
                              @"iPhone7,1":@"iPhone6_Plus",
                              @"iPhone7,2":@"iPhone6",
                              @"iPhone8,1":@"iPhone6S",
                              @"iPhone8,2":@"iPhone6_PlusS"
                              };
    }
    
    NSString *unknownPlatform = platform;
    
    if (platform){
        platform = [deviceNamesByCode objectForKey:platform];
    }
    if ([platform length] == 0){
        platform = unknownPlatform;
    }
    return platform;
}

+ (NSString *)getUUID{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *uuid = (__bridge NSString *)newUniqueIdString;
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    return uuid;
}

+ (NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getAlias:(NSString *) phone{
    return phone;
}

#pragma mark - 字符串的简单处理
+ (NSString *)manufactureString:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)removeWhiteSpaceCharactersAtEnd:(NSString *)string{
    if (IsStrEmpty(string)) {
        return nil;
    }else{
        NSUInteger count = [string length] - 1;
        for (; count >0; count--) {
            if ([string characterAtIndex:count] != ' ') {
                break;
            }
        }
        NSString *str = [string substringToIndex:count+1];
        return str;
    }
}

+ (NSString *)removeWhiteSpaceCharactersAtBeginning:(NSString *)string{
    if (IsStrEmpty(string)) {
        return nil;
    }else{
        NSUInteger count = 0;
        for (;; count++)
        {
            if (count <string.length) {
                if ([string characterAtIndex:count] != ' ') {
                    break;
                }
            }else{
                break;
            }
        }
        NSString *str = [string substringFromIndex:count];
        return str;
    }
}

+ (CGFloat)caculateWidth:(NSString *)text size:(UIFont *)font height:(CGFloat)height{
    CGSize textBlockMinSize = {CGFLOAT_MAX, height};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    
    size = [text boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:@{
                                        NSFontAttributeName:font
                                        }
                              context:nil].size;
    
    return  size.width;
}

+ (CGFloat)caculateHeight:(NSString *)text size:(UIFont *)font width:(CGFloat)width{
    CGSize textBlockMinSize = {width, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    
    size = [text boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:@{
                                        NSFontAttributeName:font
                                        }
                              context:nil].size;
    
    return  size.height;
}

#pragma mark - 图像简单处理
+ (UIImageView *)drawLineImage:(CGRect)rect isHorizontal:(BOOL)isHorizontal lineWidth:(CGFloat)width red:(float)red green:(float)green blue:(float)blue{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, 0);
    if (isHorizontal) {
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), imageView.frame.size.width, 0);
    }else{
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 0, imageView.frame.size.height);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageView;
}

+(UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color set];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)getFirstImageFromVideoToLocal:(NSString *)localVideoName width:(CGFloat)width height:(CGFloat)height{
    return nil;
}
@end
