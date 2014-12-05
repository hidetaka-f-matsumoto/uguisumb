//
//  CMBNoteData.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBNoteData.h"
#import "CMBUtility.h"
#import "NSString+CMBTools.h"

@implementation CMBNoteData

- (NSString *)description {
    return [NSString stringWithFormat: @"CMBNoteData: scale=%@ octave=%@", _scale, _octave];
}

- (id)initWithABCParts:(NSDictionary *)parts
{
    self = [super init];
    if (self) {
        _scale = @"C";
        _octave = [NSNumber numberWithInteger:CMBOctaveBase];
        if (parts) {
            NSInteger sharp = 0;
            sharp += [parts[CMBNoteInfoKeyChange] countWithChar:CMBSharpPrefix];
            sharp -= [parts[CMBNoteInfoKeyChange] countWithChar:CMBFlatPrefix];
            NSInteger scale = [CMBUtility indexWithScale:parts[CMBNoteInfoKeyScale]] + sharp;
            NSInteger octave = scale / (NSInteger)CMBScales.count;
            scale %= (NSInteger)CMBScales.count;
            if (0 > scale) {
                octave--;
                scale += (NSInteger)CMBScales.count;
            }
            octave += CMBOctaveBase + [parts[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveUpSuffix] - [parts[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveDownSuffix];
            _scale = [CMBUtility scaleWithIndex:scale];
            _octave = [NSNumber numberWithInteger:octave];
        }
    }
    return self;
}

- (id)initWithABCString:(NSString *)abc
{
    self = [super init];
    if (self) {
        _scale = @"C";
        _octave = [NSNumber numberWithInteger:CMBOctaveBase];
        if (abc) {
            NSArray *partss = [CMBUtility noteInfosWithABCString:abc];
            self = [self initWithABCParts:partss[0]];
        }
    }
    return self;
}

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _scale = info[CMBNoteInfoKeyScale];
        _octave = info[CMBNoteInfoKeyOctave];
    }
    return self;
}

- (NSString *)abcString
{
    // オクターブ
    NSInteger octaveCnt = _octave.integerValue - CMBOctaveBase;
    NSString *octaveSuffix = octaveCnt > 0 ? CMBOctaveUpSuffix : CMBOctaveDownSuffix;
    NSMutableString *octaveStr = [NSMutableString string];
    for (NSInteger i=0; i<abs((int)octaveCnt); i++) {
        [octaveStr appendString:octaveSuffix];
    }
    return [NSString stringWithFormat:@"%@%@", _scale, octaveStr];
}

- (BOOL)isEqualToNote:(CMBNoteData *)noteData
{
    return [_scale isEqualToString:noteData.scale]
        && [_octave isEqualToNumber:noteData.octave];
}

@end
