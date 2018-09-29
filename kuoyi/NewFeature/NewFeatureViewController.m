//
//  NewFeatureViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/3/15.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "UtilsMacro.h"
#import "MyPageControl.h"
#import "RootTabBarController.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import "UIColor+TPColor.h"
#import <UIImageView+WebCache.h>
#import "KYNetService.h"


//const static NSInteger imageCount = 4;

@interface NewFeatureViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) MyPageControl *pageControl;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger imageCount;

@end

@implementation NewFeatureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   // self.imageCount = 4;
    //[self p_initUI];
    [self getADImageRequest];
}

- (void)p_initUI {
    UIScrollView *pageScrollView = [[UIScrollView alloc] init];
    pageScrollView.frame = self.view.bounds;
    //设置边缘不弹跳
    pageScrollView.bounces = NO;
    //整页滚动
    pageScrollView.pagingEnabled = YES;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    pageScrollView.delegate = self;
    for(NSInteger i = 0; i < self.imageCount; i++){
        NSString *imgName;
        if (isiPhoneXScreen) {
            imgName = [NSString stringWithFormat:@"引导页X-%ld",i+1];
        }else{
            imgName = [NSString stringWithFormat:@"引导页1-%ld", i+1];
        }
        
        //UIImage *image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];//[UIImage imageNamed:imgName];
        //UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i][@"imgurl"]] placeholderImage:[UIImage imageWithColor:[UIColor randomRGBColor]]];
        CGRect frame = CGRectZero;
        frame.origin.x = i * pageScrollView.frame.size.width;
        frame.size = pageScrollView.frame.size;
        imageView.frame = frame;
        [pageScrollView addSubview:imageView];
        
        //if(i == self.imageCount - 1){
            //开启图片的用户点击功能
            imageView.userInteractionEnabled = YES;
            //加个按钮
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageView addSubview:enterButton];
            enterButton.layer.cornerRadius = 22;
            enterButton.backgroundColor = [UIColor colorWithHexString:@"ffe903"];
            //[enterButton setImage:[UIImage imageNamed:@"startbtn"] forState:UIControlStateNormal];
            enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [enterButton setTitle:@"开始漫游 可以" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [enterButton addTarget:self action:@selector(a_enterAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterButton];
            [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView.mas_centerX);
                make.width.equalTo(@160);
                make.height.equalTo(@44);
                make.bottom.equalTo(imageView.mas_bottom).offset(- DEVICE_HEIGHT * 0.135);
            }];
        //}
    }
    
    pageScrollView.contentSize = CGSizeMake(self.imageCount * pageScrollView.frame.size.width, pageScrollView.frame.size.height);
    
    [self.view addSubview:pageScrollView];
    [self setUpPageControl];
}

-(void)getADImageRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.advert/getList";
    NSDictionary *params = @{@"type":@"2"};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        weakSelf.dataArray = dict[@"data"];
        weakSelf.imageCount = weakSelf.dataArray.count;
        [weakSelf p_initUI];
        //2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告接口是否更新
    } FailureBlock:^(NSDictionary *dict) {
        [weakSelf a_enterAction];
    }];
    
}

#pragma mark - Target Action
- (void)a_enterAction {
    RootTabBarController *tabBarVc = [[RootTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
}

- (void)setUpPageControl {
    self.pageControl = [[MyPageControl alloc] init];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imageCount;
    [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"blackpoint"]];
    [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"whitepoint"]];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@169);
        make.height.equalTo(@8);
        make.bottom.equalTo(self.view.mas_bottom).offset(- DEVICE_HEIGHT * 0.1);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pageControl updateDots];
    });
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if(offset.x<=0){
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    NSUInteger index = round(offset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = index;
    [self.pageControl updateDots];
    if (index == self.imageCount - 1) {
        self.pageControl.hidden = YES;
    }else {
        self.pageControl.hidden = NO;
    }
}

@end
