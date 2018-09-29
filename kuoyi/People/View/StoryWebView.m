//
//  StoryWebView.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/13.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "StoryWebView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import <SDCycleScrollView.h>
#import "ReturnUrlTool.h"
#import "UIWebView+CancelIndicator.h"
#import <math.h>

#define titleBtnWidth 50
#define titleHeight 54
#define TAG_BTN 10000
@interface StoryWebView()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *shareImgView;
@property (nonatomic, strong) UIImageView *collectImgView;

@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) UIScrollView *titleScrollView;

@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, copy) NSArray *idsList;

// 选中按钮
@property (nonatomic, weak) UIButton *setTitleButton;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, assign) CGFloat contentWidth;

@property (nonatomic, assign) CGFloat frameHeight;

@property (nonatomic, assign) NSInteger pageIndex;

@end


@implementation StoryWebView

-(instancetype)initWithData:(NSInteger)pid{
    
    self = [super init];
    if (self) {
        self.pid = pid;
        [self p_initUI];
        
    }
    
    return self;
    
}

-(instancetype)initWithIdList:(NSArray *)idsList andFrameHeight:(CGFloat)frameHeight{
    
    self = [super init];
    if (self) {
        self.idsList = idsList;
        self.pageIndex = 0;
        self.frameHeight = frameHeight;
        [self p_initUI];
         [self setupTitle];
        [self addChildView];
       
        
    }
    
    return self;
    
}


-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor whiteColor];
    
    self.contentWidth = DEVICE_WIDTH * 0.85 - 15;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_right);
         make.size.height.mas_equalTo(titleHeight);
    }];
    CGFloat titleShowCount = 3;
    if (self.idsList.count < 3) {
        titleShowCount = self.idsList.count;
    }
    [self addSubview:self.titleScrollView];
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.topView);
        make.size.width.mas_equalTo(titleBtnWidth * titleShowCount);
    }];
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.mas_right).offset(-DEVICE_WIDTH * 0.15);
        // make.size.width.mas_equalTo(108);
    }];
    
    UIImageView *rewardImgView = [[UIImageView alloc] init];
    rewardImgView.image = [UIImage imageNamed:@"story"];
    rewardImgView.contentMode = UIViewContentModeScaleAspectFit;
    rewardImgView.userInteractionEnabled = YES;
    [self.rightView addSubview:rewardImgView];
    [rewardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(self.rightView.mas_right).offset(-18);
        make.centerX.equalTo(self.rightView.mas_centerX);
        make.top.equalTo(self.rightView.mas_top).offset(20);
    }];
    [rewardImgView bk_whenTapped:^{
        
        if (weakSelf.rewardCallback && self.idsList.count > 0) {
            weakSelf.rewardCallback(self.idsList[self.pageIndex][@"id"]);
        }
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
        //[weakSelf shareBtnHandled];
        if (self.idsList.count > 0) {
            if (weakSelf.getWebDataCallback) {
                weakSelf.getWebDataCallback(self.idsList[self.pageIndex],YES);
            }
        }
    }];
    [self.rightView addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightView.mas_centerX);
        make.top.equalTo(rewardLabel.mas_bottom).offset(17);
    }];
    
    
    self.collectImgView = [[UIImageView alloc] init];
    self.collectImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.collectImgView];
    self.collectImgView.userInteractionEnabled  = YES;
    [self.collectImgView bk_whenTapped:^{
        if (self.idsList.count > 0) {
            if (weakSelf.getWebDataCallback) {
                weakSelf.getWebDataCallback(self.idsList[self.pageIndex],NO);
            }
        }
      
    }];
    [self.collectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightView.mas_centerX);
        make.top.equalTo(self.shareImgView.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.rightView.mas_left);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    

    
//    self.webView = [[UIWebView alloc] init];
//    self.webView.delegate = self;
//    self.webView.scalesPageToFit = YES;
//    self.webView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.rightView.mas_left);
//        make.top.equalTo(self.topView.mas_bottom);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    //ApiBaseUrl @"http://www.kuoyilife.com/index2.php/h5/people/gushiInfo.html?id=29";
//
//    NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:self.pid];
//    NSURL *url= [[NSURL alloc] initWithString:urlStr];
//    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
//    [self.webView loadRequest:request];
//    [UIWebView cancelScrollIndicator:self.webView];
    
}

-(void)configureCollection:(NSInteger)is_collection{
    
//    if (is_collection > 0) {
//        self.collectImgView.image = [UIImage imageNamed:@"pplike_select"];
//    }else{
        self.collectImgView.image = [UIImage imageNamed:@"pplike"];
//    }
    
}

