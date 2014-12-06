//
//  CMBBaseViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBBaseViewController.h"
#import "CMBUtility.h"

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
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
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
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
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
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
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
    [self.view addSubview:_bannerView];
    // リクエストを行って広告を読み込む
    GADRequest *request = [GADRequest request];
    request.testDevices = @[
                            // Simulator.
                            @"AF792C6C-3226-4114-9E53-E9ADE7D6FCEA",
                            @"C981A502-8B6D-4A1A-B249-ECDC1E37CC18",
                            @"B6DB8359-BC00-491A-8A1F-CEDE4208F4DE",
                            @"3B1168F7-3EA4-4889-AF2F-4B90990B3205",
                            @"0CFF5841-98FD-475F-9159-1ABFD747C6F5",
                            @"6446FEB2-536A-41DB-995F-C2F73E36F273",
                            @"8491ECD9-3D64-4D5E-BEDF-B68473B86D2E",
                            @"C26D8D71-E535-4E34-B4A9-5CCB0B93986D",
                            @"16152A21-1AD6-4C75-B2B2-0F86C47C6AD0",
                            @"6A16B727-3C0D-46E6-9F2C-2B1882B13FEC",
                            @"0E42C692-84E8-47D3-B41A-B95760732B10",
                            @"95328680-4B91-415C-8A55-01B5E3F2FBAD",
                            @"333196B4-A2D2-4296-ABE0-7EE4F9F7F790",
                            @"BB73EF51-F77D-4C6C-AE2A-B007C8C50F6C",
                            @"176A4F1D-B753-4DB0-813D-32213F476061",
                            @"989774E1-13AF-4CD2-9EF6-020C022D90E3",
                            // Test device.
                            @"8a493a070654bb7ceb8a286cdc0a8a6de9349427",
                            ];
    [_bannerView loadRequest:request];
    // Autolayout 制約を設定
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:_bannerView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.view
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.f
                                   constant:0.f]];
}

- (void)hideAd
{
    [_bannerView removeFromSuperview];
    _bannerView = nil;
}

@end
