//
//  SpaceWebView.m
//  kuoyi
//
//  Created by 叶子 on 2018/5/29.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "SpaceWebView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import <SDCycleScrollView.h>
#import "ReturnUrlTool.h"
#import "UIWebView+CancelIndicator.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "CalendarPickViewController.h"
#import "TimePickView.h"
#import "NotificationMacro.h"
#import "PGDatePicker.h"
#import "CustomerManager.h"
#import "PayOrderTool.h"
#import "CTAlertView.h"


@interface SpaceWebView()<SDCycleScrollViewDelegate,UIWebViewDelegate,CTAlertViewDelegate>


@property (nonatomic, copy) NSDictionary *spaceData;

@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) UIButton *beginTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) TimePickView *timepickView;

@end

@implementation SpaceWebView

-(void)dealloc{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kCalendarGetDate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCalendarGetTime object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrderSpace object:nil];
}

-(instancetype)initWithData:(NSDictionary *)data{
    
    self = [super init];
    if (self) {
        self.spaceData = data;
        self.currentCount = 1;
        [self p_initUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCalendarDate:) name:kCalendarGetDate object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCalendarTime:) name:kCalendarGetTime object:nil];
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_addToCart) name:kOrderSpace object:nil];
    }
    
    return self;
    
}
-(void)p_initUI{
    
    __weak __typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
   
    NSMutableArray *imgMArr = [NSMutableArray array];
    for (int i = 0; i < [self.spaceData[@"imgs"] count]; i++) {
        [imgMArr addObject:self.spaceData[@"imgs"][i][@"url"]];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:imgMArr];
    CGFloat scrollWidth = DEVICE_WIDTH * 0.86;
    CGFloat scrollHeight = scrollWidth * 0.58;
    //    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"b1.jpg",@"b2.jpg",@"b3.jpg"]];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(scrollWidth, scrollHeight));
        //1073  678
    }];
    
    //加透明
    UIView *pageView = [[UIView alloc] init];//
    pageView.alpha = 0.3;
    pageView.layer.cornerRadius = 6;
    pageView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    [self addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView.mas_right).offset(-10);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.pageBtn = [self createBtnWithColor:@"fffff" font:12];
    self.pageBtn.layer.cornerRadius = 6;
    NSString *pageStr = [NSString stringWithFormat:@"1/%lu",[self.spaceData[@"imgs"] count]];
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//
    //self.pageBtn.backgroundColor = [UIColor colorWithHexString:@"adaeba"];
    [self addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView.mas_right).offset(-10);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"ppclose"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        //make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.closeBtn bk_addEventHandler:^(id sender) {
        [weakSelf p_hideView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(cycleScrollView.mas_bottom);
        make.left.equalTo(self.mas_right).offset(-123-15-15);
        // make.size.width.mas_equalTo(108);
    }];
    
    //框框23
    //距离 18, 5, 14 , 15, 
    
    UILabel *leftLabel = [self createLabelWithColor:@"000000" font:10];
    leftLabel.text = @"使用时间";
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.rightView.mas_top).offset(18);
    }];
    
    self.dateBtn = [self createBtnWithColor:@"000000" font:12];
    self.dateBtn.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.dateBtn setTitle:@"请选择日期" forState:UIControlStateNormal];
    self.dateBtn.layer.borderWidth = 1;
    self.dateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.rightView addSubview:self.dateBtn];
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.top.equalTo(leftLabel.mas_bottom).offset(5);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.size.height.mas_equalTo(23);
    }];
    [self.dateBtn bk_addEventHandler:^(id sender) {
       [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarPick object:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.beginTimeBtn = [self createBtnWithColor:@"000000" font:12];
    self.beginTimeBtn.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.beginTimeBtn setTitle:@"00:00" forState:UIControlStateNormal];
    self.beginTimeBtn.layer.borderWidth = 1;
    self.beginTimeBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.rightView addSubview:self.beginTimeBtn];
    [self.beginTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.top.equalTo(self.dateBtn.mas_bottom).offset(14);
        make.right.equalTo(self.dateBtn.mas_centerX).offset(-3);
        make.size.height.mas_equalTo(23);
    }];
    [self.beginTimeBtn bk_addEventHandler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTimePick object:@{@"isBegin":@"1"}];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.endTimeBtn = [self createBtnWithColor:@"000000" font:12];
    self.endTimeBtn.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.endTimeBtn setTitle:@"00:00" forState:UIControlStateNormal];
    self.endTimeBtn.layer.borderWidth = 1;
    self.endTimeBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.rightView addSubview:self.endTimeBtn];
    [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateBtn.mas_centerX).offset(3);
        make.top.equalTo(self.dateBtn.mas_bottom).offset(14);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.size.height.mas_equalTo(23);
    }];
    [self.endTimeBtn bk_addEventHandler:^(id sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTimePick object:@{@"isBegin":@"0"}];
    } forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *infoLabel = [self createLabelWithColor:@"000000" font:10];
    infoLabel.text = @"参与人数";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.beginTimeBtn.mas_bottom).offset(15);
    }];
    
    
    self.minusBtn = [self createBtnWithColor:@"ffffff" font:10];
    self.minusBtn.backgroundColor = [UIColor blackColor];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.rightView addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.top.equalTo(infoLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(19, 27));
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
        make.size.mas_equalTo(CGSizeMake(19, 27));
    }];
    
    [self.addBtn bk_addEventHandler:^(id sender) {
        
        
        [weakSelf a_addProductCountAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.numLabel = [self createLabelWithColor:@"000000" font:17];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.layer.borderWidth = 1;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    self.numLabel.layer.borderColor = [UIColor colorWithHexString:@"000000"].CGColor;
    [self.rightView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_right).offset(2);
        make.top.equalTo(self.minusBtn.mas_top);
        make.bottom.equalTo(self.minusBtn.mas_bottom);
        make.right.equalTo(self.addBtn.mas_left).offset(-2);
        //make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    self.priceLabel = [self createLabelWithColor:@"000000" font:10];
    self.priceLabel.text = [NSString stringWithFormat: @"CNY %@元",self.spaceData[@"price"]];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.minusBtn.mas_bottom).offset(15);
    }];
    
    UIButton *addCartBtn = [self createBtnWithColor:@"ffffff" font:17];
    addCartBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [addCartBtn setTitle:@"预定" forState:UIControlStateNormal];
    [self.rightView addSubview:addCartBtn];
    [addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_left);
        make.right.equalTo(self.addBtn.mas_right);
        make.top.equalTo(self.minusBtn.mas_bottom).offset(10);
        make.size.height.mas_equalTo(30);
    }];
    [addCartBtn bk_addEventHandler:^(id sender) {
//        if ([CustomerManager sharedInstance].isLogin) {
            [weakSelf p_addToCart];
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderSpace)}];
//        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.rightView.mas_left);
        make.top.equalTo(leftLabel.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    //ApiBaseUrl
    NSInteger bid = [self.spaceData[@"id"] integerValue];
    NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeSpace andDetailId:bid];
    NSURL *url= [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [UIWebView cancelScrollIndicator:self.webView];
}
-(void)a_addProductCountAction{
    
    self.currentCount ++ ;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    NSInteger totalPrice = self.currentCount * [self.spaceData[@"price"] integerValue];
    self.priceLabel.text = [NSString stringWithFormat: @"售价：CNY %ld元",(long)totalPrice];
    
}
-(void)a_minusProductCountAction{
    
    if (self.currentCount > 1) {
        self.currentCount--;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
        NSInteger totalPrice = self.currentCount * [self.spaceData[@"price"] integerValue];
        self.priceLabel.text = [NSString stringWithFormat: @"售价：CNY %ld元",(long)totalPrice];
        
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
    if ([self.dateBtn.titleLabel.text isEqualToString:@"请选择日期"]) {
        [HLYHUD showHUDWithMessage:@"请选择正确日期!" addToView:nil];
        return;
    }
    if ([self.beginTimeBtn.titleLabel.text isEqualToString:@"00:00"]) {
        [HLYHUD showHUDWithMessage:@"请选择正确日期!" addToView:nil];
        return;
    }
    if ([self.endTimeBtn.titleLabel.text isEqualToString:@"00:00"]) {
        [HLYHUD showHUDWithMessage:@"请选择正确日期!" addToView:nil];
        return;
    }
    
    NSString *beginDate = [NSString stringWithFormat:@"%@ %@:00",self.dateBtn.titleLabel.text,self.beginTimeBtn.titleLabel.text];//@"2012-12-12 12:20:12"
     NSString *endDate = [NSString stringWithFormat:@"%@ %@:00",self.dateBtn.titleLabel.text,self.endTimeBtn.titleLabel.text];
    NSDictionary *params = @{@"id":self.spaceData[@"uuid"],@"number":@(self.currentCount),@"class":@(OrderSpace),
                             @"bgdate":beginDate,@"enddate":endDate,@"tp":self.spaceData[@"types"]
                             };
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderSpace)}];
        }
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)setCalendarDate:(NSNotification *) userinfo{
    
    NSString *selectDate =  userinfo.object[@"date"];
    [self.dateBtn setTitle:selectDate forState:UIControlStateNormal];
}

-(void)setCalendarTime:(NSNotification *) userinfo{
    
    if (userinfo.object[@"beginTime"]) {
        NSString *selectTime =  userinfo.object[@"beginTime"];
        [self.beginTimeBtn setTitle:selectTime forState:UIControlStateNormal];
    }else{
        NSString *selectTime =  userinfo.object[@"endTime"];
        [self.endTimeBtn setTitle:selectTime forState:UIControlStateNormal];
    }
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSString *pageIndex = [NSString stringWithFormat:@"%ld/%lu",(long)index + 1,[self.spaceData[@"imgs"] count]];
    [self.pageBtn setTitle:pageIndex forState:UIControlStateNormal];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
