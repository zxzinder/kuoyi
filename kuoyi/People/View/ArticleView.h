//
//  ArticleView.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/5.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleView : UIView
-(instancetype)initWithPId:(NSInteger)pid;
@property (nonatomic, copy) void (^clickCallBack)(void);

@end
