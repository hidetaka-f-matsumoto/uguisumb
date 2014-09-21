//
//  CMBNoteData.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CMBNoteInfoKeyChange = @"note_change";
static NSString * const CMBNoteInfoKeyScale = @"note_scale";
static NSString * const CMBNoteInfoKeyOctave = @"note_octave";
static NSString * const CMBNoteInfoKeyValue = @"note_value";

#define CMBScales @[@"C", @"^C", @"D", @"^D", @"E", @"F", @"^F", @"G", @"^G", @"A", @"^A", @"B"]
static NSString * const CMBSharpPrefix = @"^";
static NSString * const CMBFlatPrefix = @"_";
static NSString * const CMBOctaveUpSuffix = @"'";
static NSString * const CMBOctaveDownSuffix = @",";

/**
 * 1音符データ
 */
@interface CMBNoteData : NSObject

@property (nonatomic, strong) NSString *scale;
@property (nonatomic, strong) NSNumber *octave;

- (id)initWithABCParts:(NSDictionary *)parts;
- (id)initWithABCString:(NSString *)abc;
- (id)initWithInfo:(NSDictionary *)info;

@end
