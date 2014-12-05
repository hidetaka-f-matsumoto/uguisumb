//
//  CMBMusicBoxOctaveView.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/27.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMBSequenceOneData;

static CGFloat const CMBMusicBoxNoteButtonWidth_iPhone  = 24.f;
static CGFloat const CMBMusicBoxNoteButtonWidth_iPad    = 44.f;

@protocol CMBMusicBoxOctaveViewDelegate <NSObject>

@required
/** 音符がタップされた */
- (void)noteDidTapWithInfo:(NSMutableDictionary *)info;

@end

/**
 * 1オクターブのView
 */
@interface CMBMusicBoxOctaveView : UIView

@property (nonatomic, assign) id<CMBMusicBoxOctaveViewDelegate> delegate;
@property (nonatomic, strong) NSNumber *octave;
@property (nonatomic, readonly, getter = getOnNoteInfos) NSArray *onNoteInfos;
//@property (nonatomic, setter=setLayoutSize:) CGSize layoutSize;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *noteButtons;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *noteButtonWidthConstraints;

- (IBAction)noteButtonDidTap:(id)sender;

- (void)updateWithSequenceOneData:(CMBSequenceOneData *)soData
                            color:(UIColor *)color;

@end
