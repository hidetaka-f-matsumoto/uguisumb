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
    _delegate = nil;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self update];
}

- (void)update
{
    switch ([_delegate getCurrentOctave]) {
        case CMBOctaveMin:
            _octDownLabel.text = nil;
            break;
            
        case CMBOctaveMax:
            _octUpLabel.text = nil;
            break;
            
        default:
            break;
    }
}

@end
