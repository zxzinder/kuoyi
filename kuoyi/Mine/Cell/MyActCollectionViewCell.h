//
//  MyActCollectionViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActCollectionViewCell : UICollectionViewCell

-(void)configureData:(NSDictionary *) data;
@property (nonatomic, copy) void (^cancelCollectCallBack)(void);
@property (nonatomic, copy) void (^orderCallBack)(void);
@property (nonatomic, copy) void (^refundCallBack)(void);


@end
