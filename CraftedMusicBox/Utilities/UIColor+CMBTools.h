//
//  UIColor+CMBTools.h
//  CraftedMusicBox
//
//  Created by hide on 2014/10/03.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CMBTools)

- (UIColor *)blendWithColor:(UIColor*)color2
                     alpha:(CGFloat)alpha2;
- (UIColor *)changeAlpha:(CGFloat)alpha;

@end
