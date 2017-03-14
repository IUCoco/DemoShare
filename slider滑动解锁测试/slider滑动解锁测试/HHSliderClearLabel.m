//
//  HHSliderClearLabel.m
//  slider滑动解锁测试
//
//  Created by 清风 on 2017/3/13.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//



#import "HHSliderClearLabel.h"

#define FRAMES_PER_SEC 10
static const CGFloat gradientWidth = 0.2;
static const CGFloat gradientDimAlpha = 0.5;

@implementation HHSliderClearLabel

- (void) setAnimated:(BOOL)animated {
    if (_animated != animated) {
        _animated = animated;
        if (_animated) {
            [self startTimer];
        } else {
            [self stopTimer];
        }
    }
}

// animationTimer methods
- (void)animationTimerFired:(NSTimer*)theTimer {
    // Let the timer run for 2 * FPS rate before resetting.
    // This gives one second of sliding the highlight off to the right, plus one
    // additional second of uniform dimness
    if (++_animationTimerCount == (2 * FRAMES_PER_SEC)) {
        _animationTimerCount = 0;
    }
    
    // Update the gradient for the next frame
    [self setGradientLocations:((CGFloat)_animationTimerCount/(CGFloat)FRAMES_PER_SEC)];
}

- (void) startTimer {
    if (!_animationTimer) {
        _animationTimerCount = 0;
        [self setGradientLocations:0];
        _animationTimer = [NSTimer
                          scheduledTimerWithTimeInterval:1.0/FRAMES_PER_SEC
                          target:self
                          selector:@selector(animationTimerFired:)
                          userInfo:nil 
                          repeats:YES];
    }
}

- (void) stopTimer {
    if (_animationTimer) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}


- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)theContext
{
    // Note: due to use of kCGEncodingMacRoman, this code only works with Roman alphabets!
    // In order to support non-Roman alphabets, you need to add code generate glyphs,
    // and use CGContextShowGlyphsAtPoint
    //CGContextSelectFont(theContext, [self.font.fontName UTF8String], self.font.pointSize, kCGEncodingMacRoman);
    
    // Set Text Matrix
    CGContextSetTextMatrix(theContext, CGAffineTransformMake(1.0,  0.0,
                                                             0.0, -1.0,
                                                             0.0,  0.0));
    
    // Set Drawing Mode to clipping path, to clip the gradient created below
    CGContextSetTextDrawingMode (theContext, kCGTextClip);
    
    // Draw the label's text
    // 不支持中文
    //	const char *text = [self.text cStringUsingEncoding:NSMacOSRomanStringEncoding];
    //	CGContextShowTextAtPoint(theContext,
    //                             0,
    //                             (size_t)self.font.ascender,
    //                             text,
    //                             strlen(text));
    
    UIGraphicsPushContext(theContext);
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        [self.text drawAtPoint:CGPointMake(0, (size_t)self.font.leading) withAttributes:attrsDictionary];
        
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || [[UIScreen mainScreen] bounds].size.height <= 480.0f){
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        [self.text drawAtPoint:CGPointMake(0, (size_t)self.font.leading-18) withAttributes:attrsDictionary];
    }
    
    //NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
    
    UIGraphicsPopContext();
    
    // Calculate text width
    CGPoint textEnd = CGContextGetTextPosition(theContext);
    
    // Get the foreground text color from the UILabel.
    // Note: UIColor color space may be either monochrome or RGB.
    // If monochrome, there are 2 components, including alpha.
    // If RGB, there are 4 components, including alpha.
    CGColorRef textColor = self.textColor.CGColor;
    const CGFloat *components = CGColorGetComponents(textColor);
    size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
    BOOL isRGB = (numberOfComponents == 4);
    CGFloat red = components[0];
    CGFloat green = isRGB ? components[1] : components[0];
    CGFloat blue = isRGB ? components[2] : components[0];
    CGFloat alpha = isRGB ? components[3] : components[1];
    
    // The gradient has 4 sections, whose relative positions are defined by
    // the "gradientLocations" array:
    // 1) from 0.0 to gradientLocations[0] (dim)
    // 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
    // 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
    // 4) from gradientLocations[3] to 1.0 (dim)
    size_t num_locations = 3;
    
    // The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
    // defines the R, G, B, and alpha values to be used by the corresponding
    // element of the gradientLocations array
    CGFloat gradientComponents[12];
    for (int row = 0; row < num_locations; row++) {
        int index = 4 * row;
        gradientComponents[index++] = red;
        gradientComponents[index++] = green;
        gradientComponents[index++] = blue;
        gradientComponents[index] = alpha * gradientDimAlpha;
    }
    
    // If animating, set the center of the gradient to be bright (maximum alpha)
    // Otherwise it stays dim (as set above) leaving the text at uniform
    // dim brightness
    if (_animationTimer) {
        gradientComponents[7] = alpha;
    }
    
    // Load RGB Colorspace
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    // Create Gradient
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
                                                                  gradientLocations, num_locations);
    // Draw the gradient (using label text as the clipping path)
    CGContextDrawLinearGradient (theContext, gradient, self.bounds.origin, textEnd, 0);
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    
}

- (void) setGradientLocations:(CGFloat) leftEdge {
    // Subtract the gradient width to start the animation with the brightest
    // part (center) of the gradient at left edge of the label text
    leftEdge -= gradientWidth;
    
    //position the bright segment of the gradient, keeping all segments within the range 0..1
    gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
    gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
    gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
    
    // Re-render the label text
    [self.layer setNeedsDisplay];
}

@end
