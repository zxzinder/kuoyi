//
//  HLYHUD.m
//  TeamBuilding
//
//  Created by Helly on 15/6/30.
//  Copyright (c) 2015年 anzeinfo. All rights reserved.
//

#import "HLYHUD.h"
#import "MBProgressHUD.h"
#import "UIColor+TPColor.h"

@implementation HLYHUD

+ (void)showLoadingHudAddToView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showHUDWithMessage:(NSString *)message addToView:(UIView *)view {
    
    if (message == nil || message.length == 0) {
        return;
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];

}
+ (void)showHUdGrayMessage:(NSString *)message addToView:(UIView *)view{
    if (message == nil || message.length == 0) {
        return;
    }
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [UIColor colorWithHexString:@"999999"];
      hud.detailsLabel.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
     [hud hideAnimated:YES afterDelay:2];
}
+ (void)showHUdBlcakMessage:(NSString *)message addToView:(UIView *)view {
    if (message == nil || message.length == 0) {
        return;
    }
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
//    hud.contentColor = [UIColor whiteColor];
//    hud.bezelView.backgroundColor = [UIColor blackColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
//    hud.bezelView.alpha = 0.8;
//    CGPoint tempPoint = hud.offset;
//    tempPoint.y = [UIScreen mainScreen].bounds.size.height - 400;
//    hud.offset = tempPoint;
//    hud.bezelView.layer.cornerRadius = 15;
//    hud.bezelView.layer.masksToBounds = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+ (BOOL)hideHUDForView:(UIView *)view {
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    return [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view {
    
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    return [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
