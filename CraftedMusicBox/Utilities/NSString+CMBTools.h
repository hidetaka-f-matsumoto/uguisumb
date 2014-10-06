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
@property (nonatomic, readonly, getter=getEncodedSongStr) NSString *encodedSongStr;

+ (NSString *)jsonWithDictionary:(NSDictionary *)dic
                          pretty:(BOOL)isPretty;
+ (NSString *)songJsonWithSequences:(NSDictionary *)sequences
                             header:(CMBSongHeaderData *)header;
+ (NSString *)songJsonWithEncodedSongStr:(NSString *)encodedStr;
- (BOOL)sequences:(NSMutableDictionary **)sequences
           header:(CMBSongHeaderData **)header;
- (NSInteger)countWithChar:(NSString *)target;
- (NSInteger)countWithString:(NSString *)target;
- (NSString *)urlEncode;
- (NSString *)urlDecode;

@end
