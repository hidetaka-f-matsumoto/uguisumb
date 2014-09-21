//
//  CMBSequenceOneData.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSequenceOneData.h"

@interface CMBSequenceOneData ()

@end

@implementation CMBSequenceOneData

+ (CMBSequenceOneData *)sequenceOneData
{
    return [[CMBSequenceOneData alloc] init];
}

+ (CMBSequenceOneData *)sequenceOneDataWithNoteData:(CMBNoteData *)noteData
{
    CMBSequenceOneData *data = [CMBSequenceOneData alloc];
    return [data initWithNoteData:noteData];
}

+ (CMBSequenceOneData *)sequenceOneDataWithNoteDatas:(NSArray *)noteDatas
{
    CMBSequenceOneData *data = [CMBSequenceOneData alloc];
    return [data initWithNoteDatas:noteDatas];
}

- (id)init
{
    self = [super init];
    if (self) {
        _notes = [NSMutableArray array];
    }
    return self;
}

- (id)initWithNoteData:(CMBNoteData *)noteData
{
    self = [super init];
    if (self) {
        _notes = [NSMutableArray arrayWithObject:noteData];
    }
    return self;
}

- (id)initWithNoteDatas:(NSArray *)noteDatas
{
    self = [super init];
    if (self) {
        _notes = [NSMutableArray arrayWithArray:noteDatas];
    }
    return self;
}

- (void)addNoteData:(CMBNoteData *)noteData
{
    if ([_notes containsObject:noteData]) {
        return;
    }
    [_notes addObject:noteData];
}

- (void)removeNoteData:(CMBNoteData *)noteData
{
    [_notes removeObject:noteData];
}

@end
