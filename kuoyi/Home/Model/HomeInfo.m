//
//  HomeInfo.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "HomeInfo.h"
#import <YYModel.h>
#import "HomeDetail.h"


@implementation HomeInfo
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [HomeDetail class]};
}
@end
