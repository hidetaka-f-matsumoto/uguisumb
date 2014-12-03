
//
//  CMBMusicBoxViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxViewController.h"
#import "CMBMusicBoxTableViewCell.h"
#import "CMBMusicBoxTableViewHeadCell.h"
#import "UIColor+CMBTools.h"
#import "NSString+CMBTools.h"

@interface CMBMusicBoxViewController ()
{
    NSTimer *_timer;
    BOOL _isPlaying;
    BOOL _isStopping;
    BOOL _isFirstViewWillAppear;
    BOOL _isFirstViewDidAppear;
    CGPoint _scrollPointBegin;
    CGFloat _headViewTopConstraintConstantOriginal;
    NSMutableDictionary *_sequences; // Dictionary<NSNumber *, CMBSequenceOneData *>
    CMBSongHeaderData *_header;
}

@end

@implementation CMBMusicBoxViewController

- (void)_initFirst
{
    _isFirstViewWillAppear = YES;
    _isFirstViewDidAppear = YES;
}

- (void)_init
{
    _timer = nil;
    _isPlaying = NO;
    _isStopping = NO;
    _scrollPointBegin = CGPointZero;
    _sequences = [NSMutableDictionary dictionary];
    _header = [[CMBSongHeaderData alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initFirst];
        [self _init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;

    // UIScrollView中のコンテンツを調整
    [self adjustScrollViewContents];
    
    [self _initFirst];
    [self _init];
    
    // 通知を登録
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicBoxDidOpen:)
                                                 name:CMBCmdURLSchemeOpenMusicBox
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isFirstViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 表示更新
    [self updateViewsWithResetScroll:_isFirstViewDidAppear];
    
    _headViewTopConstraintConstantOriginal = _headViewTopConstraint.constant;
    _isFirstViewDidAppear = NO;
    
    // SoundManagerをチェック
    if (![CMBSoundManager sharedInstance].isAvailable) {
        [self showAlertDialogWithTitle:@"Sound"
                               message:@"Fail to load sound resources"
                              handler1:nil
                              handler2:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    _tableView.layoutSize = CGSizeMake(_scrollView.frame.size.width * 3.f,
                                       _scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 * UIScrollView中のコンテンツを調整
 *  AutoLayoutが効かないらしい
 *  http://blogios.stack3.net/archives/2094
 */
- (void)adjustScrollViewContents
{
    // 一旦subViewから外す
    [_tableView removeFromSuperview];
    // AutoResizingMaskを切る
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    // subViewに入れる
    [_scrollView addSubview:_tableView];
    // 制約を設定
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:0.f]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    // 楽譜名入力
    if ([segue.identifier isEqualToString:@"SongConfig"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBSongConfigViewController *vc = (CMBSongConfigViewController *)nc.topViewController;
        vc.delegate = self;
        vc.sequences = _sequences;
        vc.header = _header;
    }
    // 楽譜選択
    else if ([segue.identifier isEqualToString:@"SongManage"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBSongManageViewController *vc = (CMBSongManageViewController *)nc.topViewController;
        vc.delegate = self;
    }
}

/**
 * 表示更新
 */
- (void)updateViewsWithResetScroll:(BOOL)resetScroll
{
    if (resetScroll) {
        // スクロール初期位置
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
        _tableView.contentOffset = CGPointMake(0, 0);
    }
    // タイトル更新
    _titleLabel.text = (_header.name && 0 < _header.name.length) ? _header.name : NSLocalizedString(@"No title", @"Song title is none.");
    // オクターブ表示更新
    _octaveLabel.text = [NSString stringWithFormat:@"%zd", [self getCurrentOctave]];
    // テーブルビュー更新
    [_tableView reloadData];
}

/**
 * 1音再生
 */
- (void)playWithScale:(NSString *)scale
               octave:(NSNumber *)octave
{
    // ミュート中は鳴らさない
    if ([self isMute]) {
        return;
    }
    // 鳴らす
    CMBSoundManager *soundMan = [CMBSoundManager sharedInstance];
    [soundMan playWithInstrument:CMBSoundMusicbox scale:scale octave:octave];
}

/**
 * 再生
 */
- (void)play
{
    // フラグon
    _isPlaying = YES;
    // スクロール禁止
    [_scrollView setScrollEnabled:NO];
    [_tableView setScrollEnabled:NO];
    // ヘッダViewを非表示
    [self hideHeadView];
    // ポーズボタンに変更
    [_playButton setImage:[UIImage imageNamed:@"pause"]];
    // タイマー開始 (自動スクロール)
    if (!_timer || !_timer.isValid) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:CMBTimeDivAutoScroll
                                                  target:self
                                                selector:@selector(scrollAuto:)
                                                userInfo:nil
                                                 repeats:YES];
    }
    [_timer fire];
}

/**
 * 一時停止
 */
- (void)pause
{
    // タイマー停止
    [_timer invalidate];
    // 再生ボタンに変更
    [_playButton setImage:[UIImage imageNamed:@"play"]];
    // ヘッダViewを表示
    [self showHeadView];
    // スクロール許可
    [_scrollView setScrollEnabled:YES];
    [_tableView setScrollEnabled:YES];
    // フラグoff
    _isPlaying = NO;
}

/**
 * 停止
 */
- (void)stopWithAnimation:(BOOL)animation
{
    // 停止フラグon
    _isStopping = YES;
    
    if (_isPlaying) {
        // タイマー停止
        [_timer invalidate];
        // 再生ボタンに変更
        [_playButton setImage:[UIImage imageNamed:@"play.png"]];
    }
    // 上までスクロールする
    [_tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animation];
    // ヘッダViewを表示
    [self showHeadView];
    // スクロール許可
    [_scrollView setScrollEnabled:YES];
    [_tableView setScrollEnabled:YES];
    // 再生フラグoff
    _isPlaying = NO;
}

/**
 * ミュート中か
 */
- (BOOL)isMute
{
    return _isStopping;
}

/**
 * 再生ボタン
 */
- (IBAction)playButtonDidTap:(id)sender
{
    // 再生中の場合
    if (_isPlaying) {
        [self pause];
    }
    // 再生中でない場合
    else {
        [self play];
    }
}

/**
 * ストップボタン
 */
- (IBAction)stopButtonDidTap:(id)sender
{
    [self stopWithAnimation:YES];
}

/**
 * 共有ボタン
 */
- (IBAction)shareButtonDidTap:(id)sender
{
    [self showActionSheetWithTitle:NSLocalizedString(@"Share", @"Share")
                           message:nil
                          buttons1:@[
                                     @{@"title": NSLocalizedString(@"LINE", @"LINE"),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self sendLINE];
    }},
                                     @{@"title": NSLocalizedString(@"Mail", @"Mail"),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self sendMail];
    }}
                                     ]
                          buttons2:@[
                                     @{@"title": NSLocalizedString(@"LINE", @"LINE"),
                                       @"handler": ^(void)
                                       {
        [self sendLINE];
    }},
                                     @{@"title": NSLocalizedString(@"Mail", @"Mail"),
                                       @"handler": ^(void)
                                       {
        [self sendMail];
    }}
                                     ]
     ];
}

