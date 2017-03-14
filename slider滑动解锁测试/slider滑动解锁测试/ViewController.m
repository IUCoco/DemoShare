//
//  ViewController.m
//  slider滑动解锁测试
//
//  Created by 清风 on 2017/3/13.
//  Copyright © 2017年 com.hhdd. All rights reserved.
//

#import "ViewController.h"
#import "HHSliderClearView.h"

@interface ViewController ()<HHSliderClearViewDelegate>

@property (strong, nonatomic) HHSliderClearView *clearSlider;//滑块带边框
@property (strong, nonatomic) HHSliderClearView *clearSlider1;//滑块不带边框

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    //添加滑块
//    _clearSlider = [[HHSliderClearView alloc] initWithFrame:CGRectMake(20.0, 100.0, [[UIScreen mainScreen] bounds].size.width-38.0, 35.0)];
//    _clearSlider.tag = 0;
//    //边框颜色
//    _clearSlider.layer.borderWidth = 1;
//    _clearSlider.layer.borderColor =  [[UIColor orangeColor] CGColor];
//    //背景颜色
//    _clearSlider.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
//    //边角弧度
//    _clearSlider.layer.cornerRadius = 10.0;
//    //设置显示字体
//    [_clearSlider setText:@"Happy New Year!"];
//    //滑块图案
//    UIImage *thumbImage = [UIImage imageNamed:@"cutely"];
//    [_clearSlider setUpThumbImage:thumbImage];
//    //闪动字体颜色
//    [_clearSlider setLabelColor:[UIColor colorWithRed:255/255.0 green:109/255.0 blue:11/255.0 alpha:1.0]];
//    //设置代理
//    [_clearSlider setDelegate:self];
//    [self.view addSubview:_clearSlider];
    
    
    _clearSlider = [[HHSliderClearView alloc] initWithFrame:CGRectMake(20.0, 165.0, [[UIScreen mainScreen] bounds].size.width-38.0, 35.0)];
    _clearSlider.tag = 0;
    _clearSlider.layer.cornerRadius = 3.0;
    _clearSlider.backgroundColor = [UIColor grayColor];
    [_clearSlider setText:@"滑动来解锁"];
    //滑块图案
    UIImage *thumbImage = [UIImage imageNamed:@"cutely"];
    [_clearSlider setUpThumbImage:thumbImage];
    [_clearSlider setDelegate:self];
    [self.view addSubview:_clearSlider];
    
}

//- (void) sliderDidSlide:(HHSliderClearView *)slideView {
//    switch ((long)slideView.tag) {
//        case 0:
//            NSLog(@"Happy New Year!");
//            break;
//        default:
//            break;
//    }
//}

- (void) sliderDidCompleteSlide:(HHSliderClearView *)slideView{
    NSLog(@"-----滑动结束啦！");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
