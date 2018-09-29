//
//  PayAddressTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayAddressTableViewCell : UITableViewCell
-(void)configureCellWithData:(NSDictionary *)data;
@property (nonatomic, copy) void (^editCallBack)(void);
@end
