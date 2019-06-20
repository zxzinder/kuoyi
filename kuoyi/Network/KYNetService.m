//
//  KYNetService.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "KYNetService.h"
#import <AFNetworking.h>
#import "UtilsMacro.h"


@implementation KYNetService
/** Post 请求 */
+(void)PostHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"text/plain",nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        /** 这里是处理事件的回调 */
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        /** 这里是处理事件的回调 */
        if (failureBlock) {
            failureBlock(@{});
        }
    }
     ];
    
    
}


/** Get 请求 */
+(void)GetHttpDataWithUrlStr:(NSString *)url Dic:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailedBlock)failureBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  //  manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    
   // manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    
   // manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
   // [manager.requestSerializer setValue: @"application/json;" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"***************Params****************");
    NSLog(@"地址：%@\n 参数：%@",url, dic);
    NSLog(@"***************Params****************");
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ApiBaseUrl,url];
    [manager GET:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      //  NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /** 这里是处理事件的回调 */
        NSDictionary *data;
        if ([NSJSONSerialization isValidJSONObject:responseObject]) {
           data = responseObject;
        }
        //successBlock(responseObject);
        if ([data[@"error"] integerValue] == 0) {
            successBlock(data);
        }else{
            NSLog(@"***************Error****************");
            NSLog(@"%@:失败  %@",url, data[@"msg"]);
            NSLog(@"***************Error****************");
            failureBlock(data);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        /** 这里是处理事件的回调 */
        if (failureBlock) {
//            failureBlock(error);
            NSDictionary *data = @{@"msg":@"请求失败"};
            failureBlock(data);
        }
    }
     
     ];
    
}
+(void)postDataWithUrl:(NSString*)url param:(NSDictionary *)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSDictionary *dict))fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ApiBaseUrl,url];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *jsonStr = [self dictionaryToJson:param];
    NSData *body  =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    
    
    
    //发起请求
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,NSError * _Nullable error){
        if (!error) {
            
           // BOOL isJson = [NSJSONSerialization isValidJSONObject:responseObject];
            
            //if ([responseObject isKindOfClass:[NSDictionary class]]) {
                // 请求成功数据处理
                
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dic[@"error"] && [dic[@"error"] integerValue] == 0) {
                 success(dic);
            }else{
                NSLog(@"%@:失败  %@",url, dic[@"msg"]);
                 fail(dic);
            }
            
//            } else {
//                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//
//                NSString *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",str);
//            }
        } else {
            NSLog(@"%@:失败",url);
            NSDictionary *dic = @{@"msg":@"请求失败"};
            fail(dic);
        }
        
     
          
          
          
      }] resume];
    
}
+(void)getDataWithUrl:(NSString*)url param:(NSDictionary *)param success:(void(^)(NSDictionary *dict))success fail:(void (^)(NSDictionary *dict))fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//不设置会报-1016或者会有编码问题
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; //不设置会报-1016或者会有编码问题
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //不设置会报 error 3840
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ApiBaseUrl,url];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    
    [request addValue:@"application/json;" forHTTPHeaderField:@"Content-Type"];
    NSString *jsonStr = [self dictionaryToJson:param];
    NSData *body  =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    
    
    
    //发起请求
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,NSError * _Nullable error){
        if (!error) {
            
            // BOOL isJson = [NSJSONSerialization isValidJSONObject:responseObject];
            
            //if ([responseObject isKindOfClass:[NSDictionary class]]) {
            // 请求成功数据处理
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dic[@"error"] && [dic[@"error"] integerValue] == 0) {
                success(dic);
            }else{
                NSLog(@"%@:失败  %@",url, dic[@"msg"]);
                fail(dic);
            }
            
            //            } else {
            //                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            //
            //                NSString *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            //                NSLog(@"%@",str);
            //            }
        } else {
            NSLog(@"%@:失败",url);
            NSDictionary *dic = @{@"msg":@"请求失败"};
            fail(dic);
        }
        
        
        
        
        
    }] resume];
    
}
+(void)upload:(NSData *)data FileName:(NSString *)fileName MimeType:(NSString *)mimeType sucess:(void (^)(NSDictionary *))sucess error:(void (^)(NSError *))errorBlock{
    NSString *baseUrlString = [NSString stringWithFormat:@"%@v1.user/upHeadImg",ApiBaseUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:baseUrlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传图片，以文件流的格式，这里注意：name是指服务器端的文件夹名字
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject;
        if (dic[@"error"] && [dic[@"error"] integerValue] == 0) {
            sucess(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError =nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
