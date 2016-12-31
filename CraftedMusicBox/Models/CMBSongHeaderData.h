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
@property (nonatomic, strong) NSString *composer;
@property (nonatomic, strong) NSNumber *speed;
@property (nonatomic, strong) NSNumber *division1;
@property (nonatomic, strong) NSNumber *division2;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSString *scaleMode;
@property (nonatomic, strong) NSString *instrument;
@property (nonatomic, strong) NSString *version;

- (id)initWithInfo:(NSDictionary *)info;
- (NSDictionary *)dictionary;

@end
