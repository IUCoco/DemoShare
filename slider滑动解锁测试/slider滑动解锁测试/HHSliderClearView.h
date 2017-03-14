//
//  HHSliderClearView.h
//  slider滑动解锁测试
//
//  Created by 清风 on 2017/3/13.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHSliderClearLabel;
@protocol HHSliderClearViewDelegate;


@interface HHSliderClearView : UIView

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) HHSliderClearLabel *label;
@property (nonatomic, weak) id<HHSliderClearViewDelegate> delegate;
//@property (nonatomic, assign, getter=isSliding) BOOL sliding;
@property (nonatomic, assign) BOOL sliding;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

- (void)setUpThumbImage:(UIImage *)image;//设置滑动图案

@end

@protocol  HHSliderClearViewDelegate<NSObject>
//- (void)sliderDidSlide:(HHSliderClearView *)slideView;
- (void)sliderDidCompleteSlide:(HHSliderClearView *)slideView;
@end
