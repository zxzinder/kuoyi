//
//  UIWebView+CancelIndicator.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "UIWebView+CancelIndicator.h"

@implementation UIWebView (CancelIndicator)

+(void)cancelScrollIndicator:(UIWebView *)webView{
    webView.opaque = NO;
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
        }
    }
    
}

@end
