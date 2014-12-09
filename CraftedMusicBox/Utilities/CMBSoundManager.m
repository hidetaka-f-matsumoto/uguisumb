//
//  CMBSoundManager.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/06.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSoundManager.h"

@implementation CMBSoundManager

static CMBSoundManager *_instance = nil;

- (void)_init
{
    @try {
        const NSDictionary *CMBSoundResources = @{
                                                  CMBSoundMusicbox : @{
                                                          @3 : CMBSoundResMusicboxOct3,
                                                          @4 : CMBSoundResMusicboxOct4,
                                                          @5 : CMBSoundResMusicboxOct5,
                                                          },
                                                  CMBSoundXylophone : @{
                                                          @3 : CMBSoundResXylophoneOct3,
                                                          @4 : CMBSoundResXylophoneOct4,
                                                          @5 : CMBSoundResXylophoneOct5,
                                                          },
                                                  };
        _sounds = [NSMutableDictionary dictionary];
        NSURL *url;
        NSBundle *mb = [NSBundle mainBundle];
        // 楽器ごとにループ
        for (NSString *inst in CMBSoundResources) {
            _sounds[inst] = [NSMutableDictionary dictionary];
            // オクターブでループ
            for (NSInteger oct=CMBOctaveMin; oct<=CMBOctaveMax; oct++) {
                NSMutableDictionary *soundsInOct = [NSMutableDictionary dictionary];
                // スケールでループ
                for (NSInteger scl=0; scl<CMBScales.count; scl++) {
                    // リソースを登録
                    NSString *resName = CMBSoundResources[inst][[NSNumber numberWithInteger:oct]][scl];
                    NSString *resPath = [mb pathForResource:resName ofType:@"caf"];
                    if (!resPath) {
                        continue;
                    }
                    url = [NSURL fileURLWithPath:resPath];
#if AUDIO_PLAYER
                    AVAudioPlayer *sound= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    soundsInOct[CMBScales[scl]] = sound;
                    // 再生準備。バッファに読み込んでおく
                    [sound prepareToPlay];
                    sound.volume = 0.5f;
#else // AUDIO_PLAYER
                    SystemSoundID sound;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
                    soundsInOct[CMBScales[scl]] = [NSNumber numberWithLong:sound];
#endif // AUDIO_PLAYER
                }
                _sounds[inst][[NSNumber numberWithInteger:oct]] = soundsInOct;
            }
        }
        _isAvailable = YES;
    }
    @catch (NSException *ex) {
        _isAvailable = NO;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

+ (CMBSoundManager *)sharedInstance
{
    if (!_instance) {
        _instance = [CMBSoundManager new];
    }
    return _instance;
}

/**
 * 1音再生
 */
- (void)playWithInstrument:(NSString *)instrument
                     scale:(NSString *)scale
                    octave:(NSNumber *)octave
{
    if (!_isAvailable) {
        return;
    }
    // 再生
#if AUDIO_PLAYER
    AVAudioPlayer *sound = _sounds[instrument][octave][scale];
    if (sound) {
        // サブスレッドで非同期に実行 (カクつき対策)
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^() {
            if ([sound isPlaying]) {
                [sound stop];
                sound.currentTime = 0;
            }
            [sound play];
        });
    }
#else // AUDIO_PLAYER
    SystemSoundID sound = [_sounds[instrument][octave][scale] unsignedIntValue];
    if (sound) {
        AudioServicesPlaySystemSound(sound);
    }
#endif // AUDIO_PLAYER
}

@end
