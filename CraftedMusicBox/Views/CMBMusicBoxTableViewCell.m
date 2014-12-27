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
    _preY = 0.0f;
    _delegate = nil;
    _parentTableView = nil;
    _tineView = nil;
    [self _initViews];
}

- (void)_initViews
{
    CGFloat buttonWidth = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? CMBMusicBoxNoteButtonWidth_iPhone : CMBMusicBoxNoteButtonWidth_iPad;
    for (NSLayoutConstraint *constraint in _noteButtonWidthConstraints) {
        // 幅を調整
        constraint.constant = buttonWidth;
    }
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
//    NSLog(@"process y=%f", self.frame.origin.y - _parentTableView.contentOffset.y);
    // オルゴール歯の位置
    CGFloat tineY = _tineView.frame.origin.y + _tineView.frame.size.height - 20.0f; // StatusBar分
    // 現在位置
    CGFloat curY = self.frame.origin.y - _parentTableView.contentOffset.y;
    // 画面内かチェック (余裕を見ておく)
    if (20.f <= curY && _parentTableView.frame.size.height - 20.f > curY) {
        // オルゴール歯を通過したかチェック
        if (tineY >= curY && tineY < _preY) {
            NSLog(@"process tineY=%f, curY=%f, preY=%f", tineY, curY, _preY);
            // ピックされた事を通知
            NSIndexPath *indexPath = [_parentTableView indexPathForCell:self];
            [_delegate musicboxDidPickWithIndexPath:indexPath];
        }
    }
    // 前回の位置を記録
    _preY = curY;
}

- (void)update
{
    [self _initViews];
    NSIndexPath *indexPath = [_parentTableView indexPathForCell:self];
    self.contentView.backgroundColor = [_delegate musicboxCellColorWithIndexPath:indexPath];
    CMBSequenceOneData *soData = [_delegate musicboxCellSequenceOneWithIndexPath:indexPath];
    NSInteger currentOctave = [_delegate getCurrentOctave];
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
             CMBNoteInfoKeyOctave : [NSNumber numberWithInteger:[_delegate getCurrentOctave]]
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
    [_delegate musicboxDidTapWithInfo:info];
}

@end
