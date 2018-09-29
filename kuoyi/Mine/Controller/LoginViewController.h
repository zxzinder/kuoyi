//
//  LoginViewController.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

- (instancetype)initWithLoginSuccessBlock:(void(^)(void))block;

@end
