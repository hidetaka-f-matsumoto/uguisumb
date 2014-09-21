//
//  CMBUtility.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBUtility.h"
#import "NSString+CMBTools.h"

@implementation CMBUtility

static CMBUtility *_instance = nil;

- (id)init
{
    self = [super init];
    if (!self) {
    }
    return self;
}

+ (CMBUtility *)sharedInstance
{
    if (!_instance) {
        _instance = [CMBUtility new];
    }
    return _instance;
}

+ (NSArray *)noteInfosWithABCString:(NSString *)abc
{
    NSError *error = nil;
    NSString* pattern = @"([\\_\\^]*)([CDEFGAB])([,']*)([0-9/]*)";
    NSRegularExpression* regexp =
    [NSRegularExpression regularExpressionWithPattern:pattern
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    if (error) {
        return nil;
    }
    NSMutableArray *info = [NSMutableArray array];
    id block = ^(NSTextCheckingResult *match, NSMatchingFlags flag, BOOL *stop){
        [info addObject:@{
                          CMBNoteInfoKeyChange : [abc substringWithRange:[match rangeAtIndex:1]],
                          CMBNoteInfoKeyScale : [abc substringWithRange:[match rangeAtIndex:2]],
                          CMBNoteInfoKeyOctave : [abc substringWithRange:[match rangeAtIndex:3]],
                          CMBNoteInfoKeyValue : [abc substringWithRange:[match rangeAtIndex:4]]
                          }
         ];
    };
    [regexp enumerateMatchesInString:abc options:0 range:NSMakeRange(0, abc.length) usingBlock:block];
    return info;
//    NSTextCheckingResult *match = [regexp firstMatchInString:abc
//                                                    options:0
//                                                      range:NSMakeRange(0, abc.length)];
//    return @[
//             [abc substringWithRange:[match rangeAtIndex:1]],
//             [abc substringWithRange:[match rangeAtIndex:2]],
//             [abc substringWithRange:[match rangeAtIndex:3]],
//             [abc substringWithRange:[match rangeAtIndex:4]]
//             ];
}

- (BOOL)saveScoreWithSequences:(NSArray *)sequences
                      fileName:(NSString *)fileName
{
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // ホームディレクトリ直下にあるDocumentsフォルダを取得する
        NSArray *fileDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES);
        // 楽譜ディレクトリ
        NSString *fileDir = [fileDirs[0] stringByAppendingPathComponent:@"scores/"];
        // 存在しない場合は作成
        if (![fileManager fileExistsAtPath:fileDir]) {
            NSError *error = nil;
            BOOL created = [fileManager createDirectoryAtPath:fileDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
            if (!created) {
                NSLog(@"failed to create directory. reason is %@ - %@", error, error.userInfo);
                return NO;
            }
        }
        // 楽譜ファイル
        NSString *filePath = [fileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.abc", fileName]];
        // ABC文字列に変換
        NSString *abc = [NSString stringABCWithSequence:sequences];
        //ファイルを作成する
        [abc writeToFile:filePath atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
    }
    @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

@end
