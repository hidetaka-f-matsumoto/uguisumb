//
//  CMBSongConfigViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseModalViewController.h"
#import "CMBSongHeaderData.h"

@protocol CMBSongConfigDelegate <NSObject>

@required
- (void)songDidConfigureWithSave:(BOOL)save;

@end

/**
 * Song設定
 */
@interface CMBSongConfigViewController : CMBBaseModalViewController

@property (nonatomic, assign) id<CMBSongConfigDelegate> delegate;
@property (atomic, assign) CMBSongHeaderData *header;

- (IBAction)applyButtonDidTap:(id)sender;
- (IBAction)applyAndSaveButtonDidTap:(id)sender;

@end
