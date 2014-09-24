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

- (NSString *)getScoreDirPath;
- (NSString *)getScorePathWithFileName:(NSString *)fileName;
- (NSMutableArray *)getScoreInfos;
- (BOOL)loadSongWithSequences:(NSMutableDictionary **)sequences
                       header:(CMBSongHeaderData **)header
                     fileName:(NSString *)fileName;
- (BOOL)saveSongWithSequences:(NSMutableDictionary *)sequences
                       header:(CMBSongHeaderData *)header
                     fileName:(NSString *)fileName;

@end
