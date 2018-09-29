//
//  MyLessonCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MyLessonCollectionViewCell.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import "EnumHeader.h"


@interface MyLessonCollectionViewCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *lessonImgView;
@property (nonatomic, strong) UILabel *lessonLabel;
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *storyImgView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UILabel *refundLabel;

@property (nonatomic, assign) OrderType orderType;

@end

@implementation MyLessonCollectionViewCell
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
    
    self.lessonImgView = [[UIImageView alloc] init];
    self.lessonImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.lessonImgView.image = [UIImage imageNamed:@"mylesson"];
    [self.topView addSubview:self.lessonImgView];
    [self.lessonImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
//    self.lessonLabel = [self createLabelWithColor:@"717171" font:10];
//    [self.topView addSubview:self.lessonLabel];
//    [self.lessonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.lessonImgView.mas_right).offset(5);
//        make.centerY.equalTo(self.topView.mas_centerY);
//    }];
//
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setImage:[UIImage imageNamed:@"delete_black"] forState:UIControlStateNormal];
    [self.topView addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [self.collectBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.cancelCollectCallBack ) {
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
    
    
    CGFloat nameFont,descFont,orderFont,priceFont,topOffset;
    if (is55InchScreen || isiPhoneXScreen) {
        nameFont = 17;
        descFont = 10;
        orderFont = 12;
        priceFont = 12;
        topOffset = 5;
    }else{
        nameFont = 13;
        descFont = 9;
        orderFont = 11;
        priceFont = 10;
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
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    CGFloat imgW = self.frame.size.width * 0.88;//139  158
    CGFloat imgH = imgW * 1.5;
    self.storyImgView = [[UIImageView alloc] init];
    //self.storyImgView.contentMode = UIViewContentModeScaleAspectFit;
    //self.storyImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, imgW, imgH)];
    [self.botView addSubview:self.storyImgView];
    [self.storyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(topOffset);
        make.centerX.equalTo(self.botView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(imgW, imgH));
    }];
    
    self.orderBtn = [self createBtnWithColor:@"ffffff" font:orderFont];
    [self.orderBtn setTitle:@"前往报名" forState:UIControlStateNormal];
    self.orderBtn.layer.cornerRadius = 2;
    self.orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:orderFont];
    self.orderBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [self.botView addSubview:self.orderBtn];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storyImgView.mas_right);
        make.top.equalTo(self.storyImgView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 23));
    }];
    [self.orderBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.orderCallBack && self.orderType == OrderTypeWaitPay) {
            weakSelf.orderCallBack();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.priceLabel = [self createLabelWithColor:@"3c3c3c" font:priceFont];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:priceFont];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.botView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storyImgView.mas_left);
        make.right.equalTo(self.orderBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.orderBtn.mas_centerY);
    }];
    self.refundLabel = [self createLabelWithColor:@"595858" font:11];
    self.refundLabel.textAlignment = NSTextAlignmentRight;
    self.refundLabel.userInteractionEnabled = YES;
    [backView addSubview:self.refundLabel];
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderBtn.mas_right);
        make.top.equalTo(self.orderBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 10));
    }];
    [self.refundLabel bk_whenTapped:^{
        if (weakSelf.refundCallBack) {
            weakSelf.refundCallBack();
        }
    }];
}
-(void)configureData:(NSDictionary *)data{
    self.orderType = [data[@"state"] integerValue];
    [self.orderBtn setTitle:@"已完成" forState:UIControlStateNormal];
    if (self.orderType == OrderTypeWaitPay) {
        [self.orderBtn setTitle:@"前往预定" forState:UIControlStateNormal];
        self.refundLabel.text = @"";
    }else if (self.orderType == OrderTypeWaitSend){
        [self.orderBtn setTitle:@"已付款" forState:UIControlStateNormal];
        self.refundLabel.text = @"申请退款";
    }else if (self.orderType == OrderTypeRefunding){
         self.refundLabel.text = @"退款申请中";
    }else if (self.orderType == OrderTypeRefunded){
         self.refundLabel.text = @"退款完成";
    }else if (self.orderType == OrderTypeRefundChecked){
         self.refundLabel.text = @"退款审核通过";
    }else if (self.orderType == OrderTypeRefundReject){
         self.refundLabel.text = @"拒绝退款";
    }else{
         self.refundLabel.text = @"";
    }
    //self.lessonLabel.text = @"技能300+";
    self.priceLabel.text =  [NSString stringWithFormat:@"CNY %@元",data[@"goods_price"]];//@"CNY 2000元";
    self.nameLabel.text = [NSString stringWithFormat:@"%@",data[@"goods_title"]];//@"禅学研习";
    self.descLabel.text =  @"伍宝亲自编写教案，执教中华茶道课程。";//[NSString stringWithFormat:@"%@",data[@"title_two"]];//
    [self.storyImgView sd_setImageWithURL:[NSURL URLWithString:data[@"goods_img"]] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    return lbl;
    
}
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return btn;
    
}
@end
