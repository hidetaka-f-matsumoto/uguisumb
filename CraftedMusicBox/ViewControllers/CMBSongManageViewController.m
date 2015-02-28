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
    NSAttributedString *loadStr =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Load", @"Load")
                                    attributes:@{
                                                 NSFontAttributeName : [CMBUtility fontForButton],
                                                 NSForegroundColorAttributeName : [CMBUtility whiteColor],
                                                 }];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[CMBUtility greenColor]
                                      attributedTitle:loadStr];
    NSAttributedString *deleteStr =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Delete", @"Delete")
                                    attributes:@{
                                                 NSFontAttributeName : [CMBUtility fontForButton],
                                                 NSForegroundColorAttributeName : [CMBUtility whiteColor],
                                                 }];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[CMBUtility redColor]
                                      attributedTitle:deleteStr];
    
    return rightUtilityButtons;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
            numberOfRows = _songInfos.count;
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SongManageTableViewHeadCell"];
            break;
        case 1:
        {
            CMBSongManageTableViewCell *smCell = [tableView dequeueReusableCellWithIdentifier:@"SongManageTableViewCell"];
            [smCell setupWithSongInfo:_songInfos[indexPath.row]];
            // SWTableViewCell
            smCell.rightUtilityButtons = [self rightButtons];
            smCell.delegate = self;
            cell = smCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        {
            // Load button was pressed
            NSString *title = NSLocalizedString(@"Load song", @"Load song");
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You wanna load %@?", @"The message to confirm you want to load the song with name %@."), songCell.info[@"name"]];
            [self showConfirmDialogWithTitle:title
                                     message:message
                                    handler1:^(UIAlertAction *action) {
                                        [self loadSongWithInfo:songCell.info];
                                    }
                                    handler2:^(void) {
                                        [self loadSongWithInfo:songCell.info];
                                    }];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSString *title = NSLocalizedString(@"Delete song", @"Delete song");
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You wanna delete %@?", @"The message to confirm you want to delete the song with name %@."), songCell.info[@"name"]];
            [self showConfirmDialogWithTitle:title
                                     message:message
                                    handler1:^(UIAlertAction *action) {
                                        [self deleteSongWithInfo:songCell.info indexPath:cellIndexPath];
                                    }
                                    handler2:^(void) {
                                        [self deleteSongWithInfo:songCell.info indexPath:cellIndexPath];
                                    }];
            break;
        }
        default:
            break;
    }
}

- (void)loadSongWithInfo:(NSDictionary *)songInfo
{
    // シーケンス、ヘッダを読み込み
    NSMutableDictionary *sequences;
    CMBSongHeaderData *header;
    BOOL isSuccess = [[CMBUtility sharedInstance] loadSongWithSequences:&sequences
                                                                 header:&header
                                                               fileName:songInfo[@"name"]];
    if (!isSuccess) {
        // 失敗
        NSString *title = NSLocalizedString(@"Load song", @"Load song");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Failed to load %@.", @"The message when you failed to load the song with name %@."), songInfo[@"name"]];
        [self showAlertDialogWithTitle:title
                               message:message
                              handler1:nil
                              handler2:nil];
        return;
    }
    // 画面を閉じてデリゲートに通知する
    [self dismissViewControllerAnimated:YES completion:^(void) {
        [_delegate songDidLoadWithSequence:sequences
                                    header:header];
    }];
}

- (void)deleteSongWithInfo:(NSDictionary *)songInfo
                 indexPath:(NSIndexPath *)indexPath
{
    BOOL isSuccess = [[CMBUtility sharedInstance] deleteSongWithFileName:songInfo[@"name"]];
    if (!isSuccess) {
        // 失敗
        NSString *title = NSLocalizedString(@"Delete song", @"Delete song");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Failed to delete %@.", @"The message when failed to delete the song with name %@"), songInfo[@"name"]];
        [self showAlertDialogWithTitle:title
                               message:message
                              handler1:nil
                              handler2:nil];
        return;
    }
    // 表示更新
    [_songInfos removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    // デリゲートに通知
    [_delegate songDidDeleteWithFileName:songInfo[@"name"]];
}

@end
