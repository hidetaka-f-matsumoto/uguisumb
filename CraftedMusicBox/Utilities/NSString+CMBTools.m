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

+ (NSString *)jsonWithDictionary:(NSDictionary *)dic
                          pretty:(BOOL)isPretty
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:(NSJSONWritingOptions)(isPretty ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)abcWithSequences:(NSDictionary *)sequences
{
    NSMutableDictionary *abcDic = [NSMutableDictionary dictionary];
    for (NSNumber *time in sequences) {
        CMBSequenceOneData *seqOneData = sequences[time];
        if (!seqOneData) {
            continue;
        }
        NSString *timeStr = time.stringValue;
        id abcOne;
        // 和音
        if (1 < seqOneData.notes.count) {
            NSMutableArray *abcArr = [NSMutableArray array];
            for (CMBNoteData *noteData in seqOneData.notes) {
                [abcArr addObject:[noteData abcString]];
            }
            abcOne = abcArr;
        }
        // 単音
        else if (1 == seqOneData.notes.count) {
            abcOne = [seqOneData.notes[0] abcString];
        }
        [abcDic setObject:abcOne forKey:timeStr];
    }
    return [NSString jsonWithDictionary:abcDic pretty:NO];
}

- (NSNumber *)getNumberValue
{
    return [NSNumber numberWithInteger:self.integerValue];
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
