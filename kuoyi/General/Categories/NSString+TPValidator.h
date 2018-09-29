//
//  NSString+TPValidator.h
//  TransportPassenger
//
//  Created by Helly on 1/7/16.
//  Copyright © 2016 AnzeInfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TPValidator)

- (BOOL)isValidPassword;
- (BOOL)isValidUserName;
- (BOOL)isValidPhoneNumber;

- (BOOL)isContainsEmoji;
- (BOOL)isInputRuleAndBlank:(NSString *)str;
- (NSString *)disable_emoji:(NSString *)text;
- (BOOL)isInputRuleNotBlank:(NSString *)str;

/**
 *  返回高度
 */
+ (CGFloat)caculateHeight:(NSString *)title font:(NSInteger)font size:(CGSize)size;

/**
 *  返回宽度
 */
+ (CGFloat)caculateWidth:(NSString *)title font:(NSInteger)font size:(CGSize)size;


@end
