//
//  CMBSongManageTableViewCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongManageTableViewCell.h"

@implementation CMBSongManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // 選択の場合
    if (selected) {
        // メニューを開く
        [self showRightUtilityButtonsAnimated:YES];
    }
}

- (void)setupWithSongInfo:(NSDictionary *)info
{
    _info = info;
    _nameLabel.text = info[@"name"];
}

@end
