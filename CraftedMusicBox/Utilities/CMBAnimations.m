//
//  CMBAnimations.m
//  CraftedMusicBox
//
//  Created by 松本 英高 on 2015/08/11.
//  Copyright (c) 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import "CMBAnimations.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMBAnimations


/**
 * 音符移動アニメ
 */
+ (CALayer *)noteAnimationLayerWithName:(NSString *)name
                               startPos:(CGPoint)kStartPos
                               delegate:(UIViewController *)delegate {
    CALayer *layer = [self noteLayer];
    
    CGPoint kEndPos =  CGPointMake(kStartPos.x - 40.f, kStartPos.y - 60.f);
    CGPoint kCtrlPos1 = CGPointMake(kStartPos.x, kStartPos.y - 20.f);
    CGPoint kCtrlPos2 = CGPointMake(kEndPos.x, kEndPos.y + 20.f);
    
    // 移動
    CAKeyframeAnimation *animMove = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animMove.delegate = delegate;
    animMove.duration = 1.f;
    animMove.fillMode = kCAFillModeForwards;
    // UIBezierPathで放物線のパスを生成
    UIBezierPath *path =  [UIBezierPath bezierPath];
    [path moveToPoint:kStartPos];
    [path addCurveToPoint:kEndPos controlPoint1:kCtrlPos1 controlPoint2:kCtrlPos2];
    // パスをCAKeyframeAnimationオブジェクトにセット
    animMove.path = path.CGPath;
    
    // フェード
    CAKeyframeAnimation *animFade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animFade.delegate = delegate;
    animFade.duration = 1.f;
    animFade.fillMode = kCAFillModeBoth;
    animFade.keyTimes = @[@0.f, @0.15f, @0.3f, @0.7f, @0.85f, @1.f];
    animFade.values = @[@0.f, @0.6f, @1.f, @1.f, @0.6f, @0.f];
    
    // アニメーショングループ
    CAAnimationGroup *ag = [CAAnimationGroup animation];
    ag.delegate = delegate;
    ag.duration = 1.f;
    ag.animations = @[animMove, animFade];
    ag.removedOnCompletion = NO;
    ag.fillMode = kCAFillModeForwards;
    [ag setValuesForKeysWithDictionary:@{@"animationName": name,
                                         @"animationLayer": layer}];
    [layer addAnimation:ag forKey:@"uguisu-sing-note"];
   
    return layer;
}

/**
 * 音符レイヤー
 */
+ (CALayer*)noteLayer
{
    // 画像を用意
    NSString *imageName = arc4random_uniform(2) == 0 ? @"note8" : @"note8-2";
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    // CALayerのインスタンスを作る
    CALayer *layer = [CALayer layer];
    layer.shouldRasterize = YES; // ラスタライズを有効
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contents = (__bridge id)image.CGImage;
    layer.doubleSided = YES; // ひっくり返ったときに背面も見えるようにする
    layer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    // 大きさを適当に変更
    CGFloat scale = (arc4random_uniform(6)/20.0) + 1.f;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, scale, scale, 1.0);
    transform.m34 = -1.0 / 300; // 奥行き感を出すおまじない
    layer.transform = transform;
    
    CABasicAnimation *rotateXAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateXAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateXAnim.duration = arc4random_uniform(2); // 乱数を生成する自前関数
    rotateXAnim.fromValue = @0.0;
    rotateXAnim.toValue = @(arc4random_uniform(2.7)); // 乱数を生成する自前関数
    rotateXAnim.repeatCount = NSIntegerMax; // とにかく大きい数
    rotateXAnim.removedOnCompletion = NO;
    rotateXAnim.fillMode = kCAFillModeForwards;
    rotateXAnim.cumulative = YES; // 累積
    [layer addAnimation:rotateXAnim forKey:@"rotate x"];
    
    return layer;
}

@end
