//
//  RewardViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/14.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "RewardViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "KYNetService.h"
#import "HLYHUD.h"
#import "HomeDetail.h"
#import "PeopleInfo.h"
#import <YYModel.h>
#import <SDCycleScrollView.h>
#import <BlocksKit+UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "VendorMacro.h"
#import "APRSASigner.h"
#import "CTAlertView.h"
#import <UIImageView+WebCache.h>


#define BUTTON_TAG 1000
@interface RewardViewController ()<SDCycleScrollViewDelegate,UITextFieldDelegate,CTAlertViewDelegate>

//@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *otherPriceLaebl;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UITextField *priceTF;
@property (nonatomic, strong) UIButton *rewardBtn;

/**
 选中按钮
 */
@property (nonatomic, weak) UIButton *setTypeButton;


@property (nonatomic, strong) NSArray *priceArray;

@property (nonatomic, assign) CGFloat rewardPrice;

@property (nonatomic, copy) NSDictionary *payInfoDic;

@end

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赞赏";
    self.rewardPrice = 0;
     self.priceArray = @[@"1",@"2",@"5",@"10",@"20",@"50"];
    // Do any additional setup after loading the view.
    [self p_initUI];
   
}

-(void)p_initUI{
    __weak typeof(self)weakSelf = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat scrollHeight = (DEVICE_WIDTH) * 0.516;
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"b1.jpg",@"b2.jpg",@"b3.jpg"]];
//    self.cycleScrollView.delegate = self;
//    self.cycleScrollView.autoScroll = NO;
//    self.cycleScrollView.showPageControl = NO;
//    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    [self.view addSubview:self.cycleScrollView];//737 1155
//    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.size.height.mas_equalTo(scrollHeight);
//    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"b2.jpg"]];
     [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.size.height.mas_equalTo(scrollHeight);
    }];
    
    self.infoLabel = [self createLabelWithColor:@"3c3c3c" font:15];
    self.infoLabel.text = @"支持原创，创作者（团队）会收到你的鼓励。";
    [self.view addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.top.equalTo(imgView.mas_bottom).offset(20);
    }];
    
    CGFloat btnW,btnH;
    btnW = (DEVICE_WIDTH - 22*2 - 8*2) /3;
    btnH = btnW * 0.52;
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.midView];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, btnH * 2 + 10));
    }];
    
    NSMutableArray *firstArray = [NSMutableArray array];
    for (int i = 0 ; i < 3; i++) {
        UIButton *btn = [self createBtnWithColor:@"0000ff" font:15];
        btn.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 5;
        btn.tag = BUTTON_TAG + [self.priceArray[i] integerValue];
        [btn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:self.priceArray[i] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
        NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:@" 元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
        [priceAttribute appendAttributedString:endAttribute];
        [btn setAttributedTitle:priceAttribute forState:UIControlStateNormal];
        [self.midView addSubview:btn];
        [firstArray addObject:btn];
    }
    [firstArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:22 tailSpacing:22];
    [firstArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_top);
        make.size.height.mas_equalTo(btnH);
    }];
    
    NSMutableArray *secondArray = [NSMutableArray array];
    for (int i = 3; i < 6; i++) {
        UIButton *btn = [self createBtnWithColor:@"0000ff" font:15];
        btn.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = 5;
        btn.tag = BUTTON_TAG + [self.priceArray[i] integerValue];
        [btn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:self.priceArray[i] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
        NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:@" 元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
        [priceAttribute appendAttributedString:endAttribute];
        [btn setAttributedTitle:priceAttribute forState:UIControlStateNormal];
        [self.midView addSubview:btn];
        [secondArray addObject:btn];
    }
    [secondArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:22 tailSpacing:22];
    [secondArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.midView.mas_top).offset(btnH + 10);
        make.size.height.mas_equalTo(btnH);
        make.bottom.equalTo(self.midView.mas_bottom);
    }];
    
    
    self.otherPriceLaebl = [self createLabelWithColor:@"0000ff" font:12];
    self.otherPriceLaebl.text = @"其他金额";
    [self.view addSubview:self.otherPriceLaebl];
    [self.otherPriceLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel.mas_left);
        make.top.equalTo(self.midView.mas_bottom).offset(40);
    }];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    self.botView.layer.borderColor = [UIColor colorWithHexString:@"f0f3f5"].CGColor;
    self.botView.layer.borderWidth = 1;
    self.botView.layer.cornerRadius = 5;
    [self.view addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel.mas_left);
        make.top.equalTo(self.otherPriceLaebl.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-22);
        make.size.height.mas_equalTo(38);
    }];
    
    UILabel *priceLabel = [self createLabelWithColor:@"3c3c3c" font:14];
    priceLabel.text = @"金额（元）";
    [self.botView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(self.botView.mas_left).offset(15);
        make.size.width.mas_equalTo(90);
    }];
    
    self.priceTF = [[UITextField alloc] init];
    self.priceTF.placeholder = @"请在此输入金额";
    self.priceTF.delegate = self;
    [self.priceTF setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];//
    [self.priceTF setValue:[UIColor colorWithHexString:@"dcdddd"] forKeyPath:@"_placeholderLabel.textColor"];
    self.priceTF.textColor = [UIColor colorWithHexString:@"000000"];
    self.priceTF.font = [UIFont systemFontOfSize:14];
    self.priceTF.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTF.textAlignment = NSTextAlignmentLeft;
    [self.botView addSubview:self.priceTF];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(priceLabel.mas_right).offset(20);
        make.right.equalTo(self.botView.mas_right).offset(-30);
    }];
    
    self.rewardBtn = [self createBtnWithColor:@"ffffff" font:15];
    [self.rewardBtn setTitle:@"赞赏" forState:UIControlStateNormal];
    self.rewardBtn.backgroundColor = [UIColor colorWithHexString:@"ff127e"];
    self.rewardBtn.layer.cornerRadius = 5;
    [self.view addSubview:self.rewardBtn];
    [self.rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left);
        make.top.equalTo(self.botView.mas_bottom).offset(22);
        make.right.equalTo(self.botView.mas_right);
        make.size.height.mas_equalTo(38);
    }];
    [self.rewardBtn bk_addEventHandler:^(id sender) {
        [weakSelf rewardRequest];
    } forControlEvents:UIControlEventTouchUpInside];
}

