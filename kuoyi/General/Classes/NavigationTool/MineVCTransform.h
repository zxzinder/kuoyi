//
//  MineVCTransform.h
//  kuoyi
//
//  Created by alexzinder on 2018/8/23.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MineVCTransform : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect transitionBeforeFrame;

@property (nonatomic, assign) CGRect transitionAfterFrame;  

@end
