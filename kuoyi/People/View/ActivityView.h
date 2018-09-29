//
//  ActivityView.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
-(instancetype)initWithPId:(NSInteger)pid;
@property (nonatomic, copy) void (^clickCallBack)(void);

@end
