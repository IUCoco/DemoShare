//
//  HHSliderClearView.m
//  slider滑动解锁测试
//
//  Created by 清风 on 2017/3/13.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import "HHSliderClearView.h"
#import "HHSliderClearLabel.h"


@implementation HHSliderClearView

- (id)initWithFrame:(CGRect)frame
{
//    if (frame.size.width < 136.0) {
//        frame.size.width = 136.0;
//    }
//    if (frame.size.height < 44.0) {
//        frame.size.height = 34.0;
//    }
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContent];
    }
    return self;
}

- (void)loadContent{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    if (!_label || !_slider) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        _label = [[HHSliderClearLabel alloc] initWithFrame:CGRectZero];
        _label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:16];
        [self addSubview:_label];
        _label.animated = YES;
        
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGPoint ctr = _slider.center;
        CGRect sliderFrame = _slider.frame;
        sliderFrame.size.width -= 4;
        _slider.frame = sliderFrame;
        _slider.center = ctr;
        _slider.backgroundColor = [UIColor clearColor];
        
//        UIImage *thumbImage = [self thumbWithColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
//        UIImage *thumbImage = [UIImage imageNamed:@"cutely"];
//        [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
        
        UIImage *clearImage = [self clearPixel];
        [_slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
        
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        _slider.continuous = YES;
        _slider.value = 0.0;
        [self addSubview:_slider];
        
        // Set the slider action methods
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self
                    action:@selector(sliderDown:)
          forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self
                    action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
        
        
    }
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat sliderWidth = [_slider thumbImageForState:_slider.state].size.width;
    CGSize labelSize = [_label sizeThatFits:self.bounds.size];
    
    _label.frame = CGRectMake(sliderWidth + 20.0,
                              CGRectGetMidY(self.bounds) - (labelSize.height / 2.0),
                              CGRectGetWidth(self.bounds) - sliderWidth - 30.0,
                              labelSize.height
                              );
    _slider.frame = self.bounds;
}

// Implement the "enabled" property
- (BOOL) enabled {
    return _slider.enabled;
}

- (void) setEnabled:(BOOL)enabled{
    _slider.enabled = enabled;
    _label.enabled = enabled;
    if (enabled) {
        _slider.value = 0.0;
        _label.alpha = 1.0;
        _sliding = NO;
    }
    [_label setAnimated:enabled];
}

// Implement the "text" property
- (NSString *) text {
    return [_label text];
}

- (void) setText:(NSString *)text {
    [_label setText:text];
}

// Implement the "labelColor" property
- (UIColor *) labelColor {
    return [_label textColor];
}

- (void) setLabelColor:(UIColor *)labelColor {
    [_label setTextColor:labelColor];
}

// UISlider actions
- (void) sliderUp:(UISlider *)sender {
    
    if (_sliding) {
        _sliding = NO;
        
        if (_slider.value == 1.0) {
//            [_delegate sliderDidSlide:self];
            [_delegate sliderDidCompleteSlide:self];
        }
        
        [_slider setValue:0.0 animated: YES];
        _label.alpha = 1.0;
        [_label setAnimated:YES];
    }
}

- (void) sliderDown:(UISlider *)sender {
    
    if (!_sliding) {
        [_label setAnimated:NO];
    }
    _sliding = YES;
}

- (void) sliderChanged:(UISlider *)sender {
    
    _label.alpha = MAX(0.0, 1.0 - (_slider.value * 3.5));
}


- (void)setUpThumbImage:(UIImage *)image{//设置滑动图片
    [_slider setThumbImage:image forState:UIControlStateNormal];
}

- (UIImage *) clearPixel {//清掉slider的滑条
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
