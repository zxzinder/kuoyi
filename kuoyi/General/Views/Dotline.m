//
//  Dotline.m
//  TransportPassenger
//
//  Created by 李齐 on 15/10/28.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#import "Dotline.h"
#import "UtilsMacro.h"

@implementation Dotline

-(instancetype)initWithWidth:(CGFloat)width{
    self.lineWidth = width;
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawLine];
    }
    return self;
}

- (void) drawLine {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:RGBColor(176, 176, 176, 0.8).CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (self.lineWidth) {
        CGPathAddLineToPoint(path, NULL, self.lineWidth, 0);
    }else {
        CGPathAddLineToPoint(path, NULL, DEVICE_WIDTH, 0);
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [[self layer] addSublayer:shapeLayer];
}

@end
