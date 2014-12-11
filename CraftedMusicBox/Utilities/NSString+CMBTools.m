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

+ (NSString *)songJsonWithSequences:(NSDictionary *)sequences
                             header:(CMBSongHeaderData *)header
{
    if (!sequences || !header) {
        return nil;
    }
    NSMutableDictionary *songDic = [NSMutableDictionary dictionary];
    // ヘッダ
    [songDic setObject:[header dictionary] forKey:@"header"];
    // シーケンス
    NSMutableDictionary *seqDic = [NSMutableDictionary dictionary];
    for (NSNumber *time in sequences) {
        CMBSequenceOneData *seqOneData = sequences[time];
        if (!seqOneData || !seqOneData.notes || 0 >= seqOneData.notes.count) {
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
        [seqDic setObject:abcOne forKey:timeStr];
    }
    [songDic setObject:seqDic forKey:@"sequences"];
    return [NSString jsonWithDictionary:songDic pretty:NO];
}

- (BOOL)sequences:(NSMutableDictionary **)sequences
           header:(CMBSongHeaderData **)header;
{
    NSError *error;
    NSDictionary *songDic =
    [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                    options:NSJSONReadingMutableContainers
                                      error:&error];
    if (error) {
        return NO;
    }
    // ヘッダ作成
    *header = [[CMBSongHeaderData alloc] initWithInfo:songDic[@"header"]];
    // シーケンス作成
    *sequences = [NSMutableDictionary dictionary];
    NSDictionary *seqDic = songDic[@"sequences"];
    for (NSString *timeStr in seqDic) {
        id abcOne = seqDic[timeStr];
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
        [*sequences setObject:sequence forKey:time];
    }
    return YES;
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

- (NSString *)urlEncode
{
    //encoding
//    NSString *escapedUrlString =
//    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
//                                                        NULL,
//                                                        (CFStringRef)self,
//                                                        NULL,
//                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                        kCFStringEncodingUTF8
//                                                        ));
    NSString* escapedUrlString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    return escapedUrlString;
}

- (NSString *)urlDecode
{
    //decoding
//    NSString *decodedUrlString =
//    (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
//                                                                        NULL,
//                                                                        (CFStringRef)self,
//                                                                        CFSTR(""),
//                                                                        kCFStringEncodingUTF8
//                                                                        ));
    NSString* decodedUrlString = [self stringByRemovingPercentEncoding];
    return decodedUrlString;
}

+ (NSString *)songJsonWithEncodedSongStr:(NSString *)encodedStr
{
    // Base64デコード
    NSData *songData = [[NSData alloc] initWithBase64EncodedString:encodedStr options:kNilOptions];
    NSString *songJson = [[NSString alloc] initWithData:songData encoding:NSUTF8StringEncoding];
    return songJson;
}

- (NSString *)getEncodedSongStr
{
    // Base64エンコード
    NSData *songData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *songStr = [songData base64EncodedStringWithOptions:kNilOptions];
    return songStr;
}

@end
