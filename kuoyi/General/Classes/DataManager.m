//
//  DataManager.m
//  TransportDriver
//
//  Created by alexzinder on 17/6/26.
//  Copyright © 2017年 Sichuan Yun Ze Zheng Yuan Technology Co.,. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

/**
 *  向属性列表中添加数据
 *
 *  @param object 添加的对象
 *  @param key    key值（标识）
 *
 *  @return 返回是否成功
 */
+ (BOOL)saveObject:(id)object forKey:(NSString *)key {
    //    NSLog(@"%@",NSHomeDirectory());
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    // 同步到文件系统
    BOOL success = [userDefaults synchronize];
    return  success;
}
/**
 *  查询属性列表中的数据
 *
 *  @param key 根据key值(标识)查询
 *
 *  @return 返回查询的结果
 */
+ (id)objectForRead:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *objects = [userDefaults objectForKey:key];
    return objects;
    
}

/**
 *  删除key对应的数据
 *
 *  @param key key值（标识）
 *
 *  @return 返回是否成功
 */
+ (BOOL)clearObjectsForKey:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    BOOL success  = [userDefaults synchronize];
    return  success;
}

@end
