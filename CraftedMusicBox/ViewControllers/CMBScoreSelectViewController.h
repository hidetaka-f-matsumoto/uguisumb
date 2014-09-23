//
//  CMBScoreSelectViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseModalViewController.h"

@protocol CMBScoreSelectDelegate <NSObject>

@required
- (void)scoreDidSelectWithInfo:(NSDictionary *)info;

@end

/**
 * 楽譜選択
 */
@interface CMBScoreSelectViewController : CMBBaseModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<CMBScoreSelectDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
