//
//  CMBScoreNameEditViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseModalViewController.h"

@protocol CMBScoreNameEditDelegate <NSObject>

@required
- (void)scoreNameDidEditWithName:(NSString *)name;

@end

/**
 * 楽譜名入力
 */
@interface CMBScoreNameEditViewController : CMBBaseModalViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<CMBScoreNameEditDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *captionLabel;
@property (nonatomic, weak) IBOutlet UITextField *scoreNameText;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

- (IBAction)okButtonDidTap:(id)sender;

@end
