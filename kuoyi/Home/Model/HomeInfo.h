//
//  HomeInfo.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeInfo : NSObject
//page    当前页数 没有数据时为1
//countpage    总页数   没有数据时为1
//pagesize    一页记录数
//comment    评论数
//fabulous    赞的数量
//list    人物列表  没有数据时为空数组[]
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger countpage;
@property (nonatomic, assign) NSInteger pagesize;
@property (nonatomic, assign) NSInteger comment;
@property (nonatomic, assign) NSInteger fabulous;
@property (nonatomic, copy) NSArray *list;
@end
