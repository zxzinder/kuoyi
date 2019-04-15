//
//  PeopleHomeView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/27.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PeopleHomeView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import "PersonalView.h"
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import <BlocksKit+UIKit.h>
#import "PeopleInfo.h"
#import "UmengShareview.h"
#import <BarrageRenderer/BarrageRenderer.h>
#import "KYNetService.h"
#import "HLYHUD.h"
#import "NotificationMacro.h"
#import "EnumHeader.h"
#import "HomeDetail.h"
#import "NSString+TPValidator.h"


@interface PeopleHomeView()<SDCycleScrollViewDelegate,BarrageRendererDelegate,UITextFieldDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) BarrageRenderer *renderer;

//@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIImageView *collectImgView;
@property (nonatomic, strong) UILabel *collectLabel;
//@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIImageView *likeImgView;
@property (nonatomic, strong) UILabel *likeLabel;
//@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIImageView *shareImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) PersonalView *personalView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *botBtn;

@property (nonatomic, strong) UITextField *dmTextField;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView  *switchView;

@property (nonatomic, assign) BOOL isCloseDM;

@property (nonatomic, strong) PeopleInfo *info;

@property (nonatomic, assign) NSTimeInterval predictedTime;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, copy) NSArray *dmColorArray;

@property (nonatomic, strong) NSArray *dmArray;

@property (nonatomic, assign) NSInteger totalDMCount;

@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) NSInteger fabulousCount;

@end

@implementation PeopleHomeView

-(instancetype)initWithInfo:(PeopleInfo *)info{
    
    self = [super init];
    if (self) {
        self.isCloseDM = NO;
        self.info = info;
        self.dmColorArray = @[@"fffc00",  @"d8ff00", @"00ff9c", @"12ff00"];
        [self p_initUI];
        [self initBarrageRenderer];
        [self getDMList];
    }
    
    return self;
    
}

- (void)initBarrageRenderer{
    
     __weak __typeof(self)weakSelf = self;
    //33   4    1
    UIImageView *dmImgView = [[UIImageView alloc] init];
    dmImgView.image = [UIImage imageNamed:@"dmComment"];
    dmImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:dmImgView];
    [dmImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-19);
        make.left.equalTo(self.mas_left).offset(33);
        make.size.mas_equalTo(CGSizeMake(21, 21));
       // make.size.height.mas_equalTo(21);
    }];
    
    CGFloat switchWH = 11;
    UIView *dmRightView = [[UIView alloc] init];
    dmRightView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    dmRightView.layer.cornerRadius = 3;
    dmRightView.alpha = 0.6;
    [self addSubview:dmRightView];
    [dmRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-19);
        make.left.equalTo(self.mas_right).offset(-66-30);
        make.right.equalTo(self.mas_right).offset(-20);
        make.size.height.mas_equalTo(21);
    }];
    [dmRightView bk_whenTapped:^{
        if (self.isCloseDM) {
            [UIView animateWithDuration:0.3 animations:^{
                 self.switchView.frame = CGRectMake(10 + 30 - switchWH/2, 5, switchWH, switchWH);
            }];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"1c1bf2"];
            [self sendBarrageAllData];
            [self start];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.switchView.frame = CGRectMake(34 + 30 - switchWH/2, 5, switchWH, switchWH);
                
            }];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"595757"];
            [self stopDidClick];
        }
        self.isCloseDM = !self.isCloseDM;
    }];
    
    UILabel *dmLabel = [self createLabelWithColor:@"ffffff" font:12];
    dmLabel.text = @"弹幕";
    [dmRightView addSubview:dmLabel];
    [dmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dmRightView);
        make.left.equalTo(dmRightView.mas_left).offset(5);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"1c1bf2"];
    self.lineView.layer.cornerRadius = 5/2;
    [dmRightView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dmRightView);
        make.left.equalTo(dmRightView.mas_left).offset(10+30);
        make.size.mas_equalTo(CGSizeMake(24, 5));
    }];
    
    //开关按钮 11    24,5  蓝1c1bf2  灰595757
    
    self.switchView = [[UIView alloc] init];
    self.switchView.backgroundColor = [UIColor whiteColor];
    self.switchView.layer.cornerRadius = switchWH/2;
    self.switchView.frame = CGRectMake(10+30 - switchWH/2, 5, switchWH, switchWH);
    [dmRightView addSubview:self.switchView];
