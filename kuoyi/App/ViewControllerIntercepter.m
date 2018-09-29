//
//  ViewControllerIntercepter.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ViewControllerIntercepter.h"
#import "Aspects.h"
#import <UIKit/UIKit.h>

@implementation ViewControllerIntercepter
+ (void)load {
    [super load];
    
    [ViewControllerIntercepter sharedInstance];
}

+ (instancetype)sharedInstance {
    
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
            [self customBackBarButtonItemWithController:[aspectInfo instance]];
        } error:NULL];
    }
    return self;
}

- (void)customBackBarButtonItemWithController:(UIViewController *)controller {
    
    UIBarButtonItem *backBarButtonItem = [UIBarButtonItem new];
    backBarButtonItem.title = @"";
    controller.navigationItem.backBarButtonItem = backBarButtonItem;

    UIImage *backImage = [UIImage imageNamed:@"navgation_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.navigationController.navigationBar.backIndicatorImage = backImage;
    controller.navigationController.navigationBar.backIndicatorTransitionMaskImage = backImage;
}

@end
