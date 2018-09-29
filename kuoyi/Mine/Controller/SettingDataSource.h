//
//  SettingDataSource.h
//  TransportPassenger
//
//  Created by  HCD on 15/11/20.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumHeader.h"
static NSString *APP_STORE = @"APPSTORE";
static NSString *SHARE_US = @"SHAREUS";
@interface SettingDataSourceItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *pushControllerName;
@property (assign, nonatomic) WebProtocolType protocolType;
@property (strong, nonatomic) NSArray  *childDataSource;

- (instancetype)initTitle:(NSString *)title pushVCName:(NSString *)pushControllerName ;

@end

@interface SettingDataSource : NSObject
+ (NSArray *)dataSource;
@end
