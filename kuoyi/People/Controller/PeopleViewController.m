//
//  PeopleViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PeopleViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "ContentView.h"
#import "PeopleHomeView.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "HomeDetail.h"
#import "PeopleInfo.h"
#import <YYModel.h>
#import "BaseWebViewController.h"
#import "ReturnUrlTool.h"
#import "UmengShareview.h"
#import "StroyWebViewController.h"
#import "RewardViewController.h"
#import "CalendarPickViewController.h"
#import "NotificationMacro.h"
#import "PGDatePickManager.h"
#import "LoginViewController.h"
#import "CustomerManager.h"
#import "CTAlertView.h"

static NSString *CELLID = @"peopleCell";
static NSString *normalCELLID = @"normalCell";

#define ScrollView_TAG 1234
@interface PeopleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,PGDatePickerDelegate,CTAlertViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIScrollView *contentScrollView;
//@property (nonatomic, strong) UICollectionView *peopleCollectionView;

@property (nonatomic, strong) PeopleHomeView *peopleView;
@property (nonatomic, strong) ContentView *conView;
@property (nonatomic, strong) PeopleInfo *peopleInfo;

@property (nonatomic, strong) UIView *moveView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *botBtn;

@property (nonatomic, assign) BOOL isBegin;

@property (nonatomic, assign) BOOL isShowDetailBtn;

@end

