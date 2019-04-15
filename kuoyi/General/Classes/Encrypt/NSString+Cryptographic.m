//
//  NSString+Cryptographic.m
//  WFarm
//
//  Created by lxxccc on 15/1/29.
//  Copyright (c) 2015年 com.bluesword. All rights reserved.
//

#import "NSString+Cryptographic.h"
#import "CryptographicTools.h"

@implementation NSString(Cryptographic)

- (NSString *) md5String{
    return [[[CryptographicTools sharedInstance] md5StringFrom:self] uppercaseString];
}

- (NSString *) desEncryptStringWithKey:(NSString *) key{
    return [[CryptographicTools sharedInstance] desEncryptWithText:self key:key];
}

- (NSString *) desDecryptStringWithKey:(NSString *) key{
    return [[CryptographicTools sharedInstance] desDecryptWithText:self key:key];
}

- (NSString *) aes128EncryptString{
    return [[CryptographicTools sharedInstance] AES128EncryptStrig:self];
}

- (NSString *) aes128DecryptString{
    return [[CryptographicTools sharedInstance] AES128DecryptString:self];
}
- (NSString *)hmacSHA256String{
    
    return [[CryptographicTools sharedInstance] hmacSHA256WithContent:self];
    
}
- (NSString *)base64EncryptString{
    
     return [[CryptographicTools sharedInstance] base64StringFrom:self];
    
}

- (NSString *)base64DecryptString{
    
    return [[CryptographicTools sharedInstance] base64DecryptStringFrom:self];
    
}
@end
