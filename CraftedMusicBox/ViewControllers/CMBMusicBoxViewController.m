
//
//  CMBMusicBoxViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxViewController.h"
#import "CMBMusicBoxTableViewCell.h"
#import "CMBUtility.h"

@interface CMBMusicBoxViewController ()
{
    NSTimer *_timer;
    BOOL _isPlaying;
    BOOL _isFirstViewWillAppear;
    BOOL _isFirstViewDidAppear;
    CGPoint _scrollPointBegin;
    CGRect _headViewOriginalFrame;
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
    _scrollPointBegin = CGPointZero;
    _sequences = [NSMutableDictionary dictionary];
    _header = [[CMBSongHeaderData alloc] init];
}

- (void)loadSounds
{
    _sounds = [NSMutableDictionary dictionary];
    NSURL *url;
    NSBundle *mb = [NSBundle mainBundle];
    SystemSoundID sound;
    
    for (NSInteger i=CMBOctaveMin; i<=CMBOctaveMax; i++) {
        NSMutableDictionary *soundsInOctave = [NSMutableDictionary dictionary];
        for (NSString *scaleKey in CMBScales) {
            // TODO: 読み込みを体系化
        }
        url = [NSURL fileURLWithPath:[mb pathForResource:@"xylophone.C4" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        [soundsInOctave setObject:[NSNumber numberWithLong:sound] forKey:CMBScales[0]];
        url = [NSURL fileURLWithPath:[mb pathForResource:@"xylophone.C4s" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        [soundsInOctave setObject:[NSNumber numberWithLong:sound] forKey:CMBScales[1]];
        url = [NSURL fileURLWithPath:[mb pathForResource:@"xylophone.D4" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        [soundsInOctave setObject:[NSNumber numberWithLong:sound] forKey:CMBScales[2]];
        url = [NSURL fileURLWithPath:[mb pathForResource:@"xylophone.D4s" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        [soundsInOctave setObject:[NSNumber numberWithLong:sound] forKey:CMBScales[3]];
        url = [NSURL fileURLWithPath:[mb pathForResource:@"xylophone.E4" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        [soundsInOctave setObject:[NSNumber numberWithLong:sound] forKey:CMBScales[4]];

        _sounds[[NSNumber numberWithInteger:i]] = soundsInOctave;
    }
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
    _tableView.delegate = self;
    _tableView.dataSource = self;

    // UIScrollView中のコンテンツを調整
    [self adjustScrollViewContents];
    
    [self _initFirst];
    [self _init];
    [self loadSounds];
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
    
    _headViewOriginalFrame = _headView.frame;
    _isFirstViewDidAppear = NO;
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
                                                           multiplier:1.0f
                                                             constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0f
                                                             constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:0]];
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
    _titleLabel.text = _header.name;
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
    SystemSoundID sound = [_sounds[octave][scale] unsignedIntValue];
    if (sound) {
        AudioServicesPlaySystemSound(sound);
    }
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
    [_playButton setImage:[UIImage imageNamed:@"pause.png"]];
    // タイマー開始 (自動スクロール)
    if (!_timer) {
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
    [_playButton setImage:[UIImage imageNamed:@"play.png"]];
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
    if (_isPlaying) {
        // タイマー停止
        [_timer invalidate];
        // 再生ボタンに変更
        [_playButton setImage:[UIImage imageNamed:@"play.png"]];
    }
    // タイマー破棄
    _timer = nil;
    // 上までスクロールする
    [_tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animation];
    // ヘッダViewを表示
    [self showHeadView];
    // スクロール許可
    [_scrollView setScrollEnabled:YES];
    [_tableView setScrollEnabled:YES];
    // フラグoff
    _isPlaying = NO;
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
 * メニューボタン
 */
- (IBAction)menueButtonDidTap:(id)sender
{
    UIActionSheet *sheet =[[UIActionSheet alloc]
                           initWithTitle:@"Menue"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"New song", @"Config song", @"Manage songs", nil];
    
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [sheet showInView:self.view];
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
    offset.y = offset.y + (CMBMusicBoxTableViewCellHeight * _header.tempo.floatValue * 4 * CMBTimeDivAutoScroll / 60.0f);
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
    [UIView animateWithDuration:0.2f
                     animations:^(void)
     {
         _headView.frame = _headViewOriginalFrame;
     }];
}

- (void)hideHeadView
{
    [UIView animateWithDuration:0.4f
                     animations:^(void)
     {
         _headView.frame = CGRectMake(0,
                                      -1 * _headView.frame.size.height,
                                      _headView.frame.size.width,
                                      _headView.frame.size.height);
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
            numberOfRows = 100;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewHeadCell"];
            break;
        case 1:
        {
            CMBMusicBoxTableViewCell *mbCell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewCell"];
            mbCell.delegate = self;
            mbCell.parentTableView = _tableView;
            mbCell.tineView = _tineView;
            [mbCell updateWithSequenceOne:_sequences[[NSNumber numberWithInteger:indexPath.row]]];
            cell = mbCell;
            break;
        }
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewFootCell"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:
            height = 88.0f;
            break;
        case 1:
            height = CMBMusicBoxTableViewCellHeight;
            break;
        case 2:
            height = 88.0f;
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

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // オルゴールテーブルの場合
    if (scrollView == _tableView) {
        // ヘッダViewを表示
        [self showHeadView];
    }
    // ページング用スクロールの場合
    else if (scrollView == _scrollView) {
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

#pragma mark - UIActionSheetDelegate

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *v in actionSheet.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *l = (UILabel *)v;
            l.font = [UIFont fontWithName:@"SetoFont-SP" size:17.f];
        }
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)v;
            b.titleLabel.font = [UIFont fontWithName:@"SetoFont-SP" size:19.f];
            [b setTitleColor:[CMBUtility tintColor] forState:UIControlStateNormal];
        }
    }
}

-   (void)actionSheet:(UIActionSheet *)actionSheet
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        // nothing to do.
    }else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // nothing to do.
    }else{
        switch (buttonIndex) {
            case 0: // New song.
                [self songNewButtonDidTap];
                break;
            case 1: // Config this song.
                [self songConfigButtonDidTap];
                break;
            case 2: // Manage songs.
                [self songManageButtonDidTap];
                break;
            default:
                break;
        }
    }
}

#pragma mark - CMBMusicBoxTableViewCellDelegate

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
    // 確認ダイアログ
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Save song"
                                        message:[NSString stringWithFormat:@"Complete to save the song as %@.", name]
                                 preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    // ダイアログを表示
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
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

#pragma mark - Debug.

- (void)soundTest
{
    [self playWithScale:@"C" octave:[NSNumber numberWithInteger:4]];
}

@end
