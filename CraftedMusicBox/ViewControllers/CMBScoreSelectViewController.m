//
//  CMBScoreSelectViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBScoreSelectViewController.h"
#import "CMBUtility.h"
#import "CMBScoreSelectTableViewCell.h"

@interface CMBScoreSelectViewController ()
{
    NSMutableArray *_scoreInfos;
}

@end

@implementation CMBScoreSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _scoreInfos = [[CMBUtility sharedInstance] getScoreInfos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _scoreInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ScoreSelectTableViewCell";
    CMBScoreSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setupWithScoreInfo:_scoreInfos[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択されたセルを取得
    CMBScoreSelectTableViewCell *cell = (CMBScoreSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [_delegate scoreDidSelectWithInfo:cell.scoreInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
