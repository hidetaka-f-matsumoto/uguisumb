//
//  CMBMusicBoxTableViewHeadCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/11/29.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const CMBMusicBoxTableViewHeadCellHeight = 154.f;

@protocol CMBMusicBoxTableViewHeadCellDelegate <NSObject>

@required
/** 現在のオクターブ */
- (NSInteger)getCurrentOctave;

@end

@interface CMBMusicBoxTableViewHeadCell : UITableViewCell

@property (nonatomic, assign) id<CMBMusicBoxTableViewHeadCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *octDownLabel;
@property (nonatomic, weak) IBOutlet UILabel *octUpLabel;

- (void)update;

@end
