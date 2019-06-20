//
//  WebProgressLayer.h
//  kuoyi
//
//  Created by alexzinder on 2019/6/14.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebProgressLayer : CAShapeLayer

@property (nonatomic, strong) UIColor *progressColor;
/**
 进度条开始加载
 */
- (void)progressAnimationStart;
/**
 进度条加载完成
 */
- (void)progressAnimationCompletion;

@end

NS_ASSUME_NONNULL_END
