//
//  CMBBaseViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADBannerView.h>
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

- (UIViewController *)topMostController;
- (BOOL)isTopMostViewController;
- (void)loadingBeginWithNetwork:(BOOL)network;
- (void)loadingEndWithNetwork:(BOOL)network;
- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                         handler:(void (^)(UIAlertAction *action))handler;
- (void)showConfirmDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                           handler:(void (^)(UIAlertAction *action))handler;
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                         buttons:(NSArray *)buttons;
- (NetworkStatus)checkNetworkStatus;

@end
