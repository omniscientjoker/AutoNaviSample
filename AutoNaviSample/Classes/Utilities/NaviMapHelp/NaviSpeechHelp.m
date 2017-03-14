//
//  NaviSpeechHelp.m
//  AutoNaviSample
//
//  Created by joker on 2017/3/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "NaviSpeechHelp.h"

@interface NaviSpeechHelp () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong, readwrite) AVSpeechSynthesizer *speechSynthesizer;

@end


@implementation NaviSpeechHelp
+ (instancetype)sharedNaviSpeechHelp
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NaviSpeechHelp alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self buildNaviSpeechHelp];
    }
    return self;
}

- (void)buildNaviSpeechHelp
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        return;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [self.speechSynthesizer setDelegate:self];
}

- (void)speakString:(NSString *)string
{
    if (self.speechSynthesizer)
    {
        AVSpeechUtterance *aUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        [aUtterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"]];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            aUtterance.rate = 0.25;
        }
        else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
        {
            aUtterance.rate = 0.15;
        }
        
        if ([self.speechSynthesizer isSpeaking])
        {
            [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        }
        
        [self.speechSynthesizer speakUtterance:aUtterance];
    }
}

- (void)stopSpeak
{
    if (self.speechSynthesizer)
    {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}
@end
