//
//  CMBUtility.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBUtility.h"
#import "NSString+CMBTools.h"
#import "NSMutableDictionary+CMBTools.h"

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

- (NSString *)getScoreDirPath
{
    NSString *path = nil;
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // ホームディレクトリ直下にあるDocumentsフォルダを取得する
        NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
        // 楽譜ディレクトリ
        path = [pathes[0] stringByAppendingPathComponent:@"scores/"];
        // 存在しない場合は作成
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error = nil;
            BOOL created = [fileManager createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
            if (!created) {
                NSLog(@"failed to create directory. reason is %@ - %@", error, error.userInfo);
                path = nil;
            }
        }
    }
    @catch (NSException *exception) {
        path = nil;
    }
    @finally {
        return path;
    }
}

- (NSString *)getScorePathWithFileName:(NSString *)fileName
{
    NSString *path = [self getScoreDirPath];
    if (!path) {
        return nil;
    }
    // 楽譜ファイル
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.abc", fileName]];
}

/**
 * 楽譜情報一覧を取得
 * @return List<Dictionary *>
 *  name: 楽譜名
 *  path: パス
 */
- (NSMutableArray *)getScoreInfos
{
    // 楽譜ディレクトリ
    NSString *dir = [self getScoreDirPath];
    // 楽譜一覧を取得
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:dir
                                                     error:&error];
    if (error) {
        return nil;
    }
    // 楽譜情報
    NSMutableArray *infos = [NSMutableArray array];
    for (NSString *file in files) {
        NSString *name = [file stringByReplacingOccurrencesOfString:@".abc" withString:@""];
        NSString *path = [dir stringByAppendingString:file];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              path, @"path",
                              nil];
        [infos addObject:info];
    }
    return infos;
}

- (BOOL)loadScoreWithSequences:(NSMutableDictionary **)sequences
                      fileName:(NSString *)fileName
{
    // 楽譜ファイルパス
    NSString *path = [self getScorePathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    NSError *error = nil;
    NSString *abc = [[NSString alloc] initWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    if (error) {
        return NO;
    }
    *sequences = [NSMutableDictionary sequencesWithABC:abc];
    if (!sequences) {
        return NO;
    }
    return YES;
}

- (BOOL)saveScoreWithSequences:(NSMutableDictionary *)sequences
                      fileName:(NSString *)fileName
{
    // 楽譜ファイルパス
    NSString *path = [self getScorePathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    // ABC文字列に変換
    NSString *abc = [NSString abcWithSequences:sequences];
    if (!abc) {
        return NO;
    }
    //ファイルを作成する
    NSError *error = nil;
    [abc writeToFile:path
          atomically:NO
            encoding:NSUTF8StringEncoding
               error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

@end
