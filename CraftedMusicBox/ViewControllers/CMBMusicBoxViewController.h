//
//  CMBMusicBoxViewController.h
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBBaseViewController.h"
#import "CMBMusicBoxViewCell.h"
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"

@interface CMBMusicBoxViewController : CMBBaseViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CMBMusicBoxViewCellDelegate>
{
    NSMutableDictionary *_dataSource;
}

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;
@property (strong, nonatomic) NSMutableDictionary *sounds;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tineView;

- (IBAction)playButtonDidTap:(id)sender;
- (IBAction)stopButtonDidTap:(id)sender;

@end
