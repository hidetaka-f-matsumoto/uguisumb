//
//  CMBMusicBoxTableViewCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBSequenceOneData.h"
#import "SWTableViewCell.h"

static CGFloat const CMBMusicBoxTableViewCellHeightForLoad  = 11.f;
static CGFloat const CMBMusicBoxTableViewCellHeight         = 44.f;

@protocol CMBMusicBoxTableViewCellDelegate <NSObject>

@required
/** タップされた */
- (void)musicboxDidTapWithInfo:(NSDictionary *)info;
/** 弾かれた */
- (void)musicboxDidPickWithIndexPath:(NSIndexPath *)indexPath;
/** 現在のオクターブ */
- (NSInteger)getCurrentOctave;
/** セルの背景色 */
- (UIColor *)musicboxCellColorWithIndexPath:(NSIndexPath *)indexPath;
/** セルのシーケンス */
- (CMBSequenceOneData *)musicboxCellSequenceOneWithIndexPath:(NSIndexPath *)indexPath;

@end

/**
 * 1シーケンスのCell
 */
@interface CMBMusicBoxTableViewCell : UITableViewCell

@property (nonatomic, assign) id<CMBMusicBoxTableViewCellDelegate> delegate;
@property (nonatomic, assign) UITableView *parentTableView;
@property (nonatomic, assign) UIView *tineView;
@property (nonatomic) CGFloat tineViewOffset;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *noteButtons;

- (IBAction)noteButtonDidTap:(id)sender;

- (void)process;
- (void)update;

@end
