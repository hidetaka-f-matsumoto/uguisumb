//
//  CMBSongConfigViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongConfigViewController.h"
#import "CMBUtility.h"
#import "CMBSoundManager.h"
#import "CMBSongConfigTableViewController.h"

@interface CMBSongConfigViewController ()
{
    CMBSongConfigTableViewController* _tableViewController;
}
@end

@implementation CMBSongConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_tableViewController resetWithHeader:_header];
}

- (void)dealloc
{
    // 通知の登録解除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"embededTableView"]) {
        _tableViewController = segue.destinationViewController;
    }
}

- (void)applyConfig
{
    [_tableViewController copyConfigToHeader:_header];
    [CMBSoundManager sharedInstance].instrument = _header.instrument;
}

- (IBAction)applyButtonDidTap:(id)sender
{
    // 適用
    [self applyConfig];
    // 閉じる
    [self dismissViewControllerAnimated:YES
                             completion:^(void) {
                                 // デリゲートに通知
                                 [_delegate songDidConfigureWithSave:NO];
                             }];
}

- (IBAction)applyAndSaveButtonDidTap:(id)sender
{
    // 適用
    [self applyConfig];
    // 閉じる
    [self dismissViewControllerAnimated:YES
                             completion:^(void) {
                                 // デリゲートに通知
                                 [_delegate songDidConfigureWithSave:YES];
                             }];
}

@end
