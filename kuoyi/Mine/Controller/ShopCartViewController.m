//
//  ShopCartViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ShopCartViewController.h"
#import <MGSwipeTableCell.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import "ShopCartTableViewCell.h"
#import <BlocksKit+UIKit.h>
#import "PayOrderViewController.h"
#import "KYNetService.h"
#import "HLYHUD.h"


#define BUTTON_TAG 2000
static NSString * CELLID = @"shopCell";
@interface ShopCartViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *delAllBtn;

@property (nonatomic, strong) UITableView *shopTableView;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *allSelectBtn;
@property (nonatomic, strong) UILabel *allSelectLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIButton *payBtn;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, assign) BOOL isShowAll;

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) CGFloat totalDiscount;
@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShowAll = NO;
    [self setNavigation];
    [self p_initUI];
//    for (int i = 0; i < 20; i++) {
//        int ranX = arc4random() % 100 + 10;
//        int disX = arc4random() % 10;
//        NSString *price = [NSString stringWithFormat:@"%d",ranX];
//        NSString *dis = [NSString stringWithFormat:@"%d",disX];
//        NSDictionary *data = @{@"price":price,@"discount":dis};
//        [self.dataArray addObject:data];
//    }
    [self getShopCarListRequest];
   
}

-(void)setNavigation{
    __weak __typeof(self)weakSelf = self;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"购物车";
    //right
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 30, 20);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"17a7af"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightBtn bk_addEventHandler:^(id sender) {
        self.isShowAll = !self.isShowAll;
        [weakSelf showhideDelAllBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}


-(void)p_initUI{
       __weak __typeof(self)weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    self.topView = [[UIView alloc] init];
    self.topView.alpha = 0;
    self.topView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.size.height.mas_equalTo(0);
    }];
    
    //287
    self.delAllBtn = [self createBtnWithColor:@"17a7af" font:15];
    [self.delAllBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    self.delAllBtn.layer.cornerRadius = 4;
    self.delAllBtn.layer.masksToBounds = YES;
    self.delAllBtn.layer.borderColor = [UIColor colorWithHexString:@"17a7af"].CGColor;
    self.delAllBtn.layer.borderWidth = 1;
    [self.topView addSubview:self.delAllBtn];
    [self.delAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(95, 24));
    }];
    [self.delAllBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.dataArray.count > 0) {
             [weakSelf deleteShopCar:YES andIndexPath:nil];
        }else{
            [HLYHUD showHUDWithMessage:@"暂无商品删除！" addToView:nil];
        }
       
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
    [self.view addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.size.height.mas_equalTo(55);
    }];
    self.allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allSelectBtn setImage:[UIImage imageNamed:@"shopUnSelect"] forState:UIControlStateNormal];
    [self.allSelectBtn setImage:[UIImage imageNamed:@"shopSelect"] forState:UIControlStateSelected];
    [self.botView addSubview:self.allSelectBtn];
    [self.allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(self.botView.mas_left).offset(14);
    }];
    [self.allSelectBtn bk_addEventHandler:^(id sender) {
    
        [weakSelf a_selectButtonAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.allSelectLabel = [self createLabelWithColor:@"000000" font:15];
    self.allSelectLabel.text = @"全选";
    [self.botView addSubview:self.allSelectLabel];
    [self.allSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(self.allSelectBtn.mas_right).offset(10);
    }];
    
    self.payBtn = [self createBtnWithColor:@"ffffff" font:16];
    self.payBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    self.payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.payBtn setTitle:@"立刻结算" forState:UIControlStateNormal];
    [self.botView addSubview:self.payBtn];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.width.mas_equalTo(DEVICE_WIDTH * 0.23);
        make.top.bottom.right.equalTo(self.botView);
    }];
    [self.payBtn bk_addEventHandler:^(id sender) {
        [weakSelf goToPay];
    } forControlEvents:UIControlEventTouchUpInside];
    self.totalPriceLabel = [self createLabelWithColor:@"000000" font:17];
    self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
    self.totalPriceLabel.attributedText = [self setTotalPriceTextAttribute:@"￥0"];
    [self.botView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.right.equalTo(self.payBtn.mas_left).offset(-10);
    }];
    
    self.discountLabel = [self createLabelWithColor:@"16a5af" font:9];
    self.discountLabel.textAlignment = NSTextAlignmentRight;
    self.discountLabel.text = @"为您节省 ￥0";//Helvetica-Oblique
    self.discountLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:9];
    [self.botView addSubview:self.discountLabel];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPriceLabel.mas_bottom).offset(2);
        make.right.equalTo(self.totalPriceLabel.mas_right);
    }];

    
    self.shopTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.shopTableView.delegate         = self;
    self.shopTableView.dataSource       = self;
    self.shopTableView.rowHeight = 103;
    self.shopTableView.bounces = NO;
    self.shopTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.shopTableView.showsVerticalScrollIndicator = NO;
    self.shopTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.shopTableView];
    [self.shopTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
}

