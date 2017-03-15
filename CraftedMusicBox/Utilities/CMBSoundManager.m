//
//  CMBSoundManager.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/06.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSoundManager.h"
#import "EPSSampler.h"
#import "CMBUtility.h"
#import "CMBNoteData.h"

@interface CMBSoundManager ()
{
    EPSSampler *_sampler;
}

@end

@implementation CMBSoundManager

static CMBSoundManager *_instance = nil;

- (void)_init
{
    if (!_instrument) {
        _instrument = CMBSoundDefault;
    }
    @try {
#if 1 == AU_SAMPLER
        NSURL *presetURL = [[NSBundle mainBundle] URLForResource:_instrument withExtension:@"aupreset"];
        _sampler = [[EPSSampler alloc] initWithPresetURL:presetURL];
#else // 1 == AU_SAMPLER
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
#if 1 == AUDIO_PLAYER
                    AVAudioPlayer *sound= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                    soundsInOct[CMBScales[scl]] = sound;
                    // 再生準備。バッファに読み込んでおく
                    [sound prepareToPlay];
                    sound.volume = 0.7f;
#elif 1 == SYSTEM_SOUND
                    SystemSoundID sound;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
                    soundsInOct[CMBScales[scl]] = [NSNumber numberWithLong:sound];
#endif
                }
                _sounds[inst][[NSNumber numberWithInteger:oct]] = soundsInOct;
            }
        }
#endif
        [self _initEq];
        _isAvailable = YES;
    }
    @catch (NSException *ex) {
        _isAvailable = NO;
    }
}

- (void)_initEq
{
    _eq = [NSMutableDictionary dictionary];
    CGFloat vol;
    // オクターブでループ
    for (NSInteger oct=CMBOctaveMin; oct<=CMBOctaveMax; oct++) {
        NSInteger octHigh = oct - CMBOctaveBase - 1;
        // スケールでループ
        for (NSString *scl in CMBScales) {
            NSInteger sclIdx = [CMBUtility indexWithScale:scl];
            // 中低域
            if (0 > octHigh) {
                vol = 1.f;
            }
            // 高域。うるさいので抑え気味にする
            else {
                vol = 1.f - powf(sclIdx + octHigh * CMBScaleNum, 1.8f) * 0.001f;
            }
            _eq[[NSString stringWithFormat:@"%zd%@", oct, scl]] = [NSNumber numberWithFloat:vol];
        }
    }
    DPRINT(@"init EQ: %@", _eq);
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
 * Instrument setter
 */
- (void)setInstrument:(NSString *)instrument
{
    if (_instrument == instrument) {
        return;
    }
    _instrument = instrument;
    [self _init];
}

/**
 * MIDI note number
 */
+ (UInt32)midiScaleWithScale:(NSString *)scale
                      octave:(NSNumber *)octave
{
    NSInteger scaleIdx = [CMBUtility indexWithScale:scale];
    NSInteger octaveDiff = octave.integerValue - CMBOctaveBase;
    return (UInt32)(MIDINoteNumber_C4 + scaleIdx + 12 * octaveDiff);
}

/**
 * EQ
 */
+ (CGFloat)eqWithScale:(NSString *)scale
                octave:(NSNumber *)octave
{
    NSDictionary *eq = [[self class] sharedInstance].eq;
    NSNumber *volume = eq[[NSString stringWithFormat:@"%zd%@", octave.integerValue, scale]];
    return volume.floatValue;
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
    CGFloat eq = [[self class] eqWithScale:scale octave:octave];
    // 再生
#if 1 == AU_SAMPLER
    UInt32 note = [[self class] midiScaleWithScale:scale octave:octave];
    [_sampler startPlayingNote:note withVelocity:(0.7f * eq)];
#elif 1 == AUDIO_PLAYER
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
#elif 1 == SYSTEM_SOUND
    SystemSoundID sound = [_sounds[instrument][octave][scale] unsignedIntValue];
    if (sound) {
        AudioServicesPlaySystemSound(sound);
    }
#endif
}

@end
