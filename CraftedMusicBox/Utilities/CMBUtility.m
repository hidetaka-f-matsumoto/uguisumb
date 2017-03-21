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
    if (self) {
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
        color = [UIColor colorWithRed:0.18823529411765f green:0.29803921568627f blue:0.10980392156863f alpha:1.f];
    }
    return color;
}

+ (UIColor *)tintColorAlpha50
{
    return [[CMBUtility tintColor] changeAlpha:0.5f];
}

+ (UIColor *)tintColorAlpha25
{
    return [[CMBUtility tintColor] changeAlpha:0.25f];
}

+ (UIColor *)whiteColorAlpha25
{
    return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.25f];
}

+ (UIColor *)brownColor
{
    return [UIColor colorWithRed:0.49803921568627f green:0.3921568627451f blue:0.27450980392157f alpha:1.f];
}

+ (UIColor *)lightBrownColor
{
    return [UIColor colorWithRed:0.79607843137255f green:0.59607843137255f blue:0.33333333333333f alpha:1.f];
}

+ (UIColor *)greenColor
{
    return [UIColor colorWithRed:0.45098039215686f green:0.63529411764706f blue:0.17254901960784f alpha:1.f];
}

+ (UIColor *)lightGreenColor
{
    return [UIColor colorWithRed:0.8f green:0.91764705882353f blue:0.49803921568627f alpha:1.f];
}

+ (UIColor *)redColor
{
    return [UIColor colorWithRed:0.5922f green:0.f blue:0.0275f alpha:1.0f];
}

+ (UIColor *)orangeColor
{
    return [UIColor colorWithRed:1.f green:0.4784f blue:0.0588f alpha:1.0f];
}

+ (UIColor *)yellowColor
{
    return [UIColor colorWithRed:1.f green:0.8902f blue:0.f alpha:1.0f];
}

+ (UIColor *)whiteColor
{
    return [UIColor whiteColor];
}

+ (UIFont *)fontForButton
{
    return [UIFont fontWithName:@"SetoFont-SP" size:19.f];
}

+ (UIFont *)fontForLabel
{
    return [UIFont fontWithName:@"SetoFont-SP" size:17.f];
}

+ (NSString *)scaleWithIndex:(NSInteger)index
{
    if (0 > index || CMBScales.count <= index) {
        return nil;
    }
    NSString *a= CMBScales[index];
    return a;
}

+ (NSInteger)indexWithScale:(NSString *)scale
{
    if (!scale) {
        return -1;
    }
    return [CMBScales indexOfObject:scale];
}

+ (NSDictionary *)apiSongDataWithSequences:(NSMutableDictionary *)sequences
                                    header:(CMBSongHeaderData *)header
{
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:sequences
                                                  header:header];
    // リクエストパラメータ
    return @{@"title": header.name,
             @"composer": header.composer,
             @"json_enc": songJson.encodedSongStr};
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
        // ファイル名無しの場合をケア
        if ([name isEqualToString:@".song"]) {
            name = @"";
        }
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

- (BOOL)isExistSongWithFileName:(NSString *)fileName
{
    // Songファイルパス
    NSString *path = [self getSongPathWithFileName:fileName];
    if (!path) {
        return NO;
    }
    // ファイルの存在チェック
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

- (void)openURL:(NSURL *)url
{
    NSString *controller = [url host];
    NSString *action = [url lastPathComponent];
    NSDictionary *params = [url queryDictionary];
    // オルゴール画面
    if ([controller isEqualToString:CMBURLControllerMusicBox]) {
        // song読み込み
        if ([action isEqualToString:CMBURLActionLoadSong]) {
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
                                 NSLocalizedString(@"Open URL", @"Open URL."), @"title",
                                 NSLocalizedString(@"Failed to load the song.", @"Error message when you failed to load the song from URL."), @"message",
                                 nil]
                         forKey:@"error"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:CMBNotifyURLOpenMusicBox
                                                                object:nil
                                                              userInfo:info];
        }
    }
}

- (BOOL)checkFirstRunCurrentVersion
{
    NSString *path = nil;
    @try {
        // ホームディレクトリ直下にあるDocumentsフォルダを取得する
        NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [pathes[0] stringByAppendingPathComponent:@"run.txt"];
    }
    @catch (NSException *exception) {
        return NO;
    }
    NSError *error;
    // 最後に起動したバージョン
    NSString *lastVer = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    // 現在のバージョン
    NSString *currentVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 初回起動か判定
    BOOL isFirstRun = !lastVer || ![currentVer isEqualToString:lastVer];
    if (isFirstRun) {
        // 起動バージョンを更新
        [currentVer writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
    }
    return isFirstRun;
}

@end
