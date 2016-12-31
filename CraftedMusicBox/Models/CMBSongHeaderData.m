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
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _name = (info && info[@"name"]) ? info[@"name"] : @"";
        _composer = (info && info[@"composer"]) ? info[@"composer"] : @"";
        _speed = (info && info[@"speed"]) ? info[@"speed"] : [NSNumber numberWithFloat:CMBSpeedDefault];
        _division1 = (info && info[@"division1"]) ? info[@"division1"] : [NSNumber numberWithInteger:CMBDivisionDefault];
        _division2 = (info && info[@"division2"]) ? info[@"division2"] : [NSNumber numberWithInteger:CMBDivisionDefault];
        _length = (info && info[@"length"]) ? info[@"length"] : [NSNumber numberWithInteger:CMBSequenceTimeDefault];
        _scaleMode = (info && info[@"scale_mode"]) ? info[@"scale_mode"] : @"normal";
        _instrument = (info && info[@"instrument"]) ? info[@"instrument"] : CMBSoundDefault;
        _version = (info && info[@"version"]) ? info[@"version"] : version;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            version, @"version", // set current app version.
            _name, @"name",
            _composer, @"composer",
            _speed, @"speed",
            _division1, @"division1",
            _division2, @"division2",
            _length, @"length",
            _scaleMode, @"scale_mode",
            _instrument, @"instrument",
            nil];
}

@end
