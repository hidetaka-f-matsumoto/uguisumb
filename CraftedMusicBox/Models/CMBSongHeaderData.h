//
//  CMBSongHeaderData.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/24.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMBSongHeaderData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *speed;
@property (nonatomic, strong) NSNumber *division1;
@property (nonatomic, strong) NSNumber *division2;

- (id)initWithInfo:(NSDictionary *)info;
- (NSDictionary *)dictionary;

@end
