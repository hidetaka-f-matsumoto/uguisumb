//
//  CMBMusicBoxOctaveView.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/27.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMBSequenceOneData;

@protocol CMBMusicBoxOctaveViewDelegate <NSObject>

@required
- (void)noteDidTapWithInfo:(id)info;

@end

@interface CMBMusicBoxOctaveView : UIView

@property (nonatomic, assign) id<CMBMusicBoxOctaveViewDelegate> delegate;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *noteButtons;
@property (nonatomic, strong) NSNumber *octave;
@property (nonatomic, readonly, getter = getOnNoteInfos) NSArray *onNoteInfos;

- (IBAction)noteButtonDidTap:(id)sender;

- (void)updateWithOctaveOne:(CMBSequenceOneData *)soData;

+ (NSString *)scaleWithIndex:(NSInteger)index;
+ (NSInteger)indexWithScale:(NSString *)scale;

@end
