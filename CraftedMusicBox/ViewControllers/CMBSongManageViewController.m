//
//  CMBSongManageViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBSongManageViewController.h"
#import "CMBUtility.h"
#import "CMBSongManageTableViewCell.h"

@interface CMBSongManageViewController ()
{
    NSMutableArray *_songInfos;
}

@end

@implementation CMBSongManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _songInfos = [[CMBUtility sharedInstance] getSongInfos];
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.1f green:0.78f blue:0.1f alpha:1.0]
                                                title:@"Load"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _songInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SongManageTableViewCell";
    CMBSongManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setupWithSongInfo:_songInfos[indexPath.row]];
    // SWTableViewCell
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
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
}

#pragma mark - SWTableViewCellDelegate

- (void)        swipeableTableViewCell:(SWTableViewCell *)cell
 didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    CMBSongManageTableViewCell *songCell = (CMBSongManageTableViewCell *)cell;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:songCell];
    switch (index) {
        case 0:
            // Load button was pressed;
            [self loadSongWithInfo:songCell.info];
            break;
        case 1:
            // Delete button was pressed
            [self deleteSongWithInfo:songCell.info indexPath:cellIndexPath];
            break;
        default:
            break;
    }
}

- (void)loadSongWithInfo:(NSDictionary *)songInfo
{
    // 確認ダイアログ
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Load song"
                                        message:[NSString stringWithFormat:@"You wanna load %@?", songInfo[@"name"]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
    {
        // シーケンス、ヘッダを読み込み
        NSMutableDictionary *sequences;
        CMBSongHeaderData *header;
        BOOL isSuccess = [[CMBUtility sharedInstance] loadSongWithSequences:&sequences
                                                                     header:&header
                                                                   fileName:songInfo[@"name"]];
        if (!isSuccess) {
            // 失敗
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Load song"
                                                message:[NSString stringWithFormat:@"Fail to load %@.", songInfo[@"name"]]
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
            return;
        }
        // 画面を閉じてデリゲートに通知する
        [self dismissViewControllerAnimated:YES completion:^(void) {
            [_delegate songDidLoadWithSequence:sequences
                                        header:header];
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

- (void)deleteSongWithInfo:(NSDictionary *)songInfo
                 indexPath:(NSIndexPath *)indexPath
{
    // 確認ダイアログ
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Delete song"
                                        message:[NSString stringWithFormat:@"You wanna delete %@?", songInfo[@"name"]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
    {
        BOOL isSuccess = [[CMBUtility sharedInstance] deleteSongWithFileName:songInfo[@"name"]];
        if (!isSuccess) {
            // 失敗
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Delete song"
                                                message:[NSString stringWithFormat:@"Fail to delete %@.", songInfo[@"name"]]
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
            return;
        }
        // 表示更新
        [_songInfos removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
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

@end
