//
//  NaviSpeechHelp.h
//  AutoNaviSample
//
//  Created by joker on 2017/3/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NaviSpeechHelp : NSObject
+ (instancetype)sharedNaviSpeechHelp;
- (void)speakString:(NSString *)string;
- (void)stopSpeak;
@end
