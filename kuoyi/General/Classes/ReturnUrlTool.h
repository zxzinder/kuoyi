//
//  ReturnUrlTool.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumHeader.h"

@interface ReturnUrlTool : NSObject

/**
 *  返回url
 *
 */
+ (NSString *)getUrlByWebType:(WebProtocolType)webType andDetailId:(NSInteger)detailId;


@end
