//
//  PeopleInfo.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleInfo : NSObject
//name    名字
//fengmian    封面图片
//headimg    头象
//labels    人物标签多个用|隔开，最多2个
//info    人物介绍
//imgs    图集
//url    图片地址
@property (nonatomic, assign) NSInteger pid;//人物id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fengmian;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *labels;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *gushi_title;
@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, copy) NSArray *article_list;

@property (nonatomic, assign) NSInteger is_collection;
@property (nonatomic, assign) NSInteger is_fabulous;

@end
