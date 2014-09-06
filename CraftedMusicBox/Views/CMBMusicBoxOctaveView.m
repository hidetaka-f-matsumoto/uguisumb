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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    UIButton *noteButton = (UIButton *)sender;
    noteButton.selected = !noteButton.selected;
    if (noteButton.selected) {
        NSInteger index = [_noteButtons indexOfObject:noteButton];
        [_delegate noteDidTapWithInfo:[self noteInfoWithButtonIndex:index]];
    }
}

- (void)updateWithOctaveOne:(CMBSequenceOneData *)soData
{
    for (CMBNoteData *note in soData) {
        if (!note || note.octave != _octave) {
            continue;
        }
        [_noteButtons[note.scale.integerValue] setSelected:YES];
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
