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
    _tempoSlider.minimumValue = CMBTempoMin;
    _tempoSlider.maximumValue = CMBTempoMax;
    [_tempoSlider addTarget:self action:@selector(tempoSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _tempoStepper.minimumValue = CMBTempoMin;
    _tempoStepper.maximumValue = CMBTempoMax;
    _tempoStepper.stepValue = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _nameText.text = _header.name;
    _tempoLabel.text = [NSString stringWithFormat:@"%zd", _header.tempo.integerValue];
    _tempoSlider.value = _header.tempo.floatValue;
    _tempoStepper.value = _header.tempo.floatValue;
    [_divisionControl setSelectedSegmentIndex:[CMBDivisions indexOfObject:_header.division]];
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
    _header.tempo = [NSNumber numberWithInteger:(NSInteger)_tempoSlider.value];
    _header.division = CMBDivisions[_divisionControl.selectedSegmentIndex];
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
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Save song"
                                        message:[NSString stringWithFormat:@"You wanna save %@?", _nameText.text]
                                 preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
    {
        [self applyConfig];
        // 保存実行
        BOOL isSuccess = [[CMBUtility sharedInstance] saveSongWithSequences:_sequences
                                                                     header:_header
                                                                   fileName:_nameText.text];
        if (!isSuccess) {
            // 失敗
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Save song"
                                                message:[NSString stringWithFormat:@"Fail to save %@.", _nameText.text]
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }
        // 閉じる
        [self dismissViewControllerAnimated:YES
                                 completion:^(void)
        {
            [_delegate songDidSaveWithName:_nameText.text];
        }];
    }]];
    // Cancel処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    // ダイアログを表示
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (IBAction)tempoStepperDidTap:(id)sender
{
    _tempoLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_tempoStepper.value];
    _tempoSlider.value = _tempoStepper.value;
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
    _tempoLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_tempoSlider.value];
    _tempoStepper.value = _tempoSlider.value;
}

@end
