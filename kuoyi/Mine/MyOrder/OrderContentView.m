//
//  OrderContentView.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/10.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "OrderContentView.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "OrderTableViewCell.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "CTAlertView.h"
#import "PayOrderTool.h"
#import "NotificationMacro.h"
#import <MGSwipeTableCell.h>

static NSString *CELLID = @"orderCell";
@interface OrderContentView()<UITableViewDelegate,UITableViewDataSource,CTAlertViewDelegate>

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, assign) OrderType orderType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *productArray;

@property (nonatomic, strong) NSArray *typeNameArray;

@end

@implementation OrderContentView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGetOrder object:nil];
}
- (instancetype)initWithOrderType:(OrderType)orderType{
    
    self = [super init];
    if (self) {
        self.typeNameArray = @[@"",@"未付款",@"",@"",@"未发货",@"已发货",@"已完成"];
//        for (int i = 0; i < 2; i++) {
//            int ranX = arc4random() % 100 + 10;
//            int disX = arc4random() % 10;
//            NSString *price = [NSString stringWithFormat:@"%d",ranX];
//            NSString *dis = [NSString stringWithFormat:@"%d",disX];
//            NSDictionary *data = @{@"price":price,@"discount":dis};
//            [self.productArray addObject:data];
//        }
//        NSDictionary *infoData = @{@"orderNumber":@"12312312313",@"statusText":@"未发货",@"price":@"300.00",@"product":self.productArray};
//        for (int i = 0; i < 5; i++) {
//            [self.dataArray addObject:infoData];
//        }
        self.orderType = orderType;
        [self p_initUI];
        [self getMyOrderListRequest];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyOrderListRequest) name:kNotificationGetOrder object:nil];
    }
    
    return self;
}


-(void)p_initUI{
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.contentTableView.delegate         = self;
    self.contentTableView.dataSource       = self;
    self.contentTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.contentTableView.showsVerticalScrollIndicator = NO;
    self.contentTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

-(void)getMyOrderListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/getOrderList";
    NSDictionary *params = @{@"page":@"1",@"class":@(BookAndGoods),@"state":@(self.orderType)};
    
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = [dict[@"data"][@"data"] mutableCopy];
        [weakSelf.contentTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];

}

-(void)addOrderRequest:(NSString *)order_on{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/aliPay";
    NSDictionary *params = @{@"orderNo":order_on};
    
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [PayOrderTool goToAliPay:dict[@"data"]];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)deleteOrder:(NSString *)order_on andType:(NSString *)type andSection:(NSInteger)section{
    //v1.order/confirmCollectGoods
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/delOrder";
    NSDictionary *params = @{@"on":order_on,@"type":type};//order_class
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict){
        [HLYHUD hideAllHUDsForView:nil];
        [weakSelf.dataArray removeObjectAtIndex:section];
        [HLYHUD showHUDWithMessage:@"删除成功！" addToView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetOrder object:nil];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)confirmOrder:(NSString *)order_on{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/confirmCollectGoods";
    NSDictionary *params = @{@"orderOn":order_on};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict){
        [HLYHUD hideAllHUDsForView:nil];
        //[weakSelf getMyOrderListRequest];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetOrder object:nil];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
-(void)refundOrder:(NSString *)order_on{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/refund";
    NSDictionary *params = @{@"orderOn":order_on};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict){
        [HLYHUD hideAllHUDsForView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetOrder object:nil];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section][@"order_list"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30+34;
    }
    return 34;//71
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __weak __typeof(self)weakSelf = self;
    CGFloat sectionHeight = 34;
    if (section == 0) {
        sectionHeight = 64;
    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH,sectionHeight);
    backView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    if (section == 0) {
        UILabel *serviceLabel = [self createLabelWithColor:@"16a6ae" font:12];
        serviceLabel.textAlignment = NSTextAlignmentRight;
        serviceLabel.text = [NSString stringWithFormat:@"如有疑问，请拨打客服电话：%@",serviceTel];
        serviceLabel.backgroundColor = [UIColor clearColor];
        [backView addSubview:serviceLabel];
        [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.height.mas_equalTo(30);
            make.left.equalTo(backView.mas_left).offset(15);
            make.right.equalTo(backView.mas_right).offset(-15);
            make.top.equalTo(backView.mas_top).offset(0);
        }];
        serviceLabel.userInteractionEnabled = YES;
        [serviceLabel bk_whenTapped:^{
            [weakSelf callKFteL];
        }];
    }
    UIView *botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [backView addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backView);
        make.size.height.mas_equalTo(34);
    }];
    
    UILabel *sectionLabel = [self createLabelWithColor:@"000000" font:10];
    sectionLabel.text = [NSString stringWithFormat:@"订单号：%@",self.dataArray[section][@"order_on"]];
    [botView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.bottom.equalTo(backView.mas_bottom).offset(-6);
    }];
    
    UILabel *rightLabel = [self createLabelWithColor:@"f20706" font:10];
    rightLabel.text = [NSString stringWithFormat:@"%@",self.typeNameArray[self.orderType]];
    [botView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.bottom.equalTo(backView.mas_bottom).offset(-6);
    }];
    
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    OrderTypeAll = 0, //全部
//    OrderTypeWaitPay = 1,      //待支付
//    OrderTypeWaitSend = 2, //未发货
//    OrderTypeReceive = 3,    //确认收货
//    OrderTypeFinish = 4    //已完成
   // if (self.orderType != OrderTypeAll) {
        return 71;
    //}
    //return 34;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    __weak __typeof(self)weakSelf = self;
    //goods_num  goods_allprice
