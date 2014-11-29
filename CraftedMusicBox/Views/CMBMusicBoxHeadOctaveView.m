//
//  CMBMusicBoxHeadOctaveView.m
//  CraftedMusicBox
//
//  Created by hide on 2014/11/26.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxHeadOctaveView.h"

@implementation CMBMusicBoxHeadOctaveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setLayoutSize:(CGSize)layoutSize
{
    // 設定
    _layoutSize = layoutSize;
    // intrinsicContentSizeが変わったことをAuto Layoutに知らせる
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    return _layoutSize;
}

- (void)updateWithOctave:(NSInteger)octave
{
    switch (octave) {
        case CMBOctaveMin:
            _octDownArrowImage.image = nil;
            _octDownFingerImage.image = nil;
            _octDownLabel.text = nil;
            break;
            
        case CMBOctaveMax:
            _octUpArrowImage.image = nil;
            _octUpFingerImage.image = nil;
            _octUpLabel.text = nil;
            break;
            
        default:
            break;
    }
}

@end
