//
//  SettingDataSource.m
//  TransportPassenger
//
//  Created by  HCD on 15/11/20.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#import "SettingDataSource.h"

@implementation SettingDataSourceItem

- (instancetype)initTitle:(NSString *)title pushVCName:(NSString *)pushControllerName
{
    self = [super init];
    if (self) {
        self.title = title;
        self.pushControllerName = pushControllerName;
    }
    return self;
}

@end

@implementation SettingDataSource
+ (NSArray *)dataSource
{
//    _dataSourceArray = @[
//                         @[@"正文字号",@"清除缓存"],
//                         @[@"帮助反馈",@"关注我们",@"分享KUOYI给好友",@"站长指南",@"去App Store给KUOYI个好评"],
//                         @[@"用户协议",@"版本号"],
//                         ];
    SettingDataSourceItem * articleFont = [[SettingDataSourceItem alloc]initTitle:@"正文字号" pushVCName:@""];
    
    SettingDataSourceItem * clearCache = [[SettingDataSourceItem alloc]initTitle:@"清除缓存" pushVCName:@""];
    
    
    
    SettingDataSourceItem * feedBack = [[SettingDataSourceItem alloc] initTitle:@"意见反馈" pushVCName:@"FeedBackViewController"];
    SettingDataSourceItem * aboutUs = [[SettingDataSourceItem alloc]initTitle:@"关于我们" pushVCName:@"BaseWebViewController"];
    aboutUs.protocolType = kWebProtocolTypeAboutUs;
    
    SettingDataSourceItem * shareUs = [[SettingDataSourceItem alloc]initTitle:@"分享KUOYI给好友" pushVCName:SHARE_US];
    SettingDataSourceItem * guide = [[SettingDataSourceItem alloc]initTitle:@"站长指南" pushVCName:@"BaseWebViewController"];
    guide.protocolType = kWebProtocolTypeGuide;
    SettingDataSourceItem * comment = [[SettingDataSourceItem alloc]initTitle:@"去App Store给KUOYI个好评" pushVCName:APP_STORE];
    
    
    
    SettingDataSourceItem * userPro = [[SettingDataSourceItem alloc]initTitle:@"用户协议" pushVCName:@"BaseWebViewController"];
    userPro.protocolType = kWebProtocolTypeAgreement;
    SettingDataSourceItem *update = [[SettingDataSourceItem alloc] initTitle:@"当前版本" pushVCName:@""];
    

    
    return @[@[articleFont,clearCache],@[feedBack,aboutUs,shareUs,guide,comment],@[userPro,update]];
}



@end





