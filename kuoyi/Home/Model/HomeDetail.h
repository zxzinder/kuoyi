//
//  HomeDetail.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDetail : NSObject
//id    人物ID
//title    名字
//img    图集
//info    简介
//isbook    是否有书
//isspace    是否有空间
//iscurriculum    是否有课程
//isactivity    是否有活动
//isproduct    是否有产品

@property (nonatomic, assign) NSInteger detailID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *gushi_title;
@property (nonatomic, copy) NSArray *img;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *fengmian;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *fabulous;
@property (nonatomic, copy) NSString *rewardimg;
@property (nonatomic, copy) NSString *shareinfo;

@property (nonatomic, assign) BOOL isbook;
@property (nonatomic, assign) BOOL isspace;
@property (nonatomic, assign) BOOL iscurriculum;
@property (nonatomic, assign) BOOL isactivity;
@property (nonatomic, assign) BOOL isproduct;

@property (nonatomic, assign) NSInteger is_collection;
@property (nonatomic, assign) NSInteger is_fabulous;

@end











