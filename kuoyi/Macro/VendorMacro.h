//
//  VendorMacro.h
//  TransportPassenger
//  存放第三方库使用的相关宏定义
//  Created by Helly on 10/16/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h
// 友盟分享
#define kUmengAppKey    @"5a70089eb27b0a44820001bb"
#define kUMShareTitle   @"可以"
#define kUMShareText    @"可以，安全、专业的互联网客运服务平台，专注城际专车和政企包车业务，为您提供出行专业用车服务。"
#define kUMShareUrlText @"可以，安全、专业的互联网客运服务平台，专注城际专车和政企包车业务，为您提供出行专业用车服务。http://wx.easylines.cn/share.html"
#define kUMShareUrl @"http://mp.weixin.qq.com/s?__biz=MzA3NzQyNzA1NA==&mid=507368350&idx=1&sn=948a8062d7d55d629a192ef9a0826cdf&scene=0&ptlang=2052&ADUIN=674112050&ADSESSION=1468891862&ADTAG=CLIENT.QQ.5485_.0&ADPUBNO=26574#wechat_redirect"
// 友盟推送
#define DEVICE_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define kUMessageAppKey                      @"5627256ce0f55ab9230001b9"
#define kUMessageAliasTypeTransportPassenger @"CUSTOMER"

// 微信AppId
#define kWXAppId                             @"wx63126dd59809d15e"
#define kWXAppSecret                         @"872b992c4dd5c227ed45f7e4de027e61"
#define KWXPartnerId                         @"1293881701"

// QQAppId
#define kQQAppId                             @"1106840738"
#define kQQAppKey                            @"lueRleH3hcBCgyW5"

// 微博App Key

#define kWBAppKey                            @"2387398404"
#define kWBSecret                            @"5dd2411aff5dbc4d05b78d1a0f65bb4a"


// 支付宝支付
#define kServiceKey                          @"mobile.securitypay.pay"
#define kPartnerKey                          @"2017080308019368"
#define kInputCharsetKey                     @"utf-8"
#define kSignTypeKey                         @"RSA"

#define kSignKey                             @"MIIEpAIBAAKCAQEApZ/RxCXt0H3y1h/c9hE/ZuxuEO5gKrCI3qnMY9RJdWY9u0AR+sdm1ZwjbnPRoEBYtfeWmL0O8biYNygsA7+R2+l227GyRRUDlX1fccOZI90SmJLnM4QYeO5kiR/BqpuKFDuogv6T7UkzyM2I3umChRcIUo050n1PPglve7q/h/1SS6t5ZHSEPnGENDPEjXOY9JQaV24VPvObtViHrbRVp7V6Zt0uBPWBWz61aGVlJ0uUY6OOOJl9bYN+u3iFTokHKjFAvmS7YVAXJqdRWfREFOWB1x3p2A9GJQLYCwlSTDpJjR32lxlIZKlgPB4nBJBhXP2r9oORiI02xQoLedRTgwIDAQABAoIBAAhfYOpKhJAindEHQVNLIephD1tZwZDG5dRjvwpY4/HEXmCF56LGy8MGpp/hyPoR5qokPv+vpv6/NyqqpDb4SzZTwgdvHzTw0AKRmO6WVbqDZXpDCt8G0Xnjiz+HVHH8dOl67pTYq7+2EKEZCs9B/LAfrvMFYqPqY8QeE/2sPhxwtA55OyyjNJlwNFzptZ0PKTPKmsbJ6+MwixpAK1vjje6r4UDtUUrnfFuhzM2CTYhCPc3cDGjHxSwvmnJaRfs73iNdzlavpDbOcwJjobF0dQ8uKUOfo3TLA13NRQh7JChBWUZwg+HssP4YAUb8AONEcpfiN/L9flZtl7+7Algu27kCgYEA10OTGjRnLwtttn7szGrlpDyezi3du4fFgamY3DvBimpfcTQqihVLbbyc8z6gjhgLf8QkNKJe5/BaBz3cOzoqb+OiXTugde4p65yILnKiAVH1jdx1MypBb82au0+kH+QwsHNekMeE6sRma8RcgrB3SAWlpbrWAEEOsOJNWE3JqZUCgYEAxPd1qmIEbaUBWKIH89NeafFiv0QrJmYW0gt+8kxmtvof399us66yP0TUkcR1P1UfAOk5yPK1cvO2q39ozQPsH5BvE2GKonMs1GPSoZ83LRODqVoE+CvzsBs9jGiMA9vAOf7zYF4tmeoOTfLnvx7o0K42HXnFHCRXVS4EojwZMrcCgYEAvfgYnYuZc972F5OzjkLYHjSRQQshHxoWpvLwv4rMpkZxrAmJcQqR4moNaGzgbAW0QDDscrbIYo+uI63n6SzPvqZ45yZz2R8xR4iAdd0cM2YM+gCQPXMRBIXCA4OpJ6vNfCqUTdiF6FkiugA0U/E/kwPIx5U2vkqrmFZeQ4uCaHECgYAD8KtS6DkMdHONcVhVYVIPLnv6NYPjdcFZHE/CyxJ28JP4p4CQaZs5NshFzjdGOA6xtvin82r7zLJHxfmzuDNeAkamjZn3W/R2nzSUdRnmdfB5T8qvqDlsuW7Gw0ShwyCaSGZX9CpXXN5CYuyN3zFrE0ET3964jGWO16fSEv+yCwKBgQDJx5xVTWh+OxnQM5yRj7ocue7r39GPo0G9HRlaPHTkc4Xkp/UVJhYpVEBZr1s70+rBujns4jrCfGwQEQ14OJpcgdVsRFzZZTWgaSwictHaAkQl5CbT6HZjun6PXNNlFXNVRlIwzwqHWVm9wRAKM/i9+1NbHteA5PSkqVamSQA00w=="

