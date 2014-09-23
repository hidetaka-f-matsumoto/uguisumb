//
//  CMBScoreSelectTableViewCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBScoreSelectTableViewCell.h"

@implementation CMBScoreSelectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithScoreInfo:(NSDictionary *)info
{
    _scoreInfo = info;
    _scoreNameLabel.text = info[@"name"];
}

@end
