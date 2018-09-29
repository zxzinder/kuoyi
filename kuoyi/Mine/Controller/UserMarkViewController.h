//
//  UserMarkViewController.h
//  kuoyi
//
//  Created by alexzinder on 2018/9/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMarkViewController : UIViewController

@property (nonatomic, assign) BOOL isFromRegister;

@property (nonatomic, copy) void (^finishCallback)(void);


@end
