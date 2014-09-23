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
    NSMutableArray *_sequences; // List<CMBSequenceOneData *>
}

@property (nonatomic, assign) RingBuffer *ringBuffer;

@end

@implementation CMBMusicBoxViewController

- (void)_init
{
    _timer = nil;
    _isPlaying = NO;
    _scrollPointBegin = CGPointZero;
    _sequences = [NSMutableArray array];
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
    [self loadSequencesWithFileName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    
    _ringBuffer = new RingBuffer(32768, 2);
    _audioManager = [Novocaine audioManager];
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
    if ([segue.identifier isEqualToString:@"ScoreNameEdit"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBScoreNameEditViewController *vc = (CMBScoreNameEditViewController *)nc.topViewController;
        vc.delegate = self;
    }
    // 楽譜選択
    else if ([segue.identifier isEqualToString:@"ScoreSelect"]) {
        UINavigationController *nc = segue.destinationViewController;
        CMBScoreSelectViewController *vc = (CMBScoreSelectViewController *)nc.topViewController;
        vc.delegate = self;
    }
}

/**
 * 表示更新
 */
- (void)updateViews
{
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
    SystemSoundID sound = [_sounds[octave][scale] longValue];
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
                           otherButtonTitles:@"Save", @"Load", @"Config", nil];
    
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    [sheet showInView:self.view];
}

/**
 * 保存ボタン
 */
- (void)saveButtonDidTap
{
    [self performSegueWithIdentifier:@"ScoreNameEdit"
                              sender:self];
}

/**
 * 読み込みボタン
 */
- (void)loadButtonDidTap
{
    [self performSegueWithIdentifier:@"ScoreSelect"
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
    return _sequences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MusicBoxTableViewCell";
    CMBMusicBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.parentTableView = _tableView;
    cell.tineView = _tineView;
    [cell updateWithSequenceOne:_sequences[indexPath.row]];
    
    return cell;
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
            case 0: // Save
                [self saveButtonDidTap];
                break;
            case 1: // Load
                [self loadButtonDidTap];
                break;
            case 2: // Config
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
    NSLog(@"%d", indexPath.row);
    CMBSequenceOneData *seqOneData = _sequences[indexPath.row];
    // シーケンスデータが新規の場合
    if (!seqOneData) {
        seqOneData = [CMBSequenceOneData sequenceOneData];
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

#pragma mark - CMBScoreNameEditDelegate

- (void)scoreNameDidEditWithName:(NSString *)name
{
    // 確認ダイアログ
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"楽譜の保存"
                                        message:[NSString stringWithFormat:@"%@ で楽譜を保存します。よろしいですか？", name]
                                 preferredStyle:UIAlertControllerStyleAlert];
    // OK処理
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
    {
        // 保存実行
        BOOL isSuccess = [[CMBUtility sharedInstance] saveScoreWithSequences:_sequences
                                                                    fileName:name];
        if (!isSuccess) {
            // 失敗
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"楽譜の保存"
                                                message:@"楽譜の保存に失敗しました。"
                                         preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }
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

#pragma mark - CMBScoreSelectDelegate

- (void)scoreDidSelectWithInfo:(NSDictionary *)info
{
    // シーケンスを読み込み
    BOOL isSuccess = [[CMBUtility sharedInstance] loadScoreWithSequences:nil
                                                                fileName:info[@"name"]];
    if (!isSuccess) {
        // 保存失敗
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"楽譜の読み込み"
                                            message:@"楽譜の読み込みに失敗しました。"
                                     preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    // 表示更新
    [self updateViews];
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

#pragma mark - Save/Load Score.

- (void)loadSequencesWithFileName:(NSString *)name
{
    // TODO:
    for (NSInteger i=0; i<100; i++) {
        [_sequences addObject:[CMBSequenceOneData sequenceOneData]];
    }
}

#pragma mark - Debug.

- (void)soundTest
{
    [self playWithScale:@"C" octave:[NSNumber numberWithInteger:4]];
}

- (void)soundTest2
{
    __weak CMBMusicBoxViewController * wself = self;

    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"xylophone.C4" withExtension:@"wav"];
    
    _fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:_audioManager.samplingRate
                       numChannels:_audioManager.numOutputChannels];
    
    [_fileReader play];
    _fileReader.currentTime = 0.0;
    
    
    [_audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         NSLog(@"Time: %f", wself.fileReader.currentTime);
     }];

    [self.audioManager play];
}

@end
