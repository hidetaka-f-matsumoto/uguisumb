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
    CGPoint _scrollPointBegin;
    NSMutableDictionary *_sequences; // Dictionary<NSNumber *, CMBSequenceOneData *>
    CMBSongHeaderData *_header;
}

@end

@implementation CMBMusicBoxViewController

- (void)_init
{
    _timer = nil;
    _isPlaying = NO;
    _scrollPointBegin = CGPointZero;
    _sequences = [NSMutableDictionary dictionary];
    _header = [[CMBSongHeaderData alloc] initWithInfo:nil];
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

    [self _init];
    [self loadSounds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // 表示更新
    [self updateViews];
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
- (void)updateViews
{
    // スクロール初期位置
    _scrollView.contentOffset = CGPointMake(320, 0);
    _tableView.contentOffset = CGPointMake(0, 0);
    // ナビゲーションバー更新
    self.navigationItem.title = _header.name;
    // テーブルビュー更新
    [_tableView reloadData];
}

- (void)updateDataSource
{
    
}

/**
 * 1音再生
 */
- (void)playWithScale:(NSString *)scale
               octave:(NSNumber *)octave
{
    SystemSoundID sound = [_sounds[octave][scale] unsignedIntValue];
    if (sound) {
        AudioServicesPlayAlertSound(sound);
    }
}

/**
 * 再生ボタン
 */
- (IBAction)playButtonDidTap:(id)sender
{
    // 再生中の場合
    if (_isPlaying) {
        // タイマー停止
        [_timer invalidate];
        _isPlaying = NO;
    }
    // 再生中でない場合
    else {
        // タイマー開始 (自動スクロール)
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                      target:self
                                                    selector:@selector(scrollAuto:)
                                                    userInfo:nil
                                                     repeats:YES];
        }
        [_timer fire];
        _isPlaying = YES;
    }
}

/**
 * ストップボタン
 */
- (IBAction)stopButtonDidTap:(id)sender
{
    // タイマー停止 & 破棄
    [_timer invalidate];
    _timer = nil;
    // 上までスクロールする
    [_tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

/**
 * メニューボタン
 */
- (IBAction)menueButtonDidTap:(id)sender
{
    UIActionSheet *sheet =[[UIActionSheet alloc]
                           initWithTitle:@"Action Sheet"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Config this song", @"Manage songs", nil];
    
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [sheet showInView:self.view];
}

/**
 * Song設定ボタン
 */
- (void)songConfigButtonDidTap
{
    [self performSegueWithIdentifier:@"SongConfig"
                              sender:self];
}

/**
 * Song管理ボタン
 */
- (void)songManageButtonDidTap
{
    [self performSegueWithIdentifier:@"SongManage"
                              sender:self];
}

/**
 * 自動スクロール
 */
- (void)scrollAuto:(NSTimer*)timer
{
    CGPoint offset = _tableView.contentOffset;
    offset.y = offset.y + 4; // TODO: テンポから算出
    if (offset.y < _tableView.frame.origin.y + _tableView.frame.size.height) {
        _tableView.contentOffset = offset;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    NSString *cellIdentifier = @"MusicBoxTableViewCell";
    CMBMusicBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.parentTableView = _tableView;
    cell.tineView = _tineView;
    [cell updateWithSequenceOne:_sequences[[NSNumber numberWithInteger:indexPath.row]]];
    
    return cell;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UIScrollViewDelegate

/**
 * スクロール管理の初期化
 */
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    _scrollPointBegin = [scrollView contentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
//    CGPoint currentPoint = scrollView.contentOffset;
//    currentPoint.y = _scrollPointBegin.y;
//    [scrollView setContentOffset:currentPoint];
    for (CMBMusicBoxTableViewCell *cell in [_tableView visibleCells]) {
        [cell process];
    }
}

#pragma mark - UIActionSheetDelegate

-   (void)actionSheet:(UIActionSheet *)actionSheet
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        // nothing to do.
    }else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // nothing to do.
    }else{
        switch (buttonIndex) {
            case 0: // Config this song
                [self songConfigButtonDidTap];
                break;
            case 1: // Manage songs
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
    [self updateViews];
}

#pragma mark - Debug.

- (void)soundTest
{
    [self playWithScale:@"C" octave:[NSNumber numberWithInteger:4]];
}

@end
