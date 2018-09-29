//
//  HomeDetail.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "HomeDetail.h"
#import <YYModel.h>


@implementation HomeDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"detailID" : @"id"
             };
}
@end
