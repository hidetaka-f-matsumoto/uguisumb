//
//  CMBMusicBoxViewController.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxViewController.h"
#import "CMBMusicBoxViewCell.h"

@interface CMBMusicBoxViewController ()
{
    NSTimer *_timer;
    BOOL _isPlaying;
    CGPoint _scrollPointBegin;
}

@property (nonatomic, assign) RingBuffer *ringBuffer;

@end

@implementation CMBMusicBoxViewController

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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollView.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self loadSounds];
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

- (void)updateViews
{
    
}

- (void)updateDataSource
{
    
}

- (void)playWithScale:(NSString *)scale
               octave:(NSNumber *)octave
{
    SystemSoundID sound = [_sounds[octave][scale] longValue];
    if (sound) {
        AudioServicesPlayAlertSound(sound);
    }
}

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

- (IBAction)stopButtonDidTap:(id)sender
{
    // タイマー停止 & 破棄
    [_timer invalidate];
    _timer = nil;
    // 上までスクロールする
    [_tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

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
    NSString *cellIdentifier = @"MusicBoxCell";
    CMBMusicBoxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.parentTableView = _tableView;
    cell.tineView = _tineView;
    
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
    for (CMBMusicBoxViewCell *cell in [_tableView visibleCells]) {
        [cell process];
    }
}

#pragma mark - CMBMusicBoxViewCellDelegate

- (void)noteDidTapWithInfo:(NSDictionary *)info
{
    if (!info) {
        return;
    }
    [self playWithScale:info[CMBNoteInfoKeyScale]
                 octave:info[CMBNoteInfoKeyOctave]];
}

- (void)notesDidPickWithInfos:(NSArray *)infos
{
    for (NSDictionary *info in infos) {
        [self playWithScale:info[CMBNoteInfoKeyScale]
                     octave:info[CMBNoteInfoKeyOctave]];
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