//    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(dmRightView);
//        make.centerX.equalTo(self.lineView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(switchWH, switchWH));
//    }];
    
  
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    backView.layer.cornerRadius = 3;
    backView.alpha = 0.6;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-19);
        make.left.equalTo(dmImgView.mas_right).offset(4);
        make.right.equalTo(dmRightView.mas_left).offset(-1);
        make.size.height.mas_equalTo(21);
    }];
    
    self.dmTextField = [[UITextField alloc] init];
     self.dmTextField.font = [UIFont systemFontOfSize:12];
    self.dmTextField.backgroundColor = [UIColor clearColor];
    self.dmTextField.returnKeyType = UIReturnKeySend;

    self.dmTextField.textColor = [UIColor whiteColor];
   
    self.dmTextField.delegate = self;
    [self addSubview:self.dmTextField];
    [self.dmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65);
        make.right.equalTo(self.mas_right).offset(-80);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.height.mas_equalTo(20);
    }];
    
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    //sendButton.layer.borderColor = [UIColor yellowColor].CGColor;
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendButton addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:sendButton];
//    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-80);
//        make.centerY.equalTo(backView.mas_centerY);
//    }];
    
    UIView *dmView = [[UIView alloc] init]; //286  420
    dmView.backgroundColor = [UIColor clearColor];
    //dmView.frame = CGRectMake(0, DEVICE_HEIGHT - 400, 220, 400);
    [self addSubview:dmView];
    [dmView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.bottom.equalTo(self.cycleScrollView);
        make.left.equalTo(self.cycleScrollView.mas_left).offset(20);
        make.bottom.equalTo(self.dmTextField.mas_top).offset(-5);
        //make.size.mas_equalTo(CGSizeMake(96, 140));
        make.right.equalTo(self.cycleScrollView.mas_right).offset(-20);
        make.size.height.mas_equalTo(140);
    }];
    
    self.renderer = [[BarrageRenderer alloc]init];
    self.renderer.view.userInteractionEnabled = NO;
    self.renderer.masked = NO;
    self.renderer.delegate = self;
    self.renderer.redisplay = YES;
    self.renderer.canvasMargin = UIEdgeInsetsMake(10, 0, 10, 0);
    self.predictedTime = 0.0f;
//    [self sendBarrageAllData];
//    [self start];
    [dmView addSubview:self.renderer.view];
    

}

