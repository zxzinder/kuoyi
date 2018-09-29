//
//  ChangePhoneViewController.h
//  kuoyi
//
//  Created by alexzinder on 2018/9/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangePhoneViewController : UIViewController

@property (nonatomic, copy) void (^finishCallback)(NSString *newPhone);


@end

NS_ASSUME_NONNULL_END
