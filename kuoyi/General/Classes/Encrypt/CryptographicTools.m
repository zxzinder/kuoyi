//
//  CryptographicTools.m
//  WFarm
//
//  Created by lxxccc on 15/1/29.
//  Copyright (c) 2015年 com.bluesword. All rights reserved.
//

#import "CryptographicTools.h"
#import "GTMDefines.h"
#import "GTMBase64.h"
//#import "ConverUtil.h"

static CryptographicTools *_sharedInstance = nil;

@implementation CryptographicTools

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (NSString *) base64StringFrom:(NSString*) input{
    NSData *data = [GTMBase64 encodeData:[input dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}


- (NSString *) md5StringFrom:(NSString*) input{
    if (nil == input) {
        return nil;
    }
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}



- (NSString *) desEncryptWithText:(NSString *)sText key:(NSString*)key{
    return [self encrypt:sText key:key];
}


- (NSString *) desDecryptWithText:(NSString *)sText key:(NSString*)key{
    return [self decrypt:sText key:key];
}

#define gIv             @"12345678"

// 加密方法
- (NSString*)encrypt:(NSString*)plainText key:(NSString*)gkey{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

// 解密方法
- (NSString*)decrypt:(NSString*)encryptText key:(NSString*)gkey{
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}





//- (NSData *)DESCryptographic:(NSData *)inputData encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key{
//    const void *dataIn;
//    size_t dataInLength;
//    
//    dataInLength = [inputData length];
//    dataIn = [inputData bytes];
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
//    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
//    size_t dataOutMoved = 0;
//    
//    dataOutAvailable = (dataInLength  + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
//    memset((void *)dataOut, 0x0, dataOutAvailable);
//    
//    const void *vkey = (const void *) [key cStringUsingEncoding:NSUTF8StringEncoding];
//    const void *iv = (const void *) [@"12345678" cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    //CCCrypt函数 加密/解密
//    ccStatus = CCCrypt(encryptOperation,//  加密/解密
//                       kCCAlgorithm3DES,//  加密根据哪个标准（des，3des，aes。。。。）
//                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
//                       vkey,  //密钥    加密和解密的密钥必须一致
//                       kCCKeySize3DES,//   DES 密钥的大小（kCCKeySizeDES=8）
//                       iv, //  可选的初始矢量
//                       dataIn, // 数据的存储单元
//                       dataInLength,// 数据的大小
//                       (void *)dataOut,// 用于返回数据
//                       dataOutAvailable,
//                       &dataOutMoved);
//    if (kCCSuccess == ccStatus) {
//        NSData *result = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
//        return result;
//    }else{
//        if (kCCAlignmentError == ccStatus) {
//            NSLog(@"对齐失败");
//        }
//        NSLog(@"加解密失败  %zd", ccStatus);
//        return nil;
//    }
//}

@end
