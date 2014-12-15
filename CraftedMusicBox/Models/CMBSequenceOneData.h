//
//  CMBSequenceOneData.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBNoteData.h"

/**
 * 1シーケンスデータ
 *  List<CMBNoteData *>
 */
@interface CMBSequenceOneData : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *notes;

+ (CMBSequenceOneData *)sequenceOneData;
+ (CMBSequenceOneData *)sequenceOneDataWithNoteData:(CMBNoteData *)noteData;
+ (CMBSequenceOneData *)sequenceOneDataWithNoteDatas:(NSArray *)noteDatas;
- (id)initWithNoteData:(CMBNoteData *)noteData;
- (id)initWithNoteDatas:(NSArray *)noteDatas;
- (BOOL)isNotes;
- (BOOL)isContainNoteData:(CMBNoteData *)noteData;
- (void)addNoteData:(CMBNoteData *)noteData;
- (void)removeNoteData:(CMBNoteData *)noteData;

@end
