//
//  NSString+CMBTools.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CMBTools)

+ (NSString *)stringABCWithSequence:(NSArray *)sequences;

- (NSInteger)countWithChar:(NSString *)target;
- (NSInteger)countWithString:(NSString *)target;

@end
