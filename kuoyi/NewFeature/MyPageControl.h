//
//  MyPageControl.h
//  kuoyi
//
//  Created by alexzinder on 2018/3/15.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl

- (id)initWithFrame:(CGRect)frame;
- (void)updateDots;
@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;


@end