#define kAppPublic @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ/RxCXt0H3y1h/c9hE/ZuxuEO5gKrCI3qnMY9RJdWY9u0AR+sdm1ZwjbnPRoEBYtfeWmL0O8biYNygsA7+R2+l227GyRRUDlX1fccOZI90SmJLnM4QYeO5kiR/BqpuKFDuogv6T7UkzyM2I3umChRcIUo050n1PPglve7q/h/1SS6t5ZHSEPnGENDPEjXOY9JQaV24VPvObtViHrbRVp7V6Zt0uBPWBWz61aGVlJ0uUY6OOOJl9bYN+u3iFTokHKjFAvmS7YVAXJqdRWfREFOWB1x3p2A9GJQLYCwlSTDpJjR32lxlIZKlgPB4nBJBhXP2r9oORiI02xQoLedRTgwIDAQAB"

#define kAliZFBPublic @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkj3rETkWu+4MyxX73/Y26uPQO6SMnKBxYsB343Dk7pxAf7FU6LUYvktybdOULyQZpw+Pv34n5uBbo5Bu7blTIBn+DlRmcPJZQtPXRN9mInst+LeIqyQv8mZloWYx36w4qT90XrWJySE1s2welnnl02KB6XI1MpSWO8c2Vrh8dqXZkOpQgsTtPiwd3Vn2g23uSOq9BfYEEErvZ+j8O07htZlxfOqcxadPX6NyiPwL4xCcBDsnpvqsIqOqq1U3nxLx04irh1CB+oyZ2/CoJ1yH4LXduRXHx/KQlDb3XufCWxQocxbrd2nLy/ORj5bo6zEcB4HH/0eqOqP6+4x2pn8DxwIDAQAB"

#define kPaymentTypeKey                      @"1"
#define kSellerIdKey                         @"kuoyilife@163.com"
#define kTimeoutKey                          @"30m"

#define kAlipaySchemeKey                           @"alipay2017080308019368"


#define kCallBackPrefixAlipay @"alipay2017080308019368://safepay/"

#define CANCELBUTTON_TAG 100
#define OKBUTTON_TAG 200

#endif /* VendorMacro_h */