-(void)p_initUI{
      __weak __typeof(self)weakSelf = self;
    CGFloat scrollHeight = DEVICE_WIDTH * 8/7;// 1418 / 1242
    self.backgroundColor = [UIColor whiteColor];
    NSMutableArray *imgMArr = [NSMutableArray array];
    for (int i = 0; i < [self.info.imgs count]; i++) {
        [imgMArr addObject:self.info.imgs[i][@"url"]];
    }
    NSString *pageStr;//
    if (self.info.imgs && self.info.imgs.count > 0) {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:imgMArr];
        pageStr = [NSString stringWithFormat:@"1/%lu",self.info.imgs.count];
    }else{
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"p2.jpg"]];
        pageStr = [NSString stringWithFormat:@"1/1"];
    }
 
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.showPageControl = NO;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.size.height.mas_equalTo(scrollHeight);
    }];
 
    
    self.shareImgView = [[UIImageView alloc] init];
    self.shareImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.shareImgView.image = [UIImage imageNamed:@"ppshare"];
    self.shareImgView.userInteractionEnabled  = YES;
    [self.shareImgView bk_whenTapped:^{
        //[weakSelf shareBtnHandled];
        if (weakSelf.shareCallback) {
            weakSelf.shareCallback();
        }
    }];
    [self addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(self.mas_top).offset(26);
    }];
    self.likeLabel = [self createLabelWithColor:@"dcdddd" font:11];
    self.likeLabel.text = @"0";
    [self addSubview:self.likeLabel];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareImgView.mas_left).offset(-14);
        make.centerY.equalTo(self.shareImgView.mas_top);
    }];
    
    
    self.likeImgView = [[UIImageView alloc] init];
    self.likeImgView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.info.is_fabulous > 0) {
        self.likeImgView.image = [UIImage imageNamed:@"pppraise_select"];
    }else{
        self.likeImgView.image = [UIImage imageNamed:@"pppraise"];
    }
    
    [self addSubview:self.likeImgView];
    self.likeImgView.userInteractionEnabled  = YES;
    [self.likeImgView bk_whenTapped:^{
        if (self.info.is_fabulous > 0) {
            [HLYHUD showHUDWithMessage:@"已点赞" addToView:nil];
        }else{
            if (weakSelf.praiseCallBack) {
                weakSelf.praiseCallBack();
            }
        }
        
    }];
    [self.likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.shareImgView.mas_centerY);
    }];
    
    self.collectLabel = [self createLabelWithColor:@"dcdddd" font:11];
    self.collectLabel.text = @"0";
    [self addSubview:self.collectLabel];
    [self.collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeImgView.mas_left).offset(-14);
        make.centerY.equalTo(self.likeLabel.mas_centerY);
    }];
    
    self.collectImgView = [[UIImageView alloc] init];
    self.collectImgView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.info.is_collection > 0) {//pplike_select
        self.collectImgView.image = [UIImage imageNamed:@"pplike_select"];
    }else{
        self.collectImgView.image = [UIImage imageNamed:@"pplike"];
    }
    [self addSubview:self.collectImgView];
    self.collectImgView.userInteractionEnabled  = YES;
    [self.collectImgView bk_whenTapped:^{
//        if (self.info.is_collection > 0) {
//            [HLYHUD showHUDWithMessage:@"已收藏" addToView:nil];
//        }else{
            if (weakSelf.collectCallBack) {
                weakSelf.collectCallBack();
            }
//        }
       
    }];
    [self.collectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectLabel.mas_left).offset(-2);
        make.centerY.equalTo(self.shareImgView.mas_centerY);
    }];
    
    
    //加透明
    UIView *pageView = [[UIView alloc] init];//
    pageView.alpha = 0.3;
    pageView.layer.cornerRadius = 6;
    pageView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    [self addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.shareImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.pageBtn = [self createBtnWithColor:@"fffff" font:12 icon:nil];
    self.pageBtn.layer.cornerRadius = 6;
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//
    [self addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
         make.centerY.equalTo(self.shareImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    CGFloat titleTop = 11;
    CGFloat titleFont = 20;
    CGFloat personTop = 0;
    CGFloat offsetY = 4;
    CGFloat botHW = 10;
    
    if (is55InchScreen || isiPhoneXScreen) {
        titleTop = 13;
        titleFont = 25;
        personTop = 11;
        offsetY = 10;
        botHW = 14;
    }
    if (isiPhoneXScreen) {
        titleTop = 33;
    }
    NSString *titleStr = self.info.gushi_title;
    if (!self.info.gushi_title || [self.info.gushi_title isEqualToString:@""]) {
        titleStr = @"填充";
    }
    CGFloat titleHeight = [NSString caculateHeight:titleStr font:titleFont size:CGSizeMake(DEVICE_WIDTH - 28, 50)];
    self.titleLabel = [self createLabelWithColor:@"3c3c3c" font:titleFont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"STZhongsong" size:titleFont];
    self.titleLabel.text = self.info.gushi_title;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(titleTop);
        make.left.equalTo(self.mas_left).offset(14);
        make.size.height.mas_equalTo(titleHeight);
    }];
    
    self.personalView = [[PersonalView alloc] initWithType:NO];
    [self.personalView configureBotData:self.info];
   // [self.personalView configureBackViewColor];
    [self addSubview:self.personalView];
    [self.personalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        //make.top.equalTo(self.titleLabel.mas_bottom).offset(personTop);
        make.bottom.equalTo(self.mas_bottom);
        make.size.height.mas_equalTo(80);
    }];
    self.personalView.storyCallback = ^{
        if (weakSelf.storyCallback) {
            weakSelf.storyCallback();
        }
    };
}
-(void)showDetailImgView{
    
    [self.personalView showDetailImgView];
    
}
-(void)hideDetailImgView{
    
     [self.personalView hideDetailImgView];
    
}
-(void)configureBackViewColor:(BOOL)isWhite{
    
     [self.personalView configureBackViewColor:isWhite];
    
}

-(void)updateCollectCount:(NSInteger)type{
    if (type == 0) {//取消收藏
        self.collectCount--;
        self.info.is_collection--;
        self.collectLabel.text = [NSString stringWithFormat:@"%ld",(long)self.collectCount];
        self.collectImgView.image = [UIImage imageNamed:@"pplike"];
    }else{
        self.collectCount++;
        self.info.is_collection++;
        self.collectLabel.text = [NSString stringWithFormat:@"%ld",(long)self.collectCount];
        self.collectImgView.image = [UIImage imageNamed:@"pplike_select"];
    }
   
}
-(void)updateFabulousCount{
    
    self.fabulousCount++;
    self.info.is_fabulous++;
    self.likeLabel.text = [NSString stringWithFormat:@"%ld",(long)self.fabulousCount];
    self.likeImgView.image = [UIImage imageNamed:@"pppraise_select"];
    
}

