//
//  CMBBaseViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBBaseViewController.h"
#import "CMBUtility.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

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
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                           cancelButtonItem:nil
                           otherButtonItems:[RIButtonItem itemWithLabel:@"OK" action:handler2]
          , nil] show];
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
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"OK" action:handler2]
          , nil] show];
    }
}

@end
