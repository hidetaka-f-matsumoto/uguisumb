//
//  NSString+CMBTools.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "NSString+CMBTools.h"
#import "CMBNoteData.h"
#import "CMBSequenceOneData.h"

@implementation NSString (CMBTools)

+ (NSString *)stringABCWithSequence:(NSArray *)sequences
{
    NSMutableString *abc = [NSMutableString string];
    for (CMBSequenceOneData *seqOneData in sequences) {
        NSMutableString *abcOne = [NSMutableString string];
        BOOL isChord = 1 < seqOneData.notes.count;
        for (CMBNoteData *noteData in seqOneData.notes) {
            [abcOne appendString:[noteData abcString]];
        }
        if (isChord) {
            [abc appendString:@"["];
        }
        [abc appendString:abcOne];
        if (isChord) {
            [abc appendString:@"]"];
        }
    }
    return abc;
}

- (NSInteger)countWithChar:(NSString *)target
{
    unichar c_target = [target characterAtIndex:0];
    NSInteger count = 0;
    for (NSInteger i=0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c_target == c) {
            count++;
        }
    }
    return count;
}

- (NSInteger)countWithString:(NSString *)target
{
    NSError *error = nil;
    NSString* pattern = target;
    NSRegularExpression* regexp =
    [NSRegularExpression regularExpressionWithPattern:pattern
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    if (error) {
        return 0;
    }
    NSTextCheckingResult *match = [regexp firstMatchInString:self
                                                     options:0
                                                       range:NSMakeRange(0, self.length)];
    return match.numberOfRanges;
}

@end
