//
//  ActivityWebView.m
//  kuoyi
//
//  Created by alexzinder on 2018/5/30.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ActivityWebView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import <SDCycleScrollView.h>
#import "ReturnUrlTool.h"
#import "UIImage+Generate.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import <UIImageView+WebCache.h>
#import "ActionSeetPickerView.h"
#import "UIWebView+CancelIndicator.h"
#import "EnumHeader.h"
#import "NotificationMacro.h"
#import "CustomerManager.h"
#import "PayOrderTool.h"
#import "CTAlertView.h"

@interface ActivityWebView()<UIWebViewDelegate,ActionSeetPickViewDelegate,CTAlertViewDelegate>

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImageView *topImgView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;

//priceLabel
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;


@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, copy) NSDictionary *activityData;



@end


@implementation ActivityWebView
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderActivity object:nil];
     
}
-(instancetype)initWithData:(NSDictionary *)data{
    
    self = [super init];
    if (self) {
        self.activityData = data;
        self.currentCount = 1;
        [self p_initUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_addToCart) name:kOrderActivity object:nil];

    }
    
    return self;
    
    
}
-(void)p_initUI{
    //107
    __weak __typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    

    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_right).offset(-123-14-15);
        // make.size.width.mas_equalTo(108);
    }];
    
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"ppclose"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(self.mas_top).offset(19);//19
        //make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.closeBtn bk_addEventHandler:^(id sender) {
        [weakSelf p_hideView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.topImgView = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:self.activityData[@"haibao"]];
    [self.topImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
   // self.topImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, 123, 185)];
    [self.rightView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightView.mas_top).offset(50);
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.size.height.mas_equalTo(185);
    }];
    
    
    UILabel *infoLabel = [self createLabelWithColor:@"000000" font:10];
    infoLabel.text = @"参与时间";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImgView.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.topImgView.mas_bottom).offset(20);
    }];
    
    
    UIButton *lesBtn = [self createBtnWithColor:@"000000" font:12];
    lesBtn.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [lesBtn setTitle:@"研修课" forState:UIControlStateNormal];
    lesBtn.layer.borderWidth = 1;
    lesBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.rightView addSubview:lesBtn];
    [lesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLabel.mas_left);
        make.top.equalTo(infoLabel.mas_bottom).offset(5);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.size.height.mas_equalTo(25);
    }];
    [lesBtn bk_addEventHandler:^(id sender) {
        ActionSeetPickerView *picker = [[ActionSeetPickerView alloc] initPickviewWithArray:@[@"研修课",@"进修课",@"高阶课"] isHaveNavControler:YES];
        picker.delegate = self;
        [picker setToolbarTintColor:[UIColor whiteColor]];
        [picker setLeftTintColor:[UIColor tp_lightGaryTextColor]];
        [picker setRightTintColor:[UIColor colorWithHexString:@"17a7af"]];
        [picker show];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *leftLabel = [self createLabelWithColor:@"000000" font:10];
    leftLabel.text = @"参与人数";
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImgView.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(lesBtn.mas_bottom).offset(20);
    }];
    
    self.minusBtn = [self createBtnWithColor:@"ffffff" font:10];
    self.minusBtn.backgroundColor = [UIColor blackColor];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.rightView addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.top.equalTo(leftLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(18, 25));
    }];
    [self.minusBtn bk_addEventHandler:^(id sender) {
        [weakSelf a_minusProductCountAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.addBtn = [self createBtnWithColor:@"ffffff" font:10];
    self.addBtn.backgroundColor = [UIColor blackColor];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.rightView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.centerY.equalTo(self.minusBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 25));
    }];
    
    [self.addBtn bk_addEventHandler:^(id sender) {
        [weakSelf a_addProductCountAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.numLabel = [self createLabelWithColor:@"000000" font:10];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.layer.borderWidth = 1;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    self.numLabel.layer.borderColor = [UIColor colorWithHexString:@"000000"].CGColor;
    [self.rightView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_right).offset(3);
        make.top.equalTo(self.minusBtn.mas_top);
        make.bottom.equalTo(self.minusBtn.mas_bottom);
        make.right.equalTo(self.addBtn.mas_left).offset(-3);
        //make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    self.priceLabel = [self createLabelWithColor:@"000000" font:10];
    if ([self.activityData[@"price"] isEqualToString:@"0"]) {
        self.priceLabel.text = @"免费参与";
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"CNY %@",self.activityData[@"price"]];
    }
    [self.rightView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_left);
        make.top.equalTo(self.minusBtn.mas_bottom).offset(10);
    }];
    
    UIButton *addCartBtn = [self createBtnWithColor:@"ffffff" font:12];
    addCartBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [addCartBtn setTitle:@"报名" forState:UIControlStateNormal];
    [self.rightView addSubview:addCartBtn];
    [addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_left);
        make.right.equalTo(self.addBtn.mas_right);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.size.height.mas_equalTo(30);
    }];
    [addCartBtn bk_addEventHandler:^(id sender) {
        //[weakSelf p_addToCart];
//        if ([CustomerManager sharedInstance].isLogin) {
            [weakSelf p_addToCart];
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderActivity)}];
//        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.right.equalTo(self.rightView.mas_left);
        make.top.equalTo(self.closeBtn.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    NSInteger bid = [self.activityData[@"id"] integerValue];
    NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeActivity andDetailId:bid];
    NSURL *webUrl= [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:webUrl];
    [self.webView loadRequest:request];
    [UIWebView cancelScrollIndicator:self.webView];
 
    
    
}
-(void)a_addProductCountAction{
    
    self.currentCount ++ ;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    if ([self.activityData[@"price"] isEqualToString:@"0"]) {
        self.priceLabel.text = @"免费参与";
    }else{
        NSInteger totalPrice = self.currentCount * [self.activityData[@"price"] integerValue];
        self.priceLabel.text = [NSString stringWithFormat:@"CNY %ld",(long)totalPrice];
    }
}
-(void)a_minusProductCountAction{
    
    if (self.currentCount > 1) {
        self.currentCount--;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
        if ([self.activityData[@"price"] isEqualToString:@"0"]) {
            self.priceLabel.text = @"免费参与";
        }else{
            NSInteger totalPrice = self.currentCount * [self.activityData[@"price"] integerValue];
            self.priceLabel.text = [NSString stringWithFormat:@"CNY %ld",(long)totalPrice];
        }
    }
    
}
-(void)p_hideView{
    
    self.alpha = 0;
    [self removeFromSuperview];
}
-(void)p_addToCart{
    
    if (self.currentCount <= 0) {
        [HLYHUD showHUDWithMessage:@"请选择正确的参与人数!" addToView:nil];
        return;
    }
    //    NSInteger stockNum = [self.lessonData[@"stock"] integerValue];
    //    if (self.currentCount > stockNum) {
    //        [HLYHUD showHUDWithMessage:@"库存不足！" addToView:nil];
    //        return;
    //    }
    NSDictionary *params = @{@"id":self.activityData[@"uuid"],@"number":@(self.currentCount),@"class":@(OrderActivity)};
    //    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/addProductOrder";
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:@"预定成功" addToView:nil];
         //[PayOrderTool goToAliPay:dict[@"data"]];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderActivity)}];
        }
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
#pragma mark ActionSeetPickViewDelegate
- (void)toobarDonBtnHaveClick:(ActionSeetPickerView *)pickView resultString:(NSString *)resultString {

    NSLog(@"%@",resultString);
    
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
