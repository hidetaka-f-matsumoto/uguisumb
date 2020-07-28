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
#ifdef DEBUG
static NSString * const CMBSvURL = @"https://uguisumb-stg.herokuapp.com";
#else
static NSString * const CMBSvURL = @"https://www.uguisumb.app";
#endif
static NSString * const CMBSvApiSecret = @"JDVjhLA8";
static NSString * const CMBSvApiSong = @"/api/v2/songs";

/**
 * SNS
 */
static NSString * const CMBHashTag = @"#UguisuMB #うぐいすオルゴール";

/**
 * Song
 */
static CGFloat const CMBSpeedDefault = 50.0f;
static CGFloat const CMBSpeedMin = 1.0f;
static CGFloat const CMBSpeedMax = 320.0f;
static NSInteger const CMBDivisionDefault = 4;
#define CMBDivisions @[@2, @3, @4, @5, @6, @7, @8, @11]
static NSInteger const CMBOctaveMin = 2;
static NSInteger const CMBOctaveMax = 6;
static NSInteger const CMBOctaveBase = 4;
static NSInteger const CMBOctaveRange = CMBOctaveMax - CMBOctaveMin + 1;
static NSInteger const CMBScaleNum = 12;
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
static NSString * const CMBSoundMusicbox = @"MusicBox";
#define CMBSoundResMusicboxOct3 @[@"C3", @"C#3", @"D3", @"D#3", @"E3", @"F3", @"F#3", @"G3", @"G#3", @"A3", @"A#3", @"B3"]
#define CMBSoundResMusicboxOct4 @[@"C4", @"C#4", @"D4", @"D#4", @"E4", @"F4", @"F#4", @"G4", @"G#4", @"A4", @"A#4", @"B4"]
#define CMBSoundResMusicboxOct5 @[@"C5", @"C#5", @"D5", @"D#5", @"E5", @"F5", @"F#5", @"G5", @"G#5", @"A5", @"A#5", @"B5"]

static NSString * const CMBSoundXylophone = @"Xylophone";
#define CMBSoundResXylophoneOct3 @[@"C3", @"C#3", @"D3", @"D#3", @"E3", @"F3", @"F#3", @"G3", @"G#3", @"A3", @"A#3", @"B3"]
#define CMBSoundResXylophoneOct4 @[@"C4", @"C#4", @"D4", @"D#4", @"E4", @"F4", @"F#4", @"G4", @"G#4", @"A4", @"A#4", @"B4"]
#define CMBSoundResXylophoneOct5 @[@"C5", @"C#5", @"D5", @"D#5", @"E5", @"F5", @"F#5", @"G5", @"G#5", @"A5", @"A#5", @"B5"]

static NSString * const CMBSoundVibraphone = @"Vibraphone";
static NSString * const CMBSoundMarimba = @"Marimba";

#define CMBSoundDefault CMBSoundMusicbox
#define CMBInstruments @[CMBSoundMusicbox, CMBSoundMarimba, CMBSoundVibraphone]

/**
 * Image resource
 */
#define CMBNoteImages @[@"note4", @"note8", @"note16-2"]

/**
 * Scale names
 */
#define CMBScaleNameKeys @[@"normal", @"doremi", @"haniho"]
#define CMBScaleNames @{ \
    @"normal": @[@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B"], \
    @"doremi": @[@"do", @"do#", @"re", @"re#", @"mi", @"fa", @"fa#", @"so", @"so#", @"la", @"la#", @"ti"], \
    @"haniho": @[@"ハ", @"嬰ﾊ", @"ニ", @"嬰ﾆ", @"ホ", @"ヘ", @"嬰ﾍ", @"ト", @"嬰ﾄ", @"イ", @"嬰ｲ", @"ロ"], \
}

#endif
