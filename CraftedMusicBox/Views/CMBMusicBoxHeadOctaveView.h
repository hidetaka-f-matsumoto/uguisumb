//
//  CMBMusicBoxHeadOctaveView.h
//  CraftedMusicBox
//
//  Created by hide on 2014/11/26.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 1オクターブのヘッダ
 */
@interface CMBMusicBoxHeadOctaveView : UIView

@property (nonatomic, strong) NSNumber *octave;
@property (nonatomic, setter=setLayoutSize:) CGSize layoutSize;

@property (nonatomic, weak) IBOutlet UIImageView *octDownArrowImage;
@property (nonatomic, weak) IBOutlet UIImageView *octDownFingerImage;
@property (nonatomic, weak) IBOutlet UILabel *octDownLabel;
@property (nonatomic, weak) IBOutlet UIImageView *octUpArrowImage;
@property (nonatomic, weak) IBOutlet UIImageView *octUpFingerImage;
@property (nonatomic, weak) IBOutlet UILabel *octUpLabel;

- (void)updateWithOctave:(NSInteger)octave;

@end
