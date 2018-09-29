//
//  KYNetService.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock) (NSDictionary *dict);

typedef void (^FailedBlock) (NSDictionary *dict);

@interface KYNetService : NSObject

/** Post 请求 */
+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

/** Get 请求 */
+(void)GetHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock;

+(void)postDataWithUrl:(NSString *)url param:(NSDictionary *)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSDictionary *dict))fail;
+(void)getDataWithUrl:(NSString*)url param:(NSDictionary *)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSDictionary *dict))fail;
+(void)upload:(NSData *)data FileName:(NSString *)fileName MimeType:(NSString *)mimeType sucess:(void (^)(NSDictionary *))sucess error:(void (^)(NSError *))errorBlock;
@end
