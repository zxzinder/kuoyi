//
//  MessageiewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MessageiewController.h"
#import <MGSwipeTableCell.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import "MessageTableViewCell.h"
#import <BlocksKit+UIKit.h>
#import "KYNetService.h"
#import "HLYHUD.h"
#import "MessageModel.h"
#import "NSString+TPValidator.h"
#import "CTAlertView.h"


static NSString * CELLID = @"mesgCell";
@interface MessageiewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *delAllBtn;

@property (nonatomic, strong) UITableView *mesgTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isShowAll;

@end

@implementation MessageiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShowAll = NO;
    [self setNavigation];
    [self p_initUI];
//    for (int i = 0; i < 20; i++) {
//        [self.dataArray addObject:@(i)];
//    }
    [self getMessageListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigation{
    __weak __typeof(self)weakSelf = self;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"提醒";
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
        make.size.height.mas_equalTo(52);
    }];
    
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
              [weakSelf deleteMessage:YES andIndexPath:nil];
        }else{
            [HLYHUD showHUDWithMessage:@"暂无消息删除！" addToView:nil];
        }
       
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.mesgTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.mesgTableView.delegate         = self;
    self.mesgTableView.dataSource       = self;
    self.mesgTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.mesgTableView.showsVerticalScrollIndicator = NO;
    self.mesgTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.mesgTableView];
    [self.mesgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight + 10);
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
        [self.mesgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.left.right.bottom.equalTo(self.view);
              make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight + 10);
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
        [self.mesgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.topView.mas_bottom);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    
    
}

-(void)getMessageListRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.user/getMsg";
    NSDictionary *params = @{@"page":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        NSArray *reslutArray = dict[@"data"][@"data"];
        if (reslutArray.count > 0) {
            for (int i = 0; i < reslutArray.count; i++) {
                MessageModel *model = [[MessageModel alloc] init];
                model.msgData = reslutArray[i];
                model.isShowDetail = NO;
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.mesgTableView reloadData];
        }
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}

-(void)updateInfoState:(NSString *)msgId{
    
    __weak __typeof(self)weakSelf = self;
    //[HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.user/upMsgState";
    NSDictionary *params = @{@"id":msgId};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
      //  [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
       // [weakSelf.mesgTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
       // [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)deleteMessage:(BOOL)isDelAll andIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.user/delUserMsg";
    NSDictionary *params;
    if (isDelAll) {
        NSMutableString *idsStr = [[NSMutableString alloc] init];
        for (int i = 0 ; i < self.dataArray.count; i++) {
            MessageModel *model = self.dataArray[indexPath.row];
            NSDictionary *shopData = model.msgData;
            if (i != self.dataArray.count - 1) {
                [idsStr appendString:[NSString stringWithFormat:@"%@,",shopData[@"id"]]];//user_uid
            }else{
                [idsStr appendString:[NSString stringWithFormat:@"%@",shopData[@"id"]]];//user_uid
            }
            
        }
        params = @{@"ids":idsStr};
    }else{
        MessageModel *model = self.dataArray[indexPath.row];
        params = @{@"ids":model.msgData[@"id"]};
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
        
        [weakSelf.mesgTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
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
    MessageModel *model = self.dataArray[indexPath.row];
    if (model.isShowDetail) {
        CGFloat rowHeight = 0;
        NSString *infoStr = model.msgData[@"msg"];
        if (infoStr && ![infoStr isEqualToString:@""]) {
            rowHeight = 19 + [NSString caculateHeight:infoStr font:12 size:CGSizeMake(DEVICE_WIDTH - 30, 1000)];
        }
       
        return rowHeight + 65;
    }
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    MessageModel *model = self.dataArray[indexPath.row];
    MessageTableViewCell *cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithData:model];

    MGSwipeButton *delBtn = [MGSwipeButton buttonWithTitle:@"删除" icon:[UIImage imageNamed:@"talk_delete"] backgroundColor:[UIColor colorWithHexString:@"fb217d"] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [CTAlertView showAlertViewWithTitle:@"" Details:@"确认要删除订单吗？" CancelButton:@"取消" DoneButton:@"确认" callBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf deleteMessage:NO andIndexPath:indexPath];
            }
        }];
        
        return YES;
    }];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cell.rightButtons = @[delBtn];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageModel *model = self.dataArray[indexPath.row];
    if (model.isShowDetail) {
        model.isShowDetail = NO;
    }else{
        model.isShowDetail = YES;
    }
    if ([model.msgData[@"state"] integerValue] == 0) {
        [model.msgData setValue:@"1" forKey:@"state"];
        [self updateInfoState:model.msgData[@"id"]];
    }
    //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
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
- (UIView *)emptyTableViewOfBackgroundView {
    
    UIView *backView = [[UIView alloc] initWithFrame:self.mesgTableView.frame];
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
