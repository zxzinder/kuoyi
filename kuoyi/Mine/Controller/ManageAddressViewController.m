//
//  ManageAddressViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ManageAddressViewController.h"
#import <MGSwipeTableCell.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import "ManageAddressTableViewCell.h"
#import <BlocksKit+UIKit.h>
#import "WriteAddressViewController.h"
#import "KYNetService.h"
#import "HLYHUD.h"

static NSString * CELLID = @"addressCell";
@interface ManageAddressViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UITableView *addressTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 选中按钮
 */
@property (nonatomic, strong) UIButton *setTypeButton;



@end

@implementation ManageAddressViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getAddressListRequest];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"地址管理";
    // Do any additional setup after loading the view.
    [self p_initUI];
//    for (int i = 0; i < 3; i++) {
//        int ranX = arc4random() % 100 + 10;
//        int disX = arc4random() % 10;
//        NSString *price = [NSString stringWithFormat:@"%d",ranX];
//        NSString *dis = [NSString stringWithFormat:@"%d",disX];
//        NSDictionary *data = @{@"price":price,@"discount":dis};
//        [self.dataArray addObject:data];
//    }
    
}

-(void)p_initUI{
      __weak __typeof(self)weakSelf = self;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    self.addBtn = [self createBtnWithColor:@"ffffff" font:16];//0.82
    self.addBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 5;
    [self.addBtn setTitle:@"新增常用收货地址" forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH * 0.82, 43));
    }];
    [self.addBtn bk_addEventHandler:^(id sender) {
        WriteAddressViewController *vc = [[WriteAddressViewController alloc] init];
        vc.title = @"新增收货地址";
        vc.addressData = nil;
        vc.isEdit = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.addressTableView.delegate         = self;
    self.addressTableView.dataSource       = self;
    self.addressTableView.rowHeight        = 127;
    self.addressTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.addressTableView.showsVerticalScrollIndicator = NO;
    self.addressTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.addressTableView];
    [self.addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.bottom.equalTo(self.addBtn.mas_top).offset(-14);
    }];
    
    
    
}


-(void)getAddressListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.address/getListAddress";
    NSDictionary *params = @{@"page":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = dict[@"data"][@"data"];
        [weakSelf.addressTableView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}

-(void)deleteAddressRequest:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.address/del";
    NSDictionary *params = @{@"address_ids":self.dataArray[indexPath.section][@"id"]};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"删除成功" addToView:nil];
        [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
        [weakSelf.addressTableView reloadData];
//        [weakSelf.addressTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dataArray.count == 0 || self.dataArray == nil) {
        
        tableView.backgroundView = [self emptyTableViewOfBackgroundView];
        return 0;
    } else {
        tableView.backgroundView = nil;
        return self.dataArray.count;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    

    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 5);
    backView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    return backView;

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    ManageAddressTableViewCell *cell = [[ManageAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithData:self.dataArray[indexPath.section]];
    cell.selectCallBack = ^(UIButton *btn) {
        [weakSelf setTypeBtn:btn];
    };
    cell.editCallBack = ^{
        WriteAddressViewController *vc = [[WriteAddressViewController alloc] init];
        vc.addressData = self.dataArray[indexPath.section];
        vc.title = @"编辑收货地址";
         vc.isEdit = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"talk_delete"] backgroundColor:[UIColor colorWithHexString:@"fb217d"] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
//        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        // [tableView reloadData];
        [weakSelf deleteAddressRequest:indexPath];
        return YES;
    }]];
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isNeedSelect) {
        if (self.selectCallBack) {
            self.selectCallBack(self.dataArray[indexPath.section]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
// 选中按钮
- (void)setTypeBtn:(UIButton *)btn
{
    if ([self.setTypeButton isEqual:btn]) {
        btn.selected = NO;
        self.setTypeButton = nil;
    }else{
        self.setTypeButton.selected = NO;
        btn.selected = YES;
        self.setTypeButton = btn;
    }
    
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
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.addressTableView.frame];
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
