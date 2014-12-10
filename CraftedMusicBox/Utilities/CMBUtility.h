//
//  CMBUtility.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBNoteData.h"
#import "CMBSequenceOneData.h"
#import "CMBSongHeaderData.h"

@interface CMBUtility : NSObject

+ (CMBUtility *)sharedInstance;
+ (NSArray *)noteInfosWithABCString:(NSString *)abc;

+ (UIColor *)tintColor;
+ (UIColor *)tintColorAlpha50;
+ (UIColor *)tintColorAlpha25;
+ (UIColor *)brownColor;
+ (UIColor *)lightBrownColor;
+ (UIColor *)greenColor;
+ (UIColor *)lightGreenColor;
+ (UIColor *)redColor;
+ (UIColor *)orangeColor;
+ (UIColor *)yellowColor;
+ (UIColor *)whiteColor;

+ (UIFont *)fontForButton;
+ (UIFont *)fontForLabel;

+ (NSString *)scaleWithIndex:(NSInteger)index;
+ (NSInteger)indexWithScale:(NSString *)scale;

- (NSString *)getSongDirPath;
- (NSString *)getSongPathWithFileName:(NSString *)fileName;
- (NSMutableArray *)getSongInfos;
- (BOOL)loadSongWithSequences:(NSMutableDictionary **)sequences
                       header:(CMBSongHeaderData **)header
                     fileName:(NSString *)fileName;
- (BOOL)saveSongWithSequences:(NSMutableDictionary *)sequences
                       header:(CMBSongHeaderData *)header
                     fileName:(NSString *)fileName;
- (BOOL)deleteSongWithFileName:(NSString *)fileName;
- (BOOL)isExistSongWithFileName:(NSString *)fileName;
- (void)openURL:(NSURL *)url;

@end
