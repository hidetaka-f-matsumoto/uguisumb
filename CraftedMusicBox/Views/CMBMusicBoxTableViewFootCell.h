//
//  CMBMusicBoxTableViewFootCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/12/28.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const CMBMusicBoxTableViewFootCellHeight = 200;

@protocol CMBMusicBoxTableViewFootCellDelegate <NSObject>

@required
/** タイム追加リクエスト */
- (void)musicBoxDidRequestAddTime;
/** タイム削除リクエスト */
- (void)musicBoxDidRequestRemoveTime;
/** 作曲者 */
- (NSString *)getComposer;

@end

@interface CMBMusicBoxTableViewFootCell : UITableViewCell

@property (nonatomic, assign) id<CMBMusicBoxTableViewFootCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *composerLabel;

- (IBAction)timeAddButtonDidTap:(id)sender;
- (IBAction)timeRemoveButtonDidTap:(id)sender;

@end
