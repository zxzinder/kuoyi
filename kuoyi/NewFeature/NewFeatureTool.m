//
//  NewFeatureTool.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/15.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "NewFeatureTool.h"
#import "RootTabBarController.h"
#import "NewFeatureViewController.h"
#import "HomeViewController.h"
#import "DataManager.h"


#define VersionKey @"version"
#define TimeKey @"timekey"
@implementation NewFeatureTool

+ (void)chooseRootViewController:(UIWindow *)window {
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:VersionKey];
    NSString *lastTime = [DataManager objectForRead:TimeKey];
    NSDate *nowDate =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowStr = [formatter stringFromDate:nowDate];
    
    
//    if ([nowStr isEqualToString:lastTime]) {
//        //RootTabBarController *controller = [[RootTabBarController alloc] init];
//        HomeViewController *controller = [[HomeViewController alloc] init];
//        UINavigationController *rootNVC = [[UINavigationController alloc] initWithRootViewController:controller];
//        window.rootViewController = rootNVC;
//    }else{
        NewFeatureViewController *viewController = [[NewFeatureViewController alloc] init];
        window.rootViewController = viewController;
        //[[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:VersionKey];
        [DataManager saveObject:nowStr forKey:TimeKey];
//    }
}
@end
