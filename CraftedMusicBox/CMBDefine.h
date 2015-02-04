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
 * URL Scheme
 */
static NSString * const CMBURLScheme = @"uguisumb";
static NSString * const CMBURLControllerMusicBox = @"mb";
static NSString * const CMBURLActionLoadSong = @"load";
static NSString * const CMBURLParamVersion = @"ver";
static NSString * const CMBURLParamSong = @"song";

/**
 * Server
 */
static NSString * const CMBSvSupportURL = @"https://uguisumb.herokuapp.com/support/";
static NSString * const CMBSvApiURL = @"https://uguisumb.herokuapp.com/api/";
static NSString * const CMBSvViewURL = @"https://uguisumb.herokuapp.com/html/";
static NSString * const CMBSvActionSongReg = @"song.register.php";
static NSString * const CMBSvActionSongLink = @"song.link.php";
static NSString * const CMBSvQuerySong = @"song";
static NSString * const CMBSvQuerySongKey = @"key";
static NSString * const CMBSvQuerySongTitle = @"title";

/**
 * SNS
 */
static NSString * const CMBHashTag = @"#UguisuMB";

/**
 * Song
 */
static CGFloat const CMBSpeedDefault = 50.0f;
static CGFloat const CMBSpeedMin = 1.0f;
static CGFloat const CMBSpeedMax = 200.0f;
static NSInteger const CMBDivisionDefault = 4;
#define CMBDivisions @[@2, @3, @4, @5, @6, @7, @8, @11]
static NSInteger const CMBOctaveMin = 3;
static NSInteger const CMBOctaveMax = 5;
static NSInteger const CMBOctaveBase = 4;
static NSInteger const CMBOctaveRange = CMBOctaveMax - CMBOctaveMin + 1;
static NSInteger const CMBScaleNum = 11;
static NSInteger const CMBSequenceTimeDefault = CMBDivisionDefault * 10;

/**
 * Notification
 */
static NSString * const CMBNotifyAppDidEnterBackground = @"CMBNotifyAppDidEnterBackground";
static NSString * const CMBNotifyAppWillTerminate = @"CMBNotifyAppWillTerminate";
static NSString * const CMBNotifyURLOpenMusicBox = @"CMBNotifyURLOpenMusicBox";

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
#define CMBSoundResMusicboxOct3 @[@"C3", @"C#3", @"D3", @"D#3", @"E3", @"F3", @"F#3", @"G3", @"G#3", @"A3", @"A#3", @"B3"]
#define CMBSoundResMusicboxOct4 @[@"C4", @"C#4", @"D4", @"D#4", @"E4", @"F4", @"F#4", @"G4", @"G#4", @"A4", @"A#4", @"B4"]
#define CMBSoundResMusicboxOct5 @[@"C5", @"C#5", @"D5", @"D#5", @"E5", @"F5", @"F#5", @"G5", @"G#5", @"A5", @"A#5", @"B5"]

static NSString * const CMBSoundXylophone = @"CMBSoundXylophone";
#define CMBSoundResXylophoneOct3 @[@"C3", @"C#3", @"D3", @"D#3", @"E3", @"F3", @"F#3", @"G3", @"G#3", @"A3", @"A#3", @"B3"]
#define CMBSoundResXylophoneOct4 @[@"C4", @"C#4", @"D4", @"D#4", @"E4", @"F4", @"F#4", @"G4", @"G#4", @"A4", @"A#4", @"B4"]
#define CMBSoundResXylophoneOct5 @[@"C5", @"C#5", @"D5", @"D#5", @"E5", @"F5", @"F#5", @"G5", @"G#5", @"A5", @"A#5", @"B5"]

#endif
