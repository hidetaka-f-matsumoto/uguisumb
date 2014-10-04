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
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SetoFont-SP" size:19.0]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[CMBUtility tintColor]];
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
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
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
        [alertView bk_addButtonWithTitle:@"OK" handler:handler2];
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
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        // OK処理
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
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
        [alertView bk_addButtonWithTitle:@"Cancel" handler:nil];
        [alertView bk_addButtonWithTitle:@"OK" handler:handler2];
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
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
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
        [actionSheet bk_setCancelButtonWithTitle:@"Cancel" handler:nil];
        // アクションシート表示
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [actionSheet showInView:self.view];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    UILabel *title = [alertView valueForKey:@"_titleLabel"];
    title.font = [UIFont fontWithName:@"SetoFont-SP" size:19];
    [title setTextColor:[UIColor whiteColor]];
     
    UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];
    body.font = [UIFont fontWithName:@"SetoFont-SP" size:17];
    [body setTextColor:[UIColor whiteColor]];
}

@end
