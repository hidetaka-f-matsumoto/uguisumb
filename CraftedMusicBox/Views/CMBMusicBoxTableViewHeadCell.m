//
//  CMBMusicBoxTableViewHeadCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/11/29.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxTableViewHeadCell.h"

@implementation CMBMusicBoxTableViewHeadCell

- (void)_init
{
    _octaveViews = [NSMutableArray array];
    for (NSInteger i=0; i<CMBOctaveRange; i++) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CMBMusicBoxHeadOctaveView" owner:self options:nil];
        CMBMusicBoxHeadOctaveView *octaveView = nibs[0];
        [octaveView updateWithOctave:(CMBOctaveMin + i)];
        [self.contentView addSubview:octaveView];
        [_octaveViews addObject:octaveView];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self _init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayoutSize:(CGSize)layoutSize
{
    // 設定
    _layoutSize = layoutSize;
    for (NSInteger i=0; i<CMBOctaveRange; i++) {
        CMBMusicBoxHeadOctaveView *octaveView = _octaveViews[i];
        CGSize size = CGSizeMake(layoutSize.width / (CGFloat)CMBOctaveRange, layoutSize.height);
        CGRect frame = CGRectMake(size.width * i, 0.f, size.width, size.height);
        octaveView.frame = frame;
        octaveView.layoutSize = size;
    }
    // intrinsicContentSizeが変わったことをAuto Layoutに知らせる
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    return _layoutSize;
}

@end
