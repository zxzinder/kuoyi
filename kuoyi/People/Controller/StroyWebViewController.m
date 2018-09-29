//
//  StroyWebViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/5/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "StroyWebViewController.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import "UmengShareview.h"
#import "UIWebView+CancelIndicator.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "CustomerManager.h"
#import "RewardViewController.h"


@interface StroyWebViewController ()<UIWebViewDelegate>


@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIImageView *shareImgView;
@property (nonatomic, strong) UIImageView *collectImgView;

@property (nonatomic, strong) NSDictionary *storyData;

@end

@implementation StroyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_initUI];
    [self getStoryDetail:self.storyId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_right).offset(-DEVICE_WIDTH * 0.15);
    }];
    
    UIImageView *rewardImgView = [[UIImageView alloc] init];
    rewardImgView.image = [UIImage imageNamed:@"story"];
    rewardImgView.contentMode = UIViewContentModeScaleAspectFit;
    rewardImgView.userInteractionEnabled = YES;
    [self.rightView addSubview:rewardImgView];
    [rewardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(self.rightView.mas_right).offset(-18);
        make.centerX.equalTo(self.rightView.mas_centerX);
        make.top.equalTo(self.rightView.mas_top).offset(20 + statusBarAndNavigationBarHeight);
    }];
    [rewardImgView bk_whenTapped:^{
        RewardViewController *vc = [[RewardViewController alloc] init];
        vc.pid = weakSelf.peopleId;
        vc.uuid = [CustomerManager sharedInstance].customer.uuid;
        vc.imgUrl = self.storyData[@"rewardimg"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UILabel *rewardLabel = [self createLabelWithColor:@"3c3c3c" font:12];
    rewardLabel.text = @"喂奶酪";
    [self.rightView addSubview:rewardLabel];
    [rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rewardImgView.mas_centerX);
        make.top.equalTo(rewardImgView.mas_bottom);
    }];
    
    self.shareImgView = [[UIImageView alloc] init];
    self.shareImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.shareImgView.image = [UIImage imageNamed:@"ppshare"];
    self.shareImgView.userInteractionEnabled  = YES;
    [self.shareImgView bk_whenTapped:^{
        NSDictionary *data = @{@"shareDesContent":self.storyData[@"share_info"],@"shareDesTitle":self.storyData[@"share_title"],@"shareImageUrl":self.storyData[@"share_img"],@"shareLinkUrl":self.urlString};
        UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
        share.UmengShareViewSuccessCallback = ^(NSInteger index) {
            [weakSelf addShareInfoRequest:index];
        };
        share.UmengShareViewCallback = ^(int i){
            NSLog(@"111111");
        };
        [share show];
    }];
    [self.rightView addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightView.mas_centerX);
        make.top.equalTo(rewardLabel.mas_bottom).offset(17);
    }];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.right.equalTo(self.rightView.mas_left);
    }];
    //ApiBaseUrl

    NSURL *url= [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [UIWebView cancelScrollIndicator:self.webView];
    
    
}
-(void)addShareInfoRequest:(NSInteger)type{
    
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.share/addShare";
    NSDictionary *params = @{@"type":@(type),@"info":@""};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getStoryDetail:(NSString *)storyId{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.article/getInfo";
    NSDictionary *params = @{@"id":storyId};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict){
        
        [HLYHUD hideAllHUDsForView:nil];
        self.storyData = dict[@"data"];
        NSLog(@"%@",dict);
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSString *htmlTitle = @"document.title";
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
//        NSLog(@"titleHtmlInfo： %@",titleHtmlInfo);
//        self.title = titleHtmlInfo;
//
//    });
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
@end
