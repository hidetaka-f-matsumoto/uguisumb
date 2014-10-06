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

@interface CMBSoundManager : NSObject

@property (nonatomic, readonly) NSMutableDictionary *sounds;
@property (nonatomic, readonly) BOOL isAvailable;

+ (CMBSoundManager *)sharedInstance;
- (void)playWithInstrument:(NSString *)instrument
                     scale:(NSString *)scale
                    octave:(NSNumber *)octave;

@end
