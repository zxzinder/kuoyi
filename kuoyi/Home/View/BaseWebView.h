//
//  BaseWebView.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/31.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebView : UIWebView

-(instancetype)initWithUrlString:(NSString *)urlString;

-(void)configData;

@end
