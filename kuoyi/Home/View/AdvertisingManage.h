//
//  AdvertisingManage.h
//  kuoyi
//
//  Created by alexzinder on 2018/9/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisingManage : NSObject
/**
 *  单例初始化
 */
+ (instancetype)sharedManage;

/**
 *  添加广告页
 */
- (void)advertiseViewShow;

@end
