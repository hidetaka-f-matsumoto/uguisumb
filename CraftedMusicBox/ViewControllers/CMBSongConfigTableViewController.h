//
//  CMBSongConfigTableViewController.h
//  CraftedMusicBox
//
//  Created by Hidetaka Matsumoto on 2018/01/24.
//  Copyright © 2018年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBSongHeaderData.h"

@interface CMBSongConfigTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *nameText;
@property (nonatomic, weak) IBOutlet UITextField *composerText;
@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UIStepper *speedStepper;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division1Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division2Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *scaleControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *instrumentControl;

- (IBAction)speedStepperDidTap:(id)sender;

- (void)resetWithHeader:(CMBSongHeaderData *)header;
- (void)copyConfigToHeader:(CMBSongHeaderData *)header;

@end
