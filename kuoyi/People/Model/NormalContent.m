//
//  NormalContent.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/1.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "NormalContent.h"
#import <YYModel.h>

@implementation NormalContent
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nid" : @"id"
             };
}
@end
