//
//  PersonalView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PersonalView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "KYNetService.h"
#import "HLYHUD.h"
#import "PeopleInfo.h"
#import <UIImageView+WebCache.h>
#import "CustomerManager.h"



@interface PersonalView()

@property (nonatomic, strong) UIView *topView;

//@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIImageView *collectImgView;
@property (nonatomic, strong) UILabel *collectLabel;
//@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIImageView *likeImgView;
@property (nonatomic, strong) UILabel *likeLabel;
//@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIImageView *shareImgView;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *briefLabel;
/**
 故事
 */
//@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIImageView *detailImgView;
@property (nonatomic, strong) UILabel *infoLabel;
/**
 是否需要顶部分享等按钮
 */
@property (nonatomic, assign) BOOL isNeedTop;

@end

@implementation PersonalView

-(instancetype)initWithType:(BOOL)isNeedTop{
    
    self = [super init];
    if (self) {
        self.isNeedTop = isNeedTop;
        [self p_initUI];
    }
    
    return self;
    
}
-(void)p_initUI{
    __weak __typeof(self)weakSelf = self;
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.headImgView = [[UIImageView alloc] init];
    self.headImgView.layer.borderColor = [UIColor colorWithHexString:@"ced9d0"].CGColor;
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.cornerRadius = imgSizeHW/2;
    self.headImgView.layer.masksToBounds = YES;
    [self.botView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left).offset(14);
        //make.top.equalTo(self.botView.mas_top);
        make.centerY.equalTo(self.botView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(imgSizeHW, imgSizeHW));
    }];
    
    self.nameLabel = [self createLabelWithColor:@"3c3c3c" font:17];
    [self.botView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_top).offset(12);
    }];
    
    self.briefLabel = [self createLabelWithColor:@"3c3c3c" font:12];
    [self.botView addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    NSString *imgStr = @"story_circle";
    if ([CustomerManager sharedInstance].isLogin && [CustomerManager sharedInstance].customer.gender == 2) {
        imgStr = @"story_circle_girl";
    }
    self.detailImgView = [[UIImageView alloc] init];
    self.detailImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.detailImgView.image = [UIImage imageNamed:imgStr];
    self.detailImgView.alpha = 0;
    [self addSubview:self.detailImgView];
    [self.detailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.botView.mas_right).offset(-20);
        make.centerY.equalTo(self.headImgView.mas_centerY);
    }];
    self.detailImgView.userInteractionEnabled = YES;
    [self.detailImgView bk_whenTapped:^{
        weakSelf.detailImgView.alpha = 0;
        weakSelf.infoLabel.alpha = 0;
        if (weakSelf.storyCallback) {
            weakSelf.storyCallback();
        }
    }];
    
    self.infoLabel = [self createLabelWithColor:@"3c3c3c" font:12];
    self.infoLabel.text = @"故事";
    self.infoLabel.alpha = 0;
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.detailImgView.mas_centerX);
        make.top.equalTo(self.detailImgView.mas_bottom).offset(5);
    }];
}
-(void)configureBotData:(PeopleInfo *)info{
    
    if (info.headimg) {
        NSURL *url = [NSURL URLWithString:info.headimg];
        [self.headImgView sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    }else{
        self.headImgView.image = [UIImage imageWithColor:[UIColor whiteColor]];
    }
    self.nameLabel.text = info.name;
    
    if ([info.labels containsString:@"|"]) {
        NSArray *lblArray = [info.labels componentsSeparatedByString:@"|"];
        self.briefLabel.text = lblArray[0];
        UILabel *secLabel = [self createLabelWithColor:@"3c3c3c" font:11];
        secLabel.text = lblArray[1];
        [self.botView addSubview:secLabel];
        [secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.briefLabel.mas_left);
            make.top.equalTo(self.briefLabel.mas_bottom).offset(5);
        }];
    }else{
        self.briefLabel.text = info.labels;//多个是|隔开
    }
    
}
-(void)configureBackViewColor:(BOOL)isWhite{
    if (isWhite) {
         self.botView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }else{
         self.botView.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
    }
   
}
-(void)showDetailImgView{
    [UIView animateWithDuration:0.3 animations:^{
        self.detailImgView.alpha = 1;
        self.infoLabel.alpha = 1;
    }];
    
}
-(void)hideDetailImgView{
    [UIView animateWithDuration:0.3 animations:^{
        self.detailImgView.alpha = 0;
        self.infoLabel.alpha = 0;
    }];
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font icon:(NSString *)icon{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    if (icon) {
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    
    return btn;
    
}
@end
