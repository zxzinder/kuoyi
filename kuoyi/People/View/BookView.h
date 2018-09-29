//
//  BookView.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/27.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookView : UIView
-(instancetype)initWithPId:(NSInteger)pid;
@property (nonatomic, copy) void (^clickCallBack)(void);

@end
