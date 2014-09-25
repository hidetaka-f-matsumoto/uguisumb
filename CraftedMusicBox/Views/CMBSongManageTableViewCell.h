//
//  CMBSongManageTableViewCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CMBSongManageTableViewCell : SWTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, assign) NSDictionary *info;

- (void)setupWithSongInfo:(NSDictionary *)info;

@end