@implementation PeopleViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCalendarPick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTimePick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPeopleGoLogin object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationPayInfoCallBack object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"kuoyi";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self addNavigationTitleView];
    [self getPeopleDataRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToCalendar) name:kCalendarPick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLogin:) name:kPeopleGoLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToTimePick:) name:kTimePick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayCallback:) name:kNotificationPayInfoCallBack object:nil];
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
    
    CGFloat midH = 80;
    CGFloat moveViewHeight = 60;
    if (isiPhoneXScreen) {
        moveViewHeight = 120;
    }
    __weak __typeof(self)weakSelf = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView = [[UIScrollView alloc]init];
    self.contentScrollView.backgroundColor =  [UIColor whiteColor];
    self.contentScrollView.contentSize = CGSizeMake(0, DEVICE_HEIGHT * 2 - midH - statusBarAndNavigationBarHeight * 2 - moveViewHeight - tabbarSafeBottomMargin);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.tag = ScrollView_TAG;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
    }];

    
    self.peopleView = [[PeopleHomeView alloc] initWithInfo:self.peopleInfo];
    self.peopleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - statusBarAndNavigationBarHeight - moveViewHeight);
    [self.contentScrollView addSubview:self.peopleView];
    self.peopleView.storyCallback = ^{
        [weakSelf.conView hideMidView];
        weakSelf.isShowDetailBtn = NO;
    };
    self.peopleView.shareCallback = ^{
        NSString *url =  [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:weakSelf.homeDetail.detailID];
        NSDictionary *data = @{@"shareDesContent":@"测试测试测试测试测试内容内容内容",@"shareDesTitle":@"kuoyi分享",
                               @"shareImageUrl":@"http://192.168.1.12/picnull",@"shareLinkUrl":url};
        UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
        share.UmengShareViewCallback = ^(int i){
            
        };
        [share show];
    };
    self.peopleView.doneEditCallBack = ^{
        //[weakSelf.contentScrollView setContentOffset:CGPointMake(0, 0) ];
        [weakSelf.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    };
    self.peopleView.collectCallBack = ^{
        [weakSelf didCollectRequest:weakSelf.homeDetail.detailID andType:1];
    };
    self.peopleView.praiseCallBack = ^{
        [weakSelf didPraiseRequest:weakSelf.homeDetail.detailID];
    };
    
    self.moveView = [[UIView alloc] init];
    self.moveView.backgroundColor = [UIColor whiteColor];
    self.moveView.frame = CGRectMake(0, self.peopleView.frame.size.height, DEVICE_WIDTH, moveViewHeight);
    [self.contentScrollView addSubview:self.moveView];
    
    self.contentLabel = [self createLabelWithColor:@"3c3c3c" font:15];
    if (self.peopleInfo.info) {
        NSString *str = self.peopleInfo.info;//@"也许骨子里，即将成为一名父亲的他依然是个守旧的人，但是，他已经用当下最大的努力为未来创造最大程度的自由";
        self.contentLabel.attributedText= [self changeLabelStyle:str];
    }else{
        self.contentLabel.text = @"";
    }
    self.contentLabel.numberOfLines = 2;
    [self.moveView addSubview:self.contentLabel];//bot 11
    CGFloat contentTop = 5;
    if (is55InchScreen) {
        contentTop = 0;
    }else if (isiPhoneXScreen){
        contentTop = 10;
    }
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moveView.mas_left).offset(14);
        make.right.equalTo(self.moveView.mas_right).offset(-14);
        make.top.equalTo(self.moveView.mas_top).offset(contentTop);
    }];
    
    self.botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.botBtn setImage:[UIImage imageNamed:@"pulldown"] forState:UIControlStateNormal];
    [self.moveView addSubview:self.botBtn];
    [self.botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moveView.mas_right).offset(-12);
        make.bottom.equalTo(self.moveView.mas_bottom).offset(-5-system_gesture_height);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    self.conView = [[ContentView alloc] initWithData:self.homeDetail andPeopleInfo:self.peopleInfo];
    self.conView.frame = CGRectMake(0, DEVICE_HEIGHT - statusBarAndNavigationBarHeight - moveViewHeight, DEVICE_WIDTH, DEVICE_HEIGHT - midH - statusBarAndNavigationBarHeight - tabbarSafeBottomMargin);
    [self.contentScrollView addSubview:self.conView];
    self.conView.titleBtnCallback = ^{
        [weakSelf.peopleView showDetailImgView];
        weakSelf.isShowDetailBtn = YES;
    };
    self.conView.rewardCallback = ^(NSString *uuid) {
        RewardViewController *vc = [[RewardViewController alloc] init];
        vc.pid = weakSelf.homeDetail.detailID;
        vc.uuid = uuid;
        vc.imgUrl = weakSelf.homeDetail.rewardimg;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    self.conView.getWebDataCallback = ^(NSDictionary *webDic, BOOL isShare) {
        if (isShare) {
            NSString *url =  [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:[webDic[@"id"] integerValue]];
            NSDictionary *data = @{@"shareDesContent":webDic[@"share_info"],@"shareDesTitle":webDic[@"share_title"],
                                   @"shareImageUrl":webDic[@"share_img"],@"shareLinkUrl":url};
            UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
            share.UmengShareViewSuccessCallback = ^(NSInteger index) {
                [weakSelf addShareInfoRequest:index];
            };
            share.UmengShareViewCallback = ^(int i){
                NSLog(@"111111");
            };
            [share show];
        }else{
//            if (![CustomerManager sharedInstance].isLogin) {
//                LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
//
//                    [weakSelf didCollectRequest:[webDic[@"id"] integerValue]];
//                }];
//                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
//            }else{
                [weakSelf didCollectRequest:[webDic[@"id"] integerValue] andType:5];
//            }
        }
    };
    
    [self.contentScrollView sendSubviewToBack:self.conView];
    
}
-(void)addShareInfoRequest:(NSInteger)type{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.share/addShare";
    NSDictionary *params = @{@"type":@(type),@"info":@""};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)didCollectRequest:(NSInteger)did andType:(NSInteger)type{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.collect/addfavorites";//1 代表人 5 代表故事
    NSString *uuid = [CustomerManager sharedInstance].customer.uuid;
    NSDictionary *params = @{@"object_id":@(did),@"user_uid": uuid ? uuid:@"",@"fav_type":@(type)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        if (type == 1) {
            [weakSelf.peopleView updateCollectCount];
        }else if (type == 5){
            
        }
        [HLYHUD showHUDWithMessage:@"收藏成功！" addToView:nil];
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
            }];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
        }else{
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        }
        
    }];
    
}
-(void)didPraiseRequest:(NSInteger)did{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.fabulous/add";//class类型（1人物 2书 3店 4课程 5活动）
      NSString *uuid = [CustomerManager sharedInstance].customer.uuid;
    NSDictionary *params = @{@"id":@(did),@"userid":uuid ? uuid:@"",@"class":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"点赞成功！" addToView:nil];
        [weakSelf.peopleView updateFabulousCount];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if ([dict[@"error"] integerValue] == 401) {
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
            }];
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
        }else{
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        }
    }];
    
    
}
-(void)getPeopleDataRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.People/info";
    NSDictionary *params = @{@"id":@(self.homeDetail.detailID)};
