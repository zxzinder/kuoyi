//
//  UserMarkViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/9/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "UserMarkViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "LNAddressSelectView.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "UserMarkCollectionViewCell.h"
#import "HomeViewController.h"
#import "CustomerManager.h"



static NSString *CELLID = @"markCell";
@interface UserMarkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *markCollectionView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secLabel;
@property (nonatomic, strong) UILabel *botFirLabel;

@property (nonatomic, strong) UIButton *botBtn;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation UserMarkViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"2fb9c3"];
    self.title = @"选择标签";
    self.pageIndex = 0;
//    for (int i = 0; i < 13; i++) {
//        [self.dataArray addObject:[NSString stringWithFormat:@"标签%d",i]];
//    }
    [self p_initUI];
    [self getUserMarkRequest];
    // Do any additional setup after loading the view.
}

-(void)p_initUI{
    __weak __typeof(self)weakSelf = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.markCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.markCollectionView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    self.markCollectionView.showsHorizontalScrollIndicator = NO;
    self.markCollectionView.layer.borderColor = [UIColor blackColor].CGColor;
    self.markCollectionView.layer.borderWidth = 5;
    self.markCollectionView.pagingEnabled = YES;
    self.markCollectionView.delegate = self;
    self.markCollectionView.dataSource =self;
    self.markCollectionView.bounces = NO;
    self.markCollectionView.scrollEnabled = NO;
    [self.view addSubview:self.markCollectionView];
    
    [self.markCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH * 0.87, DEVICE_WIDTH * 0.87 * 1.5));
    }];
    [self.markCollectionView registerClass:[UserMarkCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    
    self.secLabel = [self createLabelWithColor:@"000000" font:15];
    self.secLabel.text = @"看看有多少和你一样自恋的同路人。";
    [self.view addSubview:self.secLabel];
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.markCollectionView.mas_top).offset(-10);
        make.left.equalTo(self.markCollectionView.mas_left);
    }];
    
    self.firstLabel = [self createLabelWithColor:@"000000" font:15];
    self.firstLabel.text = @"请努力的“夸奖”自己";
    [self.view addSubview:self.firstLabel];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.secLabel.mas_top).offset(-5);
        make.left.equalTo(self.markCollectionView.mas_left);
    }];
    
    self.botFirLabel = [self createLabelWithColor:@"004a4f" font:12];
    self.botFirLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.botFirLabel.text = @"如果想更改标签可以到\n个人页面里修改";
    self.botFirLabel.numberOfLines = 2;
    [self.view addSubview:self.botFirLabel];
    [self.botFirLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.markCollectionView.mas_bottom).offset(10);
        make.left.equalTo(self.markCollectionView.mas_left);
    }];
    
    self.botBtn = [self createBtnWithColor:@"ffffff" font:20];
    self.botBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.botBtn setTitle:@"保 存" forState:UIControlStateNormal];
    self.botBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.botBtn];//167  57
    [self.botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.markCollectionView.mas_bottom);
        make.right.equalTo(self.markCollectionView.mas_right);
        make.size.mas_equalTo(CGSizeMake(167, 57));
    }];
    [self.botBtn bk_addEventHandler:^(id sender) {
        
        if (weakSelf.dataArray.count / 7 == weakSelf.pageIndex || weakSelf.dataArray.count <=7 ) {
            [weakSelf updateUserMarkRequest];
        }else{
            if (weakSelf.dataArray.count / 7 == weakSelf.pageIndex + 1) {
                [weakSelf.botBtn setTitle:@"保 存" forState:UIControlStateNormal];
            }
            [weakSelf.markCollectionView setContentOffset:CGPointMake((weakSelf.pageIndex + 1) * weakSelf.markCollectionView.frame.size.width , 0) animated:YES];
            weakSelf.pageIndex++;
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)popToVC{
    
    if (self.isFromRegister) {
        if (self.finishCallback) {
            self.finishCallback();
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
-(void)getUserMarkRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.lable/getList";
    [KYNetService GetHttpDataWithUrlStr:url Dic:nil SuccessBlock:^(NSDictionary *dict){
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = [dict[@"data"] mutableCopy];
        if (weakSelf.dataArray.count > 7) {
            [weakSelf.botBtn setTitle:@"下一页" forState:UIControlStateNormal];
        }else{
            [weakSelf.botBtn setTitle:@"保 存" forState:UIControlStateNormal];
        }
        [weakSelf.markCollectionView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)updateUserMarkRequest{
    if (self.selectArray.count > 0) {
        NSMutableString *idsStr = [[NSMutableString alloc] init];
        for (int i = 0 ; i < self.selectArray.count; i++) {
            if (i != self.selectArray.count - 1) {
                [idsStr appendString:[NSString stringWithFormat:@"%@,",self.selectArray[i]]];//
            }else{
                [idsStr appendString:[NSString stringWithFormat:@"%@",self.selectArray[i]]];//
            }
            
        }
        NSDictionary *params = @{@"lable_ids":idsStr};
        __weak __typeof(self)weakSelf = self;
        [HLYHUD showLoadingHudAddToView:nil];
        NSString *url = @"v1.user/upLable";
        [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
            [HLYHUD hideAllHUDsForView:nil];
            NSLog(@"%@",dict);
            [CustomerManager sharedInstance].customer.lable_ids = idsStr;
            [[CustomerManager sharedInstance] updateCustomer];
            [weakSelf popToVC];
        } fail:^(NSDictionary *dict) {
            [HLYHUD hideAllHUDsForView:nil];
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
            [weakSelf popToVC];
        }];
    }else{
        [self popToVC];
    }
   
    
    
}

-(void)a_singleSelectAction:(NSInteger)index isSelect:(BOOL)isSelect{
    NSString *uuid = self.dataArray[index][@"id"];
    if (isSelect) {
        [self.selectArray addObject:uuid];
    }else{
        [self.selectArray removeObject:uuid];
    }
}

#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.dataArray.count;
    return count;
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    UserMarkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [cell configureData:self.dataArray[indexPath.row]];
    cell.selectCallBack = ^(BOOL isSelect) {
        [weakSelf a_singleSelectAction:indexPath.row isSelect:isSelect];
    };
    if (self.dataArray[indexPath.row][@"is_select"] && [self.dataArray[indexPath.row][@"is_select"] integerValue] == 1) {
         [weakSelf a_singleSelectAction:indexPath.row isSelect:YES];
    }
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
    CGFloat cellW = self.markCollectionView.frame.size.width;
    CGFloat cellH = self.markCollectionView.frame.size.height/7;
    return CGSizeMake(cellW, cellH);
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    CGFloat x = scrollView.contentOffset.x;
    CGFloat a = self.markCollectionView.frame.size.width;
    self.pageIndex = round(x / a);
    NSLog(@"scrollView.contentOffset.x: %f",x);
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
@end
