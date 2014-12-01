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
    // サイズが変わらない場合は何もしない
    if (_layoutSize.height == layoutSize.height && _layoutSize.width == layoutSize.width &&
        self.frame.size.height == layoutSize.height && self.frame.size.width == layoutSize.width) {
        return;
    }
    // 設定
    _layoutSize = layoutSize;
    // 再描画 (setNeedsLayoutの方がパフォーマンスが良いので採用)
    //    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)intrinsicContentSize
{
    return _layoutSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger i=0; i<CMBOctaveRange; i++) {
        // layoutSize内に、CMBOctaveRange分のviewを並べる
        CMBMusicBoxHeadOctaveView *octaveView = _octaveViews[i];
        CGSize size = CGSizeMake(self.frame.size.width / (CGFloat)CMBOctaveRange, self.frame.size.height);
        CGRect frame = CGRectMake(size.width * i, 0.f, size.width, size.height);
        octaveView.frame = frame;
    }
}

@end
