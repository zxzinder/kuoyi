//
//  FileCacheTool.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/30.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface FileCacheTool : NSObject
/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 返回文件夹尺寸
 */
+ (void)getFileSizeCompletion:(void(^)(NSInteger totalSize))completion;

/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath;

@end
