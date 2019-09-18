//
//  StoryCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/3.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "StoryCollectionViewCell.h"
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>


@interface StoryCollectionViewCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *calorieImgView;
@property (nonatomic, strong) UILabel *calorieLabel;
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *storyImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation StoryCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void) p_init{
    __weak __typeof(self)weakSelf = self;
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.size.height.mas_equalTo(AdaptedHeightValue(33));
    }];
    
    self.calorieImgView = [[UIImageView alloc] init];
    self.calorieImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.calorieImgView.image = [UIImage imageNamed:@"carlory"];
    [self.topView addSubview:self.calorieImgView];
    [self.calorieImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
//    self.calorieLabel = [self createLabelWithColor:@"717171" font:10];
//    self.calorieLabel.text = @"300卡路里";
//    [self.topView addSubview:self.calorieLabel];
//    [self.calorieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.calorieImgView.mas_right).offset(5);
//        make.centerY.equalTo(self.topView.mas_centerY);
//    }];
//    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setImage:[UIImage imageNamed:@"storyCollect"] forState:UIControlStateNormal];
    [self.topView addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [self.collectBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.cancelCollectCallBack) {
            weakSelf.cancelCollectCallBack();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.topView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.bottom.equalTo(self.topView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(backView);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    CGFloat nameFont,descFont,titleFont,subFont,topOffset;
    if (is55InchScreen) {
        nameFont = 17;
        descFont = 8;
        titleFont = 9;
        subFont = 10;
        topOffset = 5;
    }else{
        nameFont = 13;
        descFont = 7;
        titleFont = 8;
        subFont = 9;
        topOffset = 5;
    }
    
    self.nameLabel = [self createLabelWithColor:@"241a16" font:nameFont];
    [self.botView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left).offset(10);
        make.right.equalTo(self.botView.mas_right).offset(-10);
        make.top.equalTo(self.botView.mas_top).offset(topOffset);
    }];
    
    self.descLabel = [self createLabelWithColor:@"241a16" font:descFont];
    [self.botView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left).offset(10);
        make.right.equalTo(self.botView.mas_right).offset(-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(AdaptedHeightValue(5));
    }];
    CGFloat imgW = self.frame.size.width * 0.73;//  self.frame.size.width - 9 -9
    CGFloat imgH = imgW * 2/3; //496 * 270
    self.storyImgView = [[UIImageView alloc] init];
    //self.storyImgView.contentMode = UIViewContentModeScaleAspectFit;
    //self.storyImgView.image = [UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, imgW, imgH)];
    [self.botView addSubview:self.storyImgView];
    [self.storyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(topOffset);
        make.left.equalTo(self.botView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(imgW, imgH));
    }];
    
    self.titleLabel = [self createLabelWithColor:@"6a4d1e" font:titleFont];
    self.titleLabel.numberOfLines = 2;
    [self.botView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left).offset(10);
        make.right.equalTo(self.botView.mas_right).offset(-10);
        make.top.equalTo(self.storyImgView.mas_bottom).offset(topOffset);
    }];
    
//    self.subTitleLabel = [self createLabelWithColor:@"6a4d1e" font:subFont];
//    self.subTitleLabel.numberOfLines = 0;
//    [self.botView addSubview:self.subTitleLabel];
//    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.storyImgView.mas_right).offset(AdaptedWidthValue(10));
//        make.top.equalTo(self.storyImgView.mas_top);
//        make.bottom.equalTo(self.storyImgView.mas_bottom);
//        make.right.equalTo(self.storyImgView.mas_right).offset(AdaptedWidthValue(20));
//    }];
}
-(void)configureData:(NSDictionary *)data{
    if (data[@"imgurl"] && ![data[@"imgurl"] isKindOfClass:[NSNull class]]) {
          [self.storyImgView sd_setImageWithURL:[NSURL URLWithString:data[@"imgurl"]] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    }
  
    self.nameLabel.text = [NSString stringWithFormat:@"%@",data[@"title"]];//@"内心有温柔与坚守";
    self.descLabel.text = [NSString stringWithFormat:@"%@",data[@"author"]];//@"文|康康达"
    if ([data[@"ftitle"] isKindOfClass:[NSNull class]]) {
        self.titleLabel.text = @"";
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@",data[@"ftitle"]];
    }
    //@"如果按照六十岁的寿命算，他已有一半入土，正是生命短暂平生所愿";
   // self.subTitleLabel.text = data[@"title"];//@"梁博X凸版印刷";
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    return lbl;
    
}
@end
