//
//  ShopCartTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface ShopCartTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *editBtn;

-(void)configureCellWithData:(NSDictionary *)data;

-(void)updateCellUI;

@property (nonatomic, copy) void (^selectCallBack)(BOOL isSelect);

@property (nonatomic, copy) void (^addCountCallBack)(NSInteger count);

@end