-(void)getDMList{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.danMu/getList";
    NSDictionary *params = @{@"peopleid":@(self.info.pid),@"page":@"1"};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dmArray = dict[@"data"][@"data"];
        weakSelf.fabulousCount = [dict[@"fabulous"] integerValue];
        weakSelf.collectCount = [dict[@"collect"] integerValue];
        weakSelf.likeLabel.text = [NSString stringWithFormat:@"%@",dict[@"fabulous"]];
        weakSelf.collectLabel.text = [NSString stringWithFormat:@"%@",dict[@"collect"]];
        weakSelf.totalDMCount = weakSelf.dmArray.count;
        weakSelf.dmTextField.placeholder = [NSString stringWithFormat:@"已有%lu发弹幕，你也来一发吧！",(unsigned long)weakSelf.totalDMCount];
        [weakSelf.dmTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [weakSelf.dmTextField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        [weakSelf sendBarrageAllData];
        [weakSelf start];
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)addDMRequest:(NSString *)content{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.danMu/addDanMu";
    NSDictionary *params = @{@"peopleid":@(self.info.pid),@"info":content};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        weakSelf.totalDMCount = weakSelf.totalDMCount + 1;
        weakSelf.dmTextField.text = @"";
        weakSelf.dmTextField.placeholder = [NSString stringWithFormat:@"已有%lu发弹幕，你也来一发吧！",(unsigned long)weakSelf.totalDMCount];
        if (weakSelf.doneEditCallBack) {
            weakSelf.doneEditCallBack();
        }
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleGoLogin object:@{@"type":@(SendDM)}];
        }else{
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        }
    }];
    
}

-(void)shareBtnHandled{
    
    NSDictionary *data = @{@"shareDesContent":@"测试测试测试测试测试内容内容内容",@"shareDesTitle":@"kuoyi分享",
                           @"shareImageUrl":@"http://192.168.1.12/picnull",@"shareLinkUrl":@"https://mp.weixin.qq.com/s/S9vprdp1w6PNVXGnZnegKg"};
    UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
    share.UmengShareViewCallback = ^(int i){
        
    };
    [share show];
}

-(void)sendBarrageAllData{
    //
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < self.dmArray.count; i++) {
        BarrageDescriptor * descriptor = [[BarrageDescriptor alloc] init];
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
        descriptor.params[@"trackNumber"] = @3;
        descriptor.params[@"text"] = self.dmArray[i][@"info"]; //字体大小10 BarrageWalkDirectionR2L
//        if (i == 0) {
//            descriptor.params[@"textColor"] = [UIColor clearColor];
//        }else{
           descriptor.params[@"textColor"] = [UIColor colorWithHexString:self.dmColorArray[arc4random() % 4]];
//        }
        descriptor.params[@"shadowColor"] = [UIColor darkGrayColor];
        descriptor.params[@"speed"] = @(60);//@(0.5 * 12 + 100);
        descriptor.params[@"delay"] = @(i*0.5+1);
        descriptor.params[@"avoidCollision"] = @(YES);
        [mArr addObject:descriptor];
    }
    [self.renderer load:mArr];
    // [self.renderer receive:descriptor];
    
    
}
//开始发送弹幕

- (void)start
{
    self.startDate = [NSDate date];
    [self.renderer start];
    
}

//发送弹幕

- (void)sendBarrageWithModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.renderer receive:[self walkImageTextSpriteDescriptorAWithData]];
    });
}
//加载弹幕描述符

- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithData
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc] init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    descriptor.params[@"trackNumber"] = @3;
    descriptor.params[@"text"] = self.dmTextField.text;
    descriptor.params[@"textColor"] = [UIColor redColor];
    descriptor.params[@"shadowColor"] = [UIColor darkGrayColor];
    descriptor.params[@"speed"] = @(60);//@(0.5 * 12 + 100);
    return descriptor;
}
#pragma mark - Action && Notification

- (void)buttonDidClick{
    if (!self.startDate) {
        [self start];
    }
    [self sendBarrageWithModel];
    [self addDMRequest:self.dmTextField.text];

}
-(void)stopDidClick{
    self.startDate = nil;
    [self.renderer stop];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.location > 14){
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }

    [self endEditing:YES];
    //[textField resignFirstResponder];//取消第一响应者
    [self buttonDidClick];//
    
    return YES;
    
}
#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:self.startDate];
    interval += self.predictedTime;
    return interval;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"---滚动第%ld张图片", (long)index);
    NSString *page = [NSString stringWithFormat:@"%ld/%lu",(long)index + 1,self.info.imgs.count];
    [self.pageBtn setTitle:page forState:UIControlStateNormal];
}
-(NSAttributedString *)changeLabelStyle:(NSString *)str{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 2; //设置行间距
    
    paraStyle.hyphenationFactor=1.0;
    
    paraStyle.firstLineHeadIndent=0.0;
    
    paraStyle.paragraphSpacingBefore=0.0;
    
    paraStyle.headIndent=0;
    
    paraStyle.tailIndent=0;
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font icon:(NSString *)icon{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    if (icon) {
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    
    return btn;
    
}
@end
