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

@end
