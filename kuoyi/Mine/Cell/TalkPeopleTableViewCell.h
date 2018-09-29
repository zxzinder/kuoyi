//
//  TalkPeopleTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/3.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@class TalkPeopleModel;
@interface TalkPeopleTableViewCell : MGSwipeTableCell

-(void)configureCellWithData:(TalkPeopleModel *)model;

@property (nonatomic, copy) void (^headImgCallBack)(void);

@end
