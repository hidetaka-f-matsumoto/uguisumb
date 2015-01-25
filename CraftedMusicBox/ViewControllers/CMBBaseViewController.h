//
//  CMBBaseViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "GADBannerView.h"
#import "SVProgressHUD.h"
#import "CMBUtility.h"
#import "CMBAlertController.h"
#import "Reachability.h"

@interface CMBBaseViewController : UIViewController <GADBannerViewDelegate>
{
    GADBannerView *_bannerView;
}

@property (nonatomic, weak) IBOutlet UIView *bannerFrameView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bannerFrameHeightConstraint;

- (void)beginLoadingView;
- (void)endLoadingView;
- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                        handler1:(void (^)(UIAlertAction *action))handler1
                        handler2:(void (^)(void))handler2;
- (void)showConfirmDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                          handler1:(void (^)(UIAlertAction *action))handler1
                          handler2:(void (^)(void))handler2;
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                        buttons1:(NSArray *)buttons1
                        buttons2:(NSArray *)buttons2;
- (NetworkStatus)checkNetworkStatus;

@end
