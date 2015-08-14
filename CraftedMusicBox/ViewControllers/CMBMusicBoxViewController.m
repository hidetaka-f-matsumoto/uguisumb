
//
//  CMBMusicBoxViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxViewController.h"
#import "UIColor+CMBTools.h"
#import "NSString+CMBTools.h"
#import "CMBAnimations.h"

@interface CMBMusicBoxViewController ()
{
    NSTimer *_timer;
    BOOL _isPlaying;
    BOOL _isStopping;
    BOOL _isFirstViewWillAppear;
    BOOL _isFirstViewDidAppear;
    BOOL _isCellPrepared;
    BOOL _isOctaveChanging;
    CGPoint _scrollPointBegin;
    CGFloat _headViewTopConstraintConstantOriginal;
    NSMutableDictionary *_sequences; // Dictionary<NSNumber *, CMBSequenceOneData *>
    CMBSongHeaderData *_header;
}

@end

@implementation CMBMusicBoxViewController

- (void)_initFirst
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = YES;
    
    _isFirstViewWillAppear = YES;
    _isFirstViewDidAppear = YES;
    _isCellPrepared = NO;
    _isOctaveChanging = NO;
    // 初期状態はカーテンあり
    _curtainView.backgroundColor = [CMBUtility whiteColor];
    // 通知を登録
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(musicBoxDidOpen:) name:CMBNotifyURLOpenMusicBox object:nil];
    [notifCenter addObserver:self selector:@selector(pause) name:CMBNotifyAppDidEnterBackground object:nil];
    [notifCenter addObserver:self selector:@selector(pause) name:CMBNotifyAppWillTerminate object:nil];
}

