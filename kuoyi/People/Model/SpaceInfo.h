//
//  SpaceInfo.h
//  kuoyi
//
//  Created by alexzinder on 2018/3/1.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpaceInfo : NSObject
//id    期刊ID
//title    期刊名字
//city    城市
//introduce    介绍
//fengmian    封面
//imgs    图集
//url    图片地址

@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *fengmian;
@property (nonatomic, copy) NSArray *imgs;
@property (nonatomic, assign) NSInteger minsu_count;
@property (nonatomic, assign) NSInteger kongjian_count;

@end
