//
//  StoryWebView.h
//  kuoyi
//
//  Created by alexzinder on 2018/6/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryWebView : UIView

-(instancetype)initWithData:(NSInteger)pid;
-(instancetype)initWithIdList:(NSArray *)idsList andFrameHeight:(CGFloat)frameHeight;

@property (nonatomic, copy) void (^rewardCallback)(NSString *uuid);
@property (nonatomic, copy) void (^getWebDataCallback)(NSDictionary *webDic,BOOL isShare);

-(void)configureCollectionImageSelect:(NSInteger)type;

@end
