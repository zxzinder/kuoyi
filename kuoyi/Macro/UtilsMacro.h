
//
//  UtilsMacro.h
//  TransportPassenger
//  存放一些方便使用的宏定义
//  Created by Helly on 10/16/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

#define NSLog(FORMAT, ...) \
do { \
fprintf(stderr,"%s: %d: %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, \
[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]); \
} while(0)
#else
#define NSLog(FORMAT, ...) NSLog(@"")
#endif
//www.kuoyilife.com/index.php/api/  74.121.148.196:89/kuoyi/myfolde
//www.kuoyilife.com/index2.php/api/
#define AppStoreUrl @"https://itunes.apple.com/cn/app/%E6%98%93%E6%9D%A5%E5%AE%A2%E8%BF%90-%E5%9F%8E%E9%99%85%E5%87%BA%E8%A1%8C-%E4%B8%8A%E9%97%A8%E6%8E%A5%E9%80%81%E5%88%B0%E5%AE%B6/id1080896604?mt=8"
#define webDomain @"www.kuoyilife.com/index2.php"
#define ApiBaseUrl @"http://www.kuoyilife.com/app.php/api/"
#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define LOADIMAGE(name) [UIImage imageNamed:name]

#define serviceTel @"028-68517596"
// Fonts
#define kFontHeadLine [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
#define kFontBody [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
#define kFontSubheadline [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
#define kFontFootnote [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
#define kFontCaption1 [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]
#define kFontCaption2 [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]

#define kFontOfSize17Blod kFontHeadLine
#define kFontOfSize17 kFontBody
//#define kFontOfSize15 kFontSubheadline
#define kFontOfSize15 [UIFont systemFontOfSize:15]

#define kFontOfSize13 kFontFootnote
#define kFontOfSize12 kFontCaption1
#define kFontOfSize11 kFontCaption2
#define kFontOfSize14 [UIFont systemFontOfSize:14]
//
#define kFontOfSize16 [UIFont systemFontOfSize:16]
#define kFontOfSize18 [UIFont systemFontOfSize:18]
#define kFontOfSize20 [UIFont systemFontOfSize:20]

#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreenWidthRatio  (DEVICE_WIDTH / (414.0))
#define kScreenHeightRatio (DEVICE_HEIGHT / (736.0))
#define AdaptedWidthValue(x)  (ceilf((x) * kScreenWidthRatio))
#define AdaptedHeightValue(x) (ceilf((x) * kScreenHeightRatio))
//
#define iOS8 [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define iOS9 [UIDevice currentDevice].systemVersion.floatValue >= 9.0
#define iOS10 [UIDevice currentDevice].systemVersion.floatValue >= 10.0
#define iOS11 [UIDevice currentDevice].systemVersion.floatValue >= 11.0
//3.5寸屏
#define is35InchScreen CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480))
//4寸屏
#define is4InchScreen CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))
//4.7寸屏
#define is47InchScreen CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))
//5.5寸屏
#define is55InchScreen CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))
//iphoneX
#define isiPhoneXScreen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//根控制器
#define WindowView      [[UIApplication sharedApplication] keyWindow]
//
//#define statusBarHeight 20
//#define navigationBarHeight 44
//#define tabbarHeight 49

// Status bar height.
#define  statusBarHeight      (isiPhoneXScreen ? 44.f : 20.f)

// Navigation bar height.
#define  navigationBarHeight  44.f

// Tabbar height.
#define  tabbarHeight         (isiPhoneXScreen ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  tabbarSafeBottomMargin         (isiPhoneXScreen ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  statusBarAndNavigationBarHeight  (isiPhoneXScreen ? 88.f : 64.f)
//系统手势高度
#define system_gesture_height (isiPhoneXScreen ? 13 : 0)

#define viewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
//消除 warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//#endif /* UtilsMacro_h */
