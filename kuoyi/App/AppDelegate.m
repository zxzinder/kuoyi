//
//  AppDelegate.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/22.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "HomeViewController.h"
#import "VendorMacro.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <IQKeyboardManager.h>
#import "NewFeatureTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NotificationMacro.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self p_setUpRootViewController];
    //友盟分享
    [self setupUMenginfo];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Method

- (void)p_setUpRootViewController {
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    [self.window makeKeyAndVisible];
    //    //选择根控制器
    //    RootTabBarController *controller = [[RootTabBarController alloc] init];
    //    self.window.rootViewController = controller;

    
    UIViewController *rootViewController = [[HomeViewController alloc] init];
//    if ([CustomerManager sharedInstance].isLogin) {
//        rootViewController
//    } else {
//        rootViewController = [[LoginViewController alloc] init];
//
//    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //选择根控制器
    [NewFeatureTool chooseRootViewController:self.window];
//    UINavigationController *rootNavigation = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//    self.window.rootViewController = rootNavigation;
}
- (void)setupUMenginfo {
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppKey];
    [[UMSocialManager defaultManager] openLog:YES];
    // [UMSocialData setAppKey:kUmengAppKey];
    //设置微信AppId、appSecret，分享url
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppId appSecret:kWXAppSecret redirectURL:kUMShareUrl];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppId/*设置QQ平台的appID*/  appSecret:kQQAppKey redirectURL:kUMShareUrl];
    //设置微博
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWBAppKey  appSecret:kWBSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];

}
#pragma mark - UMengShare

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self p_chooseSELWhenOpenUrl:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self p_chooseSELWhenOpenUrl:url];
}

- (BOOL)p_chooseSELWhenOpenUrl:(NSURL*)url {
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:kCallBackPrefixAlipay]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPayInfoCallBack object:@{@"resultDic":resultDic}];
            
        }];
        return NO;
    }
    return  [[UMSocialManager defaultManager] handleOpenURL:url];
    
    return NO;
}

@end
