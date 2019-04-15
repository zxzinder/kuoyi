//
//  HotPeopleTableViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2019/4/3.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotPeopleTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^webClickCallback)(void);
-(void)configeCellData:(NSString *) urlString;

@end

NS_ASSUME_NONNULL_END
