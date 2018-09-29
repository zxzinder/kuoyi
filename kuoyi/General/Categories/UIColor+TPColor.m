//
//  UIColor+TPColor.m
//  TransportPassenger
//
//  Created by Helly on 11/30/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#import "UIColor+TPColor.h"

@implementation UIColor (TPColor)

+ (UIColor *)tp_navigationBarColor {
    return [UIColor colorWithRed:0.251 green:0.235 blue:0.365 alpha:1.000];
}

+ (UIColor *)tp_navigationBarTextColor {
    return [UIColor colorWithWhite:0.906 alpha:1.000];
}

+ (UIColor *)tp_tabbarNormalTextColor {
    return [UIColor colorWithWhite:0.627 alpha:1.000];
}

+ (UIColor *)tp_tabbarSelectedColor {
    return [UIColor tp_buttonBackgroundColor];
}

+ (UIColor *)tp_sliderBackgroundColor {
    return [UIColor colorWithRed:0.467 green:0.443 blue:0.651 alpha:1.000];
}

+ (UIColor *)tp_sliderTextColor {
    return [self tp_sliderBackgroundColor];
}

+ (UIColor *)tp_whiteButtonBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)tp_buttonTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)tp_blueTextColor {
    return [UIColor colorWithRed:42.0/255 green:192.0/255 blue:212.0/255 alpha:1];
}

+ (UIColor *)tp_lightGaryBackgroundColor {
    return [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.000];
}

/**
 *    Button背景色 #FFB94A
 *
 *    @return Button背景色 #FFB94A
 */

+ (UIColor *)tp_buttonBackgroundColor {
    return [UIColor colorWithRed:1.000 green:0.725 blue:0.290 alpha:1.000];
}

+ (UIColor *)tp_blackTextColor {
     return [UIColor colorWithWhite:0.1333 alpha:1.0];
}
/**
 *    文字黑 #3C3C3C
 *
 *    @return 文字黑 #3C3C3C
 */

+ (UIColor *)tp_lightBlackTextColor {
    return [UIColor colorWithWhite:0.235 alpha:1.000];
}

/**
 *    文字灰 #999999
 *
 *    @return 文字灰 #999999
 */
+ (UIColor *)tp_darkGaryTextColor {
    return [UIColor colorWithWhite:0.6 alpha:1.0];
}


/**
 *    文字灰 #c8c8c8
 *
 *    @return 文字灰 #c8c8c8
 */
+ (UIColor *)tp_lightGaryTextColor {
    return [UIColor colorWithWhite:0.784 alpha:1.000];
}


/**
 *    文字橙 #F69603
 *
 *    @return 文字橙
 */

+ (UIColor *)tp_yellowTextColor {
    return [UIColor colorWithRed:0.965 green:0.588 blue:0.012 alpha:1.000];
}

/**
 *    文字绿色 #41cad6
 *
 *    @return 文字绿色
 */
+ (UIColor *)tp_greenTextColor {
    return [UIColor colorWithRed:0.26 green:0.808 blue:0.856 alpha:1.00];
}

/**
 *    文字红 #DF1C1C
 *
 *    @return 文字红 #DF1C1C
 */

+ (UIColor *)tp_redTextColor {
    return [UIColor colorWithRed:0.875 green:0.110 blue:0.110 alpha:1.000];
}


+ (UIColor *)tp_headOrangeTextColor {
    return [UIColor colorWithRed:0.9801 green:0.7475 blue:0.531 alpha:1.0];
}

+ (UIColor *)tp_headYellowTextColor {
    return [UIColor colorWithRed:0.922 green:0.651 blue:0.251 alpha:1.000];
}

/**
 *    默认背景色 #F69603
 *
 *    @return 默认背景色 #F69603
 */
+ (UIColor *)tp_grayCommentBackgroundColor {
    return [UIColor colorWithWhite:0.965 alpha:1.000];
}

+ (UIColor *)tp_lineColor {
    return  [UIColor colorWithWhite:0.906 alpha:1.000];
}

+ (UIColor *)tp_disableColor {
    return [UIColor tp_lightGaryTextColor];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    if (!hexString || hexString.length < 6) {
        return nil;
    }
    NSString *upperStr = hexString.uppercaseString;
    NSString *redStr = [@"0x" stringByAppendingString:[upperStr substringWithRange:NSMakeRange(0, 2)]];
    NSString *greenStr = [@"0x" stringByAppendingString:[upperStr substringWithRange:NSMakeRange(2, 2)]];
    NSString *blueStr = [@"0x" stringByAppendingString:[upperStr substringWithRange:NSMakeRange(4, 2)]];
    NSInteger red = strtoul([redStr UTF8String], 0, 16);
    NSInteger green = strtoul([greenStr UTF8String], 0, 16);
    NSInteger blue = strtoul([blueStr UTF8String], 0, 16);
    
    UIColor *color = [UIColor colorWithRed:(CGFloat)red/255.0 green:(CGFloat)green/255.0 blue:(CGFloat)blue/255.0 alpha:1];
    return color;
}

+ (UIColor *)randomRGBColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        // srandom()这个函数是初始化随机数产生器
        srandom((unsigned)time(NULL));
    }
    // random()函数产生随即值
    CGFloat red   = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue  = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)randomSHBColor {
    //  0.0 to 1.0
    CGFloat hue = arc4random() % 256 / 256.0 ;
    //  0.5 to 1.0, away from white
    CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;
    //  0.5 to 1.0, away from black
    CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)colorWithRGBA:(NSArray *)rgba {
    NSAssert(rgba.count == 4, @"Color array should have four parameters !");
    return [UIColor colorWithRed:[rgba[0] floatValue] / 255
                           green:[rgba[1] floatValue] / 255
                            blue:[rgba[2] floatValue] / 255
                           alpha:[rgba[3] floatValue] / 1];
}
@end
