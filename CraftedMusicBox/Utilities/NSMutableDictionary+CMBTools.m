//
//  NSMutableDictionary+CMBTools.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "NSMutableDictionary+CMBTools.h"
#import "NSString+CMBTools.h"
#import "CMBSequenceOneData.h"
#import "CMBNoteData.h"

@implementation NSMutableDictionary (CMBTools)

+ (NSMutableDictionary *)sequencesWithABC:(NSString *)abc
{
    NSError *error;
    NSDictionary *abcDic =
    [NSJSONSerialization JSONObjectWithData:[abc dataUsingEncoding:NSUTF8StringEncoding]
                                    options:NSJSONReadingMutableContainers
                                      error:&error];
    if (error) {
        return nil;
    }
    NSMutableDictionary *sequences = [NSMutableDictionary dictionary];
    for (NSString *timeStr in abcDic) {
        id abcOne = abcDic[timeStr];
        if (!abcOne) {
            continue;
        }
        NSNumber *time = timeStr.numberValue;
        CMBSequenceOneData *sequence = [CMBSequenceOneData sequenceOneData];
        // 和音
        if ([abcOne isKindOfClass:[NSArray class]]) {
            for (NSString *abc in (NSArray *)abcOne) {
                CMBNoteData *noteData = [[CMBNoteData alloc] initWithABCString:abc];
                [sequence.notes addObject:noteData];
            }
        }
        // 単音
        else if ([abcOne isKindOfClass:[NSString class]]) {
            CMBNoteData *noteData = [[CMBNoteData alloc] initWithABCString:abcOne];
            [sequence.notes addObject:noteData];
        }
        [sequences setObject:sequence forKey:time];
    }
    return sequences;
}

@end
