//
//  HHSliderClearLabel.h
//  slider滑动解锁测试
//
//  Created by 清风 on 2017/3/13.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HHSliderClearLabel : UILabel


{
    CGFloat gradientLocations[3];
}

@property (nonatomic, strong) NSTimer *animationTimer;
//@property (nonatomic, assign) CGFloat gradientLocations[3];
@property (nonatomic, assign) NSInteger animationTimerCount;
@property (nonatomic, assign, getter=isAnimated) BOOL animated;

@end
