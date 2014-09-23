//
//  NSString+CMBTools.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CMBTools)

@property (nonatomic, getter=getNumberValue) NSNumber *numberValue;

+ (NSString *)jsonWithDictionary:(NSDictionary *)dic
                          pretty:(BOOL)isPretty;
+ (NSString *)abcWithSequences:(NSDictionary *)sequences;

- (NSInteger)countWithChar:(NSString *)target;
- (NSInteger)countWithString:(NSString *)target;

@end
