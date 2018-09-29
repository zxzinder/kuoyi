//
//  ArticleCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/5.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ArticleCollectionViewCell.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>


@interface ArticleCollectionViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *contentImgView;


@end

@implementation ArticleCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void) p_init{
    self.contentImgView = [[UIImageView alloc] init];
//    self.contentImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];253  253
    [self.contentView addSubview:self.contentImgView];
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.width));
    }];
    
    self.nameLabel = [self createLabelWithColor:@"000000" font:11];
    self.nameLabel.text = @"TOAST BAG";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentImgView.mas_bottom).offset(AdaptedHeightValue(9));
    }];
    
    self.priceLabel = [self createLabelWithColor:@"000000" font:10];
    self.priceLabel.text = @"CNY 234";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(AdaptedHeightValue(5));
    }];
}
-(void)configeData:(NSDictionary *)data{
    NSURL *url = [NSURL URLWithString:data[@"fengmian"]];
    [self.contentImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = data[@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"CNY %@",data[@"price"]];
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
@end
