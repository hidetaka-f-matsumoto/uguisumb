//
//  CMBMusicBoxViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <BlocksKit/BlocksKit+MessageUI.h>
#import "CMBBaseViewController.h"
#import "CMBNoteData.h"
#import "CMBSequenceOneData.h"
#import "CMBSongHeaderData.h"
#import "CMBMusicBoxTableViewCell.h"
#import "CMBSongConfigViewController.h"
#import "CMBSongManageViewController.h"
#import "CMBMusicBoxTableView.h"
#import "CMBUtility.h"
#import "CMBSoundManager.h"

static CGFloat const CMBTimeDivAutoScroll = 0.02f; // [s]
static CGFloat const CMBMusicBoxTableViewFootCellHeight = 200.f;

@interface CMBMusicBoxViewController : CMBBaseViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CMBMusicBoxTableViewCellDelegate, CMBSongConfigDelegate, CMBSongManageDelegate>
{
    NSMutableDictionary *_dataSource;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CMBMusicBoxTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tineView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *octaveLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headViewTopConstraint;

- (IBAction)playButtonDidTap:(id)sender;
- (IBAction)stopButtonDidTap:(id)sender;
- (IBAction)shareButtonDidTap:(id)sender;
- (IBAction)menueButtonDidTap:(id)sender;

@end
