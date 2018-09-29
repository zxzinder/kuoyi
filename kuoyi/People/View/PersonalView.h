//
//  PersonalView.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeopleInfo;
#define imgSizeHW 67
#define btnSizeHw 40
#define allHeight 115 //100
#define topHeight 35
@interface PersonalView : UIView
/**
 是否需要顶部分享等按钮
 */
-(instancetype)initWithType:(BOOL)isNeedTop;
-(void)configureBotData:(PeopleInfo *)info;
-(void)configureBackViewColor:(BOOL)isWhite;
@property (nonatomic, copy) void (^storyCallback)(void);

-(void)showDetailImgView;
-(void)hideDetailImgView;
@end
