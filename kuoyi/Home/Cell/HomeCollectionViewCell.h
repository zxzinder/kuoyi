//
//  HomeCollectionViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/24.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TF_TAG 4321
@class HomeDetail;
@interface HomeCollectionViewCell : UICollectionViewCell

-(void)configeData:(HomeDetail *) data;
@property (nonatomic, strong) UITextField *inputTF;

@property (nonatomic, copy) void (^clickCallBack)(void);

@property (nonatomic, copy) void (^shareClickBack)(NSString *shareStr);
@property (nonatomic, copy) void (^collcetClickBack)(void);

@property (nonatomic, copy) void (^praiseClickBack)(void);

@property (nonatomic, copy) void (^doneEditCallBack)(NSString *shareStr);


@end
