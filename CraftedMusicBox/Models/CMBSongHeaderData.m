//
//  CMBSongHeaderData.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/24.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongHeaderData.h"

@implementation CMBSongHeaderData

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _name = (info && info[@"name"]) ? info[@"name"] : @"";
        _tempo = (info && info[@"tempo"]) ? info[@"tempo"] : [NSNumber numberWithInteger:CMBTempoDefault];
        _beat = (info && info[@"beat"]) ? info[@"beat"] : CMBBeatDefault;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            version, @"version",
            _name, @"name",
            _tempo, @"tempo",
            _beat, @"beat",
            nil];
}

@end
