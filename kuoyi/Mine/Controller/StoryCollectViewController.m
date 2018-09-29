//
//  StoryCollectViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/3.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "StoryCollectViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "StoryCollectionViewCell.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "CustomerManager.h"
#import "TalkPeopleModel.h"
#import <UIImageView+WebCache.h>
#import "ReturnUrlTool.h"
#import "StroyWebViewController.h"


static NSString *CELLID = @"storyCell";
@interface StoryCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *storyCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation StoryCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"故事收藏";
    // Do any additional setup after loading the view.
    [self p_initUI];
    [self getStoryListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)p_initUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.storyCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.storyCollectionView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    self.storyCollectionView.showsHorizontalScrollIndicator = NO;
    self.storyCollectionView.delegate = self;
    self.storyCollectionView.dataSource =self;
    [self.view addSubview:self.storyCollectionView];
    [self.storyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.storyCollectionView registerClass:[StoryCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    
}

-(void)getStoryListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.collect/getfavorites";
    NSDictionary *params = @{@"user_uid":[CustomerManager sharedInstance].customer.uuid,@"fav_type":@(StoryCollection)};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = [dict[@"fav_list"][@"data"] mutableCopy];
        [weakSelf.storyCollectionView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}
-(void)deleteStoryByIndexPath:(NSIndexPath *)indexPath{
    [HLYHUD showLoadingHudAddToView:nil];
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.collect/removefavorites";
    NSDictionary *params = @{@"object_id":self.dataArray[indexPath.row][@"order_id"],@"user_uid":[CustomerManager sharedInstance].customer.uuid,@"fav_type":@(StoryCollection)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"取消成功" addToView:nil];
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.storyCollectionView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
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
    
   // return self.dataArray.count;
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    
    StoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [cell configureData:self.dataArray[indexPath.row][@"info"]];
    cell.cancelCollectCallBack = ^{
        [weakSelf deleteStoryByIndexPath:indexPath];
    };
    return cell;
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:[self.dataArray[indexPath.row][@"info"][@"id"] integerValue]];
    StroyWebViewController *vc = [[StroyWebViewController alloc] init];
    vc.urlString = urlStr;
    vc.peopleId = [self.dataArray[indexPath.row][@"info"][@"people_id"] integerValue];
    vc.storyId = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row][@"info"][@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    CGFloat cellH = cellW * 1.11;
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
#pragma mark setter
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.storyCollectionView.frame];
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
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
    
    
}
@end
