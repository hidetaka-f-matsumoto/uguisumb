//
//  CMBMusicBoxTableViewFootCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/12/28.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxTableViewFootCell.h"

@implementation CMBMusicBoxTableViewFootCell

- (IBAction)timeAddButtonDidTap:(id)sender
{
    [_delegate musicBoxDidRequestAddTime];
}

- (IBAction)timeRemoveButtonDidTap:(id)sender
{
    [_delegate musicBoxDidRequestRemoveTime];
}

- (IBAction)timeAddMoreButtonDidTap:(id)sender
{
    [_delegate musicBoxDidRequestAddTimeMore];
}

- (IBAction)timeRemoveMoreButtonDidTap:(id)sender
{
    [_delegate musicBoxDidRequestRemoveTimeMore];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self update];
}

- (void)update
{
    _composerLabel.text = [_delegate getComposer];
}

@end
