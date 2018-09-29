//
//  PayOrderTool.m
//  kuoyi
//
//  Created by alexzinder on 2018/8/20.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PayOrderTool.h"
#import "NotificationMacro.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "VendorMacro.h"
#import "APRSASigner.h"
#import "CTAlertView.h"
#import "HLYHUD.h"

@implementation PayOrderTool

+(void)goToAliPay:(NSDictionary *)payInfoDic{
    
    NSString *appID = kPartnerKey;
    NSString *rsa2PrivateKey = kSignKey;
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 || [rsa2PrivateKey length] == 0)  {
        [HLYHUD showHUDWithMessage:@"缺少appId或者私钥,请检查参数设置" addToView:nil];
    }
    
    /*
     *生成订单信息及签名
     */
    APOrderInfo* order = [APOrderInfo new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = @"RSA2";
    order.notify_url = payInfoDic[@"notifyurl"];
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"测试1";//self.payInfoDic[@"description"];
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = payInfoDic[@"orderno"];//[self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = kTimeoutKey; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格self.payInfoDic[@"price"]
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:rsa2PrivateKey];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = kAlipaySchemeKey;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSNumber *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus integerValue] == 9000) {
                [HLYHUD showHUDWithMessage:@"支付成功！" addToView:nil];
            }else{
                [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
            }
        }];
    }
    
}

@end