-(void)getShopCarListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.cart/getList";
    NSDictionary *params = @{@"page":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = dict[@"data"];
        [weakSelf.shopTableView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}


-(void)deleteShopCar:(BOOL)isDelAll andIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.cart/dele";
    NSDictionary *params;
    if (isDelAll) {
        NSMutableString *idsStr = [[NSMutableString alloc] init];
        for (int i = 0 ; i < self.dataArray.count; i++) {
            NSDictionary *shopData = self.dataArray[i];
            if (i != self.dataArray.count - 1) {
                 [idsStr appendString:[NSString stringWithFormat:@"%@,",shopData[@"uuid"]]];//
            }else{
                 [idsStr appendString:[NSString stringWithFormat:@"%@",shopData[@"uuid"]]];//
            }
           
        }
        params = @{@"ids":idsStr};
    }else{
        params = @{@"ids":self.dataArray[indexPath.row][@"uuid"]};
    }
 
   
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"删除成功" addToView:nil];
        if (isDelAll) {
             [weakSelf.dataArray removeAllObjects];
        }else{
           [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        }
       
        [weakSelf.shopTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];

}

-(void)updateCountRequest:(NSIndexPath *)indexPath andCount:(NSInteger)count{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.cart/upNumber";
    NSDictionary *params = @{@"cart_id":self.dataArray[indexPath.row][@"uuid"],@"number":@(count)};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
      //  [weakSelf.shopTableView reloadData];
        [self getShopCarListRequest];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        //[HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)showhideDelAllBtn{
    
    
    [self moveAnimation:self.isShowAll];
    
}
- (void)moveAnimation:(BOOL)isShow{
    
    if (!isShow) {
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
            make.size.height.mas_equalTo(0);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.alpha = 0;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
            make.size.height.mas_equalTo(52);
        }];
        [UIView animateWithDuration:0.3 animations:^{
    
            self.topView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    
    
}
- (NSAttributedString *) setTotalPriceTextAttribute:(NSString *)peoStr
{
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:@"小计：" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:peoStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"f10605"],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Oblique" size:17]}];
    [priceAttribute appendAttributedString:endAttribute];
    
    return priceAttribute;
    
}

