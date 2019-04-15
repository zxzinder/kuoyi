//
//  CalendarPickViewController.h
//  kuoyi
//
//  Created by alexzinder on 2018/6/24.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarPickViewController : UIViewController

@property (nonatomic, strong) NSArray *cantSelectDateArray;
@property (nonatomic, copy) void (^selectCallback)(NSString *date);

@end
