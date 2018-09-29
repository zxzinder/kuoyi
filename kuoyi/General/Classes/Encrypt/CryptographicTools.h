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

- (NSString *) md5StringFrom:(NSString*) input;

- (NSString *) desEncryptWithText:(NSString *)sText key:(NSString*)key;//加密
- (NSString *) desDecryptWithText:(NSString *)sText key:(NSString*)key;//解密

@end