// 选中按钮
- (void)setTypeBtn:(UIButton *)btn
{
    self.setTypeButton.backgroundColor = [UIColor whiteColor];
    self.setTypeButton.transform = CGAffineTransformIdentity;
    if (btn) {
        btn.backgroundColor = [UIColor colorWithHexString:@"fec7c7"];
        btn.transform = CGAffineTransformMakeScale(1, 1);
    }
    
    self.setTypeButton = btn;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    textField.placeholder = @"";
    [self setTypeBtn:nil];
    self.rewardPrice = 0;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.placeholder = @"请在此输入金额";
    if (![textField.text isEqualToString:@""]) {
        self.rewardPrice = [textField.text floatValue];
    }else{
        self.rewardPrice = 0;
    }
}

-(void)rewardRequest{
    if (self.rewardPrice == 0) {
        [HLYHUD showHUDWithMessage:@"请先选择金额" addToView:nil];
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"id":self.uuid,@"price":[NSString stringWithFormat:@"%f",self.rewardPrice],@"type":@"1"};
    NSString *url = @"v1.reward/add";
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.payInfoDic = dict[@"data"];
        [weakSelf goToAliPay];
       // [HLYHUD showHUDWithMessage:@"修改成功" addToView:nil];
       // [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
-(void)goToAliPay{
    
    NSString *appID = kPartnerKey;
    NSString *rsa2PrivateKey = kSignKey;
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [rsa2PrivateKey length] == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    APOrderInfo* order = [APOrderInfo new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = @"RSA2";
    order.notify_url = self.payInfoDic[@"notifyurl"];
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"测试1";//self.payInfoDic[@"description"];
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = self.payInfoDic[@"orderno"];//[self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = kTimeoutKey; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格self.payInfoDic[@"price"]
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:rsa2PrivateKey];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = kAlipaySchemeKey;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSNumber *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus integerValue] == 9000) {
                CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"赞赏成功!" OkButton:@"确认"];
                [alerView show:nil];
            }else{
                [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
            }
        }];
    }
    
}
-(void)handlePayCallback:(NSNotification *) userinfo{
    NSDictionary *resultDic = userinfo.object[@"resultDic"];
    NSNumber *resultStatus = resultDic[@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"赞赏成功!" OkButton:@"确认"];
        alerView.delegate = self;
        [alerView show:nil];
    }else{
        [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
    }
}
#pragma mark CTAlertViewDelegate
-(void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index{
    
    if (index == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark target
-(void)priceBtnClick:(UIButton *)btn{
    self.rewardPrice = btn.tag - BUTTON_TAG;
    [self setTypeBtn:btn];
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
