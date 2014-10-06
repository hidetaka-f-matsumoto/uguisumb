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
#import "UIColor+CMBTools.h"
#import "NSURL+CMBTools.h"
#import "CMBMusicBoxViewController.h"

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

+ (UIColor *)tintColor
{
    UIColor *color = [UIApplication sharedApplication].keyWindow.tintColor;
    if (!color) {
        color = [UIColor colorWithRed:1.f green:0.f blue:0.278431f alpha:1.f];
    }
    return color;
}

+ (UIColor *)tintColorAlpha50
{
    return [UIColor colorWithRed:1.f green:0.f blue:0.278431f alpha:0.5f];
}

+ (UIColor *)tintColorAlpha25
{
    return [UIColor colorWithRed:1.f green:0.f blue:0.278431f alpha:0.25f];
}

+ (UIColor *)whiteColorAlpha25
{
    return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.25f];
}

+ (UIColor *)yellowColorAlpha25
{
    return [UIColor colorWithRed:1.f green:1.f blue:0.5f alpha:0.25f];
}

+ (UIColor *)redColorAlpha25
{
    return [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.25f];
}

+ (UIColor *)greenColorAlpha25
{
    return [UIColor colorWithRed:0.f green:1.f blue:0.f alpha:0.25f];
}

+ (UIColor *)blueColorAlpha25
{
    return [UIColor colorWithRed:0.f green:0.f blue:1.f alpha:0.25f];
}

/**
 * Songディレクトリパス取得
 */
- (NSString *)getSongDirPath
{
    NSString *path = nil;
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // ホームディレクトリ直下にあるDocumentsフォルダを取得する
        NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask,
                                                              YES);
        // Songディレクトリ
        path = [pathes[0] stringByAppendingPathComponent:@"songs/"];
        // 存在しない場合は作成
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error = nil;
            BOOL created = [fileManager createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
            if (!created) {
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

/**
 * Songファイルパス取得
 */
- (NSString *)getSongPathWithFileName:(NSString *)fileName
{
    NSString *path = [self getSongDirPath];
    if (!path) {
        return nil;
    }
    // Songファイル
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.song", fileName]];
}

/**
 * Song情報一覧を取得
 * @return List<Dictionary *>
 *  name: Song名
 *  path: パス
 */
- (NSMutableArray *)getSongInfos
{
    // Songディレクトリ
    NSString *dir = [self getSongDirPath];
    // Song一覧を取得
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:dir
                                                     error:&error];
    if (error) {
        return nil;
    }
    // Song情報
    NSMutableArray *infos = [NSMutableArray array];
    for (NSString *file in files) {
        if (![file hasSuffix:@".song"]) {
            continue;
        }
        NSString *name = [file stringByDeletingPathExtension];
        NSString *path = [dir stringByAppendingString:file];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              name, @"name",
                              path, @"path",
                              nil];
        [infos addObject:info];
    }
    return infos;
}

- (BOOL)loadSongWithSequences:(NSMutableDictionary **)sequences
                       header:(CMBSongHeaderData **)header
                     fileName:(NSString *)fileName
{
    // Songファイルパス
    NSString *path = [self getSongPathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    // ファイルを読む
    NSError *error;
    NSString *songJson = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
    if (error) {
        return NO;
    }
    BOOL isParseOK = [songJson sequences:sequences
                                  header:header];
    if (!isParseOK) {
        return NO;
    }
    return YES;
}

- (BOOL)saveSongWithSequences:(NSMutableDictionary *)sequences
                       header:(CMBSongHeaderData *)header
                     fileName:(NSString *)fileName
{
    // Songファイルパス
    NSString *path = [self getSongPathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:sequences
                                                  header:header];
    if (!songJson) {
        return NO;
    }
    // ファイルを作成する
    NSError *error;
    [songJson writeToFile:path
               atomically:NO
                 encoding:NSUTF8StringEncoding
                    error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteSongWithFileName:(NSString *)fileName
{
    // Songファイルパス
    NSString *path = [self getSongPathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    // ファイルを削除する
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:path
                            error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

- (void)openURL:(NSURL *)url
{
    NSString *controller = [url host];
    NSString *action = [url lastPathComponent];
    NSDictionary *params = [url queryDictionary];
    // オルゴール画面
    if ([controller isEqualToString:@"mb"]) {
        // song読み込み
        if ([action isEqualToString:@"load"]) {
            // デコード
            NSString *songEncoded = params[@"song"];
            NSString *songJson = [NSString songJsonWithEncodedSongStr:songEncoded];
            // song文字列をパース
            NSMutableDictionary *sequences = [NSMutableDictionary dictionary];
            CMBSongHeaderData *header = [[CMBSongHeaderData alloc] init];
            BOOL isParseOK = [songJson sequences:&sequences
                                         header:&header];
            // user情報
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            // パース成功
            if (isParseOK) {
                [info setObject:sequences forKey:@"sequences"];
                [info setObject:header forKey:@"header"];
            }
            // パース失敗
            else {
                [info setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Open URL", @"title",
                                 @"Fail to load the song.", @"message",
                                 nil]
                         forKey:@"error"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:CMBCmdURLSchemeOpenMusicBox
                                                                object:nil
                                                              userInfo:info];
        }
    }
}

@end
