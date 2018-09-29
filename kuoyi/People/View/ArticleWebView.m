//
//  ArticleWebView.m
//  kuoyi
//
//  Created by alexzinder on 2018/5/30.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ArticleWebView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import <SDCycleScrollView.h>
#import "ReturnUrlTool.h"
#import "UIWebView+CancelIndicator.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "NotificationMacro.h"
#import "CustomerManager.h"

@interface ArticleWebView()<UIWebViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, copy) NSDictionary *articleData;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, assign) NSInteger currentCount;

;

@end
@implementation ArticleWebView
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGoodsAddCart object:nil];
}
-(instancetype)initWithData:(NSDictionary *)data{
    
    self = [super init];
    if (self) {
        self.articleData = data;
            self.currentCount = 1;
        [self p_initUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_addToCart) name:kGoodsAddCart object:nil];
    }
    
    return self;
    
}
//data =     {
//    describe = "\U9ad8\U7aef\U56fd\U9645\U5316\U5320\U4eba\U5236\U9020";
//    id = 17;
//    images =         (
//                      "http://www.kuoyilife.com/uploadfile/20180529/107fb211d1dacffba269d6d960cd696b.jpg",
//                      "http://www.kuoyilife.com/uploadfile/20180529/2a75bac06e300b447aaf5af8da5413a6.jpg"
//                      );
//    info = "\U957f\Uff1a12cm*13cm";
//    infot = "<null>";
//    price = 40;
//    "stock_num" = 40;
//    title = "\U8336\U827a\U676f\U5b50";
//    uuid = 964180641e42aa68a96a159c1762ba84;
//};
//error = 0;
-(void)p_initUI{
    __weak __typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"ppclose"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(self.mas_top).offset(10);
        //make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.closeBtn bk_addEventHandler:^(id sender) {
        [weakSelf p_hideView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.currentCount = 1;
    UILabel *titleLabel = [self createLabelWithColor:@"000000" font:17];
    titleLabel.text = [NSString stringWithFormat:@"%@",self.articleData[@"title"]];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        //make.top.equalTo(
    }];
    
    UILabel *subLabel = [self createLabelWithColor:@"0000000" font:12];
    subLabel.text = [NSString stringWithFormat:@"%@",self.articleData[@"describe"]];
    [self addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
        //make.top.equalTo(
    }];
    
    
    
    NSMutableArray *imgMArr = [NSMutableArray array];
    for (int i = 0; i < [self.articleData[@"images"] count]; i++) {
        [imgMArr addObject:self.articleData[@"images"][i]];
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:imgMArr];
    CGFloat scrollHeight = (DEVICE_WIDTH - 30) * 0.636;
    //    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"b1.jpg",@"b2.jpg",@"b3.jpg"]];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.height.mas_equalTo(scrollHeight);
        make.top.equalTo(subLabel.mas_bottom).offset(7);
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
    NSString *pageStr = [NSString stringWithFormat:@"1/%lu",[self.articleData[@"images"] count]];
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//
    //self.pageBtn.backgroundColor = [UIColor colorWithHexString:@"adaeba"];
    [self addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView.mas_right).offset(-10);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
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
    self.priceLabel = [self createLabelWithColor:@"000000" font:12];
    self.priceLabel.text = [NSString stringWithFormat: @"售价：CNY %@元",self.articleData[@"price"]];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightView.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.rightView.mas_top).offset(18);
    }];
    
    UILabel *leftLabel = [self createLabelWithColor:@"000000" font:10];
    if ([self.articleData[@"stock_num"] isEqualToString:@"0"]) {
        
        leftLabel.text = @"售罄";
        
    }else{
        
        leftLabel.text = @"有库存";
    }
    
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_left);
        make.right.equalTo(self.rightView.mas_right).offset(-15);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(18);
    }];
    
    self.minusBtn = [self createBtnWithColor:@"ffffff" font:10];
    self.minusBtn.backgroundColor = [UIColor blackColor];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.rightView addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_left);
        make.top.equalTo(leftLabel.mas_bottom).offset(5);
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
    
    UIButton *addCartBtn = [self createBtnWithColor:@"ffffff" font:17];
    addCartBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
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
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(BuyGoods)}];
//        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_left);
        make.top.equalTo(self.rightView.mas_top).offset(18);
        make.bottom.equalTo(self.mas_bottom);
    }];
    //ApiBaseUrl
    NSInteger bid = [self.articleData[@"id"] integerValue];
    NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeBook andDetailId:bid];
    NSURL *url= [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [UIWebView cancelScrollIndicator:self.webView];
}
-(void)a_addProductCountAction{
    
    self.currentCount ++ ;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    NSInteger totalPrice = self.currentCount * [self.articleData[@"price"] integerValue];
    self.priceLabel.text = [NSString stringWithFormat: @"售价：CNY %ld元",(long)totalPrice];
}
-(void)a_minusProductCountAction{
    
    if (self.currentCount > 1) {
        self.currentCount--;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
        NSInteger totalPrice = self.currentCount * [self.articleData[@"price"] integerValue];
        self.priceLabel.text = [NSString stringWithFormat: @"售价：CNY %ld元",(long)totalPrice];
    }
    
}
-(void)p_hideView{
    
    self.alpha = 0;
    [self removeFromSuperview];
}
-(void)p_addToCart{
    
    if (self.currentCount <= 0) {
        [HLYHUD showHUDWithMessage:@"请选择正确的数量!" addToView:nil];
        return;
    }
    NSInteger stockNum = [self.articleData[@"stock_num"] integerValue];
    if (self.currentCount > stockNum) {
        [HLYHUD showHUDWithMessage:@"库存不足！" addToView:nil];
        return;
    }
    NSDictionary *params = @{@"id":self.articleData[@"uuid"],@"number":@(self.currentCount)};
    //    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.cart/addCart";
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:@"添加成功" addToView:nil];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(BuyGoods)}];
        }
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
  
    NSString *pageIndex = [NSString stringWithFormat:@"%ld/%lu",(long)index + 1,[self.articleData[@"images"] count]];
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
