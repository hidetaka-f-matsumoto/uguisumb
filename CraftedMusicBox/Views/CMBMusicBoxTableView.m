//
//  CMBMusicBoxTableView.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/01.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxTableView.h"

@interface CMBMusicBoxTableView ()
{
    CGPoint _preciseContentOffset;
}
@end

@implementation CMBMusicBoxTableView

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

- (CGPoint)getContentOffset
{
    return _preciseContentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _preciseContentOffset = contentOffset;
    super.contentOffset = contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    _preciseContentOffset = contentOffset;
    [super setContentOffset:contentOffset animated:animated];
}

- (CGSize)intrinsicContentSize
{
    return _layoutSize;
}

@end
