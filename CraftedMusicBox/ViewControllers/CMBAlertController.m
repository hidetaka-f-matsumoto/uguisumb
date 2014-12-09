//
//  CMBAlertController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/12/09.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBAlertController.h"
#import "CMBUtility.h"

@interface CMBAlertController ()

@end

@implementation CMBAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // レイアウト設定
    self.view.tintColor = [CMBUtility tintColor];
    // フォントのカスタマイズは無理っぽい...
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

@end
