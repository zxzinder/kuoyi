//
//  UserMarkCollectionViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/9/14.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMarkCollectionViewCell : UICollectionViewCell
-(void)configureData:(NSDictionary *) data;

@property (nonatomic, copy) void (^selectCallBack)(BOOL isSelect);

@end
