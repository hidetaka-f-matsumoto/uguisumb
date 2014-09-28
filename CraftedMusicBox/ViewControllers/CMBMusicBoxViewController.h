//
//  CMBMusicBoxViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CMBBaseViewController.h"
#import "CMBNoteData.h"
#import "CMBSequenceOneData.h"
#import "CMBSongHeaderData.h"
#import "CMBMusicBoxTableViewCell.h"
#import "CMBSongConfigViewController.h"
#import "CMBSongManageViewController.h"

static CGFloat const CMBTimeDivAutoScroll = 0.01f; // [s]

@interface CMBMusicBoxViewController : CMBBaseViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, CMBMusicBoxTableViewCellDelegate, CMBSongConfigDelegate, CMBSongManageDelegate>
{
    NSMutableDictionary *_dataSource;
}

@property (strong, nonatomic) NSMutableDictionary *sounds;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tineView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;

- (IBAction)playButtonDidTap:(id)sender;
- (IBAction)stopButtonDidTap:(id)sender;
- (IBAction)menueButtonDidTap:(id)sender;

@end
