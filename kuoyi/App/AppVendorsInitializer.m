//
//  AppVendorsInitializer.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "AppVendorsInitializer.h"
#import "UIColor+TPColor.h"

@implementation AppVendorsInitializer
+ (void)load {
    [super load];
    // 设置全局样式
    [self setupAppearance];
}

+ (void)setupAppearance {


    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];

    [UINavigationBar appearance].barTintColor = [UIColor tp_navigationBarColor];
    [UINavigationBar appearance].barStyle     = UIBarStyleDefault;
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor tp_navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor tp_blackTextColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor tp_blackTextColor], NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    
}
@end
