//
//  NormalContent.h
//  kuoyi
//
//  Created by alexzinder on 2018/3/1.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalContent : NSObject

//id    活动ID
//title    名字
//date    时间
//fengmian    封面图片
//info    活动详情
@property (nonatomic, assign) NSInteger nid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *fengmian;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *price;

@end
