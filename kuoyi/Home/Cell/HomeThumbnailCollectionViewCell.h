//
//  HomeThumbnailCollectionViewCell.h
//  kuoyi
//
//  Created by alexzinder on 2018/1/25.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HomeDetail;

@interface HomeThumbnailCollectionViewCell : UICollectionViewCell



-(void)configeData:(HomeDetail *)detail andDic:(NSDictionary *)data;
-(void) configureCellColor:(NSString *)titleColor andSegColor:(NSString *)segColor;
@end
