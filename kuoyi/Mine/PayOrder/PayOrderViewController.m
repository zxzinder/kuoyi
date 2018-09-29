//
//  PayOrderViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PayOrderViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "PayAddressTableViewCell.h"
#import "ShopCartTableViewCell.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "VendorMacro.h"
#import "APRSASigner.h"
#import "CTAlertView.h"
#import "MineViewController.h"
#import "NotificationMacro.h"
#import "ManageAddressViewController.h"
#import "MyOrderViewController.h"


#define TF_TAG 2000
#define BUTTON_TAG 3000
static NSString *addressCell = @"addressCell";
static NSString *prodcutCell = @"prodcutCell";
static NSString * CELLID = @"payCell";
@interface PayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CTAlertViewDelegate>

@property (nonatomic, strong) UITableView *payTableView;
@property (nonatomic, strong) UIButton *aliSelectBtn;
@property (nonatomic, strong) UIButton *wxSelectBtn;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *peopleInfoLabel;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *discountLabel;

@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSArray *infoArray;

@property (nonatomic, strong) NSArray *addressList;
@property (nonatomic, strong) NSDictionary *defaultAddressData;

@property (nonatomic, copy) NSDictionary *payInfoDic;

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger totalNums;
@end

@implementation PayOrderViewController
-(void)dealloc{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPayInfoCallBack object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"结算";
    self.totalNums = 0;
    self.totalPrice = 0;
    self.sectionArray = @[@"选择收货地址",@"订单详情",@"",@"结算方式",@"确认收货地址"];
    self.infoArray = @[@"备注",@"优惠",@"代金券",@"快递",@""];
//    for (int i = 0; i < 2; i++) {
//        int ranX = arc4random() % 100 + 10;
//        int disX = arc4random() % 10;
//        NSString *price = [NSString stringWithFormat:@"%d",ranX];
//        NSString *dis = [NSString stringWithFormat:@"%d",disX];
//        NSDictionary *data = @{@"price":price,@"discount":dis};
//        [self.productArray addObject:data];
//    }
    [self p_initUI];
    [self getOrderInfoRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayCallback:) name:kNotificationPayInfoCallBack object:nil];
}

-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.size.height.mas_equalTo(55);
    }];
    
    self.payBtn = [self createBtnWithColor:@"ffffff" font:16];
     self.payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [self.payBtn setTitle:@"立刻结算" forState:UIControlStateNormal];
    [self.botView addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.width.mas_equalTo(DEVICE_WIDTH * 0.23);
        make.top.bottom.right.equalTo(self.botView);
    }];
    [self.payBtn bk_addEventHandler:^(id sender) {
        [weakSelf addSettlement];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.totalPriceLabel = [self createLabelWithColor:@"000000" font:17];
    self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel.attributedText = [self setTotalPriceTextAttribute:@"￥0"];
    [self.botView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.right.equalTo(self.payBtn.mas_left).offset(-10);
    }];
    
    self.discountLabel = [self createLabelWithColor:@"17a7af" font:9];
      self.discountLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:9];
    self.discountLabel.textAlignment = NSTextAlignmentRight;
    self.discountLabel.text = @"为您节省 ￥0";
    [self.botView addSubview:self.discountLabel];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceLabel.mas_bottom).offset(2);
        make.right.equalTo(self.totalPriceLabel.mas_right);
    }];
    
    self.payTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.payTableView.delegate         = self;
    self.payTableView.dataSource       = self;
    self.payTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.payTableView.showsVerticalScrollIndicator = NO;
    self.payTableView.bounces = NO;
    self.payTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.payTableView];
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
}

