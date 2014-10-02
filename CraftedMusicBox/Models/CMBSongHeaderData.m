//
//  CMBSongHeaderData.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/24.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongHeaderData.h"

@implementation CMBSongHeaderData

- (id)init
{
    return [self initWithInfo:nil];
}

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _name = (info && info[@"name"]) ? info[@"name"] : @"";
        _speed = (info && info[@"speed"]) ? info[@"speed"] : [NSNumber numberWithFloat:CMBSpeedDefault];
        _division1 = (info && info[@"division1"]) ? info[@"division1"] : [NSNumber numberWithInteger:CMBDivisionDefault];
        _division2 = (info && info[@"division2"]) ? info[@"division2"] : [NSNumber numberWithInteger:CMBDivisionDefault];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            version, @"version",
            _name, @"name",
            _speed, @"speed",
            _division1, @"division1",
            _division2, @"division2",
            nil];
}

@end
