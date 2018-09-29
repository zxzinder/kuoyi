//
//  NSString+TPValidator.m
//  TransportPassenger
//
//  Created by Helly on 1/7/16.
//  Copyright © 2016 AnzeInfo. All rights reserved.
//

#import "NSString+TPValidator.h"

@implementation NSString (TPValidator)

- (BOOL)isValidPassword {

    BOOL valid = NO;
    
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if ((self.length >= 6 && self.length <= 12) && [predicate evaluateWithObject:self]) {
        valid = YES;
    }
    
    return valid;
}

- (BOOL)isValidUserName {
    
    if (self.length >= 2 && self.length <= 10) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isValidPhoneNumber {
    NSString *regex = @"[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self]) {
        return YES;
    } else {
        return NO;
    }
}

// 判断是否包含表情符号
- (BOOL)isContainsEmoji {
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}
/**
 *  返回高度
 */
+ (CGFloat)caculateHeight:(NSString *)title font:(NSInteger)font size:(CGSize)size {
    
    CGFloat index                         = 0;
    //计算长文本所占空间大小
    //iOS7后：
    NSDictionary *attributes                = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    //配置字符绘制规则 |位或 拼接 成一个整体
    NSStringDrawingOptions options =
    NSStringDrawingTruncatesLastVisibleLine |//如果字符绘制不完呈现省略号
    NSStringDrawingUsesFontLeading |//以字体的行高作为间距
    NSStringDrawingUsesLineFragmentOrigin;//
    
    
    // 计算文本的大小  ios7.0
    CGRect rect                             = [title boundingRectWithSize:size// 用于计算文本绘制时占据的矩形块
                                                                  options:options
                                                               attributes:attributes                                                         context:NULL];
    index                                   += rect.size.height;
    
    return index+1;
}


/**
 *  返回宽度
 */
+ (CGFloat)caculateWidth:(NSString *)title font:(NSInteger)font size:(CGSize)size {
    
    CGFloat index                         = 0;
    //计算长文本所占空间大小
    //iOS7后：
    NSDictionary *attributes                = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    
    //配置字符绘制规则 |位或 拼接 成一个整体
    NSStringDrawingOptions options =
    NSStringDrawingTruncatesLastVisibleLine |//如果字符绘制不完呈现省略号
    NSStringDrawingUsesFontLeading |//以字体的行高作为间距
    NSStringDrawingUsesLineFragmentOrigin;
    
    // 计算文本的大小  ios7.0
    CGRect rect                             = [title boundingRectWithSize:size// 用于计算文本绘制时占据的矩形块
                                                                  options:options
                                                               attributes:attributes                                                         context:NULL];
    index                                   += rect.size.width;
    return index + 1;
}
@end
