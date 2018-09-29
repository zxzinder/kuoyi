//
//  BaseWebViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/31.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "BaseWebViewController.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "BaseWebView.h"
#import "ReturnUrlTool.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addNavigationTitleView];
    self.title = self.naviTitle;
    [self p_initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addNavigationTitleView {
    
    //left
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 42, 20);
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    self.rightBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"可以logo"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [titleView addSubview:titleImageView];
    if(iOS11){
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(titleView);
        }];
    }else{
        
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(titleView);
            //make.centerX.equalTo(titleView.mas_centerX);
            //make.top.equalTo(titleView.mas_top).offset(11);
            //make.size.mas_equalTo(CGSizeMake(104*0.8, 22*0.8));
        }];
        // titleImageView.frame = CGRectMake(20, 11, 103, 22);
    }
    
    
    self.navigationItem.titleView = titleView;
    
}
-(void)p_initUI{
      self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //ApiBaseUrl
    NSURL *url= [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