/**
 * メニューボタン
 */
- (IBAction)menueButtonDidTap:(id)sender
{
    [self showActionSheetWithTitle:NSLocalizedString(@"Menue", @"Menue")
                           message:nil
                          buttons1:@[
                                     @{@"title": NSLocalizedString(@"New song", @"Create a new song."),
                                       @"handler": ^(UIAlertAction *action)
    {
        [self songNewButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Config/Save song", @"Configurate/Save the song."),
                                       @"handler": ^(UIAlertAction *action)
    {
        [self songConfigButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Manage my songs", @"Manage my songs."),
                                       @"handler": ^(UIAlertAction *action)
    {
        [self songManageButtonDidTap];
    }}
                                     ]
                          buttons2:@[
                                     @{@"title": NSLocalizedString(@"New song", @"Create a new song."),
                                       @"handler": ^(void)
    {
        [self songNewButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Config/Save song", @"Configure/Save the song."),
                                       @"handler": ^(void)
    {
        [self songConfigButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Manage my songs", @"Manage my songs."),
                                       @"handler": ^(void)
    {
        [self songManageButtonDidTap];
    }}
                                     ]
     ];
}

/**
 * Song新規ボタン
 */
- (void)songNewButtonDidTap
{
    if (_isPlaying) {
        // 一時停止
        [self pause];
    }
    // パラメータ初期化
    [self _init];
    // 表示更新
    [self updateViewsWithResetScroll:YES];
}

/**
 * Song設定ボタン
 */
- (void)songConfigButtonDidTap
{
    if (_isPlaying) {
        [self pause];
    }
    [self performSegueWithIdentifier:@"SongConfig"
                              sender:self];
}

/**
 * Song管理ボタン
 */
- (void)songManageButtonDidTap
{
    if (_isPlaying) {
        [self pause];
    }
    [self performSegueWithIdentifier:@"SongManage"
                              sender:self];
}

/**
 * 自動スクロール
 */
- (void)scrollAuto:(NSTimer*)timer
{
    CGPoint offset = _tableView.contentOffset;
    offset.y += (CMBMusicBoxTableViewCellHeight * _header.speed.floatValue * 4 * CMBTimeDivAutoScroll / 60.0f);
    // 曲中
    if (offset.y < _tableView.contentSize.height) {
        _tableView.contentOffset = offset;
    }
    // 曲終わり
    else {
        [self playButtonDidTap:nil];
    }
}

- (void)showHeadView
{
    // Ensures that all pending layout operations have been completed
    [self.view layoutIfNeeded];
    // 制約を元に戻す
    _headViewTopConstraint.constant = _headViewTopConstraintConstantOriginal;
    [UIView animateWithDuration:0.2f
                     animations:^(void)
     {
         // Forces the layout of the subtree animation block and then captures all of the frame changes
         [self.view layoutIfNeeded];
     }];
}

- (void)hideHeadView
{
    // Ensures that all pending layout operations have been completed
    [self.view layoutIfNeeded];
    // 画面外に出るよう Auto Layout の制約を設定
    _headViewTopConstraint.constant = -1.f * _headView.frame.size.height;
    [UIView animateWithDuration:0.4f
                     animations:^(void)
     {
         // Forces the layout of the subtree animation block and then captures all of the frame changes
         [self.view layoutIfNeeded];
     }];
}

- (NSInteger)getCurrentOctave
{
    NSInteger page = _scrollView.contentOffset.x / (NSInteger)_scrollView.frame.size.width;
    return CMBOctaveMin + page;
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
            numberOfRows = CMBSequenceTimeMax;
            break;
        case 2:
            numberOfRows = 1;
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
        {
            CMBMusicBoxTableViewHeadCell *mbhCell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewHeadCell" forIndexPath:indexPath];
            mbhCell.layoutSize = [self sizeOfMusicBoxHeadCell];
            cell = mbhCell;
            break;
        }
        case 1:
        {
            CMBMusicBoxTableViewCell *mbCell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewCell" forIndexPath:indexPath];
            mbCell.delegate = self;
            mbCell.parentTableView = _tableView;
            mbCell.tineView = _tineView;
            [mbCell updateWithSequenceOne:_sequences[[NSNumber numberWithInteger:indexPath.row]]
                                    color:[self cellColorWithRow:indexPath.row]];
            mbCell.layoutSize = [self sizeOfMusicBoxCell];
            cell = mbCell;
            break;
        }
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewFootCell" forIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIColor *)cellColorWithRow:(NSInteger)row
{
    UIColor *d1Color;
    UIColor *d2Color;
    if (0 == row / _header.division1.integerValue % 2) {
        d1Color = [UIColor whiteColor];
    } else {
        d1Color = [CMBUtility greenColor];
    }
    if (0 == row / _header.division1.integerValue / _header.division2.integerValue % 2) {
        d2Color = [UIColor whiteColor];
    } else {
        d2Color = [CMBUtility lightBrownColor];
    }
    return [[d1Color blendWithColor:d2Color alpha:0.5f] changeAlpha:0.25f];
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0:
            height = CMBMusicBoxTableViewHeadCellHeight;
            break;
        case 1:
            height = CMBMusicBoxTableViewCellHeight;
            break;
        case 2:
            height = CMBMusicBoxTableViewFootCellHeight;
            break;
        default:
            break;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - UIScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    BOOL isScrollable;
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        // 停止
        [self stopWithAnimation:YES];
        // 標準スクロールはしない
        isScrollable = NO;
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
        isScrollable = NO;
    }
    return isScrollable;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        _isStopping = NO;
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        // スクロール開始位置を記録
        _scrollPointBegin = [scrollView contentOffset];
        // ヘッダViewを非表示
        [self hideHeadView];
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
        // 縦スクロール禁止
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0.0f;
        scrollView.contentOffset = offset;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        if (!decelerate) {
            // ヘッダViewを表示
            [self showHeadView];
        }
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
        // オクターブ表示更新
        _octaveLabel.text = [NSString stringWithFormat:@"%zd", [self getCurrentOctave]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        // ヘッダViewを表示
        [self showHeadView];
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
        // オクターブ表示更新
        _octaveLabel.text = [NSString stringWithFormat:@"%zd", [self getCurrentOctave]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        for (UITableViewCell *cell in [_tableView visibleCells]) {
            if (![cell isKindOfClass:[CMBMusicBoxTableViewCell class]]) {
                continue;
            }
            CMBMusicBoxTableViewCell *mbCell = (CMBMusicBoxTableViewCell *)cell;
            [mbCell process];
        }
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 停止中フラグonならoffにする
    if (_isStopping) {
        _isStopping = NO;
    }
}

#pragma mark - CMBMusicBoxTableViewCellDelegate

/**
 * セルのサイズを返す
 */
- (CGSize)sizeOfMusicBoxHeadCell
{
    return CGSizeMake(_tableView.frame.size.width, CMBMusicBoxTableViewHeadCellHeight);
}

/**
 * セルのサイズを返す
 */
- (CGSize)sizeOfMusicBoxCell
{
    return CGSizeMake(_tableView.frame.size.width, CMBMusicBoxTableViewCellHeight);
}

/**
 * 1オクターブのサイズを返す
 */
- (CGSize)sizeOfOctave
{
    return CGSizeMake(_scrollView.frame.size.width, CMBMusicBoxTableViewCellHeight);
}

/**
 * 音符がタップされた
 */
- (void)noteDidTapWithInfo:(NSMutableDictionary *)info
{
    if (!info) {
        return;
    }
    BOOL isTapOn = [info[@"isTapOn"] boolValue];
    // 音を再生
    if (isTapOn) {
        [self playWithScale:info[CMBNoteInfoKeyScale]
                     octave:info[CMBNoteInfoKeyOctave]];
    }
    // シーケンスを更新
    NSIndexPath *indexPath = (NSIndexPath *)info[@"indexPath"];
    CMBSequenceOneData *seqOneData = _sequences[[NSNumber numberWithInteger:indexPath.row]];
    // シーケンスデータが新規の場合
    if (!seqOneData) {
        seqOneData = [CMBSequenceOneData sequenceOneData];
        [_sequences setObject:seqOneData forKey:[NSNumber numberWithInteger:indexPath.row]];
    }
    CMBNoteData *noteData = [[CMBNoteData alloc] initWithInfo:info];
    // TapOnの場合: 追加
    if (isTapOn) {
        [seqOneData addNoteData:noteData];
    }
    // TapOffの場合: 削除
    else {
        [seqOneData removeNoteData:noteData];
    }
}

/**
 * 音符が弾かれた
 */
- (void)notesDidPickWithInfos:(NSArray *)infos
{
    for (NSDictionary *info in infos) {
        [self playWithScale:info[CMBNoteInfoKeyScale]
                     octave:info[CMBNoteInfoKeyOctave]];
    }
}

#pragma mark - CMBSongSaveDelegate

- (void)songDidSaveWithName:(NSString *)name
{
    // nothing to do.
}

#pragma mark - CMBSongManageDelegate

- (void)songDidLoadWithSequence:(NSMutableDictionary *)sequences
                         header:(CMBSongHeaderData *)header
{
    // データ更新
    _sequences = sequences;
    _header = header;
    // 表示更新
    [self updateViewsWithResetScroll:YES];
}

#pragma mark - CMBCmdURLSchemeOpenMusicBox

- (void)musicBoxDidOpen:(NSNotification *)notif
{
    NSDictionary *error = notif.userInfo[@"error"];
    if (error) {
        [self showAlertDialogWithTitle:error[@"title"]
                               message:error[@"message"]
                              handler1:nil
                              handler2:nil];
    }
    // データ更新
    _sequences = notif.userInfo[@"sequences"];
    _header = notif.userInfo[@"header"];
    // 表示更新
    [self updateViewsWithResetScroll:YES];
}

#pragma mark - Mail

/**
 * メールで送信
 */
- (void)sendMail
{
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // エンコード
    NSString *songEncoded = songJson.encodedSongStr;
    // URLスキームを作成
    NSString *url = [@"craftedmb://mb/load?song=" stringByAppendingString:songEncoded];
    // 本文を作成
    NSString *message = [@"https://itunes.apple.com/jp/app/todo:fix/todo:fix?mt=8\n\n" stringByAppendingString:url];
    // メール送信画面を表示
    MFMailComposeViewController *mailPicker = [MFMailComposeViewController new];
    [mailPicker setSubject:NSLocalizedString(@"This is my music box.", @"The subject of the mail to send the song.")];
    [mailPicker setMessageBody:message isHTML:NO];
    mailPicker.bk_completionBlock = ^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
        switch (result) {
            case MFMailComposeResultCancelled: // キャンセル
                break;
            case MFMailComposeResultSaved: // 下書き保存
                break;
            case MFMailComposeResultSent: // 送信成功
                break;
            case MFMailComposeResultFailed:// 送信失敗
                [self showAlertDialogWithTitle:NSLocalizedString(@"Mail", @"Mail")
                                       message:NSLocalizedString(@"Failed to send the mail.", @"The message when you failed to send the mail.")
                                      handler1:nil
                                      handler2:nil];
                break;
            default:
                break;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:mailPicker animated:TRUE completion:nil];
}

#pragma mark - LINE

/**
 * LINEで送信
 */
- (void)sendLINE
{
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // エンコード
    NSString *songEncoded = songJson.encodedSongStr;
    // URLスキームを作成
    NSString *message = [@"craftedmb://mb/load?song=" stringByAppendingString:songEncoded];
    // LINE URLを作成
    NSString *lineUrl = [@"http://line.me/R/msg/text/?" stringByAppendingString:message];
    // 投稿
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lineUrl]];
}

#pragma mark - Debug.

- (void)soundTest
{
    [self playWithScale:@"C" octave:[NSNumber numberWithInteger:4]];
}

@end