- (void)setupTitle{
    __weak __typeof(self)weakSelf = self;
    //184 750
    NSInteger count = self.idsList.count;
    CGFloat btnW = titleBtnWidth;
    CGFloat btnY = 0;
    CGFloat btnH = titleHeight;
    
    //72, 1px 7b7c7c   f7f8f8
    self.titleScrollView.contentSize = CGSizeMake(titleBtnWidth * count, btnH);//self.titleArr.count *btnW
    
    //添加标题label
    if (count > 0) {
        for (NSInteger i = 0; i < count; i++) {
            
            CGFloat btnX = i * btnW;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            [btn setTitle:[NSString stringWithFormat:@"Day %d",i+1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            [btn bk_addEventHandler:^(id sender) {
                [weakSelf chick:sender];
            } forControlEvents:UIControlEventTouchUpInside];
           // [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + TAG_BTN;
            
            [self.buttons addObject:btn];
            [self.titleScrollView addSubview:btn];
            if (i == 0) {
                
                [self chick:btn] ;
            }
        }
       
    }
    
    
    
}

-(void)addChildView{
    
    CGFloat viewW = self.contentWidth;
    CGFloat viewH = 0;
    CGFloat viewY = 0;
    
    NSInteger count = self.idsList.count;
    
    self.contentScrollView.contentSize = CGSizeMake(count * viewW, 0);
    for (int i=0; i < count ; i++) {
        CGFloat viewX = i * viewW;
        viewH = self.frameHeight;// DEVICE_HEIGHT - 75  - statusBarAndNavigationBarHeight - titleHeight - 64;
        
//        UIView *backView = [[UIView alloc] init];
//        backView.frame = CGRectMake(viewX, viewY, viewW, viewH);
//        backView.backgroundColor = [UIColor randomRGBColor];
//        [self.contentScrollView addSubview:backView];
//
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        [self.contentScrollView addSubview:webView];
        //ApiBaseUrl @"http://www.kuoyilife.com/index2.php/h5/people/gushiInfo.html?id=29";

        NSString *urlStr = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:[self.idsList[i][@"id"] integerValue]];
        
        NSURL *url= [[NSURL alloc] initWithString:urlStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        [webView loadRequest:request];
        [UIWebView cancelScrollIndicator:webView];
    }
    
}


// 按钮点击
- (void)chick:(UIButton *)btn{
    
    NSUInteger i = btn.tag - TAG_BTN;
    self.pageIndex = i;
    [self setTitleBtn:btn];
    CGFloat a = self.contentWidth;
    CGFloat x = i * a;
    
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    if (self.idsList.count > 3) {
        // 选中按钮时要让选中的按钮居中
        CGFloat offsetX = btn.center.x - titleBtnWidth * 3 * 0.5;//单数用center 双数用frame
        CGFloat maxOffsetX = self.titleScrollView.contentSize.width - titleBtnWidth * 3;
        
        if (offsetX < 0) {
            offsetX = 0;
        } else if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX;
        }
        [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
  
}
// 选中按钮
- (void)setTitleBtn:(UIButton *)btn{
    [self.setTitleButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.setTitleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.setTitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    btn.transform = CGAffineTransformMakeScale(1, 1);
    self.setTitleButton = btn;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ([scrollView isEqual:self.contentScrollView]) {
//        NSInteger pageIndex = 0;
//        CGFloat x = self.contentScrollView.contentOffset.x;
//        CGFloat a = self.contentWidth;
//        pageIndex = round(x / a);
//        if (pageIndex < 3 || self.idsList.count <= 3) {
//            [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }else{//} if (pageIndex == self.idsList.count - 1 && titleShowCount > 3){
//            [self.titleScrollView setContentOffset:CGPointMake(titleBtnWidth * (self.idsList.count - 3), 0) animated:YES];
//        }
//        self.pageIndex = pageIndex;
//        [self setTitleBtn:self.buttons[pageIndex]];
//
//    }
 
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
-(UIScrollView *)titleScrollView{
    
    if (_titleScrollView == nil) {
        _titleScrollView = [[UIScrollView alloc]init];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.contentSize = CGSizeMake(self.idsList.count * titleBtnWidth, 0);
        _titleScrollView.backgroundColor =  [UIColor colorWithHexString:@"ffffff"];
        _titleScrollView.userInteractionEnabled = YES;
        _titleScrollView.bounces = NO;
    }
    return _titleScrollView;
}
-(UIScrollView *)contentScrollView{
    
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.backgroundColor =  [UIColor colorWithHexString:@"ffffff"];
        _contentScrollView.contentSize = CGSizeMake(self.idsList.count * self.contentWidth, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.scrollEnabled = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
    }
    return _contentScrollView;
}
- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end