-(void)goToPay{
    
    if (self.selectArray.count > 0) {
        NSMutableString *idsStr = [[NSMutableString alloc] init];
        for (int i = 0 ; i < self.selectArray.count; i++) {
            if (i != self.selectArray.count - 1) {
                [idsStr appendString:[NSString stringWithFormat:@"%@,",self.selectArray[i]]];//
            }else{
                [idsStr appendString:[NSString stringWithFormat:@"%@",self.selectArray[i]]];//
            }
            
        }
        PayOrderViewController *vc = [[PayOrderViewController alloc] init];
        vc.order_ids = idsStr;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [HLYHUD showHUDWithMessage:@"请先选择物品" addToView:nil];
    }
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0 || self.dataArray == nil) {
        
        tableView.backgroundView = [self emptyTableViewOfBackgroundView];
        return 0;
    } else {
        tableView.backgroundView = nil;
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    ShopCartTableViewCell *cell = [[ShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    cell.selectBtn.tag = BUTTON_TAG + indexPath.row;
    [cell configureCellWithData:self.dataArray[indexPath.row]];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"talk_delete"] backgroundColor:[UIColor colorWithHexString:@"fb217d"] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        
        [weakSelf deleteShopCar:NO andIndexPath:indexPath];
        
//        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
       // [tableView reloadData];
        return YES;
    }]];
    cell.selectCallBack = ^(BOOL isSelect) {
         [weakSelf a_singleSelectAction:indexPath.row isSelect:isSelect];
    };
    cell.addCountCallBack = ^(NSInteger count) {
        [weakSelf updateCountRequest:indexPath andCount:count];
    };
    return cell;
    
    
    
}
-(void)a_singleSelectAction:(NSInteger)index isSelect:(BOOL)isSelect{
     CGFloat productPrice = [self.dataArray[index][@"goods_price"] doubleValue] * [self.dataArray[index][@"goods_num"] doubleValue];
    NSString *uuid = self.dataArray[index][@"uuid"];
    CGFloat dis = 0;//[self.dataArray[index][@"goods_num"] doubleValue];
    if (isSelect) {
        self.totalPrice = self.totalPrice + productPrice;
        self.totalDiscount =  self.totalDiscount + dis;
        [self.selectArray addObject:uuid];
    }else{
        self.totalPrice = self.totalPrice - productPrice;
        self.totalDiscount =  self.totalDiscount - dis;
        [self.selectArray removeObject:uuid];
    }
    [self p_setLabelText];
}
- (void)a_selectButtonAction{
    self.allSelectBtn.selected = !self.allSelectBtn.selected;
    NSInteger count = [self.dataArray count];
    for (int i =0 ; i < count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:BUTTON_TAG + i];
        btn.selected = self.allSelectBtn.selected;
    }
    [self p_setTotalPrice];
}

- (void)p_setTotalPrice {
    //self.chooseArray = nil;
    if (self.allSelectBtn.selected) {
        self.totalPrice = 0;
        [self.selectArray removeAllObjects];
        //self.totalPrice = [[self.totalPriceArray valueForKeyPath:@"@sum.floatValue"] doubleValue];
        for (int i = 0 ; i < self.dataArray.count; i++) {
            CGFloat productPrice = [self.dataArray[i][@"goods_price"] doubleValue] * [self.dataArray[i][@"goods_num"] integerValue];
            CGFloat dis = 0;//[self.dataArray[i][@"goods_num"] doubleValue];
            self.totalPrice = self.totalPrice + productPrice;
            self.totalDiscount =  self.totalDiscount + dis;
            NSString *uuid = self.dataArray[i][@"uuid"];
            [self.selectArray addObject:uuid];
        }
    }else {
        self.totalPrice = 0;
        self.totalDiscount = 0;
        [self.selectArray removeAllObjects];
    }
    [self p_setLabelText];
}
-(void)p_setLabelText{
    
    self.totalPriceLabel.attributedText = [self setTotalPriceTextAttribute:[NSString stringWithFormat:@"￥%.2f",self.totalPrice]];
    self.discountLabel.text = [NSString stringWithFormat:@"为您节省 %.2f",self.totalDiscount];
    
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
-(NSMutableArray *)selectArray{

    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    
    return _selectArray;
    
}
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.shopTableView.frame];
    //    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lion"]];
    //    [backView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"暂无结果~";
    label.textColor = [UIColor tp_lightGaryTextColor];
    [backView addSubview:label];
    
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(backView.mas_centerX);
    //        make.centerY.equalTo(backView.mas_centerY);
    //    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(backView.mas_centerX);
        //        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.center.equalTo(backView);
    }];
    
    return backView;
}
@end
