//
//  CMBMusicBoxViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "CMBBaseViewController.h"
#import "CMBNoteData.h"
#import "CMBSequenceOneData.h"
#import "CMBSongHeaderData.h"
#import "CMBMusicBoxTableViewCell.h"
#import "CMBMusicBoxTableViewHeadCell.h"
#import "CMBMusicBoxTableViewFootCell.h"
#import "CMBSongConfigViewController.h"
#import "CMBSongManageViewController.h"
#import "CMBMusicBoxTableView.h"
#import "CMBUtility.h"
#import "CMBSoundManager.h"

static CGFloat const CMBTimeDivAutoScroll = 0.01f; // [s]

@interface CMBMusicBoxViewController : CMBBaseViewController
<
    UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UIGestureRecognizerDelegate, CAAnimationDelegate, MFMailComposeViewControllerDelegate,
    CMBMusicBoxTableViewCellDelegate, CMBMusicBoxTableViewHeadCellDelegate,
    CMBMusicBoxTableViewFootCellDelegate, CMBSongConfigDelegate, CMBSongManageDelegate
>
{
    NSMutableDictionary *_dataSource;
}

@property (nonatomic, getter=getCurrentOctave) NSInteger currentOctave;

@property (weak, nonatomic) IBOutlet CMBMusicBoxTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *curtainView;
@property (weak, nonatomic) IBOutlet UIView *tineView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *octaveLabel;
@property (nonatomic) IBOutletCollection(UILabel) NSArray *scaleLabels;
@property (weak, nonatomic) IBOutlet UIImageView *uguisuView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headViewTopConstraint;

- (IBAction)playButtonDidTap:(id)sender;
- (IBAction)stopButtonDidTap:(id)sender;
- (IBAction)shareButtonDidTap:(id)sender;
- (IBAction)menueButtonDidTap:(id)sender;
- (IBAction)tableViewDidSwipeLeft:(id)sender;
- (IBAction)tableViewDidSwipeRight:(id)sender;
- (IBAction)tableViewDidLongPress:(id)sender;

@end
