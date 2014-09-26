//
//  CMBMusicBoxOctaveView.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/27.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxOctaveView.h"
#import "CMBSequenceOneData.h"

@implementation CMBMusicBoxOctaveView

- (void)_init
{
    _delegate = nil;
    _octave = nil;
    [self _initViews];
}

- (void)_initViews
{
    for (UIButton *noteButton in _noteButtons) {
        noteButton.selected = NO;
        [noteButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSArray *)getOnNoteInfos
{
    NSMutableArray *notes = [NSMutableArray array];
    for (UIButton *noteButton in _noteButtons) {
        if (noteButton.selected) {
            NSInteger index = [_noteButtons indexOfObject:noteButton];
            [notes addObject:[self noteInfoWithButtonIndex:index]];
        }
    }
    return notes;
}

- (NSDictionary *)noteInfoWithButtonIndex:(NSInteger)index
{
    return @{
             CMBNoteInfoKeyScale : [CMBMusicBoxOctaveView scaleWithIndex:index],
             CMBNoteInfoKeyOctave : _octave
             };
}

#pragma mark - IBAction.

- (IBAction)noteButtonDidTap:(id)sender
{
    // ボタン選択状態を反転
    UIButton *noteButton = (UIButton *)sender;
    noteButton.selected = !noteButton.selected;
    // 通知情報を作成
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 音符
    NSInteger index = [_noteButtons indexOfObject:noteButton];
    [info addEntriesFromDictionary:[NSMutableDictionary dictionaryWithDictionary:[self noteInfoWithButtonIndex:index]]];
    // on/off
    [info setObject:[NSNumber numberWithBool:noteButton.selected] forKey:@"isTapOn"];
    // 通知
    [_delegate noteDidTapWithInfo:info];
}

- (void)updateWithSequenceOneData:(CMBSequenceOneData *)soData;
{
    [self _initViews];
    for (CMBNoteData *note in soData.notes) {
        if (!note || note.octave != _octave) {
            continue;
        }
        [_noteButtons[[CMBMusicBoxOctaveView indexWithScale:note.scale]] setSelected:YES];
    }
}

+ (NSString *)scaleWithIndex:(NSInteger)index
{
    NSString *a= CMBScales[index];
    return a;
}

+ (NSInteger)indexWithScale:(NSString *)scale
{
    if (!scale) {
        return -1;
    }
    return [CMBScales indexOfObject:scale];
}

@end
