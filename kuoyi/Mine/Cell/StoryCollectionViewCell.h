//
//  StoryCollectionViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/4/3.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCollectionViewCell : UICollectionViewCell

-(void)configureData:(NSDictionary *) data;
@property (nonatomic, copy) void (^cancelCollectCallBack)();
@end
