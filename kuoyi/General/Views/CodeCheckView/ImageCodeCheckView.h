//
//  ImageCodeCheckView.h
//  kuoyi
//
//  Created by alexzinder on 2018/2/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCodeCheckView : UIView
@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;

-(void)changeCode;
@end
