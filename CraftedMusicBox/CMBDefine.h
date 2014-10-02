//
//  CMBDefine.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/27.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#ifndef CraftedMusicBox_CMBDefine_h
#define CraftedMusicBox_CMBDefine_h

#import <Foundation/Foundation.h>

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

#endif
