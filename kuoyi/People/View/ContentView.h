//
//  ContentView.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLYHUD.h"
#import "EnumHeader.h"


@class HomeDetail;
@class PeopleInfo;
@interface ContentView : UIView
-(instancetype)initWithData:(HomeDetail *)detail andPeopleInfo:(PeopleInfo *)info;

@property (nonatomic, copy) void (^storyCallback)(void);
@property (nonatomic, copy) void (^titleBtnCallback)(void);
@property (nonatomic, copy) void (^rewardCallback)(NSString *uuid);
@property (nonatomic, copy) void (^getWebDataCallback)(NSDictionary *webDic,BOOL isShare);

-(void)hideMidView;

@end