-(void)getOrderInfoRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/settlement";
    NSDictionary *params = @{@"uids":self.order_ids};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.productArray = dict[@"data"];
        
        for (int i = 0; i < weakSelf.productArray.count; i++) {
            NSDictionary *proDic =  weakSelf.productArray[i];
            NSInteger nums = [proDic[@"goods_num"] integerValue];
            CGFloat singlePrice = [proDic[@"goods_price"] floatValue];
            weakSelf.totalPrice = weakSelf.totalPrice + singlePrice * nums;
            weakSelf.totalNums = weakSelf.totalNums + nums;
        }
        self.totalPriceLabel.attributedText = [self setTotalPriceTextAttribute:[NSString stringWithFormat:@"￥%.2f",weakSelf.totalPrice]];
        
        weakSelf.addressList = dict[@"address_list"];
        if (weakSelf.addressList.count > 0) {
            for (int i = 0; i < weakSelf.addressList.count; i++) {
                if ([weakSelf.addressList[i][@"state"] integerValue] == 1) {
                    weakSelf.defaultAddressData = weakSelf.addressList[i];
                    break;
                }
            }
        }
        [weakSelf.payTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)addSettlement{
     __weak __typeof(self)weakSelf = self;
    
    if (!self.defaultAddressData) {
        [HLYHUD showHUDWithMessage:@"请先选择地址" addToView:nil];
        return;
    }
    
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/addSettlement";
    NSDictionary *params = @{@"oids":self.order_ids,@"address_id":self.defaultAddressData[@"uuid"],@"info":@""};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.payInfoDic = dict[@"data"];
        [weakSelf goToAliPay];
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
                CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"支付成功!" OkButton:@"确认"];
                [alerView show:self.view];
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
        CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"支付成功!" OkButton:@"确认"];
        alerView.delegate = self;
        [alerView show:self.view];
    }else{
        [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
        [self pushToOrderView];
    }
}
-(void)pushToOrderView{
    
    MyOrderViewController *vc = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark CTAlertViewDelegate
-(void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index{
    
    if (index == 200) {
        for(UIViewController *controller in self.navigationController.viewControllers) {
            if([controller isKindOfClass:[MineViewController class]]){
                MineViewController *vc = (MineViewController *)controller;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return self.productArray.count;
    }else if (section == 2){
        return 5;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 5;
    }
    return 28;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat backHegiht = 28;
    if (section == 2) {
        backHegiht = 5;
    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH,backHegiht);
    backView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    if (section != 2) {
        UILabel *sectionLabel = [self createLabelWithColor:@"585757" font:13];
        sectionLabel.text = self.sectionArray[section];
        [backView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(15);
            make.centerY.equalTo(backView.mas_centerY);
        }];
    }
    
    return backView;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        return 104;
    }else if (indexPath.section == 1){
        return 103;
    }else if (indexPath.section == 2){
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 0;
        }
    }else if (indexPath.section == 3){
        return 50;
    }else if (indexPath.section == 4){
        return 50;
    }
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    if (indexPath.section == 0) {//addressCell
        PayAddressTableViewCell *cell = [[PayAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCellWithData:self.defaultAddressData];
        cell.editCallBack = ^{
            ManageAddressViewController *vc = [[ManageAddressViewController alloc] init];
            vc.isNeedSelect = YES;
            vc.selectCallBack = ^(NSDictionary *addressData) {
                weakSelf.defaultAddressData = addressData;
                [weakSelf.payTableView reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.section == 1){
        ShopCartTableViewCell *cell = [[ShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:prodcutCell];
        cell.allowsSwipeWhenTappingButtons = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectBtn.hidden = YES;
        cell.editBtn.hidden = YES;
        [cell updateCellUI];
        [cell configureCellWithData:self.productArray[indexPath.row]];
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureCell:cell andIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configurePayWayCell:cell andIndexPath:indexPath];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureConfirmCell:cell andIndexPath:indexPath];
        return cell;
    }
  
}
/**
 * infoCell
 */
-(void)configureCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    UILabel *leftLabel = [self createLabelWithColor:@"000000" font:15];
    leftLabel.text = self.infoArray[indexPath.row];
    [cell.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(24);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [cell.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.size.height.mas_equalTo(1);
    }];
    
    
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITextField *telTF = [[UITextField alloc] init];
        telTF.placeholder = indexPath.row == 0 ? @"您可在此写下备注，不超过350个字" : @"输入代金券号码";
        telTF.textColor = [UIColor colorWithHexString:@"585757"];
        telTF.delegate = self;
        telTF.textAlignment = NSTextAlignmentLeft;
        telTF.tag = TF_TAG + indexPath.row;
        [cell.contentView addSubview:telTF];
        [telTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(24 + 40 + 21);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
        }];
        telTF.font = [UIFont systemFontOfSize:12];
        [telTF setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        [telTF setValue:[UIColor colorWithHexString:@"9fa0a0"] forKeyPath:@"_placeholderLabel.textColor"];
        if (indexPath.row == 2) {
             cell.hidden = YES;
            UIButton *actionBtn = [self createBtnWithColor:@"ffffff" font:15];
            [actionBtn setTitle:@"激活" forState:UIControlStateNormal];
            actionBtn.backgroundColor = [UIColor colorWithHexString:@"16a6ae"];
            [cell.contentView addSubview:actionBtn];
            [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(76, 24));
            }];
        }
    }else if (indexPath.row == 1 || indexPath.row == 3){
        //rightIcon
//        UIImageView *rightImgView = [[UIImageView alloc] init];
//        rightImgView.image = [UIImage imageNamed:@"rightIcon"];
//        [cell.contentView addSubview:rightImgView];
//        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(cell.contentView.mas_right).offset(-15);
//            make.centerY.equalTo(cell.contentView.mas_centerY);
//        }];
        
        
        UILabel *rightLabel = [self createLabelWithColor:@"585757" font:12];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.text = @"全场包邮";
        [cell.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        if (indexPath.row == 1) {
             cell.hidden = YES;
            rightLabel.textColor = [UIColor colorWithHexString:@"f40807"];
            rightLabel.text = @"满减活动减免：-30.00";
        }
    }else{
        segView.hidden = YES;
        UILabel *rightLabel = [self createLabelWithColor:@"595757" font:13];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.attributedText = [self setInfoCellTotalPriceTextAttribute:[NSString stringWithFormat:@"%ld",(long)self.totalNums] andPrice:[NSString stringWithFormat:@"%.2f",self.totalPrice]];
        [cell.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
    
}
-(void)configurePayWayCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    self.aliSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aliSelectBtn setImage:[UIImage imageNamed:@"shopUnSelect"] forState:UIControlStateNormal];
    [self.aliSelectBtn setImage:[UIImage imageNamed:@"shopSelect"] forState:UIControlStateSelected];
    self.aliSelectBtn.selected = YES;
    [cell.contentView addSubview:self.aliSelectBtn];
    [self.aliSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.left.equalTo(cell.contentView.mas_left).offset(24);
    }];
    [self.aliSelectBtn bk_addEventHandler:^(id sender) {
       // weakSelf.aliSelectBtn.selected = !weakSelf.aliSelectBtn.selected;
        weakSelf.wxSelectBtn.selected = NO;
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *aliImgView = [[UIImageView alloc] init];
    aliImgView.image = [UIImage imageNamed:@"zfb"];
    [cell.contentView addSubview:aliImgView];
    [aliImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.left.equalTo(self.aliSelectBtn.mas_right).offset(19);
    }];
    
//    self.wxSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.wxSelectBtn setImage:[UIImage imageNamed:@"shopUnSelect"] forState:UIControlStateNormal];
//    [self.wxSelectBtn setImage:[UIImage imageNamed:@"shopSelect"] forState:UIControlStateSelected];
//    [cell.contentView addSubview:self.wxSelectBtn];
//    [self.wxSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(cell.contentView.mas_centerY);
//        make.left.equalTo(aliImgView.mas_right).offset(43);
//    }];
//    [self.wxSelectBtn bk_addEventHandler:^(id sender) {
//        weakSelf.wxSelectBtn.selected = !weakSelf.wxSelectBtn.selected;
//        weakSelf.aliSelectBtn.selected = NO;
//    } forControlEvents:UIControlEventTouchUpInside];
//
//    UIImageView *wxImgView = [[UIImageView alloc] init];
//    wxImgView.image = [UIImage imageNamed:@"wx"];
//    [cell.contentView addSubview:wxImgView];
//    [wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(cell.contentView.mas_centerY);
//        make.left.equalTo(self.wxSelectBtn.mas_right).offset(19);
//    }];
//
    
}
-(void)configureConfirmCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{

    self.addressLabel = [self createLabelWithColor:@"000000" font:11];
    self.addressLabel.text =[NSString stringWithFormat:@"寄送到：%@",self.defaultAddressData[@"details"]];//@"四川成都高新区天府软件园E区6栋";
    [cell.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView.mas_centerY).offset(-1);
        make.left.equalTo(cell.contentView.mas_left).offset(24);
    }];
    
    self.peopleInfoLabel = [self createLabelWithColor:@"000000" font:11];
    self.peopleInfoLabel.text = [NSString stringWithFormat:@"收件人：%@，%@",self.defaultAddressData[@"name"],self.defaultAddressData[@"phone"]];//@"阿萨德,13980187654";
    [cell.contentView addSubview:self.peopleInfoLabel];
    [self.peopleInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_centerY).offset(1);
        make.left.equalTo(cell.contentView.mas_left).offset(24);
    }];
}
- (NSAttributedString *) setInfoCellTotalPriceTextAttribute:(NSString *)countStr andPrice:(NSString *)priceStr{
    
    NSString *firstStr = [NSString stringWithFormat:@"共 %@件 商品  小计：",countStr];
    
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:firstStr attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSString *endStr = [NSString stringWithFormat:@"￥%@",priceStr];
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:endStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"f10605"],NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldItalicMT" size:13]}];
    [priceAttribute appendAttributedString:endAttribute];
    
    return priceAttribute;
    
}
- (NSAttributedString *) setTotalPriceTextAttribute:(NSString *)peoStr
{
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:@"合计金额：" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:peoStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"f10605"],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:17]}];
    [priceAttribute appendAttributedString:endAttribute];
    
    return priceAttribute;
    
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
-(NSMutableArray *)productArray{
    
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}
@end
