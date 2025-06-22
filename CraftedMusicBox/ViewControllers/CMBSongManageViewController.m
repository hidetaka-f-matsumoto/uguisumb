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

// Replaced rightButtons method with native iOS swipe actions in tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:

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

#pragma mark - UITableViewDelegate Swipe Actions

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0))
{
    if (indexPath.section != 1) {
        return nil;
    }
    
    CMBSongManageTableViewCell *songCell = (CMBSongManageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // Load action
    UIContextualAction *loadAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                             title:NSLocalizedString(@"Load", @"Load")
                                                                           handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *title = NSLocalizedString(@"Load song", @"Load song");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You wanna load %@?", @"The message to confirm you want to load the song with name %@."), songCell.info[@"name"]];
        [self showConfirmDialogWithTitle:title
                                 message:message
                                 handler:^(UIAlertAction *alertAction) {
                                     [self loadSongWithInfo:songCell.info];
                                     completionHandler(YES);
                                 }];
    }];
    loadAction.backgroundColor = [CMBUtility greenColor];
    
    // Delete action
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                               title:NSLocalizedString(@"Delete", @"Delete")
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *title = NSLocalizedString(@"Delete song", @"Delete song");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You wanna delete %@?", @"The message to confirm you want to delete the song with name %@."), songCell.info[@"name"]];
        [self showConfirmDialogWithTitle:title
                                 message:message
                                 handler:^(UIAlertAction *alertAction) {
                                     [self deleteSongWithInfo:songCell.info indexPath:indexPath];
                                     completionHandler(YES);
                                 }];
    }];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, loadAction]];
    configuration.performsFirstActionWithFullSwipe = NO;
    return configuration;
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
                               handler:nil];
        return;
    }
    // 画面を閉じてデリゲートに通知する
    [self dismissViewControllerAnimated:YES completion:^(void) {
        [self->_delegate songDidLoadWithSequence:sequences
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
                               handler:nil];
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
