//
//  AdvertisingManage.m
//  kuoyi
//
//  Created by alexzinder on 2018/9/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "AdvertisingManage.h"
#import "KYNetService.h"
#import <UIKit/UIKit.h>

#define AdUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName";
static NSString *const adUrlString = @"adUrlString";
static NSString *const adTimeCount = @"adTimeCount";
static NSString *const adDataSource = @"adDataSource";

@interface AdvertisingManage()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AdvertisingManage
+ (instancetype)sharedManage {
    
    static AdvertisingManage *advertisingManage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertisingManage = [[AdvertisingManage alloc] init];
    });
    return advertisingManage;
}
- (void)advertiseViewShow {
   
    //1.判断沙盒中是否存在广告图片，如果存在直接显示
    NSString *filePath = [self getFilePathWithImageName:[AdUserDefaults valueForKey:adImageName]];
    NSString *adDetails = [AdUserDefaults valueForKey:adUrlString];
    NSInteger timeCount = [[AdUserDefaults valueForKey:adTimeCount] integerValue] / 1000;
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {  //图片存在
//        AdvertisingView *advertiseView = [[AdvertisingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        advertiseView.imageFilePath = filePath;
//        if (adDetails.length != 0) {
//            advertiseView.isAdClick = YES;
//        }
//        [advertiseView showWithTimeCount:timeCount];
    }
}

-(void)getADImageRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.advert/getList";
    NSDictionary *params = @{@"type":@"2"};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        weakSelf.dataArray = dict[@"data"];
        //2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告接口是否更新
        [weakSelf getAdvertiseImage];
    } FailureBlock:^(NSDictionary *dict) {
        [weakSelf deleteOldImage];
    }];
    
}
- (void)getAdvertiseImage {
//    NSString *imageUrl = self.adData[@"picPath"];
//    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//    NSString *imageName = [stringArr lastObject];
//    [AdUserDefaults setValue:self.adData[@"link"] forKey:adUrlString];//如果有广告链接，先将广告链接也保存下来
//    NSString *timeCount = [NSString stringWithFormat:@"%@", self.adData[@"remainTime"]];
//    [AdUserDefaults setValue:timeCount forKey:adTimeCount];
//    [AdUserDefaults setValue:self.adData forKey:adDataSource];
//    [AdUserDefaults synchronize];
//    //拼接沙盒路径
//    NSString *filePath = [self getFilePathWithImageName:imageName];
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (!isExist) { //如果该图片不存在，则删除老图片，下载新图片
//        [self deleteOldImage];
//        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
//    }
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //下载图片
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        //拼接保存文件的名称
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {//保存成功
            NSLog(@"保存成功");
            [AdUserDefaults setValue:imageName forKey:adImageName];
            [AdUserDefaults synchronize];
        }else {
            NSLog(@"保存失败");
        }
    });
}
/**
 *  删除旧广告相关
 */
- (void)deleteOldImage {
    
    NSString *imageName = [AdUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        [fileManage removeItemAtPath:filePath error:nil];
        //把广告链接也要删掉
        [AdUserDefaults setValue:nil forKey:adUrlString];
        [AdUserDefaults synchronize];
    }
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManage fileExistsAtPath:filePath isDirectory:&isDirectory];
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    return nil;
}


@end
