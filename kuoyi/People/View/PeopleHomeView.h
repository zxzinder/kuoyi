//
//  PeopleHomeView.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/27.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeopleInfo;
@class HomeDetail;
@interface PeopleHomeView : UIView

-(instancetype)initWithInfo:(PeopleInfo *)info;

@property (nonatomic, copy) void (^storyCallback)(void);
@property (nonatomic, copy) void (^shareCallback)(void);
@property (nonatomic, copy) void (^doneEditCallBack)(void);
@property (nonatomic, copy) void (^collectCallBack)(void);
@property (nonatomic, copy) void (^praiseCallBack)(void);

-(void)showDetailImgView;
-(void)hideDetailImgView;
-(void)configureBackViewColor:(BOOL)isWhite;

-(void)updateCollectCount:(NSInteger)type;
-(void)updateFabulousCount;

@end