- (void)_init
{
    _timer = nil;
    _isPlaying = NO;
    _isStopping = NO;
    _scrollPointBegin = CGPointZero;
    _sequences = [NSMutableDictionary dictionary];
    _header = [[CMBSongHeaderData alloc] init];
    _currentOctave = CMBOctaveBase;
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

    [self _initFirst];
    [self _init];
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
    [self updateViewsWithResetScroll:_isFirstViewDidAppear animation:NO completion:nil];
    _headViewTopConstraintConstantOriginal = _headViewTopConstraint.constant;
    // セル準備中の場合は、準備完了にして再更新
    if (!_isCellPrepared) {
        _isCellPrepared = YES;
        // 表示更新
        [self updateViewsWithResetScroll:NO animation:NO completion:nil];
        // カーテンを隠す
        [UIView animateWithDuration:0.5f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void) {_curtainView.backgroundColor = [UIColor clearColor];}
                         completion:nil];
    }
    // SoundManagerをチェック
    if (![CMBSoundManager sharedInstance].isAvailable) {
        [self showAlertDialogWithTitle:NSLocalizedString(@"Sound", @"Sound")
                               message:NSLocalizedString(@"Failed to load sound resources.", @"The message when you failed to load sound resources.")
                              handler1:nil
                              handler2:nil];
    }
    _isFirstViewDidAppear = NO;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    // 楽譜名入力
    if ([segue.identifier isEqualToString:@"SongConfig"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBSongConfigViewController *vc = (CMBSongConfigViewController *)nc.topViewController;
        vc.delegate = self;
        vc.header = _header;
    }
    // 楽譜選択
    else if ([segue.identifier isEqualToString:@"SongManage"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBSongManageViewController *vc = (CMBSongManageViewController *)nc.topViewController;
        vc.delegate = self;
    }
}

#pragma mark - Control sounds

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
    // 再生中の場合は何もしない
    if (_isPlaying) {
        return;
    }
    // フラグon
    _isPlaying = YES;
    // スクロール禁止
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
    // 再生中でない場合は何もしない
    if (!_isPlaying) {
        return;
    }
    // タイマー停止
    [_timer invalidate];
    // 再生ボタンに変更
    [_playButton setImage:[UIImage imageNamed:@"play"]];
    // ヘッダViewを表示
    [self showHeadView];
    // スクロール許可
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
    // 下にスクロールしている場合
    if (0.f < _tableView.contentOffset.y) {
        // 上までスクロールする
        [_tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:animation];
        // ヘッダViewを表示
        [self showHeadView];
        // スクロール許可
        [_tableView setScrollEnabled:YES];
    }
    // 既に上までスクロールしている場合
    else {
        // 停止フラグoff
        _isStopping = NO;
    }
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

#pragma mark - Action

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
    // 再生中の場合は一時停止
    [self pause];
    // メニューを表示
    [self showActionSheetWithTitle:NSLocalizedString(@"Share", @"Share")
                           message:nil
                          buttons1:@[
                                     @{@"title": NSLocalizedString(@"Facebook", @"Facebook"),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self sendFacebook];
    }},
                                     @{@"title": NSLocalizedString(@"Twitter", @"Twitter"),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self sendTwitter];
    }},
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
                                     @{@"title": NSLocalizedString(@"Facebook", @"Facebook"),
                                       @"handler": ^(void)
                                       {
        [self sendFacebook];
    }},
                                     @{@"title": NSLocalizedString(@"Twitter", @"Twitter"),
                                       @"handler": ^(void)
                                       {
        [self sendTwitter];
    }},
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
    // 再生中の場合は一時停止
    [self pause];
    // メニューを表示
    [self showActionSheetWithTitle:NSLocalizedString(@"Menue", @"Menue")
                           message:nil
                          buttons1:@[
                                     @{@"title": NSLocalizedString(@"New song", @"Create a new song."),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self songNewButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Save song", @"Save the song."),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self songSaveButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Config song", @"Configurate the song."),
                                       @"handler": ^(UIAlertAction *action)
    {
        [self songConfigButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Manage my songs", @"Manage my songs."),
                                       @"handler": ^(UIAlertAction *action)
    {
        [self songManageButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Help", @"Help"),
                                       @"handler": ^(UIAlertAction *action)
                                       {
        [self helpButtonDidTap];
    }},
                                     ]
                          buttons2:@[
                                     @{@"title": NSLocalizedString(@"New song", @"Create a new song."),
                                       @"handler": ^(void)
                                       {
        [self songNewButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Save song", @"Save the song."),
                                       @"handler": ^(void)
                                       {
        [self songSaveButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Config song", @"Configure the song."),
                                       @"handler": ^(void)
    {
        [self songConfigButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Manage my songs", @"Manage my songs."),
                                       @"handler": ^(void)
    {
        [self songManageButtonDidTap];
    }},
                                     @{@"title": NSLocalizedString(@"Help", @"Help"),
                                       @"handler": ^(void)
                                       {
        [self helpButtonDidTap];
    }},
                                     ]
     ];
}

/**
 * Song新規ボタン
 */
- (void)songNewButtonDidTap
{
    // 確認ダイアログ
    NSString *title = NSLocalizedString(@"New song", @"New song");
    NSString *message = [NSString stringWithFormat:
                         NSLocalizedString(@"You wanna create a new song?", @"The message to confirm you want to create a new song.")];
    [self showConfirmDialogWithTitle:title
                             message:message
                            handler1:^(UIAlertAction *action) {
                                [self newSong];
                            }
                            handler2:^(void) {
                                [self newSong];
                            }];
}

/**
 * Song保存ボタン
 */
- (void)songSaveButtonDidTap
{
    // 名前が無い場合
    if (!_header.name || 0 == _header.name.length) {
        // 設定画面へ
        NSString *title = NSLocalizedString(@"Save song", @"Save song");
        NSString *message = NSLocalizedString(@"Choose the title of this song before save.", @"The message when you should choose the name of this song before save.");
        [self showAlertDialogWithTitle:title
                               message:message
                              handler1:^(UIAlertAction *action) {
                                  [self performSegueWithIdentifier:@"SongConfig"
                                                            sender:self];
                              }
                              handler2:^(void) {
                                  [self performSegueWithIdentifier:@"SongConfig"
                                                            sender:self];
                              }];
    }
    // 名前がある場合
    else {
        BOOL isExist = [[CMBUtility sharedInstance] isExistSongWithFileName:_header.name];
        // 確認ダイアログ
        NSString *title = NSLocalizedString(@"Save song", @"Save song");
        NSString *message = isExist ?
        [NSString stringWithFormat:NSLocalizedString(@"%@ is already exist. You wanna overwrite?", @"The message to confirm you want to overwrite save the song with name %@."), _header.name] :
        [NSString stringWithFormat:NSLocalizedString(@"You wanna save %@?", @"The message to confirm you want to save the song with name %@."), _header.name];
        [self showConfirmDialogWithTitle:title
                                 message:message
                                handler1:^(UIAlertAction *action) {
                                    [self saveSong];
                                }
                                handler2:^(void) {
                                    [self saveSong];
                                }];
    }
}

/**
 * Song設定ボタン
 */
- (void)songConfigButtonDidTap
{
    // 設定画面へ
    [self performSegueWithIdentifier:@"SongConfig"
                              sender:self];
}

/**
 * Song管理ボタン
 */
- (void)songManageButtonDidTap
{
    // 管理画面へ
    [self performSegueWithIdentifier:@"SongManage"
                              sender:self];
}

/**
 * Helpボタン
 */
- (void)helpButtonDidTap
{
    // Help画面へ
    [self performSegueWithIdentifier:@"Help"
                              sender:self];
}

/**
 * オクターブスイッチドラッグ
 */
- (IBAction)octSwDidDrag:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint point = [pan translationInView:self.view];
    CGFloat amount = point.x + point.y;
    CGFloat angle = M_PI * amount / 800.f; // とりあえず、いい感じに調整
    // ドラッグ終わり
    if (UIGestureRecognizerStateEnded == pan.state) {
        // 一定角度より大きかったら、オクターブ上げ
        if (M_PI*10.f/180.f < angle) {
            [self octaveUp];
        }
        // 一定角度より小さかったら、オクターブ下げ
        else if (-M_PI*10.f/180.f > angle) {
            [self octaveDown];
        }
        pan.view.transform = CGAffineTransformMakeRotation(0.f);
    }
    // ドラッグ中
    else {
        CGPoint center = CGPointMake(-1 * _octaveSwitch.bounds.size.width, _octaveSwitch.bounds.size.height);
        pan.view.transform = CGAffineTransformMakeRotationAt(angle, center);
    }
}

#pragma mark - Control Views

/**
 * 表示更新
 *  animation = NO の場合は reloadData を使う (体感でパフォーマンスが良い)
 *  viewDidAppear の段階で animation = YES にするとパフォーマンスが悪いので注意
 */
- (void)updateViewsWithResetScroll:(BOOL)resetScroll
                         animation:(BOOL)animation
                        completion:(void (^)(BOOL finished))completion
{
    if (resetScroll) {
        // スクロール初期位置
        _tableView.contentOffset = CGPointMake(0, 0);
    }
    // ヘッダビュー更新
    [self updateHeadView];
    // オクターブ表示更新
    _octaveLabel.text = [NSString stringWithFormat:@"%zd", [self getCurrentOctave]];
    // テーブルビュー更新
    if (animation) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [indexSet addIndex:0];
        [indexSet addIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_tableView reloadData];
    }
    // 後処理
    if (completion) {
        completion(YES);
    }
}

/**
 * ヘッダ表示更新
 */
- (void)updateHeadView
{
    // タイトル更新
    _titleLabel.text = (_header.name && 0 < _header.name.length) ? _header.name : NSLocalizedString(@"No title", @"Song title is none.");
    // 音階表示更新
    const NSString *scaleMode = _header.scaleMode;
    NSArray *names = CMBScaleNames[scaleMode];
    UIFont *font = [UIFont fontWithName:@"SetoFont-SP" size:19.f];
    if ([scaleMode isEqualToString:@"doremi"] || [scaleMode isEqualToString:@"haniho"]) {
        font = [UIFont fontWithName:@"SetoFont-SP" size:16.f];
    }
    for (NSInteger i=0; i<_scaleLabels.count; i++) {
        UILabel *label = _scaleLabels[i];
        label.font = font;
        label.text = names[i];
    }
}

/**
 * 自動スクロール
 */
- (void)scrollAuto:(NSTimer*)timer
{
    CGPoint offset = _tableView.contentOffset;
    offset.y += (CMBMusicBoxTableViewCellHeight * _header.speed.floatValue * 4 * CMBTimeDivAutoScroll / 60.0f);
    // 曲中
    if (offset.y < (_tableView.contentSize.height - _tableView.bounds.size.height)) {
        _tableView.contentOffset = offset;
    }
    // 曲終わり
    else {
        [self pause];
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

/**
 * オクターブ上げ
 */
- (void)octaveUp {
    if (CMBOctaveMax <= _currentOctave || _isOctaveChanging) {
        return;
    }
    _isOctaveChanging = YES;
    _currentOctave++;
    // 表示更新
    [self updateViewsWithResetScroll:NO animation:YES completion:^(BOOL finished) {
        // zoom in-out
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // アニメーションのオプションを設定
        animation.duration = 0.25f;
        animation.repeatCount = 1;
        animation.autoreverses = YES;
        // 拡大・縮小倍率を設定
        animation.fromValue = [NSNumber numberWithFloat:1.f];
        animation.toValue = [NSNumber numberWithFloat:3.f];
        // アニメーションを追加
        [_octaveLabel.layer addAnimation:animation forKey:@"scale-layer"];
        _isOctaveChanging = NO;
    }];
}

/**
 * オクターブ下げ
 */
- (void)octaveDown {
    if (CMBOctaveMin >= _currentOctave || _isOctaveChanging) {
        return;
    }
    _isOctaveChanging = YES;
    _currentOctave--;
    // 表示更新
    [self updateViewsWithResetScroll:NO animation:YES completion:^(BOOL finished) {
        // zoom in-out
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // アニメーションのオプションを設定
        animation.duration = 0.25f;
        animation.repeatCount = 1;
        animation.autoreverses = YES;
        // 拡大・縮小倍率を設定
        animation.fromValue = [NSNumber numberWithFloat:1.f];
        animation.toValue = [NSNumber numberWithFloat:3.f];
        // アニメーションを追加
        [_octaveLabel.layer addAnimation:animation forKey:@"scale-layer"];
        // ローディング表示OFF
        [self loadingEndWithNetwork:NO];
        _isOctaveChanging = NO;
    }];
}

#pragma mark - CAAnimation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"animationLayer"];
    if (flag) {
        DPRINT(@"アニメーション完了");
        [layer removeFromSuperlayer];
    }
}

/**
 * 鶯が鳴く
 */
- (void)uguisuSing {
    CGPoint kStartPos = CGPointMake(_uguisuView.bounds.size.width / 2.f, 0.f);
    CALayer *noteLayer = [CMBAnimations noteAnimationLayerWithName:@"uguisuSing" startPos:kStartPos delegate:self];
    [_uguisuView.layer addSublayer:noteLayer];
}

#pragma mark - Etcs

/**
 * From - To の範囲に音符があるか
 */
- (BOOL)isNotesFrom:(NSInteger)from to:(NSInteger)to
{
    BOOL isNotes = NO;
    for (NSInteger i=from; i<=to; i++) {
        CMBSequenceOneData *soData = _sequences[[NSNumber numberWithInteger:i]];
        isNotes |= soData && [soData isNotes];
    }
    return isNotes;
}

/**
 * song length 変更
 */
- (void)changeLength:(NSInteger)length
{
    // 無くなる範囲のシーケンスを消去
    for (NSInteger i=length; i<_header.length.integerValue; i++) {
        [_sequences removeObjectForKey:[NSNumber numberWithInteger:i]];
    }
    // length更新
    _header.length = [NSNumber numberWithInteger:length];
    // 表示更新
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/**
 * 行挿入
 */
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 追加行より後ろのデータをずらす
    for (NSInteger i=_header.length.integerValue-1; i>=indexPath.row; i--) {
        NSNumber *curr = [NSNumber numberWithInteger:i];
        NSNumber *new = [NSNumber numberWithInteger:(i + 1)];
        CMBSequenceOneData *soData = _sequences[curr];
        if (!soData) {
            continue;
        }
        [_sequences removeObjectForKey:curr];
        _sequences[new] = soData;
    }
    // length更新
    _header.length = [NSNumber numberWithInteger:(_header.length.integerValue + 1)];
    // 描画更新
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/**
 * 行削除
 */
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    // シーケンスから削除
    [_sequences removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
    // 追加行より後ろのデータをずらす
    for (NSInteger i=indexPath.row; i<_header.length.integerValue; i++) {
        NSNumber *curr = [NSNumber numberWithInteger:i];
        NSNumber *new = [NSNumber numberWithInteger:(i - 1)];
        CMBSequenceOneData *soData = _sequences[curr];
        if (!soData) {
            continue;
        }
        [_sequences removeObjectForKey:curr];
        _sequences[new] = soData;
    }
    // length更新
    _header.length = [NSNumber numberWithInteger:(_header.length.integerValue - 1)];
    // 描画更新
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/**
 * 曲チェック
 */
- (BOOL)checkSongValid
{
    if (!_sequences || !_header) {
        NSString *title = NSLocalizedString(@"Song", @"Song");
        NSString *message = NSLocalizedString(@"Song is invalid.", @"The message when song is invalid.");
        [self showAlertDialogWithTitle:title message:message handler1:nil handler2:nil];
        return NO;
    }
    else if (0 >= _sequences.count) {
        NSString *title = NSLocalizedString(@"Song", @"Song");
        NSString *message = NSLocalizedString(@"Song is empty.", @"The message when song is empty.");
        [self showAlertDialogWithTitle:title message:message handler1:nil handler2:nil];
        return NO;
    }
    else if (!_header.name || 0 >= _header.name.length) {
        NSString *title = NSLocalizedString(@"Song", @"Song");
        NSString *message = NSLocalizedString(@"Song title is empty.", @"The message when song title is empty.");
        [self showAlertDialogWithTitle:title message:message handler1:nil handler2:nil];
        return NO;
    }
    return YES;
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
            numberOfRows = _header.length.integerValue;
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
            mbhCell.delegate = self;
            cell = mbhCell;
            break;
        }
        case 1:
        {
            CMBMusicBoxTableViewCell *mbCell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewCell" forIndexPath:indexPath];
            mbCell.delegate = self;
            mbCell.parentTableView = _tableView;
            mbCell.tineView = _tineView;
            mbCell.rightUtilityButtons = [self rightButtons];
            cell = mbCell;
            break;
        }
        case 2:
        {
            CMBMusicBoxTableViewFootCell *mbfCell = [tableView dequeueReusableCellWithIdentifier:@"MusicBoxTableViewFootCell" forIndexPath:indexPath];
            mbfCell.delegate = self;
            cell = mbfCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
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
            // セル準備OKの場合
            if (_isCellPrepared) {
                height = CMBMusicBoxTableViewCellHeight;
            }
            // セル準備中の場合
            else {
                height = CMBMusicBoxTableViewCellHeightForLoad;
            }
            break;
        case 2:
            height = _tableView.bounds.size.height - _headView.bounds.size.height;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        DPRINT(@"hogeeeeeee");
    }
}

#pragma mark - UIScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // 停止
    [self stopWithAnimation:YES];
    // 標準スクロールはしない
    return NO;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    _isStopping = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    // スクロール開始位置を記録
    _scrollPointBegin = [scrollView contentOffset];
    // ヘッダViewを非表示
    [self hideHeadView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        // ヘッダViewを表示
        [self showHeadView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // ヘッダViewを表示
    [self showHeadView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    for (UITableViewCell *cell in [_tableView visibleCells]) {
        if (![cell isKindOfClass:[CMBMusicBoxTableViewCell class]]) {
            continue;
        }
        CMBMusicBoxTableViewCell *mbCell = (CMBMusicBoxTableViewCell *)cell;
        [mbCell process];
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
 * 音符がタップされた
 */
- (void)musicboxDidTapWithInfo:(NSDictionary *)info
{
    if (!info) {
        return;
    }
    BOOL isTapOn = [info[@"isTapOn"] boolValue];
    if (isTapOn) {
        // 音を再生
        [self playWithScale:info[CMBNoteInfoKeyScale]
                     octave:info[CMBNoteInfoKeyOctave]];
        // 鶯が鳴く
        [self uguisuSing];
    }
    // シーケンスを更新
    NSIndexPath *indexPath = (NSIndexPath *)info[@"indexPath"];
    CMBSequenceOneData *seqOneData = _sequences[[NSNumber numberWithInteger:indexPath.row]];
    CMBNoteData *noteData = [[CMBNoteData alloc] initWithInfo:info];
    // TapOnの場合: 追加
    if (isTapOn) {
        // シーケンスデータが新規の場合
        if (!seqOneData) {
            seqOneData = [CMBSequenceOneData sequenceOneData];
            [_sequences setObject:seqOneData forKey:[NSNumber numberWithInteger:indexPath.row]];
        }
        [seqOneData addNoteData:noteData];
    }
    // TapOffの場合: 削除
    else {
        // シーケンスデータがある場合
        if (seqOneData) {
            [seqOneData removeNoteData:noteData];
            // 音符がなくなったら消しておく
            if (!seqOneData.isNotes) {
                [_sequences removeObjectForKey:[NSNumber numberWithInteger:indexPath.row]];
            }
        }
    }
}

/**
 * 弾かれた
 */
- (void)musicboxDidPickWithIndexPath:(NSIndexPath *)indexPath
{
    CMBSequenceOneData *soData = [self musicboxCellSequenceOneWithIndexPath:indexPath];
    // 音符があるかチェック
    if (!soData || ![soData isNotes]) {
        return;
    }
    // 音を再生
    for (CMBNoteData *note in soData.notes) {
        [self playWithScale:note.scale
                     octave:note.octave];
    }
    // 鶯が鳴く
    [self uguisuSing];
}

/**
 * 現在のオクターブ
 */
- (NSInteger)getCurrentOctave
{
    return _currentOctave;
}

/**
 * 作曲者
 */
- (NSString *)getComposer
{
    return _header.composer;
}

/**
 * セルの背景色
 */
- (UIColor *)musicboxCellColorWithIndexPath:(NSIndexPath *)indexPath
{
    UIColor *d1Color;
    UIColor *d2Color;
    if (0 == indexPath.row / _header.division1.integerValue % 2) {
        d1Color = [UIColor whiteColor];
    } else {
        d1Color = [CMBUtility greenColor];
    }
    if (0 == indexPath.row / _header.division1.integerValue / _header.division2.integerValue % 2) {
        d2Color = [UIColor whiteColor];
    } else {
        d2Color = [CMBUtility lightBrownColor];
    }
    return [[d1Color blendWithColor:d2Color alpha:0.5f] changeAlpha:0.25f];
}

/**
 * セルのシーケンス
 */
- (CMBSequenceOneData *)musicboxCellSequenceOneWithIndexPath:(NSIndexPath *)indexPath
{
    return _sequences[[NSNumber numberWithInteger:indexPath.row]];
}

#pragma mark - CMBMusicBoxTableViewCellFootDelegate

- (void)musicBoxDidRequestAddTime
{
    // 再生中の場合は一時停止
    [self pause];
    // 小区切り分ぴったりになるよう追加
    NSInteger div1 = _header.division1.integerValue;
    NSInteger newLen = ((_header.length.integerValue + div1) / (NSInteger)div1) * div1;
    [self changeLength:newLen];
}

- (void)musicBoxDidRequestRemoveTime
{
    // 再生中の場合は一時停止
    [self pause];
    // 小区切り分ぴったりになるよう削除
    NSInteger div1 = _header.division1.integerValue;
    NSInteger newLen = ((_header.length.integerValue - 1) / (NSInteger)div1) * div1;
    if (0 > newLen) {
        newLen = 0;
    }
    // 削除範囲に音符がある場合
    if ([self isNotesFrom:newLen to:(_header.length.integerValue - 1)]) {
        // 確認ダイアログ
        NSString *title = NSLocalizedString(@"Remove time", @"Remove time");
        NSString *message = [NSString stringWithFormat:
                             NSLocalizedString(@"You wanna remove times where is some notes?", @"The message to confirm you want to remove times where is some notes.")];
        [self showConfirmDialogWithTitle:title
                                 message:message
                                handler1:^(UIAlertAction *action) {
                                    [self changeLength:newLen];
                                }
                                handler2:^(void) {
                                    [self changeLength:newLen];
                                }];
    }
    // 削除範囲に音符が無い場合
    else {
        [self changeLength:newLen];
    }
}

#pragma mark - CMBSongConfigDelegate

- (void)songDidConfigureWithSave:(BOOL)save
{
    if (save) {
        [self songSaveButtonDidTap];
    }
}

#pragma mark - CMBSongManageDelegate

- (void)songDidLoadWithSequence:(NSMutableDictionary *)sequences
                         header:(CMBSongHeaderData *)header
{
    // 読み込み中を表示
    [self loadingBeginWithNetwork:NO];
    // データ更新
    _sequences = sequences;
    _header = header;
    // 表示更新
    [self updateViewsWithResetScroll:YES animation:YES completion:^(BOOL finished) {
        // 読み込み中を非表示
        [self loadingEndWithNetwork:NO];
    }];
}

- (void)songDidDeleteWithFileName:(NSString *)fileName
{
    if ([_header.name isEqualToString:fileName]) {
        [self newSong];
    }
}

#pragma mark - CMBNotifyURLOpenMusicBox

- (void)musicBoxDidOpen:(NSNotification *)notif
{
    // 実行ブロック
    void (^blkOpen)(void) = ^(void) {
        // エラーチェック
        NSDictionary *error = notif.userInfo[@"error"];
        if (error) {
            [self showAlertDialogWithTitle:error[@"title"]
                                   message:error[@"message"]
                                  handler1:nil
                                  handler2:nil];
            return;
        }
        // 確認ダイアログを出してsong読み込み
        NSMutableDictionary *sequence = notif.userInfo[@"sequences"];
        CMBSongHeaderData *header = notif.userInfo[@"header"];
        NSString *title = NSLocalizedString(@"Open URL", @"Open URL");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You wanna load the song from URL?", @"The message to confirm you want to load the song from URL."), header.name];
        [self showConfirmDialogWithTitle:title
                                 message:message
                                handler1:^(UIAlertAction *action) {
                                    [self songDidLoadWithSequence:sequence
                                                           header:header];
                                }
                                handler2:^(void) {
                                    [self songDidLoadWithSequence:sequence
                                                           header:header];
                                }];
    };

    // 自身が最前面の場合
    if ([self isTopMostViewController]) {
        blkOpen();
    }
    // 上に画面がある場合
    else {
        [self dismissViewControllerAnimated:NO completion:blkOpen];
    }
}

#pragma mark - Save

/**
 * 新規作成
 */
- (void)newSong
{
    // 読み込み中を表示
    [self loadingBeginWithNetwork:NO];
    // パラメータ初期化
    [self _init];
    // 表示更新
    [self updateViewsWithResetScroll:YES animation:YES completion:^(BOOL finished) {
        // 読み込み中を非表示
        [self loadingEndWithNetwork:NO];
    }];
}

/**
 * 保存
 */
- (void)saveSong
{
    // 保存実行
    BOOL isSuccess = [[CMBUtility sharedInstance] saveSongWithSequences:_sequences
                                                                 header:_header
                                                               fileName:_header.name];
    if (!isSuccess) {
        // 失敗
        NSString *title = NSLocalizedString(@"Save song", @"Save song");
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Failed to save %@.", @"The message when you failed to save the song with name %@."), _header.name];
        // 通知ダイアログ
        [self showAlertDialogWithTitle:title
                               message:message
                              handler1:nil
                              handler2:nil];
    }
}

#pragma mark - Mail

/**
 * メールで送信
 */
- (void)sendMail
{
    // 曲チェック
    if (![self checkSongValid]) {
        return;
    }
    // ネットワーク状態チェック
    if (NotReachable == [self checkNetworkStatus]) {
        return;
    }
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // リクエストパラメータ
    NSDictionary *params = @{CMBSvQuerySong: songJson.encodedSongStr,
                             CMBSvQuerySongTitle: _header.name.urlEncode,
                             CMBSvQuerySongComposer: _header.composer.urlEncode};
    // 通信
    [self apiSongRegisterWithParams:params completion:^(NSDictionary *dict) {
        // song URL
        NSString *songUrl = dict[@"songinfo"][@"url"];
        // メール送信画面を表示
        MFMailComposeViewController *mailPicker = [MFMailComposeViewController new];
        [mailPicker setSubject:NSLocalizedString(@"This is my music box.", @"The message when you send the song.")];
        [mailPicker setMessageBody:songUrl isHTML:NO];
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
    }];
}

#pragma mark - LINE

/**
 * LINEで送信
 */
- (void)sendLINE
{
    // 曲チェック
    if (![self checkSongValid]) {
        return;
    }
    // ネットワーク状態チェック
    if (NotReachable == [self checkNetworkStatus]) {
        return;
    }
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // リクエストパラメータ
    NSDictionary *params = @{CMBSvQuerySong: songJson.encodedSongStr,
                             CMBSvQuerySongTitle: _header.name.urlEncode,
                             CMBSvQuerySongComposer: _header.composer.urlEncode};
    // 通信
    [self apiSongRegisterWithParams:params completion:^(NSDictionary *dict) {
        // song URL
        NSString *songUrl = dict[@"songinfo"][@"url"];
        NSString *message = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"This is my music box.", @"The message when you send the song."), songUrl];
        // LINE URLを作成
        NSString *lineUrl = [@"http://line.me/R/msg/text/?" stringByAppendingString:message.urlEncode];
        // 投稿
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lineUrl]];
    }];
}

#pragma mark - Twitter

/**
 * Twitterで送信
 */
- (void)sendTwitter
{
    // 曲チェック
    if (![self checkSongValid]) {
        return;
    }
    // ネットワーク状態チェック
    if (NotReachable == [self checkNetworkStatus]) {
        return;
    }
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // リクエストパラメータ
    NSDictionary *params = @{CMBSvQuerySong: songJson.encodedSongStr,
                             CMBSvQuerySongTitle: _header.name.urlEncode,
                             CMBSvQuerySongComposer: _header.composer.urlEncode};
    // 通信
    [self apiSongRegisterWithParams:params completion:^(NSDictionary *dict) {
        // song URL
        NSString *songUrl = dict[@"songinfo"][@"url"];
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"This is my music box.", @"The message when you send the song."), CMBHashTag];
        // 投稿
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [vc setInitialText:message];
        [vc addURL:[NSURL URLWithString:songUrl]];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - Twitter

/**
 * Facebookで送信
 */
- (void)sendFacebook
{
    // 曲チェック
    if (![self checkSongValid]) {
        return;
    }
    // ネットワーク状態チェック
    if (NotReachable == [self checkNetworkStatus]) {
        return;
    }
    // Song-jsonに変換
    NSString *songJson = [NSString songJsonWithSequences:_sequences
                                                  header:_header];
    // リクエストパラメータ
    NSDictionary *params = @{CMBSvQuerySong: songJson.encodedSongStr,
                             CMBSvQuerySongTitle: _header.name.urlEncode,
                             CMBSvQuerySongComposer: _header.composer.urlEncode};
    // 通信
    [self apiSongRegisterWithParams:params completion:^(NSDictionary *dict) {
        // song URL
        NSString *songUrl = dict[@"songinfo"][@"url"];
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"This is my music box.", @"The message when you send the song."), CMBHashTag];
        // 投稿
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [vc setInitialText:message];
        [vc addURL:[NSURL URLWithString:songUrl]];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - Networking

- (void)apiSongRegisterWithParams:(NSDictionary *)params
                       completion:(void (^)(NSDictionary *response))handler
{
    // リクエスト作成
    NSString *url = [NSString stringWithFormat:@"%@%@", CMBSvApiURL, CMBSvActionSongReg];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil];
    if (error) {
        return;
    }
    // セッション作成
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    // タスク作成
    NSURLSessionDataTask *task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 通信エラー
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通信中表示off
                [self loadingEndWithNetwork:YES];
                // エラー表示
                [self showAlertDialogWithTitle:NSLocalizedString(@"Server", @"Server")
                                       message:NSLocalizedString(@"Failed to share the song.", @"The message when you failed to share the song.")
                                      handler1:nil
                                      handler2:nil];
            });
            return;
        }
        // レスポンスをパース
        NSError *error2;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error2];
        // パースエラー
        if (error2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通信中表示off
                [self loadingEndWithNetwork:YES];
                // エラー表示
                [self showAlertDialogWithTitle:NSLocalizedString(@"Server", @"Server")
                                       message:NSLocalizedString(@"Failed to share the song.", @"The message when you failed to share the song.")
                                      handler1:nil
                                      handler2:nil];
            });
            return;
        }
        DPRINT(@"%@", dict);
        // サーバエラー
        if (200 != [dict[@"result"][@"status"] integerValue]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通信中表示off
                [self loadingEndWithNetwork:YES];
                // エラー表示
                [self showAlertDialogWithTitle:NSLocalizedString(@"Server", @"Server")
                                       message:dict[@"result"][@"message"]
                                      handler1:nil
                                      handler2:nil];
            });
            return;
        }
        // 正常処理
        dispatch_async(dispatch_get_main_queue(), ^{
            // 通信中表示off
            [self loadingEndWithNetwork:YES];
            // ハンドラ
            handler(dict);
        });
    }];
    // 通信中表示on
    [self loadingBeginWithNetwork:YES];
    // タスク開始
    [task resume];
}

# pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    CMBMusicBoxTableViewCell *mbCell = (CMBMusicBoxTableViewCell *)cell;
    NSIndexPath *indexPath = [_tableView indexPathForCell:mbCell];
    switch (index) {
        case 0: // 挿入
        {
            [self insertRowAtIndexPath:indexPath];
            break;
        }
        case 1: // 削除
        {
            BOOL isNotes = [self isNotesFrom:indexPath.row to:indexPath.row];
            // 音符がある場合
            if (isNotes) {
                NSString *title = NSLocalizedString(@"Remove time", @"Remove time");
                NSString *message = NSLocalizedString(@"You wanna remove times where is some notes?", @"The message to confirm you want to remove times where is some notes.");
                [self showConfirmDialogWithTitle:title
                                         message:message
                                        handler1:^(UIAlertAction *action) {
                                            [self deleteRowAtIndexPath:indexPath];
                                        }
                                        handler2:^(void) {
                                            [self deleteRowAtIndexPath:indexPath];
                                        }];
            }
            // 音符が無い場合
            else {
                [self deleteRowAtIndexPath:indexPath];
            }
            break;
        }
        default:
            break;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    NSAttributedString *loadStr =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Insert", @"Insert")
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

#pragma mark - Debug.

- (void)soundTest
{
    [self playWithScale:@"C" octave:[NSNumber numberWithInteger:4]];
}

@end
