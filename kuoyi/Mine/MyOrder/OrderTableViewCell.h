//
//  OrderTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/10.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface OrderTableViewCell : MGSwipeTableCell
-(void)configureCellWithData:(NSDictionary *)data;

@end
