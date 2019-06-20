//
//  WebProgressLayer.m
//  kuoyi
//
//  Created by alexzinder on 2019/6/14.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import "WebProgressLayer.h"
#import "UtilsMacro.h"

@interface WebProgressLayer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat stepWidth;

@end

static NSTimeInterval const progressInterval = 0.01;


@implementation WebProgressLayer


- (instancetype)init {
    if (self = [super init]) {
        self.progressColor = [UIColor whiteColor];
        self.stepWidth = 0.01;
        self.lineWidth = 2;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 2)];
        [path addLineToPoint:CGPointMake(DEVICE_WIDTH, 2)];
        self.path = path.CGPath;
        self.strokeEnd = 0;
    }
    return self;
}

- (void)setProgressColor:(UIColor *)progressColor {
    if (!progressColor) {
        return;
    }
    _progressColor = progressColor;
    //self.progressColor = progressColor;
}

/* 不断设置layer描边的结束位置 */
- (void)progressChanged:(NSTimer *)timer {
    self.strokeEnd += _stepWidth;
    if (self.strokeEnd > 0.9) {
        _stepWidth = 0.0001;
    }
}

- (void)progressAnimationStart {
    self.hidden = NO;
    if (_timer) {
        [self invalidateTimer];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:progressInterval target:self selector:@selector(progressChanged:) userInfo:nil repeats:YES];
}

- (void)progressAnimationCompletion {
    [self invalidateTimer];
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        _stepWidth = 0.01;
        self.strokeEnd = 0;
    });
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}


@end
