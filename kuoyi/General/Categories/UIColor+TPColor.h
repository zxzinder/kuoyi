//
//  UIColor+TPColor.h
//  TransportPassenger
//
//  Created by Helly on 11/30/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TPColor)

+ (UIColor *)tp_navigationBarColor;

+ (UIColor *)tp_navigationBarTextColor;

+ (UIColor *)tp_tabbarNormalTextColor;

+ (UIColor *)tp_tabbarSelectedColor;

+ (UIColor *)tp_sliderBackgroundColor;

+ (UIColor *)tp_sliderTextColor;

+ (UIColor *)tp_buttonBackgroundColor;

+ (UIColor *)tp_buttonTextColor;

+ (UIColor *)tp_whiteButtonBackgroundColor;

+ (UIColor *)tp_blackTextColor;

+ (UIColor *)tp_lightBlackTextColor;

+ (UIColor *)tp_darkGaryTextColor;

+ (UIColor *)tp_lightGaryTextColor;

+ (UIColor *)tp_yellowTextColor;

+ (UIColor *)tp_greenTextColor;

+ (UIColor *)tp_redTextColor;

+ (UIColor *)tp_headOrangeTextColor;

+ (UIColor *)tp_headYellowTextColor;

+ (UIColor *)tp_grayCommentBackgroundColor;

+ (UIColor *)tp_lineColor;

+ (UIColor *)tp_disableColor;

+ (UIColor *)tp_blueTextColor;

+ (UIColor *)tp_lightGaryBackgroundColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString; //String like "e85a5a" as rgb
/**
 *  随机生成 RGB 颜色
 *
 *  @return RGB 颜色
 */
+ (UIColor *)randomRGBColor;

/**
 *  随机生成 SHB 颜色
 *
 *  @return SHB 颜色
 */
+ (UIColor *)randomSHBColor;

/**
 *  根据 RGB 值生成颜色
 *
 *  @param rgba RGB 颜色，例如 @[@112, @112, @112, @0.5]
 *
 *  @return RGB 颜色
 */
+ (UIColor *)colorWithRGBA:(NSArray *)rgba;
@end
