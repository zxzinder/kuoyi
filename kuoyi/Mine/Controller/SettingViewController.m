//
//  SettingViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/30.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "SettingViewController.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "FileCacheTool.h"
#import "SettingDataSource.h"
#import "CustomerManager.h"
#import "ReturnUrlTool.h"
#import "BaseWebViewController.h"
#import "ActionSeetPickerView.h"
#import "NotificationMacro.h"
#import "DataManager.h"
#import "UmengShareview.h"
#import "KYNetService.h"
#import "HLYHUD.h"


static NSString *CELLID = @"setCell";
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,ActionSeetPickViewDelegate>

@property (nonatomic, strong) UITableView *setTableView;

@property (nonatomic, copy) NSArray *dataSourceArray;

@property (nonatomic, assign) NSInteger totalCacheSize;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"设置";
    [self  p_initUI];
    [self getFileCache];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)p_initUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.backgroundColor = [UIColor colorWithHexString:@"2ebac2"];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(quitUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    }];
    
    self.setTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.setTableView.delegate         = self;
    self.setTableView.dataSource       = self;
    self.setTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.setTableView.showsVerticalScrollIndicator = NO;
    self.setTableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:self.setTableView];
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.bottom.equalTo(logoutButton.mas_top);
    }];
    
}
-(void)getFileCache{
    __weak __typeof(self)weakSelf = self;

    [FileCacheTool getFileSizeCompletion:^(NSInteger totalSize) {
        weakSelf.totalCacheSize = totalSize;
        
        [weakSelf.setTableView reloadData];
    }];
    
}
- (void)p_logout{
    [[CustomerManager sharedInstance] setIsLogin:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
     //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)quitUser{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.user/quit";
    [KYNetService GetHttpDataWithUrlStr:url Dic:@{} SuccessBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        [self p_logout];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSourceArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return 10;
    }else{
       return 33;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat sectionH = 10;
    if (section != 0) {
        sectionH = 33;
    }
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH, sectionH);
    backView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    if (section != 0) {
        NSString *sectionStr = @"";
        if (section == 1) {
            sectionStr = @"反馈";
        }else if (section == 2){
            sectionStr = @"关于";
        }
        UILabel *sectionLabel = [self createLabelWithColor:@"999999" font:12];
        sectionLabel.text = sectionStr;
        [backView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(20);
            make.bottom.equalTo(backView.mas_bottom).offset(-5);
        }];
    }
    
    return backView;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell andIndexPath:indexPath];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 ) {
        if (indexPath.row == 0) {
            SettingDataSourceItem *item = self.dataSourceArray[indexPath.section][indexPath.row];
            BaseWebViewController *vc = [[BaseWebViewController alloc] init];
            vc.urlString = [ReturnUrlTool getUrlByWebType:item.protocolType andDetailId:item.protocolType];
            vc.naviTitle = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 0 ){
        if (indexPath.row == 1) {
            [FileCacheTool removeDirectoryPath];
            [self getFileCache];
        }else{
            ActionSeetPickerView *picker = [[ActionSeetPickerView alloc] initPickviewWithArray:@[@"小",@"中",@"大"] isHaveNavControler:YES];
            picker.delegate = self;
            [picker setToolbarTintColor:[UIColor whiteColor]];
            [picker setLeftTintColor:[UIColor tp_lightGaryTextColor]];
            [picker setRightTintColor:[UIColor colorWithHexString:@"17a7af"]];
            [picker show];
        }
        
    }else if (indexPath.section == 1 ){
        if (indexPath.row == 2) {
            NSDictionary *data = @{@"shareDesContent":@"测试测试测试测试测试内容内容内容",@"shareDesTitle":@"kuoyi分享",
                                   @"shareImageUrl":@"http://192.168.1.12/picnull",@"shareLinkUrl":AppStoreUrl};
            UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
            share.UmengShareViewCallback = ^(int i){
                
            };
            [share show];
        }else if (indexPath.row == 4){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1080896604&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
        }
        SettingDataSourceItem *item = self.dataSourceArray[indexPath.section][indexPath.row];
        UIViewController *pushedVC = nil;
        
        if (item.pushControllerName) {
            pushedVC = [[NSClassFromString(item.pushControllerName) alloc]init];
        }
        
        if ([pushedVC isKindOfClass:[BaseWebViewController class]]) {
            //pushedVC = [[UserProtocolViewController alloc] initWithTitle:item.title type:item.protocolType];
            BaseWebViewController *vc = [[BaseWebViewController alloc] init];
            vc.urlString = [ReturnUrlTool getUrlByWebType:item.protocolType andDetailId:item.protocolType];
            vc.naviTitle = item.title;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        [self.navigationController pushViewController:pushedVC animated:YES];
    }else{

    }
    
}
-(void)configureCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    SettingDataSourceItem *item = self.dataSourceArray[indexPath.section][indexPath.row];
    
    UILabel *leftLabel = [self createLabelWithColor:@"3c3c3c" font:14];
    leftLabel.text = item.title;
    [cell.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(20);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    //rightIcon
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = [UIImage imageNamed:@"rightIcon"];
    [cell.contentView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [cell.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    UILabel *rightLabel = [self createLabelWithColor:@"999999" font:12];
    rightLabel.hidden = YES;
    [cell.contentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
    }];
    if (indexPath.section == 0 ) {//清除缓存
        if (indexPath.row == 1) {
            rightImgView.hidden = YES;
            rightLabel.text = [self sizeStr];
            rightLabel.hidden = NO;
        }else if (indexPath.row == 0) {//正文字号
            NSString *sizeStr = @"中";
            NSString *sizeFont = [DataManager objectForRead:kDefaultSizeFont];
            if (sizeFont && ![sizeFont isEqualToString:@""]) {
                if ([sizeFont isEqualToString:@"1"]) {
                    sizeStr = @"小";
                }else if ([sizeFont isEqualToString:@"2"]){
                     sizeStr = @"中";
                }else{
                      sizeStr = @"大";
                }
            }
            rightImgView.hidden = NO;
            rightLabel.text = sizeStr;
            rightLabel.hidden = NO;
            [rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-30);
            }];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 1) {//版本
         NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        rightImgView.hidden = YES;
        rightLabel.text = currentVersion;
        rightLabel.hidden = NO;
    }
}

// 获取缓存尺寸字符串
- (NSString *)sizeStr
{
    NSInteger totalSize = self.totalCacheSize;
    NSString *sizeStr = @"";
    // MB KB B
    if (totalSize > 1024 * 1024) {
        // MB
        CGFloat sizeF = totalSize / 1024 / 1024;
        sizeStr = [NSString stringWithFormat:@"%.2fMB",sizeF];
    } else if (totalSize > 1024) {
        // KB
        CGFloat sizeF = totalSize / 1024;
        sizeStr = [NSString stringWithFormat:@"%.1fKB",sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"%.ldB",totalSize];
    }
    
    return sizeStr;
}
#pragma mark ActionSeetPickViewDelegate
- (void)toobarDonBtnHaveClick:(ActionSeetPickerView *)pickView resultString:(NSString *)resultString {
    
    NSLog(@"%@",resultString);
    NSString *sizeFont;
    if ([resultString isEqualToString:@"小"]) {
        sizeFont = @"1";
    }else if ([resultString isEqualToString:@"中"]){
        sizeFont = @"2";
    }else{
        sizeFont = @"3";
    }
    [DataManager saveObject:sizeFont forKey:kDefaultSizeFont];
    [self.setTableView reloadData];
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(NSArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
//        _dataSourceArray = @[
//                             @[@"正文字号",@"清除缓存"],
//                             @[@"帮助反馈",@"关注我们",@"分享KUOYI给好友",@"站长指南",@"去App Store给KUOYI个好评"],
//                             @[@"用户协议",@"版本号"],
//                             ];
        _dataSourceArray = [SettingDataSource dataSource];
    }
    
    return _dataSourceArray;
    
}
@end
