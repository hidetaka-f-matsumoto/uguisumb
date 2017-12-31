//
//  CMBBaseViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBBaseViewController.h"

@interface CMBBaseViewController ()

@end

@implementation CMBBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ナビゲーションバーの設定
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSFontAttributeName : [UIFont fontWithName:@"SetoFont-SP" size:19.f],
       NSForegroundColorAttributeName : [CMBUtility tintColor],
      }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{
       NSFontAttributeName : [UIFont fontWithName:@"SetoFont-SP" size:19.f],
       NSForegroundColorAttributeName : [CMBUtility tintColor],
       } forState:UIControlStateNormal];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 広告を表示
    [self showAd];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初回起動の場合
    if ([[CMBUtility sharedInstance] checkFirstRunCurrentVersion]) {
        NSString *title = NSLocalizedString(@"What's New", @"What's New");
        NSString *message = NSLocalizedString(@"New feature information ver.1.4.1.", @"New feature information.");
        [self showAlertDialogWithTitle:title message:message handler:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (BOOL)isTopMostViewController
{
    return [self topMostController] == self;
}

- (void)loadingBeginWithNetwork:(BOOL)network
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD show];
    if (network) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)loadingEndWithNetwork:(BOOL)network
{
    if (network) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                         handler:(void (^)(UIAlertAction *action))handler
{
    CMBAlertController *alertController =
    [CMBAlertController alertControllerWithTitle:title
                                         message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:handler]];
    // ダイアログを表示
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)showConfirmDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                           handler:(void (^)(UIAlertAction *action))handler
{
    CMBAlertController *alertController =
    [CMBAlertController alertControllerWithTitle:title
                                         message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    // Cancel処理
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:handler]];
    // ダイアログを表示
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                         buttons:(NSArray *)buttons
{
    CMBAlertController *alertController =
    [CMBAlertController alertControllerWithTitle:title
                                         message:message
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    // 各処理
    for (NSDictionary *button in buttons) {
        [alertController addAction:[UIAlertAction actionWithTitle:button[@"title"]
                                                            style:UIAlertActionStyleDefault
                                                          handler:button[@"handler"]]];
    }
    // Cancel処理
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    // iPad用の設定
    if (alertController.popoverPresentationController) {
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect = self.view.frame;
        alertController.popoverPresentationController.permittedArrowDirections = 0;
    }
    // アクションシート表示
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Ad

- (void)showAd
{
    // 表示領域が無い場合は何もしない
    if (!_bannerFrameView) {
        return;
    }
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    // AutoresizingMask を OFF
    _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    // 広告ユニット ID を指定する
    _bannerView.adUnitID = MY_BANNER_UNIT_ID;
    // ユーザーに広告を表示した場所に後で復元する UIViewController をランタイムに知らせてビュー階層に追加する
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    [_bannerFrameView addSubview:_bannerView];
    // リクエストを行って広告を読み込む
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[
                            // Simulators.
                            // Test devices.
                            @"889ab485761f8e9717be4f74ba63cb7c",
                            @"32f668caae5f51e25a624cbad59ea2fb",
                            @"005cec916bbc6b059364291493a25819",
                            ];
#endif // DEBUG
    [_bannerView loadRequest:request];
    // Autolayout 制約を設定
    [_bannerFrameView addConstraint:
     [NSLayoutConstraint constraintWithItem:_bannerView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_bannerFrameView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.f
                                   constant:0.f]];
    [_bannerFrameView addConstraint:
     [NSLayoutConstraint constraintWithItem:_bannerView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_bannerFrameView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.f
                                   constant:0.f]];
}

- (void)hideAd
{
    [_bannerView removeFromSuperview];
    _bannerView = nil;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    // 下からスライドアニメで広告を表示
    // Ensures that all pending layout operations have been completed
    [self.view layoutIfNeeded];
    // 制約を設定
    _bannerFrameHeightConstraint.constant = bannerView.frame.size.height;
    [UIView animateWithDuration:0.5f
                     animations:^(void)
     {
         // Forces the layout of the subtree animation block and then captures all of the frame changes
         [self.view layoutIfNeeded];
     }];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    DPRINT(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

#pragma mark - Network

- (NetworkStatus)checkNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
        {
            NSString *title = NSLocalizedString(@"Network", @"Network");
            NSString *message = NSLocalizedString(@"Network is offline.", @"The message when network is offline.");
            [self showAlertDialogWithTitle:title message:message handler:nil];
            break;
        }
        default:
            break;
    }
    return status;
}

@end
