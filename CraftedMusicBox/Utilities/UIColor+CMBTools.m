//
//  UIColor+CMBTools.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/03.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "UIColor+CMBTools.h"

@implementation UIColor (CMBTools)

- (UIColor *)blendWithColor:(UIColor*)color2
                     alpha:(CGFloat)alpha2
{
    alpha2 = MIN( 1.0, MAX( 0.0, alpha2 ) );
    CGFloat beta = 1.0 - alpha2;
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat red     = r1 * beta + r2 * alpha2;
    CGFloat green   = g1 * beta + g2 * alpha2;
    CGFloat blue    = b1 * beta + b2 * alpha2;
    CGFloat alpha   = a1 * beta + a2 * alpha2;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)changeAlpha:(CGFloat)alpha
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end
