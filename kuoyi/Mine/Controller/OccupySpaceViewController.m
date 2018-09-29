//
//  OccupySpaceViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "OccupySpaceViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "OCSpaceCollectionViewCell.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "CTAlertView.h"
#import "PayOrderTool.h"
#import "NotificationMacro.h"


static NSString *CELLID = @"spaceCell";
@interface OccupySpaceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CTAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *spaceCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation OccupySpaceViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPayInfoCallBack object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"占领空间";
    // Do any additional setup after loading the view.
    [self p_initUI];
    [self getMySpaceListRequest];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayCallback:) name:kNotificationPayInfoCallBack object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)p_initUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.spaceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.spaceCollectionView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    self.spaceCollectionView.showsHorizontalScrollIndicator = NO;
    self.spaceCollectionView.delegate = self;
    self.spaceCollectionView.dataSource =self;
    [self.view addSubview:self.spaceCollectionView];
    
    [self.spaceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.spaceCollectionView registerClass:[OCSpaceCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    
}

-(void)getMySpaceListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/getOrderList";
    NSDictionary *params = @{@"page":@"1",@"class":@(OrderSpace),@"state":@"0"};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = [dict[@"data"][@"data"] mutableCopy];
        [weakSelf.spaceCollectionView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)delMySpaceRequest:(NSString *)orderNum andIndex:(NSInteger)index{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/delOrder";
    NSDictionary *params = @{@"on":orderNum,@"type":@(OrderSpace)};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        [weakSelf.dataArray removeObjectAtIndex:index];
        [weakSelf.spaceCollectionView reloadData];
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
-(void)handlePayCallback:(NSNotification *) userinfo{
    NSDictionary *resultDic = userinfo.object[@"resultDic"];
    NSNumber *resultStatus = resultDic[@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"支付成功!" OkButton:@"确认"];
        alerView.delegate = self;
        [alerView show:self.view];
    }else{
        [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
    }
}
-(void)refundOrder:(NSString *)order_on{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.order/refund";
    NSDictionary *params = @{@"orderOn":order_on};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict){
        [HLYHUD hideAllHUDsForView:nil];
        [weakSelf getMySpaceListRequest];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
#pragma mark CTAlertViewDelegate
-(void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index{
    
    if (index == 200) {
        [self getMySpaceListRequest];
    }
    
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return 1;
    
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (self.dataArray.count == 0 || self.dataArray == nil) {
        
        collectionView.backgroundView = [self emptyTableViewOfBackgroundView];
        return 0;
    } else {
        collectionView.backgroundView = nil;
        return self.dataArray.count;
    }
    
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    NSDictionary *spaceData = self.dataArray[indexPath.row][@"order_list"][0];
    OCSpaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [cell configureData:spaceData];
    cell.cancelCollectCallBack = ^{
         if ([spaceData[@"state"] integerValue] == OrderTypeWaitPay || [spaceData[@"state"] integerValue] == OrderTypeFinished) {
            [CTAlertView showAlertViewWithTitle:@"" Details:@"确认删除吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakSelf delMySpaceRequest:weakSelf.dataArray[indexPath.row][@"order_on"] andIndex:indexPath.row];
                }
            }];
          }
        
    };
    cell.orderCallBack = ^{
        [weakSelf addOrderRequest:weakSelf.dataArray[indexPath.row][@"order_on"]];
    };
    cell.refundCallBack = ^{
        if ([spaceData[@"state"] integerValue] == OrderTypeWaitSend) {
            [CTAlertView showAlertViewWithTitle:@"" Details:@"确认要申请退款吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakSelf refundOrder:self.dataArray[indexPath.row][@"order_on"]];
                }
            }];
        }
    };
    return cell;
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

#pragma mark -- 每个collectionView大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = (DEVICE_WIDTH - 14 *2 - 18) / 2;
    CGFloat cellH = cellW * 1.11 + 15;
    return CGSizeMake(cellW, cellH);
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(14, 14, 0, 14);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 18;
    
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 15;
    
    
}
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.spaceCollectionView.frame];
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
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
    
}
@end
