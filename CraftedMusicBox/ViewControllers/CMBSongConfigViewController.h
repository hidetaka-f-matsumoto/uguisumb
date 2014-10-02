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
- (void)songDidSaveWithName:(NSString *)name;

@end

/**
 * Song設定
 */
@interface CMBSongConfigViewController : CMBBaseModalViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<CMBSongConfigDelegate> delegate;
@property (atomic, assign) NSDictionary *sequences;
@property (atomic, assign) CMBSongHeaderData *header;

@property (nonatomic, weak) IBOutlet UITextField *nameText;
@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UIStepper *speedStepper;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division1Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *division2Control;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

- (IBAction)speedStepperDidTap:(id)sender;
- (IBAction)applyButtonDidTap:(id)sender;
- (IBAction)saveButtonDidTap:(id)sender;

@end
