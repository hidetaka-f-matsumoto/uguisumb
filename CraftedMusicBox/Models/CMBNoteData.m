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

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _scale = @0;
        _octave = @0;
        if (info) {
            NSInteger sharp = 0;
            sharp += [info[CMBNoteInfoKeyChange] countWithChar:CMBSharpPrefix];
            sharp -= [info[CMBNoteInfoKeyChange] countWithChar:CMBFlatPrefix];
            NSInteger scale = [CMBScales indexOfObject:info[CMBNoteInfoKeyScale]];
            if (NSNotFound != scale) {
                _scale = [NSNumber numberWithInteger:(scale + sharp)];
            }
            NSInteger octave = [info[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveUpSuffix] - [info[CMBNoteInfoKeyOctave] countWithChar:CMBOctaveDownSuffix];
            _octave = [NSNumber numberWithInteger:octave];
        }
    }
    return self;
}

- (id)initWithABCString:(NSString *)abc
{
    self = [super init];
    if (self) {
        _scale = @0;
        _octave = @0;
        if (abc) {
            NSArray *infos = [CMBUtility noteInfosWithABCString:abc];
            self = [self initWithInfo:infos[0]];
        }
    }
    return self;
}

@end
