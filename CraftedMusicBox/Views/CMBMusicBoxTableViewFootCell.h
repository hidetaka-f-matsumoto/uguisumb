//
//  CMBMusicBoxTableViewFootCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/12/28.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const CMBMusicBoxTableViewFootCellHeight = 200.f;

@protocol CMBMusicBoxTableViewFootCellDelegate <NSObject>

@required
/** タイム追加リクエスト */
- (void)musicBoxDidRequestAddTime;

@end

@interface CMBMusicBoxTableViewFootCell : UITableViewCell

@property (nonatomic, assign) id<CMBMusicBoxTableViewFootCellDelegate> delegate;

- (IBAction)timeAddButtonDidTap:(id)sender;

@end
