//
//  CMBSongConfigViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongConfigViewController.h"
#import "CMBUtility.h"

@interface CMBSongConfigViewController ()

@end

@implementation CMBSongConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameText.delegate = self;
    _speedSlider.minimumValue = CMBSpeedMin;
    _speedSlider.maximumValue = CMBSpeedMax;
    [_speedSlider addTarget:self action:@selector(tempoSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _speedStepper.minimumValue = CMBSpeedMin;
    _speedStepper.maximumValue = CMBSpeedMax;
    _speedStepper.stepValue = 1;
    
    // 通知を登録
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicBoxDidOpen:)
                                                 name:CMBCmdURLSchemeOpenMusicBox
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _nameText.text = _header.name;
    _speedLabel.text = [NSString stringWithFormat:@"%zd", _header.speed.integerValue];
    _speedSlider.value = _header.speed.floatValue;
    _speedStepper.value = _header.speed.floatValue;
    [_division1Control setSelectedSegmentIndex:[CMBDivisions indexOfObject:_header.division1]];
    [_division2Control setSelectedSegmentIndex:[CMBDivisions indexOfObject:_header.division2]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)applyConfig
{
    _header.name = _nameText.text;
    _header.speed = [NSNumber numberWithInteger:(NSInteger)_speedSlider.value];
    _header.division1 = CMBDivisions[_division1Control.selectedSegmentIndex];
    _header.division2 = CMBDivisions[_division2Control.selectedSegmentIndex];
}

- (void)saveSong
{
    [self applyConfig];
    // 保存実行
    BOOL isSuccess = [[CMBUtility sharedInstance] saveSongWithSequences:_sequences
                                                                 header:_header
                                                               fileName:_nameText.text];
    if (!isSuccess) {
        // 失敗
        NSString *title = NSLocalizedString(@"Save song", @"Save song.");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Fail to save %@.", @"The message when you failed to save the song with name %@."), _nameText.text];
        // 通知ダイアログ
        [self showAlertDialogWithTitle:title
                               message:message
                              handler1:nil
                              handler2:nil];
    }
    // 閉じる
    [self dismissViewControllerAnimated:YES
                             completion:^(void)
     {
         [_delegate songDidSaveWithName:_nameText.text];
     }];
}

- (IBAction)applyButtonDidTap:(id)sender
{
    [self applyConfig];
    // 閉じる
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)saveButtonDidTap:(id)sender
{
    // 確認ダイアログ
    NSString *title = NSLocalizedString(@"Save song", @"Save song");
    NSString *message = [NSString stringWithFormat:
                         NSLocalizedString(@"You wanna save %@?",
                                           @"The message to confirm you want to save the song with name %@."),
                         _nameText.text];
    [self showConfirmDialogWithTitle:title
                             message:message
                            handler1:^(UIAlertAction *action) {
                                [self saveSong];
                            }
                            handler2:^(void) {
                                [self saveSong];
                            }];
}

- (IBAction)speedStepperDidTap:(id)sender
{
    _speedLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_speedStepper.value];
    _speedSlider.value = _speedStepper.value;
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UISlider

- (void)tempoSliderDidChange:(id)sender
{
    _speedLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_speedSlider.value];
    _speedStepper.value = _speedSlider.value;
}

#pragma mark - CMBCmdURLSchemeOpenMusicBox

- (void)musicBoxDidOpen:(NSNotification *)notif
{
    // 閉じる
    [self closeButtonDidTap:nil];
}

@end
