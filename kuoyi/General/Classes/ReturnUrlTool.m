//
//  ReturnUrlTool.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ReturnUrlTool.h"
#import "UtilsMacro.h"
#import "DataManager.h"
#import "NotificationMacro.h"

@implementation ReturnUrlTool


+ (NSString *)getUrlByWebType:(WebProtocolType)webType andDetailId:(NSInteger)detailId{
//    kWebProtocolTypeBook             = 100001,  //书
//    kWebProtocolTypeActivity                   = 100002,  //活动
//    kWebProtocolTypeLesson             = 100003,  //课程
//    kWebProtocolTypeSpace      = 100004,  //店
//    店H5页面：http://域名/h5/dian/appInfo.html?id=店ID
//    活动H5页面：http://域名/h5/huo_dong/appInfo.html?id=活动ID
//    课程H5页面：http://域名/h5/ke_cheng/appInfo.html?id=课程ID
//    书H5页面：http://域名/h5/shu/appInfo.html?id=书ID
    
    NSString *sizeFont = [DataManager objectForRead:kDefaultSizeFont];
    if (!sizeFont || [sizeFont isEqualToString:@""]) {
        sizeFont = @"2";
    }
    
    NSString *urlStr = @"";
    if (webType == kWebProtocolTypeSpace) {
        urlStr = [NSString stringWithFormat:@"http://%@/h5/dian/appInfo.html?id=%ld",webDomain,(long)detailId];
    }else if (webType == kWebProtocolTypeActivity){
        urlStr = [NSString stringWithFormat:@"http://%@/h5/huo_dong/appInfo.html?id=%ld",webDomain,(long)detailId];
    }else if (webType == kWebProtocolTypeLesson){
        urlStr = [NSString stringWithFormat:@"http://%@/h5/ke_cheng/appInfo.html?id=%ld",webDomain,(long)detailId];
    }else if (webType == kWebProtocolTypeBook){
        urlStr = [NSString stringWithFormat:@"http://%@/h5/shu/appInfo.html?id=%ld",webDomain,(long)detailId];
    }else if (webType == kWebProtocolTypeStory){
         urlStr = [NSString stringWithFormat:@"http://%@/h5/people/gushiInfo.html?id=%ld&sizeFont=%@",webDomain,(long)detailId,sizeFont];
    }else if (webType == kWebProtocolTypeArticle){
        urlStr = [NSString stringWithFormat:@"http://%@/h5/goods/appInfo.html?id=%ld",webDomain,(long)detailId];
    }else if (webType == kWebProtocolTypeAboutUs){
        urlStr = [NSString stringWithFormat:@"http://www.kuoyilife.com/app.php/h5/article/appInfo?id=13"];
    }else if (webType == kWebProtocolTypeGuide){
        urlStr = [NSString stringWithFormat:@"http://www.kuoyilife.com/app.php/h5/article/appInfo?id=14"];
    }else if (webType == kWebProtocolTypeAgreement){
        urlStr = [NSString stringWithFormat:@"http://www.kuoyilife.com/app.php/h5/article/appInfo?id=15"];
    }
    return urlStr;
}

@end
