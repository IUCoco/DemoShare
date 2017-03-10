//
//  ViewController.m
//  金币动画测试
//
//  Created by 清风 on 2017/2/27.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import "ViewController.h"
#import "EatCoinImageView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) EatCoinImageView *eatCoinImageView;
@property (nonatomic, strong) NSMutableArray *coinImageArray;

//@property (nonatomic, strong) UIView *bounderView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleAction:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.coinImageArray = [NSMutableArray array];
    
//    _bounderView = [[UIView alloc] init];
//    [_bounderView setFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
//    [_bounderView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.7]];
//    [self.view addSubview:_bounderView];
//    [self.view bringSubviewToFront:_bounderView];
    
//    UIImage *eatCoinImage = [UIImage imageNamed:@"cutely"];
//    EatCoinImageView *eatCoinImageView = [[EatCoinImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//    eatCoinImageView.image = eatCoinImage;
//    eatCoinImageView.userInteractionEnabled = YES;
//    eatCoinImageView.frame = CGRectMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - 70, 70, 70);
//    eatCoinImageView.bounds = CGRectMake(0, 0, 70, 70);
//    eatCoinImageView.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT - 35);
//    [_bounderView addSubview:eatCoinImageView];
//    [self.view addSubview:eatCoinImageView];
//    [self.view bringSubviewToFront:eatCoinImageView];
//    [eatCoinImageView startUpdateAccelerometer];
//    self.eatCoinImageView = eatCoinImageView;
    
    UIImage *eatCoinImage = [UIImage imageNamed:@"cutely"];
    EatCoinImageView *eatCoinImageView = [[EatCoinImageView alloc] initWithFrame:CGRectZero];
     eatCoinImageView.image = eatCoinImage;
    eatCoinImageView.userInteractionEnabled = YES;
    eatCoinImageView.frame = CGRectMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - 70, 70, 70);
    eatCoinImageView.bounds = CGRectMake(0, 0, 70, 70);
    eatCoinImageView.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT - 35);
    [self.view addSubview:eatCoinImageView];
    [self.view bringSubviewToFront:eatCoinImageView];
    self.eatCoinImageView = eatCoinImageView;
    
    [eatCoinImageView startUpdateAccelerometer];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_eatCoinImageView stopUpdate];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_eatCoinImageView stopUpdate];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_eatCoinImageView startUpdateAccelerometer];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_eatCoinImageView startUpdateAccelerometer];
}

/**
 碰撞检测
*/

- (void)handleAction:(CADisplayLink *)displayLink{
    
    NSArray *array = [self.coinImageArray copy];
    
    for (UIImageView *imageView in array) {
        CGRect imageRect = [[imageView.layer presentationLayer] frame];
        CGFloat maxHeight = CGRectGetHeight(self.view.frame);
        
        //检测是否超出屏幕
        if (CGRectGetMinY(imageRect) >= maxHeight) {
            [imageView.layer removeAllAnimations];
            [imageView removeFromSuperview];
            [self.coinImageArray removeObject:imageView];
        }
        
        //检测是否碰撞
        CGRect rect = self.eatCoinImageView.frame;
        if (CGRectIntersectsRect(imageRect, rect)) {
            [imageView.layer removeAllAnimations];
            [imageView removeFromSuperview];
            [self.coinImageArray removeObject:imageView];
            NSLog(@"========== 碰撞了一个");
        }
    }
    
    //如果当前金币数小于7, 就添加金币
    NSInteger addCoinCount = 15 - self.coinImageArray.count;
    if (addCoinCount > 0) {
        [self addCoin:addCoinCount];
    }
}

/**
 添加一个金币并开始动画

 @param coinCount 添加金币数
 */
- (void)addCoin:(NSInteger)coinCount
{
    for (NSInteger i = 0; i < coinCount; i++) {
        UIImageView *coinImageView = [self createCoinImageView];
        [self.view addSubview:coinImageView];
        [self.view sendSubviewToBack:coinImageView];
        [self.coinImageArray addObject:coinImageView];
        [self coinImageViewBeginAnimation:coinImageView];
    }
}


/**
 执行金币动画
 随机时间, 动画最短时间3秒

 @param imageView 金币ImageView
 */
- (void)coinImageViewBeginAnimation:(UIImageView *)imageView
{
    CGPoint endPoint = CGPointMake(arc4random_uniform(self.view.frame.size.width), CGRectGetHeight(self.view.frame) + CGRectGetHeight(imageView.frame));
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    basicAnimation.duration = 1.0 + arc4random_uniform(1.0);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [imageView.layer addAnimation:basicAnimation forKey:@"CoinPosition"];
    imageView.transform = CGAffineTransformRotate(imageView.transform, arc4random_uniform(M_PI * 2));
}


/**
 创建一个金币ImageView
 随机比例和位置
 
 @return 金币ImageView
 */
- (UIImageView *)createCoinImageView
{
    UIImage *coinImage = [UIImage imageNamed:@"coin"];
    UIImageView *coinImageView = [[UIImageView alloc] initWithImage:coinImage];
    CGFloat scale = (30.0 + arc4random_uniform(30.0)) / 100.0;
    coinImageView.transform = CGAffineTransformMakeScale(scale, scale);
    CGSize winSize = self.view.bounds.size;
    CGFloat x = arc4random_uniform(winSize.width);
    CGFloat y = - coinImageView.frame.size.height - arc4random_uniform(winSize.height * 0.4);
//    CGFloat y = - coinImageView.frame.size.height;
    coinImageView.center = CGPointMake(x, y);
    return coinImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
