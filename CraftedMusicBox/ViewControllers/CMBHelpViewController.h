//
//  CMBHelpViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2015/02/01.
//  Copyright (c) 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseModalViewController.h"

@interface CMBHelpViewController : CMBBaseModalViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refleshButton;

- (IBAction)backButtonDidTap:(id)sender;
- (IBAction)forwardButtonDidTap:(id)sender;
- (IBAction)reloadButtonDidTap:(id)sender;

@end