//    CGFloat backHegiht = 34;
//    if (self.orderType != OrderTypeAll) {
       CGFloat backHegiht = 71;
//    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH,backHegiht);
    backView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    NSInteger totalGoodsNum = 0;
    NSInteger totalGoodsPrice = 0;
    NSArray *totalArray = self.dataArray[section][@"order_list"];
    if (totalArray.count > 0) {
        for (NSDictionary *singleData in totalArray) {
            if (singleData[@"goods_num"]) {
                totalGoodsNum = totalGoodsNum + [singleData[@"goods_num"] integerValue];
            }
            if (singleData[@"goods_allprice"]) {
                totalGoodsPrice = totalGoodsPrice + [singleData[@"goods_allprice"] integerValue];
            }
        }
    }
    UILabel *rightLabel = [self createLabelWithColor:@"585757" font:13];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.attributedText = [self setInfoCellTotalPriceTextAttribute:[NSString stringWithFormat:@"%ld",(long)totalGoodsNum] andPrice:[NSString stringWithFormat:@"%ld",(long)totalGoodsPrice]];
    [backView addSubview:rightLabel];
    //if (self.orderType != OrderTypeAll) {
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-15);
            make.top.equalTo(backView.mas_top).offset(11);
        }];
        NSString *rightStr;
        NSString *colorStr = @"fb217d";
        NSString *titleColor = @"ffffff";
        OrderType orderState = OrderTypeAll;
        if (self.orderType == OrderTypeAll){
            orderState = [self.dataArray[section][@"state"] integerValue];
        }
    
        if (self.orderType == OrderTypeWaitPay || orderState == OrderTypeWaitPay) {
            rightStr = @"去付款";
        }else if (self.orderType == OrderTypeWaitSend || orderState == OrderTypeWaitSend){
            rightStr = @"未发货";
            colorStr = @"e8e3e4";
            titleColor = @"8d757d";
        }else if (self.orderType == OrderTypeSend || orderState == OrderTypeSend){
            rightStr = @"确认收货";
        }else if (self.orderType == OrderTypeConfirm || orderState >= OrderTypeConfirm){
            rightStr = @"已完成";
            titleColor = @"8d757d";
            colorStr = @"e8e3e4";
        }
        
        UIButton *rightBtn = [self createBtnWithColor:titleColor font:13];
        [rightBtn setTitle:rightStr forState:UIControlStateNormal];
        rightBtn.layer.cornerRadius = 2;
        rightBtn.backgroundColor = [UIColor colorWithHexString:colorStr];
        [backView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-15);
            make.top.equalTo(rightLabel.mas_bottom).offset(11);
            make.size.mas_equalTo(CGSizeMake(100, 28));
        }];
        [rightBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.orderType == OrderTypeWaitPay || orderState == OrderTypeWaitPay) {
                [weakSelf addOrderRequest:self.dataArray[section][@"order_on"]];
            }else if (weakSelf.orderType == OrderTypeSend || orderState == OrderTypeSend){
                [weakSelf confirmOrder:self.dataArray[section][@"order_on"]];
            }
            else{
                NSLog(@"123123");
            }
        } forControlEvents:UIControlEventTouchUpInside];
        if (self.orderType == OrderTypeWaitPay || self.orderType == OrderTypeConfirm || orderState == OrderTypeWaitPay || orderState >= OrderTypeConfirm){
            UIButton *delBtn = [self createBtnWithColor:@"16a5af" font:13];
            delBtn.backgroundColor = [UIColor clearColor];
            delBtn.layer.cornerRadius = 2;
            [delBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            delBtn.layer.borderColor = [UIColor colorWithHexString:@"16a5af"].CGColor;
            delBtn.layer.borderWidth = 1;
            [backView addSubview:delBtn];
            [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(rightBtn.mas_left).offset(-10);
                make.top.equalTo(rightLabel.mas_bottom).offset(11);
                make.size.mas_equalTo(CGSizeMake(100, 28));
            }];
            [delBtn bk_addEventHandler:^(id sender) {
                [CTAlertView showAlertViewWithTitle:@"" Details:@"确认要删除订单吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                       [weakSelf deleteOrder:self.dataArray[section][@"order_on"] andType:self.dataArray[section][@"order_list"][0][@"order_class"] andSection:section];
                    }
                }];
                
            } forControlEvents:UIControlEventTouchUpInside];
            if (self.orderType == OrderTypeConfirm || orderState >= OrderTypeConfirm) {
                OrderType confirmState =  [self.dataArray[section][@"state"] integerValue];
                NSString *refundStr = @"";
                if (confirmState == OrderTypeConfirm) {
                    refundStr = @"申请退款";
                }else if (confirmState == OrderTypeRefunding){
                    refundStr = @"退款申请中";
                }else if (confirmState == OrderTypeRefunded){
                    refundStr = @"退款完成";
                }else if (confirmState == OrderTypeRefundChecked){
                    refundStr = @"退款审核通过";
                }else if (confirmState == OrderTypeRefundReject){
                    refundStr = @"拒绝退款";
                }
                
                UIButton *refundBtn = [self createBtnWithColor:@"595858" font:11];
                refundBtn.backgroundColor = [UIColor clearColor];
                [refundBtn setTitle:refundStr forState:UIControlStateNormal];
                refundBtn.enabled = confirmState == OrderTypeConfirm ? YES:NO;
                //refundBtn.layer.borderColor = [UIColor colorWithHexString:@"595858"].CGColor;
                //refundBtn.layer.borderWidth = 1;
                [backView addSubview:refundBtn];
                [refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(backView.mas_left).offset(15);
                    make.centerY.equalTo(rightBtn.mas_centerY);
//                    make.size.mas_equalTo(CGSizeMake(100, 28));
                }];
                [refundBtn bk_addEventHandler:^(id sender) {
                    [CTAlertView showAlertViewWithTitle:@"" Details:@"确认要申请退款吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakSelf refundOrder:self.dataArray[section][@"order_on"]];
                        }
                    }];
                    
                } forControlEvents:UIControlEventTouchUpInside];
            }
        }else if (self.orderType == OrderTypeSend || orderState == OrderTypeSend){
            //kuaidi_on
            UILabel *kdLabel = [self createLabelWithColor:@"585757" font:13];
            kdLabel.text = [NSString stringWithFormat:@"中通快递：%@",self.dataArray[section][@"kuaidi_on"]];
            [backView addSubview:kdLabel];
            [kdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backView.mas_left).offset(10);
                make.centerY.equalTo(rightLabel.mas_centerY);
                make.right.equalTo(rightLabel.mas_left).offset(-10);
            }];
        }
       
        
//    }else{
//        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(backView.mas_right).offset(-15);
//            make.centerY.equalTo(backView.mas_centerY);
//        }];
//    }
    
    return backView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 103;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *data = self.dataArray[indexPath.section][@"order_list"][indexPath.row];
    OrderTableViewCell *cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithData:data];
    // [weakSelf deleteOrder:weakSelf.dataArray[indexPath.section][@"order_on"]];
    return cell;
   
    
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
- (NSAttributedString *) setInfoCellTotalPriceTextAttribute:(NSString *)countStr andPrice:(NSString *)priceStr{
    
    NSString *firstStr = [NSString stringWithFormat:@"共%@件商品  小计：",countStr];
    
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:firstStr attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSString *endStr = [NSString stringWithFormat:@"￥%@",priceStr];
    
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:endStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"f10605"],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:13]}];
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
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)productArray{
    
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}
@end
