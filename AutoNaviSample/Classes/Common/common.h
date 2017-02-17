//
//  common.h
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface common : NSObject
//获取设备硬件版本
+ (NSString *)platform;
//获取设备硬件名称
+ (NSString *)platformString;
//获取设备UUID
+ (NSString *)getUUID;
//获取设备版本
+ (NSString *)getVersion;
//获取设备别名
+ (NSString *)getAlias:(NSString *) phone;

//去掉字符串空格和回车
+ (NSString *)manufactureString:(NSString *)string;
//去掉尾部空格
+ (NSString *)removeWhiteSpaceCharactersAtEnd:(NSString *)string;
//去除头部空格
+ (NSString *)removeWhiteSpaceCharactersAtBeginning:(NSString *)string;
//获取字符串自适应宽高
+ (CGFloat)caculateWidth:(NSString *)text size:(UIFont *)font height:(CGFloat)height;
+ (CGFloat)caculateHeight:(NSString *)text size:(UIFont *)font width:(CGFloat)width;
//画线
+ (UIImageView *)drawLineImage:(CGRect)rect isHorizontal:(BOOL)isHorizontal lineWidth:(CGFloat)width red:(float)red green:(float)green blue:(float)blue;
//图片颜色
+(UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
//截取视频第一帧
+ (UIImage *)getFirstImageFromVideoToLocal:(NSString *)localVideoName width:(CGFloat)width height:(CGFloat)height;
@end
