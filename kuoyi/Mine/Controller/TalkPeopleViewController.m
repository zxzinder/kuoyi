//
//  TalkPeopleViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/27.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "TalkPeopleViewController.h"
#import <MGSwipeTableCell.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import "TalkPeopleTableViewCell.h"
#import "HLYHUD.h"
#import "KYNetService.h"
#import "EnumHeader.h"
#import "CustomerManager.h"
#import "TalkPeopleModel.h"
#import <UIImageView+WebCache.h>
#import "PeopleViewController.h"
#import "HomeDetail.h"
#import <YYModel.h>
#import "CTAlertView.h"


static NSString * CELLID = @"talkCell";
@interface TalkPeopleViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong) UITableView *talkTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *hotList;

@end

@implementation TalkPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = NO;
    self.title = @"可聊的人";
    [self p_initUI];
//    for (int i = 0; i < 20; i++) {
//        TalkPeopleModel *model = [[TalkPeopleModel alloc] init];
//        model.peopleData = @{@"row":@(i)};
//        model.isShowDetail = NO;
//        [self.dataArray addObject:model];
//    }
    [self getTalkPeopleListRequest];
    // Do any additional setup after loading the view.
}

-(void)p_initUI{
    
    self.talkTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.talkTableView.delegate         = self;
    self.talkTableView.dataSource       = self;
    self.talkTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.talkTableView.showsVerticalScrollIndicator = NO;
//    self.talkTableView.rowHeight = 93;
    self.talkTableView.bounces = NO;
    self.talkTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];//eeeeee
    self.talkTableView.estimatedRowHeight = 0;
    self.talkTableView.estimatedSectionFooterHeight = 0;
    self.talkTableView.estimatedSectionHeaderHeight = 0;

    [self.view addSubview:self.talkTableView];
    [self.talkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
    }];
}


-(void)getTalkPeopleListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.collect/getfavorites";
    NSDictionary *params = @{@"user_uid":[CustomerManager sharedInstance].customer.uuid,@"fav_type":@(PeopleCollection)};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        NSArray *reslutArray = dict[@"fav_list"][@"data"];
        weakSelf.hotList = dict[@"hotList"];
        if (reslutArray.count > 0) {
            for (int i = 0; i < reslutArray.count; i++) {
                TalkPeopleModel *model = [[TalkPeopleModel alloc] init];
                model.peopleData = reslutArray[i];
                if (i == 0) {
                    model.isShowDetail = YES;
                }else{
                    model.isShowDetail = NO;
                }
                
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.talkTableView reloadData];

        }
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}


-(void)deletePeopleByIndexPath:(NSIndexPath *)indexPath{
    [HLYHUD showLoadingHudAddToView:nil];
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
     TalkPeopleModel *model = self.dataArray[indexPath.row];
    NSString *url = @"v1.collect/removefavorites";
    NSDictionary *params = @{@"object_id":model.peopleData[@"order_id"],@"user_uid":[CustomerManager sharedInstance].customer.uuid,@"fav_type":@(PeopleCollection)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"取消成功" addToView:nil];
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.talkTableView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TalkPeopleModel *model = self.dataArray[indexPath.row];
    if (model.isShowDetail) {
        return 94 + 47;
    }
    return 94;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.hotList.count > 0) {
        return 108;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.hotList.count > 0) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 108);
        backView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
        
        UILabel *remindLabel = [self createLabelWithColor:@"585855" font:12];
        remindLabel.text = @"你关注的同路人更新了内容";
        [backView addSubview:remindLabel];
        [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(20);
           // make.centerY.equalTo(backView.mas_top).offset(53/4);
            make.top.equalTo(backView.mas_top).offset(12);
        }];
        CGFloat btnW = 53;
        CGFloat btnH = btnW;
        CGFloat btnX = 20;
        CGFloat btnY = btnH/2 + 8;
        CGFloat segW = 26;
        for (int i = 0; i < self.hotList.count; i++) {
            btnX = 20;
            btnX = btnX + btnW * i + segW * i;
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.hotList[i][@"headimg"]] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
            imgView.layer.cornerRadius = btnW/2;
            imgView.layer.masksToBounds = YES;
            imgView.layer.borderColor = [UIColor colorWithHexString:@"acc2cd"].CGColor;
            imgView.layer.borderWidth = 1;
            imgView.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [backView addSubview:imgView];
            
            UILabel *nameLabel = [self createLabelWithColor:@"585855" font:11];
            nameLabel.text = self.hotList[i][@"people_name"];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imgView.mas_centerX);
                make.top.equalTo(imgView.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(btnW + segW, 10));
            }];
        }
        
        
        return backView;
    }else{
        return nil;
    }
   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak __typeof(self)weakSelf = self;
    
    TalkPeopleModel *model = self.dataArray[indexPath.row];
//  TalkPeopleTableViewCell *cell = [[TalkPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
//  cell = [[TalkPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    TalkPeopleTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[TalkPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImgCallBack = ^{
        //还需要接口返回信息
        PeopleViewController *vc = [[PeopleViewController alloc] init];
        HomeDetail *detail = [HomeDetail yy_modelWithJSON:model.peopleData[@"info"]];
        vc.homeDetail = detail;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [cell configureCellWithData:model];
    MGSwipeButton *delBtn = [MGSwipeButton buttonWithTitle:@"取消关注" icon:[UIImage imageNamed:@"talk_delete"] backgroundColor:[UIColor colorWithHexString:@"fb217d"] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [CTAlertView showAlertViewWithTitle:@"" Details:@"确认要取消关注吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
               [weakSelf deletePeopleByIndexPath:indexPath];
            }
        }];
        
        return YES;
    }];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cell.rightButtons = @[delBtn];
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TalkPeopleModel *model = self.dataArray[indexPath.row];
    if (model.isShowDetail) {
        model.isShowDetail = NO;
    }else{
        model.isShowDetail = YES;
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.talkTableView.frame];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"暂无结果~";
    label.textColor = [UIColor tp_lightGaryTextColor];
    [backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
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
