//
//  CMBMusicBoxTableViewHeadCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/11/29.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBMusicBoxHeadOctaveView.h"

static CGFloat const CMBMusicBoxTableViewHeadCellHeight = 200.f;

@interface CMBMusicBoxTableViewHeadCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *octaveViews;

@property (nonatomic, setter=setLayoutSize:) CGSize layoutSize;

@end
