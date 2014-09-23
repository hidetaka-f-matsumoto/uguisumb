//
//  CMBScoreSelectTableViewCell.h
//  CraftedMusicBox
//
//  Created by hide on 2014/09/23.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMBScoreSelectTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *scoreNameLabel;

@property (nonatomic, assign) NSDictionary *scoreInfo;

- (void)setupWithScoreInfo:(NSDictionary *)info;

@end
