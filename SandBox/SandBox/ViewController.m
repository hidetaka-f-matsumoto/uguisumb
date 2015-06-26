//
//  ViewController.m
//  SandBox
//
//  Created by 松本 英高 on 2015/06/26.
//  Copyright (c) 2015年 Hidetaka Matsumoto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)animButtonDidTap:(id)sender {
    [self animate];
}

- (void)animate
{
    NSLog(@"now is %@.", [NSDate date]);

    // アニメーション時間
    NSTimeInterval duration = 20.0;
    
    // レイヤーを生成
    CALayer *dropLayer = [self dropLayer];
    
    // レイヤーを追加
//    [self.snowLayers addObject:dropLayer];
    [self.view.layer addSublayer:dropLayer];
    
    // レイヤーアニメーションを設定するメソッドを定義
    [self addLayerAnimations:dropLayer
                    duration:duration
             completionBlock:^(CALayer *layer) {
                 
                 // レイヤーを破棄
                 [layer removeFromSuperlayer];
//                 [self.snowLayers removeObject:layer];
             }];
}

- (void)addLayerAnimations:(CALayer *)layer
                  duration:(NSTimeInterval)duration
           completionBlock:(void (^)(CALayer*))completionBlock
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        
        // コールバック
        if (completionBlock) {
            completionBlock(layer);
        }
    }];
    
    // 開始位置、終了位置を適当に設定
    CGPoint startPoint = layer.position;
    CGPoint endPoint = layer.position;
    
    startPoint.x = arc4random_uniform(CGRectGetWidth(layer.superlayer.bounds));
    startPoint.y = -CGRectGetHeight(layer.bounds);
    endPoint.x = arc4random_uniform(CGRectGetWidth(layer.superlayer.bounds));
    endPoint.y = CGRectGetMaxY(layer.superlayer.bounds) + CGRectGetHeight(layer.bounds);
    
    CABasicAnimation *positionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    positionAnim.duration = duration;
    positionAnim.fromValue = [NSValue valueWithCGPoint:startPoint];
    positionAnim.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAnim.removedOnCompletion = NO; // アニメーション終了後に元に戻らないようにする
    positionAnim.fillMode = kCAFillModeForwards;
    [layer addAnimation:positionAnim forKey:@"position"];
    
    [CATransaction commit];
}

- (CALayer*)dropLayer
{
    // 画像を用意
    NSString *imageName = arc4random_uniform(2)==0 ? @"note8" : @"note8-2";
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
    CGFloat minScale = 0.2;
    CGFloat scale = (arc4random_uniform(6)/20.0) + minScale;
    
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
