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

- (BOOL)saveScoreWithSequences:(NSArray *)sequences
                      fileName:(NSString *)fileName;

@end
