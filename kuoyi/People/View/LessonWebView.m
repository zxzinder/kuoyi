//
//  LessonWebView.m
//  kuoyi
//
//  Created by alexzinder on 2018/5/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "LessonWebView.h"
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
#import "CustomerManager.h"
#import "NotificationMacro.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "VendorMacro.h"
#import "APRSASigner.h"
#import "CTAlertView.h"
#import "MineViewController.h"
#import "PayOrderTool.h"



@interface LessonWebView()<UIWebViewDelegate,ActionSeetPickViewDelegate,CTAlertViewDelegate>

@property (nonatomic, assign) NSInteger detailId;

@property (nonatomic, strong) UIImageView *topImgView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;

//priceLabel
@property (nonatomic, strong) UILabel *priceLabel;

//lesBtn
@property (nonatomic, strong) UIButton *lesBtn;

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;


@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, copy) NSDictionary *lessonData;

@property (nonatomic, strong) NSMutableArray *contList;

@property (nonatomic, assign) NSInteger selectLesIndex;


@property (nonatomic, copy) NSDictionary *payInfoDic;

@end

@implementation LessonWebView

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBuyLesson object:nil];
}
-(instancetype)initWithData:(NSInteger )detailId{
    
    
    self = [super init];
    if (self) {
        self.detailId = detailId;
        self.currentCount = 1;
        [self p_initUI];
        [self getLessonRequest];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_addToCart) name:kBuyLesson object:nil];
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
        make.left.equalTo(self.mas_right).offset(-123-14-25);
        // make.size.width.mas_equalTo(108);/
    }];
    
    self.topImgView = [[UIImageView alloc] init];
  
    //topImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, 107, 148)];
    [self.rightView addSubview:self.topImgView];// 369  556
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightView.mas_top).offset(20);
        make.left.equalTo(self.rightView.mas_left).offset(14);
        make.right.equalTo(self.rightView.mas_right).offset(-14);
        make.size.height.mas_equalTo(185);//148
    }];
    
    
    UILabel *infoLabel = [self createLabelWithColor:@"000000" font:10];
    infoLabel.text = @"选择课程";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImgView.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.topImgView.mas_bottom).offset(22);
    }];


    self.lesBtn = [self createBtnWithColor:@"000000" font:12];
    self.lesBtn.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    //[lesBtn setTitle:@"研修课" forState:UIControlStateNormal];
    self.lesBtn.layer.borderWidth = 1;
    self.lesBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [self.rightView addSubview:self.lesBtn];
    [self.lesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoLabel.mas_left);
        make.top.equalTo(infoLabel.mas_bottom).offset(5);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.size.height.mas_equalTo(25);
    }];
    [self.lesBtn bk_addEventHandler:^(id sender) {//@[@"研修课",@"进修课",@"高阶课"]
        ActionSeetPickerView *picker = [[ActionSeetPickerView alloc] initPickviewWithArray:self.contList isHaveNavControler:YES];
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
        make.top.equalTo(self.lesBtn.mas_bottom).offset(20);
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
    //self.priceLabel.text = [NSString stringWithFormat:@"CNY %@",@"2000"];
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
        //if ([CustomerManager sharedInstance].isLogin) {
            [weakSelf p_addToCart];
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderLesson)}];
//        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_left);
        make.top.equalTo(self.topImgView.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [UIWebView cancelScrollIndicator:self.webView];
    
}
-(void)a_addProductCountAction{
    
    self.currentCount ++ ;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    if ([self.lessonData[@"price"] isEqualToString:@"0"]) {
        self.priceLabel.text = @"免费参与";
    }else{
        NSInteger totalPrice = self.currentCount * [self.lessonData[@"price"] integerValue];
        self.priceLabel.text = [NSString stringWithFormat:@"CNY %ld",(long)totalPrice];
    }
}
-(void)a_minusProductCountAction{
    
    if (self.currentCount > 1) {
        self.currentCount--;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
        if ([self.lessonData[@"price"] isEqualToString:@"0"]) {
            self.priceLabel.text = @"免费参与";
        }else{
            NSInteger totalPrice = self.currentCount * [self.lessonData[@"price"] integerValue];
            self.priceLabel.text = [NSString stringWithFormat:@"CNY %ld",(long)totalPrice];
        }
    }
    
}
-(void)getLessonRequest{
    
    __weak __typeof(self)weakSelf = self;
    //[HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.courses/info";
    NSDictionary *params = @{@"peopleid":@(self.detailId)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        
        NSLog(@"%@",dict);
        
        self.lessonData = dict[@"data"] ;
       // self.contList = self.lessonData[@"contlist"];
        
        if (self.lessonData[@"contlist"]) {
            for (int i = 0; i< [self.lessonData[@"contlist"] count]; i++) {
                [self.contList addObject:self.lessonData[@"contlist"][i][@"title"]];
                if (i == 0) {
                    [self.lesBtn setTitle:self.contList[i] forState:UIControlStateNormal];
                    self.selectLesIndex = 0;
                }
            }
            
        }
        
        NSURL *url = [NSURL URLWithString:self.lessonData[@"haibao"]];
        [self.topImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        if ([self.lessonData[@"price"] isEqualToString:@"0"]) {
            self.priceLabel.text = @"免费参与";
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"CNY %@",self.lessonData[@"price"]];
        }
        NSString *urlString = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeLesson andDetailId:[self.lessonData[@"id"] integerValue]];
        NSURL *weburl= [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request=[[NSURLRequest alloc]initWithURL:weburl];
        [self.webView loadRequest:request];
        
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}


-(void)p_addToCart{
    
    if (self.currentCount <= 0) {
        [HLYHUD showHUDWithMessage:@"请选择正确的参与人数!" addToView:nil];
        return;
    }
    NSInteger stockNum = [self.lessonData[@"maxnum"] integerValue];
    if (self.currentCount > stockNum) {
        [HLYHUD showHUDWithMessage:@"库存不足！" addToView:nil];
        return;
    }
    NSString *contid;
    if (self.lessonData[@"contlist"] && [self.lessonData[@"contlist"] count] > 0) {
        contid = self.lessonData[@"contlist"][self.selectLesIndex][@"id"];
    }else{
        [HLYHUD showHUDWithMessage:@"请先选择课程！" addToView:nil];
        return;
    }
    
    NSDictionary *params = @{@"id":self.lessonData[@"uuid"],@"number":@(self.currentCount),@"class":@(OrderLesson),@"contid":contid};
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/addProductOrder";
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:@"添加成功" addToView:nil];
        //weakSelf.payInfoDic = dict[@"data"];
        //[PayOrderTool goToAliPay:weakSelf.payInfoDic];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(OrderLesson)}];
        }
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
#pragma mark ActionSeetPickViewDelegate
- (void)toobarDonBtnHaveClick:(ActionSeetPickerView *)pickView resultString:(NSString *)resultString {
    
    NSLog(@"%@",resultString);
    if (self.contList.count > 0) {
        for (int i = 0; i < self.contList.count; i++) {
            if ([resultString isEqualToString:self.contList[i]]) {
                self.selectLesIndex = i;
            }
        }
    }
    
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
-(NSMutableArray *)contList{
    
    if (!_contList) {
        _contList = [NSMutableArray array];
    }
    return _contList;
}
@end
