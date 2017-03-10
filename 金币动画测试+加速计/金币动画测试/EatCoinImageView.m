//
//  eatCoinImageView.m
//  金币动画测试
//
//  Created by 清风 on 2017/2/27.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import "eatCoinImageView.h"
#import <CoreMotion/CoreMotion.h>

@interface EatCoinImageView ()
@property (readwrite) float velocity;//速度
@property (nonatomic, strong) CMMotionManager *mManager;
@end

@implementation EatCoinImageView

#pragma mark - 加速计
/* designate initializer */
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        _mManager = [[CMMotionManager alloc] init];
        /* 小球运动的速度（加速度的倍数），越大球运动越快，感觉上越灵敏 */
        self.velocity = 200;
    }
    return self;
}

/* lazy init */
- (CMMotionManager *)mManager
{
    if (!_mManager) {
        _mManager = [[CMMotionManager alloc] init];
    }
    return _mManager;
}

- (void)startUpdateAccelerometer
{
    /* 设置采样的频率，单位是秒 */
    NSTimeInterval updateInterval = 0.07;
    
    CGSize size = [self superview].frame.size;
    __block CGRect f = [self frame];
    
    //在block中，只能使用weakSelf。
    EatCoinImageView * __weak weakSelf = self;
    
    /* 判断是否加速度传感器可用，如果可用则继续 */
    if ([self.mManager isAccelerometerAvailable] == YES) {
        /* 给采样频率赋值，单位是秒 */
        [self.mManager setAccelerometerUpdateInterval:updateInterval];
        
        /* 加速度传感器开始采样，每次采样结果在block中处理 */
        [self.mManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             f.origin.x += (accelerometerData.acceleration.x * weakSelf.velocity) * 1;
             f.origin.y += (accelerometerData.acceleration.y * weakSelf.velocity) * -1;
             
             
             if(f.origin.x < 0)
                 f.origin.x = 0;
             if(f.origin.y < 0)
                 f.origin.y = 0;
             if(f.origin.y > 0)//不让向上移动
                 f.origin.y = [UIScreen mainScreen].bounds.size.height - 70;
             
             if(f.origin.x > (size.width - f.size.width))
                 f.origin.x = (size.width - f.size.width);
             if(f.origin.y > (size.height - f.size.height))
                 f.origin.y = (size.height - f.size.height);
             
             /* 运动动画 */
             [UIView beginAnimations:nil context:nil];
             [UIView setAnimationDuration:0.1];
             [weakSelf setFrame:f];
             [UIView commitAnimations];
             
         }];
    }
    
}

/* 停止传感器，当不是用的时候要及时停掉 */
- (void)stopUpdate
{
    if ([self.mManager isAccelerometerActive] == YES)
    {
        [self.mManager stopAccelerometerUpdates];
    }
    
}


#pragma mark - 手指移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //求偏移量 = 手指当前点的x值 - 手指前一个点的x值
    //当前点preciseLocationInView
    CGPoint currPoint = [touch locationInView:self];
//    CGPoint currPoint = [touch preciseLocationInView:self];

    //上一个点
    CGPoint prePoint = [touch previousLocationInView:self];
//    CGPoint prePoint = [touch precisePreviousLocationInView:self];

    //偏移量
    CGFloat conOfSetX = currPoint.x - prePoint.x;
    
    CGRect frame = self.frame;
    
    //获取整个屏幕宽度
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    float x = frame.origin.x;
    if (x + conOfSetX < 0 || x + frame.size.width + conOfSetX > screenWidth) {//防止超出屏幕
        
    }else{
        self.transform = CGAffineTransformTranslate(self.transform, conOfSetX, 0);
    }
}

//(x + delX < 0 || y + delY < 0 || x + frame.size.width + delX > screenWidth || y +frame.size.height + delY > screenHeight)

@end
