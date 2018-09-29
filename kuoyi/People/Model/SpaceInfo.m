//
//  SpaceInfo.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/1.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "SpaceInfo.h"

@implementation SpaceInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sid" : @"id"
             };
}
@end
