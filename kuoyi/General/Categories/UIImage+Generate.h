//
//  UIImage+Generate.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Generate)
+ (UIImage *)imageWithColor:(UIColor *)aColor;

+ (UIImage *)imageWithColor:(UIColor *)aColor Rect:(CGRect)aRect;
@end
