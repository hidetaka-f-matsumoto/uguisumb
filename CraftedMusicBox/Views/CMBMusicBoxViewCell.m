//
//  CMBMusicBoxViewCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxViewCell.h"

@interface CMBMusicBoxViewCell ()
{
    CGFloat _preY;
}

@end

@implementation CMBMusicBoxViewCell

- (void)setup
{
    _octaveViews = [NSMutableArray array];
    for (NSInteger i=0; i<CMBOctaveRange; i++) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CMBMusicBoxOctaveView" owner:self options:nil];
        CMBMusicBoxOctaveView *octaveView = nibs[0];
        CGRect frame = CGRectMake(320 * i,
                                  0,
                                  octaveView.frame.size.width,
                                  octaveView.frame.size.height);
        octaveView.frame = frame;
        octaveView.delegate = self;
        octaveView.octave = [NSNumber numberWithInteger:(CMBOctaveMin + i)];
        [self.contentView addSubview:octaveView];
        [_octaveViews addObject:octaveView];
    }
    _preY = 0.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)process
{
//    NSLog(@"process y=%f", self.frame.origin.y - _parentTableView.contentOffset.y);
    CGFloat tineY = _tineView.frame.origin.y - 64.0f; // NavigationBar+StatusBar分
    CGFloat curY = self.frame.origin.y - _parentTableView.contentOffset.y;
    if (tineY >= curY && tineY < _preY) {
        NSLog(@"process tineY=%f, curY=%f, preY=%f", tineY, curY, _preY);
        NSMutableArray *noteInfos = [NSMutableArray array];
        for (CMBMusicBoxOctaveView *octaveView in _octaveViews) {
            [noteInfos addObjectsFromArray:octaveView.onNoteInfos];
        }
        [_delegate notesDidPickWithInfos:noteInfos];
    }
    _preY = curY;
}

- (void)updateWithSequenceOne:(CMBSequenceOneData *)soData
{
    for (CMBMusicBoxOctaveView *octaveView in _octaveViews) {
        if (!octaveView) {
            continue;
        }
        [octaveView updateWithOctaveOne:soData];
    }
}

#pragma mark CMBMusicBoxOctaveViewDelegate

- (void)noteDidTapWithInfo:(id)info
{
    [_delegate noteDidTapWithInfo:info];
}

@end