//    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
//        [HLYHUD hideHUDForView:nil];
//        NSLog(@"%@",dict);
//        weakSelf.peopleInfo = [PeopleInfo yy_modelWithJSON:dict[@"data"]];
//        weakSelf.peopleInfo.pid = self.homeDetail.detailID;
//        [weakSelf p_initUI];
//        //[weakSelf.peopleCollectionView reloadData];
//    } FailureBlock:^(NSDictionary *dict) {
//        [HLYHUD hideHUDForView:nil];
//        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
//    }];
    [KYNetService getDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        weakSelf.peopleInfo = [PeopleInfo yy_modelWithJSON:dict[@"data"]];
        weakSelf.peopleInfo.pid = self.homeDetail.detailID;
        [weakSelf p_initUI];
        //[weakSelf.peopleCollectionView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)goToCalendar{
    //@{@"name":self.nameTextfield.text, @"password":self.passWord}
    CalendarPickViewController *vc = [[CalendarPickViewController alloc] init];
    vc.selectCallback = ^(NSString *date) {
        NSLog(@"%@",date);
        [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarGetDate object:@{@"date":date}];

    };
    [self presentViewController:vc animated:YES completion:nil];
  //  [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)goToLogin:(NSNotification *) userinfo{
    BuyType type = [userinfo.object[@"type"] integerValue];
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
        if (type == BuyBook) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBookAddCart object:nil];
        }else if (type == OrderLesson){
            [[NSNotificationCenter defaultCenter] postNotificationName:kBuyLesson object:nil];
        }else if (type == OrderActivity){
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderActivity object:nil];
        }else if (type == OrderSpace){
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrderSpace object:nil];
        }else if (type == BuyGoods){
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoodsAddCart object:nil];
        }
        
    }];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
    
}

