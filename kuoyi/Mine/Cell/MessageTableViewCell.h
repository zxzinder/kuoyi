//
//  MessageTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@class MessageModel;

@interface MessageTableViewCell : MGSwipeTableCell
-(void)configureCellWithData:(MessageModel *)data;

@end
