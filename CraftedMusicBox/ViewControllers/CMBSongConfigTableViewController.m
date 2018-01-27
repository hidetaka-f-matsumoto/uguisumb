//
//  CMBSongConfigTableViewController.m
//  CraftedMusicBox
//
//  Created by Hidetaka Matsumoto on 2018/01/24.
//  Copyright © 2018年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongConfigTableViewController.h"

@interface CMBSongConfigTableViewController ()

@end

@implementation CMBSongConfigTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameText.delegate = self;
    _composerText.delegate = self;
    _speedSlider.minimumValue = CMBSpeedMin;
    _speedSlider.maximumValue = CMBSpeedMax;
    [_speedSlider addTarget:self action:@selector(tempoSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _speedStepper.minimumValue = CMBSpeedMin;
    _speedStepper.maximumValue = CMBSpeedMax;
    _speedStepper.stepValue = 1;
}

- (void)didReceiveMemoryWarning {
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

- (void)resetWithHeader:(CMBSongHeaderData *)header {
    _nameText.text = header.name;
    _composerText.text = header.composer;
    _speedLabel.text = [NSString stringWithFormat:@"%zd", header.speed.integerValue];
    _speedSlider.value = header.speed.floatValue;
    _speedStepper.value = header.speed.floatValue;
    [_division1Control setSelectedSegmentIndex:[CMBDivisions indexOfObject:header.division1]];
    [_division2Control setSelectedSegmentIndex:[CMBDivisions indexOfObject:header.division2]];
    [_scaleControl setSelectedSegmentIndex:[CMBScaleNameKeys indexOfObject:header.scaleMode]];
    [_instrumentControl setSelectedSegmentIndex:[CMBInstruments indexOfObject:header.instrument]];
}

- (void)copyConfigToHeader:(CMBSongHeaderData *)header {
    header.name = _nameText.text;
    header.composer = _composerText.text;
    header.speed = [NSNumber numberWithInteger:(NSInteger)_speedSlider.value];
    header.division1 = CMBDivisions[_division1Control.selectedSegmentIndex];
    header.division2 = CMBDivisions[_division2Control.selectedSegmentIndex];
    header.scaleMode = CMBScaleNameKeys[_scaleControl.selectedSegmentIndex];
    header.instrument = CMBInstruments[_instrumentControl.selectedSegmentIndex];
}

- (IBAction)speedStepperDidTap:(id)sender
{
    _speedLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_speedStepper.value];
    _speedSlider.value = _speedStepper.value;
}

#pragma mark - UISlider

- (void)tempoSliderDidChange:(id)sender
{
    _speedLabel.text = [NSString stringWithFormat:@"%zd", (NSInteger)_speedSlider.value];
    _speedStepper.value = _speedSlider.value;
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

@end
