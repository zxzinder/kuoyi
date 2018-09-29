//
//  ManageAddressViewController.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageAddressViewController : UIViewController

@property (nonatomic, assign) BOOL isNeedSelect;
@property (nonatomic, copy) void (^selectCallBack)(NSDictionary *addressData);

@end
