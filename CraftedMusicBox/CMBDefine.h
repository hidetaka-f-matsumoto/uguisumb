//
//  CMBDefine.h
//  CraftedMusicBox
//
//  Created by hide on 2013/07/27.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#ifndef CraftedMusicBox_CMBDefine_h
#define CraftedMusicBox_CMBDefine_h

#import <Foundation/Foundation.h>

/**
 * Ad
 */
static NSString * const MY_BANNER_UNIT_ID = @"ca-app-pub-5633935352729199/5879342265";

/**
 * Song
 */
static CGFloat const CMBSpeedDefault = 50.0f;
static CGFloat const CMBSpeedMin = 1.0f;
static CGFloat const CMBSpeedMax = 100.0f;
static NSInteger const CMBDivisionDefault = 4;
#define CMBDivisions @[@2, @3, @4, @5, @6, @7, @8, @11]
static NSInteger const CMBOctaveMin = 3;
static NSInteger const CMBOctaveMax = 5;
static NSInteger const CMBOctaveBase = 4;
static NSInteger const CMBOctaveRange = CMBOctaveMax - CMBOctaveMin + 1;
static NSInteger const CMBScaleNum = 11;
static NSInteger const CMBSequenceTimeMax = 1000;

/**
 * Command
 */
static NSString * const CMBCmdURLSchemeOpenMusicBox = @"CMBCmdURLSchemeOpenMusicBox";

/**
 * Error
 */
#define CMBErrorDomain @"hidetaka.f.matsumoto.CMBError"
typedef enum {
    CMBErrorCodeNone = 0,
    CMBErrorCodeDBAccess,
    CMBErrorCodeFileAccess,
    CMBErrorCodeNetwork,
    CMBErrorCodeSongParse,
} CMBErrorCode;

/**
 * Sound resource
 */
static NSString * const CMBSoundMusicbox = @"CMBSoundMusicbox";
#define CMBSoundResMusicboxOct3 @[@"musicbox.C3", @"musicbox.C3s", @"musicbox.D3", @"musicbox.D3s", @"musicbox.E3", @"musicbox.F3", @"musicbox.F3s", @"musicbox.G3", @"musicbox.G3s", @"musicbox.A3", @"musicbox.A3s", @"musicbox.B3"]
#define CMBSoundResMusicboxOct4 @[@"musicbox.C4", @"musicbox.C4s", @"musicbox.D4", @"musicbox.D4s", @"musicbox.E4", @"musicbox.F4", @"musicbox.F4s", @"musicbox.G4", @"musicbox.G4s", @"musicbox.A4", @"musicbox.A4s", @"musicbox.B4"]
#define CMBSoundResMusicboxOct5 @[@"musicbox.C5", @"musicbox.C5s", @"musicbox.D5", @"musicbox.D5s", @"musicbox.E5", @"musicbox.F5", @"musicbox.F5s", @"musicbox.G5", @"musicbox.G5s", @"musicbox.A5", @"musicbox.A5s", @"musicbox.B5"]

static NSString * const CMBSoundXylophone = @"CMBSoundXylophone";
#define CMBSoundResXylophoneOct3 @[@"xylophone.C3", @"xylophone.C3s", @"xylophone.D3", @"xylophone.D3s", @"xylophone.E3", @"xylophone.F3", @"xylophone.F3s", @"xylophone.G3", @"xylophone.G3s", @"xylophone.A3", @"xylophone.A3s", @"xylophone.B3"]
#define CMBSoundResXylophoneOct4 @[@"xylophone.C4", @"xylophone.C4s", @"xylophone.D4", @"xylophone.D4s", @"xylophone.E4", @"xylophone.F4", @"xylophone.F4s", @"xylophone.G4", @"xylophone.G4s", @"xylophone.A4", @"xylophone.A4s", @"xylophone.B4"]
#define CMBSoundResXylophoneOct5 @[@"xylophone.C5", @"xylophone.C5s", @"xylophone.D5", @"xylophone.D5s", @"xylophone.E5", @"xylophone.F5", @"xylophone.F5s", @"xylophone.G5", @"xylophone.G5s", @"xylophone.A5", @"xylophone.A5s", @"xylophone.B5"]

#endif
