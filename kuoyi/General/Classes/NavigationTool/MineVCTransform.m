//
//  MineVCTransform.m
//  kuoyi
//
//  Created by alexzinder on 2018/8/23.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MineVCTransform.h"
#import "UtilsMacro.h"

@implementation MineVCTransform
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.4;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    
    //此处判断是push，还是pop 操作
    BOOL isPush = ([toViewController.navigationController.viewControllers indexOfObject:toViewController] > [fromViewController.navigationController.viewControllers indexOfObject:fromViewController]);
    if (isPush) {
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        
        toView.frame = self.transitionBeforeFrame;
        fromView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        //toView.alpha = 0;
    }else{
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        toView.frame = self.transitionAfterFrame;
        fromView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        //fromView.alpha = 1;
    }
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isPush) {
            toView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            fromView.frame = self.transitionAfterFrame;
            //toView.alpha = 1;
        }else{
            fromView.frame = self.transitionBeforeFrame;
            toView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            //fromView.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}
@end
