//
//  MessageModel.h
//  kuoyi
//
//  Created by alexzinder on 2018/7/18.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSDictionary *msgData;
@property (nonatomic, assign) BOOL isShowDetail;

@end
