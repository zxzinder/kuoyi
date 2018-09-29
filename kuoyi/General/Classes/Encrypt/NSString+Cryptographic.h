//
//  NSString+Cryptographic.h
//  WFarm
//
//  Created by lxxccc on 15/1/29.
//  Copyright (c) 2015年 com.bluesword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Cryptographic)

- (NSString *) md5String;

- (NSString *) desEncryptStringWithKey:(NSString *) key;

- (NSString *) desDecryptStringWithKey:(NSString *) key;
@end
