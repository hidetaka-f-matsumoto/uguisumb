//
//  CMBMusicBoxTableViewCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBSequenceOneData.h"
#import "CMBMusicBoxOctaveView.h"

static CGFloat const CMBMusicBoxTableViewCellHeight = 44.f;

@protocol CMBMusicBoxTableViewCellDelegate <NSObject>

@required
/** 1オクターブのサイズを返す */
- (CGSize)sizeOfOctave;
/** 音符がタップされた */
- (void)noteDidTapWithInfo:(NSMutableDictionary *)info;
/** 音符が弾かれた */
- (void)notesDidPickWithInfos:(NSArray *)infos;

@end

/**
 * 1シーケンスのCell
 */
@interface CMBMusicBoxTableViewCell : UITableViewCell <CMBMusicBoxOctaveViewDelegate>

@property (nonatomic, assign) id<CMBMusicBoxTableViewCellDelegate> delegate;
@property (nonatomic, assign) UITableView *parentTableView;
@property (nonatomic, assign) UIView *tineView;
@property (nonatomic, strong) NSMutableArray *octaveViews;

@property (nonatomic, setter=setLayoutSize:) CGSize layoutSize;

- (void)process;
- (void)updateWithSequenceOne:(CMBSequenceOneData *)soData
                        color:(UIColor *)color;

@end
