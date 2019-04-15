//
//  CryptographicTools.h
//  WFarm
//
//
//
//  Created by lxxccc on 15/1/29.
//  Copyright (c) 2015年 com.bluesword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface CryptographicTools : NSObject

+ (instancetype)sharedInstance;

- (NSString *) base64StringFrom:(NSString*) input;
- (NSString *) base64DecryptStringFrom:(NSString *)input;
- (NSString *) md5StringFrom:(NSString*) input;

- (NSString *) desEncryptWithText:(NSString *)sText key:(NSString*)key;//加密
- (NSString *) desDecryptWithText:(NSString *)sText key:(NSString*)key;//解密
/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param content 要加密的文本
 *
 *  @return 加密后的字符串
 */
- (NSString *)hmacSHA256WithContent:(NSString *)content;
-(NSString *)hmacSHA256WithContentData:(NSData *)cData;
/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
- (NSString *)AES128EncryptStrig:(NSString *)string;

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
- (NSString *)AES128DecryptString:(NSString *)string;

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容NSData
 */
- (NSData *)AES128DecryptData:(NSString *)string;
@end
