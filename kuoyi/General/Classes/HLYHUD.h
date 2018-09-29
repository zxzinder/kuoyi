//
//  HLYHUD.h
//  TeamBuilding
//
//  Created by Helly on 15/6/30.
//  Copyright (c) 2015年 anzeinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HLYHUD : NSObject

+ (void)showLoadingHudAddToView:(UIView *)view;
+ (void)showHUDWithMessage:(NSString *)message addToView:(UIView *)view;
+ (void)showHUdBlcakMessage:(NSString *)message addToView:(UIView *)view;
+ (void)showHUdGrayMessage:(NSString *)message addToView:(UIView *)view;

+ (BOOL)hideHUDForView:(UIView *)view;
+ (NSUInteger)hideAllHUDsForView:(UIView *)view;

@end
