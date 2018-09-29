//
//  DataManager.h
//  TransportDriver
//
//  Created by alexzinder on 17/6/26.
//  Copyright © 2017年 Sichuan Yun Ze Zheng Yuan Technology Co.,. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
/**
 *  向属性列表中添加数据
 *
 *  @param object 添加的对象
 *  @param key    key值（标识）
 *
 *  @return 返回是否成功
 */
+ (BOOL)saveObject:(id)object forKey:(NSString *)key;
/**
 *  查询属性列表中的数据
 *
 *  @param key 根据key值(标识)查询
 *
 *  @return 返回查询的结果
 */
+ (id)objectForRead:(NSString *)key;

/**
 *  删除key对应的数据
 *
 *  @param key key值（标识）
 *
 *  @return 返回是否成功
 */
+ (BOOL)clearObjectsForKey:(NSString *)key ;
@end
