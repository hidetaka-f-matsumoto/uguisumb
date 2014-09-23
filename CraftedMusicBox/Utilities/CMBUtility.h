//
//  CMBUtility.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBNoteData.h"

@interface CMBUtility : NSObject

+ (CMBUtility *)sharedInstance;
+ (NSArray *)noteInfosWithABCString:(NSString *)abc;

- (NSMutableArray *)getScoreInfos;
- (BOOL)loadScoreWithSequences:(NSMutableDictionary **)sequences
                      fileName:(NSString *)fileName;
- (BOOL)saveScoreWithSequences:(NSMutableDictionary *)sequences
                      fileName:(NSString *)fileName;

@end
