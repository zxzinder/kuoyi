//
//  MyOrderViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/10.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MyOrderViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "ShopCartTableViewCell.h"
#import "OrderTableViewCell.h"
#import "OrderContentView.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "PayOrderTool.h"
#import "NotificationMacro.h"
#import "CTAlertView.h"
#import "MineViewController.h"


#define BUTTON_TAG 10000
#define titleHeight 38
@interface MyOrderViewController ()<UIScrollViewDelegate,CTAlertViewDelegate>

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UILabel *serviceLabel;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView *topView;

@property (strong, nonatomic) UIScrollView *contentScrollView;

/**
 选中按钮
 */
@property (nonatomic, weak) UIButton *setTitleButton;

@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) NSMutableArray *btnsArray;


@end

@implementation MyOrderViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPayInfoCallBack object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigatin];
    self.titleArray = @[@"全部",@"未付款",@"未发货",@"确认收货",@"已完成"];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"我的订单";
    [self p_initUI];
    [self addChildView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayCallback:) name:kNotificationPayInfoCallBack object:nil];
}
-(void)setNavigatin{
    __weak typeof(self) weakSelf = self;
    //left
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 20, 20);
    self.leftBtn.backgroundColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"navgation_back"] forState:UIControlStateNormal];
    [self.leftBtn bk_addEventHandler:^(id sender) {
        
        for(UIViewController *controller in weakSelf.navigationController.viewControllers) {
            if([controller isKindOfClass:[MineViewController class]]){
                MineViewController *vc = (MineViewController *)controller;
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
}
-(void)p_initUI{
    __weak __typeof(self)weakSelf = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
//
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    //
  
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.size.height.mas_equalTo(titleHeight);
    }];
    //NSMutableArray *btnsArray = [NSMutableArray array];
    for (int i = 0 ; i < self.titleArray.count; i++) {
        UIButton *btn = [self createBtnWithColor:@"000000" font:12];
        btn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        btn.tag = BUTTON_TAG + i;
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        [self.btnsArray addObject:btn];
        if (i == 0) {
            [self setTypeBtn:btn];
        }
    }
    [self.btnsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.btnsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.mas_equalTo(titleHeight);
        make.bottom.equalTo(self.topView.mas_bottom);
    }];
    
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    
}
-(void)addChildView{
    
    CGFloat viewW = DEVICE_WIDTH;
    CGFloat viewH = 0;
    CGFloat viewY = 0;
    
    NSInteger count = self.titleArray.count;
    
    self.contentScrollView.contentSize = CGSizeMake(count * viewW, 0);
    __weak __typeof(self)weakSelf = self;
    for (int i=0; i< count ; i++) {
        CGFloat viewX = i * viewW;
        viewH = DEVICE_HEIGHT - titleHeight - statusBarAndNavigationBarHeight - 30;

        if (i==0) {
//
//            UIView *backView = [[UIView alloc] init];
//            backView.frame = CGRectMake(viewX, viewY, viewW, viewH);
//            backView.backgroundColor = [UIColor randomRGBColor];
//            [self.contentScrollView addSubview:backView];
//
            OrderContentView *ocView = [[OrderContentView alloc] initWithOrderType:OrderTypeAll];
            ocView.frame = CGRectMake(viewX, viewY, viewW, viewH);
            [self.contentScrollView addSubview:ocView];
        }else if (i==1) {
            
            OrderContentView *ocView = [[OrderContentView alloc] initWithOrderType:OrderTypeWaitPay];
            ocView.frame = CGRectMake(viewX, viewY, viewW, viewH);
            [self.contentScrollView addSubview:ocView];
        }else if (i==2){
            OrderContentView *ocView = [[OrderContentView alloc] initWithOrderType:OrderTypeWaitSend];
            ocView.frame = CGRectMake(viewX, viewY, viewW, viewH);
            [self.contentScrollView addSubview:ocView];
        }else if (i == 3){
            OrderContentView *ocView = [[OrderContentView alloc] initWithOrderType:OrderTypeSend];
            ocView.frame = CGRectMake(viewX, viewY, viewW, viewH);
            [self.contentScrollView addSubview:ocView];
        }else{
            OrderContentView *ocView = [[OrderContentView alloc] initWithOrderType:OrderTypeConfirm];
            ocView.frame = CGRectMake(viewX, viewY, viewW, viewH);
            [self.contentScrollView addSubview:ocView];
        }
        
    }
    
}
// 选中按钮
- (void)setTypeBtn:(UIButton *)btn
{
    self.setTitleButton.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.setTitleButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    self.setTitleButton.transform = CGAffineTransformIdentity;
    
    btn.backgroundColor = [UIColor colorWithHexString:@"16a6ae"];
    [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(1, 1);
    self.setTitleButton = btn;
    
}

-(void)handlePayCallback:(NSNotification *) userinfo{
    NSDictionary *resultDic = userinfo.object[@"resultDic"];
    NSNumber *resultStatus = resultDic[@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"支付成功!" OkButton:@"确认"];
        alerView.delegate = self;
        [alerView show:nil];
    }else{
        [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
    }
}
-(void)callKFteL{
    
    [CTAlertView showAlertViewWithTitle:@"客服电话" Details:serviceTel CancelButton:@"取消" DoneButton:@"确认拨打" callBack:^(NSInteger buttonIndex){
        
        if (buttonIndex == 1) {
            if (iOS10) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",serviceTel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                    if(!success) return ;
                }];
            }else{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",serviceTel];
                //拨打电话
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }
        
    }];
    
}
#pragma mark CTAlertViewDelegate
-(void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index{
    
    if (index == 200) {
        //[self getMyOrderListRequest];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetOrder object:nil];
        UIButton *btn = (UIButton *)[self.view viewWithTag:BUTTON_TAG+2];
        [self titleBtnClick:btn];
    }
    
}
#pragma mark target
-(void)titleBtnClick:(UIButton *)btn{
    
    NSInteger tag = btn.tag - BUTTON_TAG;
    
    [self setTypeBtn:btn];
    
    CGFloat offX = tag * DEVICE_WIDTH;
    [self.contentScrollView setContentOffset:CGPointMake(offX, 0) animated:YES];
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
-(NSMutableArray *)btnsArray{
    
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
    
}
-(UIScrollView *)contentScrollView{
    
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.backgroundColor =  [UIColor colorWithHexString:@"e0e8eb"];
        _contentScrollView.contentSize = CGSizeMake(self.titleArray.count * DEVICE_WIDTH, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.scrollEnabled = NO;
    }
    return _contentScrollView;
}
@end
