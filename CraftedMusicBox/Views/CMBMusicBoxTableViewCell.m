//
//  CMBMusicBoxTableViewCell.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBMusicBoxTableViewCell.h"
#import "CMBUtility.h"

@interface CMBMusicBoxTableViewCell ()
{
    CGFloat _preY;
}

@end

@implementation CMBMusicBoxTableViewCell

- (void)_init
{
    _preY = 0.f;
    self.delegate = nil;
    _parentTableView = nil;
    _tineView = nil;
    _tineViewOffset = 20.f;
    [self _initViews];
}

- (void)_initViews
{
    for (UIButton *noteButton in _noteButtons) {
        // 選択OFF
        noteButton.selected = NO;
        // 処理に時間がかかるのでやってはいけない...と思ったらそうでもなかった。あれ？
        [noteButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
#ifdef DEBUG
    static NSInteger count = 1;
    NSDate *startDate = [NSDate date];
#endif // DEBUG

    [super layoutSubviews];
    
    [self update];
    
#ifdef DEBUG
    NSDate *endDate = [NSDate date];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    DPRINT(@"処理時間 %.5f秒 %zd %@", interval, count++, self);
#endif // DEBUG
}

- (void)process
{
    // オルゴール歯の位置 (tine y + tine height - tine offset)
    CGFloat tineY = _tineView.frame.origin.y + _tineView.frame.size.height - _tineViewOffset;
    // 現在位置 (y + height/2 - table view offset)
    CGFloat curY = self.frame.origin.y + self.frame.size.height / 2.f - _parentTableView.contentOffset.y;
    // 画面内かチェック (余裕を見ておく)
    if (20.f <= curY && _parentTableView.frame.size.height - 20.f > curY) {
        // オルゴール歯を通過したかチェック
        if (tineY >= curY && tineY < _preY) {
            DPRINT(@"process tineY=%f, curY=%f, preY=%f", tineY, curY, _preY);
            // ピックされた事を通知
            NSIndexPath *indexPath = [_parentTableView indexPathForCell:self];
            [self.delegate musicboxDidPickWithIndexPath:indexPath];
        }
    }
    // 前回の位置を記録
    _preY = curY;
}

- (void)update
{
    [self _initViews];
    // iOS 10 で indexPathForCell のタイミングが変わり、使えなくなった.
    // http://stackoverflow.com/questions/40734537/uitableview-indexpathforcell-return-nil-in-ios10-with-xcode8-swift2-3
    // NSIndexPath *indexPath = [_parentTableView indexPathForCell:self];
    NSIndexPath *indexPath = [_parentTableView indexPathForRowAtPoint:self.center];
    self.contentView.backgroundColor = [self.delegate musicboxCellColorWithIndexPath:indexPath];
    CMBSequenceOneData *soData = [self.delegate musicboxCellSequenceOneWithIndexPath:indexPath];
    NSInteger currentOctave = [self.delegate getCurrentOctave];
    for (CMBNoteData *note in soData.notes) {
        if (!note || note.octave.integerValue != currentOctave) {
            continue;
        }
        [_noteButtons[[CMBUtility indexWithScale:note.scale]] setSelected:YES];
    }
}

- (NSDictionary *)noteInfoWithButtonIndex:(NSInteger)index
{
    return @{
             CMBNoteInfoKeyScale : [CMBUtility scaleWithIndex:index],
             CMBNoteInfoKeyOctave : [NSNumber numberWithInteger:[self.delegate getCurrentOctave]]
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
    // indexPath
    [info setObject:[self.parentTableView indexPathForCell:self] forKey:@"indexPath"];
    // 通知
    [self.delegate musicboxDidTapWithInfo:info];
}

@end
