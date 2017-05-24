//
//  CMBMusicBoxTableView.h
//  CraftedMusicBox
//
//  Created by hide on 2014/10/01.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMBMusicBoxTableView : UITableView

@property (nonatomic, setter=setLayoutSize:) CGSize layoutSize;
@property (nonatomic, getter=getContentOffset, setter=setContentOffset:) CGPoint contentOffset;

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

@end
