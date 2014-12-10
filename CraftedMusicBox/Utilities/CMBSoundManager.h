//
//  CMBSoundManager.h
//  CraftedMusicBox
//
//  Created by hide on 2014/10/06.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CMBNoteData.h"

#define AU_SAMPLER      1
#define AUDIO_PLAYER    0
#define SYSTEM_SOUND    0

static UInt32 const MIDINoteNumber_C4 = 60;

@interface CMBSoundManager : NSObject

@property (nonatomic, readonly) NSMutableDictionary *sounds;
@property (nonatomic, readonly) BOOL isAvailable;

+ (CMBSoundManager *)sharedInstance;
+ (UInt32)midiScaleWithScale:(NSString *)scale
                      octave:(NSNumber *)octave;
- (void)playWithInstrument:(NSString *)instrument
                     scale:(NSString *)scale
                    octave:(NSNumber *)octave;

@end
