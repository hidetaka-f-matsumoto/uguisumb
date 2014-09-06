//
//  CMBMusicBoxViewCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBSequenceOneData.h"
#import "CMBMusicBoxOctaveView.h"

@protocol CMBMusicBoxViewCellDelegate <NSObject>

- (void)noteDidTapWithInfo:(NSDictionary *)info;
- (void)notesDidPickWithInfos:(NSArray *)infos;

@end

@interface CMBMusicBoxViewCell : UITableViewCell <CMBMusicBoxOctaveViewDelegate>

@property (nonatomic, assign) id<CMBMusicBoxViewCellDelegate> delegate;
@property (nonatomic, assign) UITableView *parentTableView;
@property (nonatomic, assign) UIView *tineView;
@property (nonatomic, strong) NSMutableArray *octaveViews;

- (void)process;
- (void)updateWithSequenceOne:(CMBSequenceOneData *)soData;

@end
