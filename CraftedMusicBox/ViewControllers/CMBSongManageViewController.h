//
//  CMBSongManageViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseModalViewController.h"
#import "SWTableViewCell.h"
#import "CMBSongHeaderData.h"

@protocol CMBSongManageDelegate <NSObject>

@required
- (void)songDidLoadWithSequence:(NSMutableDictionary *)sequences
                         header:(CMBSongHeaderData *)header;
- (void)songDidDeleteWithFileName:(NSString *)fileName;

@end

/**
 * 楽譜選択
 */
@interface CMBSongManageViewController : CMBBaseModalViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (nonatomic, assign) id<CMBSongManageDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
