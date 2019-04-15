//
//  HotPeopleViewController.m
//  kuoyi
//
//  Created by alexzinder on 2019/4/3.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import "HotPeopleViewController.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import "HotPeopleTableViewCell.h"
#import <BlocksKit+UIKit.h>
#import "PeopleViewController.h"
#import "HomeDetail.h"
#import <YYModel.h>


static NSString *cellID = @"hotPeople";
@interface HotPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UITableView *hotTableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HotPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_initUI];
    [self getHotListRequest];
    self.title = @"热门";
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)p_initUI{
    
    __weak __typeof (self)weakSelf = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.hotTableView.delegate         = self;
    self.hotTableView.dataSource       = self;
    self.hotTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.hotTableView.showsVerticalScrollIndicator = NO;
    self.hotTableView.bounces = NO;
    self.hotTableView.pagingEnabled = YES;
    self.hotTableView.backgroundColor = [UIColor whiteColor];
    self.hotTableView.rowHeight = DEVICE_HEIGHT;
    [self.hotTableView registerClass:[HotPeopleTableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.hotTableView];
    [self.hotTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:@"navgation_back"] forState:UIControlStateNormal];
    [self.view addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(20);
    }];
    [self.leftBtn bk_addEventHandler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
}

-(void)getHotListRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.people/hot";
    NSDictionary *params = @{};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        self.dataArray = dict[@"fav_list"][@"data"];
        [self.hotTableView reloadData];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    HotPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath] ;
//    HotPeopleTableViewCell *cell = [[HotPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configeCellData:self.dataArray[indexPath.row][@"url"]];
    cell.webClickCallback = ^{
        PeopleViewController *vc = [[PeopleViewController alloc] init];
        HomeDetail *detail = [HomeDetail yy_modelWithJSON:weakSelf.dataArray[indexPath.row][@"info"]];
        vc.homeDetail = detail;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
    
    
}

@end