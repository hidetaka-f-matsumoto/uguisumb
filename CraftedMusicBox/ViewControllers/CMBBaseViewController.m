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
    
    // 広告を表示
    [self showAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                        handler1:(void (^)(UIAlertAction *action))handler1
                        handler2:(void (^)(void))handler2
{
    // UIAlertControllerが使える場合
    if (NSClassFromString(@"UIAlertController")) {
        CMBAlertController *alertController =
        [CMBAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        // OK処理
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                            style:UIAlertActionStyleDefault
                                                          handler:handler1]];
        // ダイアログを表示
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    // UIAlertControllerが使えない場合
    else {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:message];
        [alertView bk_addButtonWithTitle:NSLocalizedString(@"OK", @"OK") handler:handler2];
        alertView.bk_willShowBlock = ^(UIAlertView *alertView) {
            [self willPresentAlertView:alertView];
        };
        [alertView show];
    }
}

- (void)showConfirmDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                          handler1:(void (^)(UIAlertAction *action))handler1
                          handler2:(void (^)(void))handler2
{
    // UIAlertControllerが使える場合
    if (NSClassFromString(@"UIAlertController")) {
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
                                                          handler:handler1]];
        // ダイアログを表示
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    // UIAlertControllerが使えない場合
    else {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:title message:message];
        [alertView bk_addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel") handler:nil];
        [alertView bk_addButtonWithTitle:NSLocalizedString(@"OK", @"OK") handler:handler2];
        alertView.bk_willShowBlock = ^(UIAlertView *alertView) {
            [self willPresentAlertView:alertView];
        };
        [alertView show];
    }
}

- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                        buttons1:(NSArray *)buttons1
                        buttons2:(NSArray *)buttons2
{
    // UIAlertControllerが使える場合
    if (NSClassFromString(@"UIAlertController")) {
        CMBAlertController *alertController =
        [CMBAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        // 各処理
        for (NSDictionary *button in buttons1) {
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
    // UIAlertControllerが使えない場合
    else {
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:title];
        // 各処理
        for (NSDictionary *button in buttons2) {
            [actionSheet bk_addButtonWithTitle:button[@"title"] handler:button[@"handler"]];
        }
        // Cancel処理
        [actionSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel") handler:nil];
        // アクションシート表示
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        actionSheet.bk_willShowBlock = ^(UIActionSheet *actionSheet) {
            [self willPresentActionSheet:actionSheet];
        };
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIAlertViewDelegate like

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    UILabel *title = [alertView valueForKey:@"_titleLabel"];
    title.font = [UIFont fontWithName:@"SetoFont-SP" size:19];
    [title setTextColor:[UIColor whiteColor]];
     
    UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];
    body.font = [UIFont fontWithName:@"SetoFont-SP" size:17];
    [body setTextColor:[UIColor whiteColor]];
}

#pragma mark - UIActionSheetDelegate like

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *v in actionSheet.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *l = (UILabel *)v;
            l.font = [UIFont fontWithName:@"SetoFont-SP" size:17.f];
        }
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)v;
            b.titleLabel.font = [UIFont fontWithName:@"SetoFont-SP" size:19.f];
            [b setTitleColor:[CMBUtility tintColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Ad

- (void)showAd
{
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

@end
