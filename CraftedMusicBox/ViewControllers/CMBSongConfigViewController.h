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
@interface CMBSongConfigViewController : CMBBaseModalViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<CMBSongConfigDelegate> delegate;
@property (atomic, assign) CMBSongHeaderData *header;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *nameText;
@property (nonatomic, weak) IBOutlet UITextField *composerText;
@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UIStepper *speedStepper;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division1Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division2Control;

- (IBAction)speedStepperDidTap:(id)sender;
- (IBAction)applyButtonDidTap:(id)sender;
- (IBAction)applyAndSaveButtonDidTap:(id)sender;

@end
