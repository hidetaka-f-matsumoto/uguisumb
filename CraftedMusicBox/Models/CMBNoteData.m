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
        _octave = @0;
        if (parts) {
            NSInteger sharp = 0;
            sharp += [parts[CMBNoteInfoKeyChange] countWithChar:CMBSharpPrefix];
            sharp -= [parts[CMBNoteInfoKeyChange] countWithChar:CMBFlatPrefix];
            _scale = parts[CMBNoteInfoKeyScale];
            NSInteger octave = [parts[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveUpSuffix] - [parts[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveDownSuffix];
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
        _octave = @0;
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
    NSString *octaveStr = @"";
    for (NSInteger i=0; i<abs(octaveCnt); i++) {
        [octaveStr stringByAppendingString:octaveSuffix];
    }
    return [NSString stringWithFormat:@"%@%@", _scale, octaveStr];
}

@end
