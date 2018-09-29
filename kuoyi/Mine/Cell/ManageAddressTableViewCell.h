//
//  ManageAddressTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface ManageAddressTableViewCell : MGSwipeTableCell
-(void)configureCellWithData:(NSDictionary *)data;
@property (nonatomic, copy) void (^selectCallBack)(UIButton *btn);
@property (nonatomic, copy) void (^editCallBack)(void);
@property (nonatomic, strong) UIButton *defaultBtn;
@end
