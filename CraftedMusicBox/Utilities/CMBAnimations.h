//
//  CMBAnimations.h
//  CraftedMusicBox
//
//  Created by 松本 英高 on 2015/08/11.
//  Copyright (c) 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CMBAnimations : NSObject

+ (CALayer *)noteAnimationLayerWithName:(NSString *)name
                               startPos:(CGPoint)kStartPos
                               delegate:(UIViewController *)delegate;

@end
