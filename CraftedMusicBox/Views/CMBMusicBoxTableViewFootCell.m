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

@end
