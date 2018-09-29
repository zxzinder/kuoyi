//
//  Customer.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/5.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "Customer.h"
#import <YYModel.h>

@implementation Customer
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userid" : @"id"
             };
}
@end