-(void)goToTimePick:(NSNotification *) userinfo{
    NSString *isbeginStr = userinfo.object[@"isBegin"];
    if ([isbeginStr isEqualToString:@"1"]) {
        self.isBegin = YES;
    }else{
        self.isBegin = NO;
    }
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTime;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}
-(void)handlePayCallback:(NSNotification *) userinfo{
    NSDictionary *resultDic = userinfo.object[@"resultDic"];
    NSNumber *resultStatus = resultDic[@"resultStatus"];
    if ([resultStatus integerValue] == 9000) {
        CTAlertView *alerView = [[CTAlertView alloc] initWithTitle:@"" Details:@"支付成功!" OkButton:@"确认"];
        alerView.delegate = self;
        [alerView show:self.view];
    }else{
        [HLYHUD showHUDWithMessage:resultDic[@"memo"] addToView:nil];
    }
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
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *time = [NSString stringWithFormat:@"%ld:%ld",(long)dateComponents.hour,(long)dateComponents.minute];
    if (self.isBegin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarGetTime object:@{@"beginTime":time}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kCalendarGetTime object:@{@"endTime":time}];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat totalNum = self.peopleView.frame.size.height - 80;
    if (scrollView.tag == ScrollView_TAG) {
        CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
        if (point.y > 0 ) {
            NSLog(@"------往上滚动 aaa:%f",scrollView.contentOffset.y);
            if (scrollView.contentOffset.y == 0 ) {
                if (self.isShowDetailBtn) {
                     [self.peopleView hideDetailImgView];
                }
                [self.peopleView configureBackViewColor:YES];
                
            }else if (scrollView.contentOffset.y == totalNum){
                self.moveView.alpha = 0;
            }
                
        }else{
            NSLog(@"------往下滚动 bbb:%f",scrollView.contentOffset.y);
            if (scrollView.contentOffset.y > 0 ) {
                if (self.isShowDetailBtn) {
                     [self.peopleView showDetailImgView];
                }
                [self.peopleView configureBackViewColor:NO];
                
            }else{
                self.moveView.alpha = 1;
            }
        }
    }
  
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat totalNum = self.peopleView.frame.size.height - 80;
    if (scrollView.tag == ScrollView_TAG) {
        CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
        if (point.y > 0 ) {
            NSLog(@"------往上00000000 %f",scrollView.contentOffset.y);
            self.moveView.alpha = 1;//(totalNum - scrollView.contentOffset.y) / totalNum;
        }else{
            NSLog(@"------往下11111111 %f  %f",scrollView.contentOffset.y, (totalNum - scrollView.contentOffset.y) / totalNum);
            if (scrollView.contentOffset.y > 0) {
                 self.moveView.alpha = 0;//(totalNum - scrollView.contentOffset.y) / totalNum;
            }
           
        }
    }
    
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
//#pragma mark -- 组数
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//
//
//    return 2;
//
//
//}
//
//#pragma mark -- 个数
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//    return 1;
//
//}
//
//#pragma mark -- 内容
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    __weak __typeof(self)weakSelf = self;
//    if (indexPath.section == 1) {
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:normalCELLID forIndexPath:indexPath];
//        //cell.contentView.backgroundColor = [UIColor colorWithHexString:@"d1ddd6"];
//        ContentView *conView = [[ContentView alloc] initWithData:self.homeDetail andPeopleInfo:self.peopleInfo];
//        [cell.contentView addSubview:conView];
//        [conView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(cell.contentView);
//        }];
//
//        conView.storyCallback = ^{
//            StroyWebViewController *vc = [[StroyWebViewController alloc] init];
//            //BaseWebViewController *vc = [[BaseWebViewController alloc] init];
//            //vc.naviTitle = @"人";
//            vc.urlString = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:self.homeDetail.detailID];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//        return cell;
//    }else{
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath ];
//          //cell.contentView.backgroundColor = [UIColor colorWithHexString:@"d1ccc6"];
//        PeopleHomeView *peopleView = [[PeopleHomeView alloc] initWithInfo:self.peopleInfo];
//        [cell.contentView addSubview:peopleView];
//        [peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(cell.contentView);
//        }];
//        peopleView.storyCallback = ^{
//            StroyWebViewController *vc = [[StroyWebViewController alloc] init];
//            //vc.naviTitle = @"人";
//            vc.urlString = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:self.homeDetail.detailID];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//        peopleView.shareCallback = ^{
//            NSString *url =  [ReturnUrlTool getUrlByWebType:kWebProtocolTypeStory andDetailId:self.homeDetail.detailID];
//            NSDictionary *data = @{@"shareDesContent":@"测试测试测试测试测试内容内容内容",@"shareDesTitle":@"kuoyi分享",
//                                   @"shareImageUrl":@"http://192.168.1.12/picnull",@"shareLinkUrl":url};
//            UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
//            share.UmengShareViewCallback = ^(int i){
//
//            };
//            [share show];
//        };
//        peopleView.doneEditCallBack = ^{
//            [weakSelf.peopleCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//        };
//        return cell;
//    }
//
//
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    return CGSizeMake(0, 0);
//
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 0);
//}
//
//#pragma mark -- 每个collectionView大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    return CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT - statusBarAndNavigationBarHeight);
//
//}
//
//#pragma mark -- collectionView距离上左下右位置设置
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//
//}
//
//
//#pragma mark --  collectionView之间最小列间距
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//    return 0;
//
//
//}
//
//#pragma mark -- collectionView之间最小行间距
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//
//    return 0;
//
//
//}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//
//
//}

@end
