//
//  MyPageControl.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/15.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:image];
    }
    return self;
}

-(void)updateDots
{
    NSArray *subview = self.subviews;  // 获取所有子视图
    for (NSInteger i = 1; i < [subview count]; i++)
    {
        UIView *dot = [subview objectAtIndex:i];
        if ((self.currentPage + 1 == i)) {
            
            if (dot.subviews.count == 0) {
                
                [dot addSubview:[self addSelectImage:_imagePageStateHighlighted index:i]];
            }else{
                UIImageView *imageView = dot.subviews[0];
                [imageView removeFromSuperview];
                [dot addSubview:[self addSelectImage:_imagePageStateHighlighted index:i]];
            }
            
        }else{
            
            if (dot.subviews.count == 0) {
                
                [dot addSubview:[self addSelectImage:_imagePageStateNormal index:i]];
            }else{
                UIImageView *imageView = dot.subviews[0];
                [imageView removeFromSuperview];
                [dot addSubview:[self addSelectImage:_imagePageStateNormal index:i]];
            }
        }
    }
}

- (UIImageView *) addSelectImage:(UIImage *)image index:(NSInteger) index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (image == _imagePageStateHighlighted) {
        //imageView.frame = CGRectMake(-10, 0, 24, 8);
        imageView.frame = CGRectMake(0, 0, 10, 10);
    }else{
        if ((index - 1) < self.currentPage) {
            imageView.frame = CGRectMake(0, 0, 10, 10);
        }else{
            imageView.frame = CGRectMake(0, 0, 10, 10);
        }
    }
    imageView.image = image;
    return imageView;
}

@end
