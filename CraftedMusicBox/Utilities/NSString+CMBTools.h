//
//  NSString+CMBTools.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMBSongHeaderData.h"

@interface NSString (CMBTools)

@property (nonatomic, readonly, getter=getNumberValue) NSNumber *numberValue;

+ (NSString *)jsonWithDictionary:(NSDictionary *)dic
                          pretty:(BOOL)isPretty;
+ (NSString *)songJsonWithSequences:(NSDictionary *)sequences
                             header:(CMBSongHeaderData *)header;
- (BOOL)sequences:(NSMutableDictionary **)sequences
           header:(CMBSongHeaderData **)header;
- (NSInteger)countWithChar:(NSString *)target;
- (NSInteger)countWithString:(NSString *)target;

@end
