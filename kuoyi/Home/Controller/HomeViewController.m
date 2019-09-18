//
//  HomeViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/22.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "HomeCollectionViewCell.h"
#import <BlocksKit+UIKit.h>
#import "HomeThumbnailCollectionViewCell.h"
#import "PeopleViewController.h"
#import "MineViewController.h"
#import "UINavigationController+WXSTransition.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "HomeInfo.h"
#import <YYModel.h>
#import "HomeDetail.h"
#import "UIImage+Generate.h"
#import "UmengShareview.h"
#import "CustomerManager.h"
#import "LoginViewController.h"
#import "MineVCTransform.h"
#import "UserMarkViewController.h"
#import "NotificationMacro.h"
#import "HotPeopleViewController.h"


#define cellHeight DEVICE_HEIGHT - statusBarAndNavigationBarHeight
#define BUTTON_TAG 1000
#define MENUBTN_HW 50
#define MENUBTN_HW_SMALL 42
static NSString *CELLID = @"homeCell";
static NSString *ThuCELLID = @"thuCell";
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *colBackView;
@property (nonatomic, strong) UICollectionView *homeCollectionView;
/**
 右边菜单
 */
@property (nonatomic, strong) UIView *menuView;
/**
 全选按钮，未选中是大图，选中是缩略图
 */
@property (nonatomic, strong) UIButton *allBtn;

@property (nonatomic, strong) UIView *typeView;

/**
 选中按钮
 */
@property (nonatomic, weak) UIButton *setTypeButton;


@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *disLikeBtn;

@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UILabel *totlaPageLabel;

@property (nonatomic, copy) NSMutableArray *dataArray;

@property (nonatomic, copy) NSArray *backColorArray;
@property (nonatomic, copy) NSArray *titleColorArray;
@property (nonatomic, copy) NSArray *segColorArray;

@property (nonatomic, strong) HomeInfo *homeInfo;

@property (nonatomic, assign) NSInteger btnTypeCount;
@property (nonatomic, copy) NSArray *typeNameArray;

@property (nonatomic, copy) NSArray *menuList;

@property (nonatomic, assign) BOOL isSelectMenu;

@property (nonatomic, strong) MineVCTransform *mineTransform;


@end

@implementation HomeViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHomePageLoad object:nil];;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //self.title = @"kuoyi";
    
//    for (int i = 0; i < 32; i++) {
//        [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_loadData) name:kHomePageLoad object:nil];
    [self p_initUI];
    [self addNavigationTitleView];
    [self p_loadData];
    [self getMenuDataRequest];
    [self getADRequest];
    
//    NSArray *fontFamilys = [UIFont familyNames];
//    for (NSString *familyName in fontFamilys) {
//        NSLog(@"family name : %@",familyName);
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for (NSString *fontName in fontNames) {
//            NSLog(@"font name : %@",fontName);
//        }
//    }
    
}
-(void)setNaviBtn{
    __weak __typeof(self)weakSelf = self;
    self.view.backgroundColor = [UIColor clearColor];
    //left
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 40, 20);
    [self.leftBtn setTitle:@"人物" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"3c3c3c"] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.leftBtn.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    [self.leftBtn bk_addEventHandler:^(id sender) {
        HotPeopleViewController *vc = [[HotPeopleViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];

    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 40, 44);
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *mineImgView = [[UIImageView alloc] init];
    mineImgView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *defaultMineStr;
    if ([CustomerManager sharedInstance].isLogin) {
        defaultMineStr  = [CustomerManager sharedInstance].customer.gender == 2 ? @"minegirl":@"mineboy";
    }else{
        defaultMineStr = @"mineboy";
    }
    mineImgView.image = [UIImage imageNamed:defaultMineStr];
    [self.rightBtn addSubview:mineImgView];
    [mineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rightBtn);
    }];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightBtn bk_addEventHandler:^(id sender) {
        weakSelf.rightBtn.enabled = NO;
        [weakSelf getUserInfoSucess:^{

            [weakSelf goToMineVC];
        } error:^{
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
                //[weakSelf goToMineVC];
            }];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
        }];
        //UserMarkViewController *vc = [[UserMarkViewController alloc] init];
        //[weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}
-(void)goToMineVC{
    
    self.navigationController.delegate = self;
    self.mineTransform.transitionBeforeFrame = CGRectMake(0, -DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.mineTransform.transitionAfterFrame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    //self.mineTransform.transitionBeforeFrame = CGRectMake(DEVICE_WIDTH, 30, DEVICE_WIDTH, DEVICE_HEIGHT - 60);
   // self.mineTransform.transitionAfterFrame = CGRectMake(-DEVICE_WIDTH, 30, DEVICE_WIDTH, DEVICE_HEIGHT - 60);
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.delegate = nil;
    [self setNaviBtn];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // self.navigationController.navigationBar.hidden = YES;
}
- (void) addNavigationTitleView {
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
-(void)p_loadData{
    
     [self getHomeDataRequest:nil];
    
}
/**
 生成界面
 */
-(void)p_initUI{
    //71 414
    CGFloat ww = DEVICE_WIDTH * 0.17;
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
        make.size.width.mas_equalTo(DEVICE_WIDTH * 0.17);
    }];
    //生成菜单
    [self p_initMenuUI];

    self.colBackView = [[UIView alloc] init];
    self.colBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.colBackView];
    [self.colBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.menuView.mas_left);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.homeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.homeCollectionView.backgroundColor = [UIColor whiteColor];
    self.homeCollectionView.showsVerticalScrollIndicator = NO;
    self.homeCollectionView.pagingEnabled = YES;
    self.homeCollectionView.delegate = self;
    self.homeCollectionView.dataSource =self;
    [self.colBackView addSubview:self.homeCollectionView];
    
    [self.homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.colBackView);
    }];
    
    [self.homeCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    [self.homeCollectionView registerClass:[HomeThumbnailCollectionViewCell class] forCellWithReuseIdentifier:ThuCELLID];
    
    [self.homeCollectionView reloadData];
}
-(void)p_initMenuUI{
     __weak __typeof(self)weakSelf = self;
    self.allBtn = [self createBtnWithColor:@"000000" font:10 icon:nil];
    
    NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:@"ALL" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:10]}];
    [self.allBtn setAttributedTitle:titleAttribute forState:UIControlStateNormal];
   // [self.allBtn setTitle:@"ALL" forState:UIControlStateNormal];
    self.allBtn.selected = NO;
    [self.allBtn setImage:[UIImage imageNamed:@"all"] forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"all_selected"] forState:UIControlStateSelected];
    [self.menuView addSubview:self.allBtn];
    if (is55InchScreen) {
        self.allBtn.titleEdgeInsets = UIEdgeInsetsMake(MENUBTN_HW ,-MENUBTN_HW+10, 0,0);
        self.allBtn.imageEdgeInsets = UIEdgeInsetsMake(-9 ,5, 0,0);
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuView.mas_top).offset(34);
            //make.centerX.equalTo(self.menuView.mas_centerX);
            make.right.equalTo(self.menuView.mas_right).offset(-14);
            make.size.mas_equalTo(CGSizeMake(54, 54 + 10));
        }];
    }else{
        self.allBtn.titleEdgeInsets = UIEdgeInsetsMake(MENUBTN_HW_SMALL ,-MENUBTN_HW_SMALL+8, 0,0);
        self.allBtn.imageEdgeInsets = UIEdgeInsetsMake(-9 ,5, 7,-7);//(-15 ,11, 0,0)
        [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuView.mas_top).offset(34);
            //make.centerX.equalTo(self.menuView.mas_centerX);
            make.left.equalTo(self.menuView.mas_left).offset(2);
            make.size.mas_equalTo(CGSizeMake(MENUBTN_HW_SMALL-2, MENUBTN_HW_SMALL + 6));
        }];
    }
   
    [self.allBtn bk_addEventHandler:^(id sender) {
        
        //点击all 切换大小 并刷新数据
        //
        
        weakSelf.setTypeButton.backgroundColor = [UIColor whiteColor];
        weakSelf.allBtn.selected = !weakSelf.allBtn.selected;
        
        if (weakSelf.isSelectMenu) {
            [weakSelf getHomeDataRequest:nil];
            [weakSelf setTypeBtn:nil];
        }else{
            [weakSelf.homeCollectionView reloadData];
            [weakSelf.homeCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        weakSelf.isSelectMenu = NO;
        [weakSelf clearLikeOrDisLikeBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    //生成类型btn
  
    
    CGFloat typeBtnHW = MENUBTN_HW_SMALL;
    if (is55InchScreen) {
        typeBtnHW = MENUBTN_HW;
    }
    self.typeView = [[UIView alloc] init];
    self.typeView.backgroundColor = [UIColor whiteColor];
    [self.menuView addSubview:self.typeView];
    self.typeView.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
    self.typeView.layer.borderWidth = 2;
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.allBtn.mas_bottom).offset(13);
        //make.centerX.equalTo(self.menuView.mas_centerX);
        make.left.equalTo(self.menuView.mas_left).offset(7);
        make.size.mas_equalTo(CGSizeMake(typeBtnHW, typeBtnHW * self.btnTypeCount));
    }];
    //NSInteger btnCount = 3;
    //NSArray *nameArray = @[@"宅男\n27",@"慢作\n8",@"好玩\n10"];

    //生成同路陌路btn
    [self p_initSelectBtn];
    //生成page统计
    self.totlaPageLabel = [[UILabel alloc] init];
    self.totlaPageLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
    self.totlaPageLabel.textAlignment = NSTextAlignmentLeft;
    
    self.totlaPageLabel.attributedText = [self totalPageTextAttribute:@"0"];
    self.totlaPageLabel.transform = CGAffineTransformRotate(self.totlaPageLabel.transform, M_PI/2);
    [self.menuView addSubview:self.totlaPageLabel];
    [self.totlaPageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.menuView.mas_bottom).offset(-10);
        make.centerX.equalTo(self.menuView.mas_centerX).offset(-11);
        make.size.mas_equalTo(CGSizeMake(100, DEVICE_WIDTH * 0.17 -30 ));
    }];
    
    UIImageView *segImgView = [[UIImageView alloc] init];
    segImgView.image = [UIImage imageNamed:@"线"];
    [self.menuView addSubview:segImgView];
    [segImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.menuView.mas_bottom).offset(-80);
        make.left.equalTo(self.menuView.mas_left).offset(9);
        make.size.mas_equalTo(CGSizeMake(15, 26));
    }];
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
    self.pageLabel.font = [UIFont boldSystemFontOfSize:15];
   // self.pageLabel.text = @"1/50 <";
    self.pageLabel.textAlignment = NSTextAlignmentRight;
    self.pageLabel.attributedText = [self pageTextAttribute:@"0"];
    self.pageLabel.transform = CGAffineTransformRotate(self.pageLabel.transform, M_PI/2);
    [self.menuView addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(segImgView.mas_top).offset(-30);
        make.centerX.equalTo(self.menuView.mas_centerX).offset(-5);
        //make.left.equalTo(self.menuView.mas_left).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, DEVICE_WIDTH * 0.17));
    }];
    
    UIImageView *pulldownImgView = [[UIImageView alloc] init];
    pulldownImgView.contentMode = UIViewContentModeScaleAspectFit;
    pulldownImgView.image = [UIImage imageNamed:@"pulldown"];
    [self.menuView addSubview:pulldownImgView];
    [pulldownImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.menuView.mas_bottom).offset(-21);
       // make.centerX.equalTo(self.menuView.mas_centerX);
        make.left.equalTo(self.menuView.mas_left).offset(11);
        
    }];
    
    
}
-(void)p_initTypeBtn{
    CGFloat typeBtnHW = MENUBTN_HW_SMALL;
    if (is55InchScreen) {
        typeBtnHW = MENUBTN_HW;
    }
    [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(typeBtnHW, typeBtnHW * self.btnTypeCount));
    }];
    if (self.btnTypeCount < 2) {
        UIButton *btn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
        btn.tag = BUTTON_TAG;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //[btn setTitle:self.typeNameArray[0] forState:UIControlStateNormal];
        NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:self.typeNameArray[0] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
         [btn setAttributedTitle:titleAttribute forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.typeView);
        }];
    }else{
        NSMutableArray *btnsArray = [NSMutableArray array];
        for (int i = 0 ; i < self.btnTypeCount; i++) {
            UIButton *btn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
            NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:self.typeNameArray[i] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
            btn.tag = BUTTON_TAG + i;
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
            [btn setAttributedTitle:titleAttribute forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.typeView addSubview:btn];
            [btnsArray addObject:btn];
        }
        [btnsArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [btnsArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(typeBtnHW);
            make.left.equalTo(self.typeView.mas_left);
        }];
    }
   
    //生成分割线
    for (int i = 0; i < self.btnTypeCount; i++) {
        if (i != self.btnTypeCount - 1) {
            UIView *segView = [[UIView alloc] init];
            segView.backgroundColor = [UIColor colorWithHexString:@"0000ff"];
            [self.typeView addSubview:segView];
            [segView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.typeView);
                make.size.height.mas_equalTo(2);
                make.top.equalTo(self.typeView.mas_top).offset(typeBtnHW * (i+1));
            }];
        }
    }
    
}
-(void)p_initSelectBtn{
    CGFloat typeBtnHW = MENUBTN_HW_SMALL;
    if (is55InchScreen) {
        typeBtnHW = MENUBTN_HW;
    }
    __weak __typeof(self)weakSelf = self;
    //CGFloat btnHW = 60;
    self.likeBtn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
    NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:@"同路" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
    [self.likeBtn setAttributedTitle:titleAttribute forState:UIControlStateNormal];
   // [self.likeBtn setTitle:@"同路" forState:UIControlStateNormal];
    self.likeBtn.layer.cornerRadius = typeBtnHW /2;
    self.likeBtn.layer.borderWidth = 2;
    self.likeBtn.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
    [self.menuView addSubview:self.likeBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeView.mas_bottom).offset(25);
       // make.centerX.equalTo(self.menuView.mas_centerX);
        make.left.equalTo(self.menuView.mas_left).offset(7);
        make.size.mas_equalTo(CGSizeMake(typeBtnHW, typeBtnHW));
    }];
    [self.likeBtn bk_addEventHandler:^(id sender) {
        weakSelf.likeBtn.selected = !weakSelf.likeBtn.selected;
         weakSelf.likeBtn.backgroundColor = [UIColor colorWithHexString:@"c4d6fe"];
        
        weakSelf.disLikeBtn.backgroundColor = [UIColor whiteColor];
        weakSelf.disLikeBtn.selected = NO;
        
        weakSelf.isSelectMenu = YES;
        if ([CustomerManager sharedInstance].isLogin) {
            if ([[CustomerManager sharedInstance].customer.lable_ids isEqualToString:@""]) {
                UserMarkViewController *vc = [[UserMarkViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                weakSelf.isSelectMenu = YES;
                [self getHomeDadaByLabelType:@"1" andLabel:[CustomerManager sharedInstance].customer.lable_ids];
            }
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
            }];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
        }
       
    } forControlEvents:UIControlEventTouchUpInside];
    //18 13
    self.disLikeBtn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
    NSAttributedString *distitleAttribute = [[NSAttributedString alloc] initWithString:@"陌路" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
    [self.disLikeBtn setAttributedTitle:distitleAttribute forState:UIControlStateNormal];
   // [self.disLikeBtn setTitle:@"陌路" forState:UIControlStateNormal];
    self.disLikeBtn.layer.cornerRadius = typeBtnHW /2;
    self.disLikeBtn.layer.borderWidth = 2;
    self.disLikeBtn.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
    [self.menuView addSubview:self.disLikeBtn];
    [self.disLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeBtn.mas_bottom).offset(5);
        //make.centerX.equalTo(self.menuView.mas_centerX);
        make.left.equalTo(self.menuView.mas_left).offset(7);
        make.size.mas_equalTo(CGSizeMake(typeBtnHW, typeBtnHW));
    }];
    [self.disLikeBtn bk_addEventHandler:^(id sender) {
        weakSelf.disLikeBtn.selected = !weakSelf.disLikeBtn.selected;
         weakSelf.disLikeBtn.backgroundColor = [UIColor colorWithHexString:@"c4d6fe"];
        
        weakSelf.likeBtn.backgroundColor = [UIColor whiteColor];
        weakSelf.likeBtn.selected = NO;
        
        if ([CustomerManager sharedInstance].isLogin) {
            if ([[CustomerManager sharedInstance].customer.lable_ids isEqualToString:@""]) {
                UserMarkViewController *vc = [[UserMarkViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                weakSelf.isSelectMenu = YES;
                [weakSelf getHomeDadaByLabelType:@"2" andLabel:[CustomerManager sharedInstance].customer.lable_ids];
            }
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginSuccessBlock:^{
            }];
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES  completion:nil];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}
// 选中按钮
- (void)setTypeBtn:(UIButton *)btn
{
    self.setTypeButton.backgroundColor = [UIColor whiteColor];
    self.setTypeButton.transform = CGAffineTransformIdentity;
    if (btn) {
        btn.backgroundColor = [UIColor colorWithHexString:@"fec7c7"];
        btn.transform = CGAffineTransformMakeScale(1, 1);
    }
    self.setTypeButton = btn;
}
-(void)clearLikeOrDisLikeBtn{
    
    self.disLikeBtn.backgroundColor = [UIColor whiteColor];
    self.disLikeBtn.selected = NO;
    
    self.likeBtn.backgroundColor = [UIColor whiteColor];
    self.likeBtn.selected = NO;
    
}
#pragma mark Request
-(void)getHomeDataRequest:(NSString *)classid{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.People";
    NSDictionary *params;
    if (classid) {
        params = @{@"classid":classid,@"pagesize":@"10",@"ispage":@"false"};
    }else{
        params = @{@"classid":@"0",@"pagesize":@"10",@"ispage":@"false"};//添加
    }
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        weakSelf.homeInfo = [HomeInfo yy_modelWithJSON:dict];
        weakSelf.dataArray = [weakSelf.homeInfo.list mutableCopy];
        weakSelf.totlaPageLabel.attributedText = [weakSelf totalPageTextAttribute:[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.dataArray.count]];
        [weakSelf.homeCollectionView reloadData];
        [weakSelf.homeCollectionView setContentOffset:CGPointMake(0,0) animated:NO];
        if (weakSelf.dataArray.count > 0) {
               weakSelf.pageLabel.attributedText = [self pageTextAttribute:@"1"];
        }else{
               weakSelf.pageLabel.attributedText = [self pageTextAttribute:@"0"];
        }
     
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getHomeDadaByLabelType:(NSString *)type andLabel:(NSString *)userLabel{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.People";
    NSDictionary *params;
    //type: 1是同路  2是陌路
    params = @{@"type":type,@"labile":userLabel ,@"pagesize":@"10",@"ispage":@"false"};//添加
    
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        weakSelf.homeInfo = [HomeInfo yy_modelWithJSON:dict];
        weakSelf.dataArray = [weakSelf.homeInfo.list mutableCopy];
        weakSelf.totlaPageLabel.attributedText = [weakSelf totalPageTextAttribute:[NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.dataArray.count]];
        [weakSelf.homeCollectionView reloadData];
        [weakSelf.homeCollectionView setContentOffset:CGPointMake(0,0) animated:NO];
        if (weakSelf.dataArray.count > 0) {
            weakSelf.pageLabel.attributedText = [self pageTextAttribute:@"1"];
        }else{
            weakSelf.pageLabel.attributedText = [self pageTextAttribute:@"0"];
        }
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getMenuDataRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.People/classList";
    NSDictionary *params = @{};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        //NSInteger btnCount = 3;
        //NSArray *nameArray = @[@"宅男\n27",@"慢作\n8",@"好玩\n10"];
        weakSelf.btnTypeCount = 0;
        if (dict[@"list"] && [dict[@"list"] count] > 0) {
           weakSelf.btnTypeCount = [dict[@"list"] count];
            NSMutableArray *mArr = [NSMutableArray array];
            for (int i = 0; i < weakSelf.btnTypeCount; i++) {
                NSString *name = [NSString stringWithFormat:@"%@\n%@",dict[@"list"][i][@"title"],dict[@"list"][i][@"num"]];
                [mArr addObject:name];
            }
            weakSelf.typeNameArray = [mArr copy];
            //生成类型btn
            [weakSelf p_initTypeBtn];
        }
        self.menuList = dict[@"list"];
        NSLog(@"%@",dict);
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)didCollectRequest:(NSInteger)did andIndex:(NSInteger)index{
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.collect/addfavorites";//1 代表人 5 代表故事
    NSString *uuid = [CustomerManager sharedInstance].customer.uuid;
    NSDictionary *params = @{@"object_id":@(did),@"user_uid": uuid ? uuid:@"",@"fav_type":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
         NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        HomeDetail *detail = weakSelf.homeInfo.list[index];
        //detail.is_collection++;
        detail.is_collection = [dict[@"type"] integerValue];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.homeCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
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
    NSDictionary *params = @{@"id":@(did),@"userid":@"1",@"class":@"1"};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"点赞成功！" addToView:nil];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}

-(void)getADRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.advert/getList";
    NSDictionary *params = @{@"type":@"2"};
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
           NSLog(@"%@",dict);
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)addShareInfoRequest:(NSInteger)type :(NSString *)shareStr{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.share/addShare";//class类型（1人物 2书 3店 4课程 5活动）
    NSDictionary *params = @{@"type":@(type),@"info":shareStr,@"id":@""};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getUserInfoSucess:(void(^)(void))sucess error:(void(^)(void))error{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.user/getInfo";
    [KYNetService GetHttpDataWithUrlStr:url Dic:@{} SuccessBlock:^(NSDictionary *dict) {
        weakSelf.rightBtn.enabled = YES;
        if (sucess) {
            sucess();
        }
    
    } FailureBlock:^(NSDictionary *dict) {
        weakSelf.rightBtn.enabled = YES;
        if ([dict[@"error"] integerValue] == 401) {
            if (error) {
                error();
            }
        }else{
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        }
       
    }];
}
#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return self.mineTransform;
        
    }else if (operation == UINavigationControllerOperationPop){
        return self.mineTransform;
    }
    return nil;
    
    
}
#pragma mark target
-(void)titleBtnClick:(UIButton *)btn{
    self.isSelectMenu = YES;//!self.isSelectMenu;
    [self setTypeBtn:btn];
    NSInteger typeId = [self.menuList[btn.tag - BUTTON_TAG][@"id"] integerValue];
    [self getHomeDataRequest:[NSString stringWithFormat:@"%ld",(long)typeId]];
    [self clearLikeOrDisLikeBtn];
    
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.allBtn.isSelected) {
        
        NSInteger count = self.dataArray.count;
        if (count % 8 == 0) {
            count = count / 8;
        }else{
            count = count / 8 + 1;
        }
        
        return count;
        
//        if (self.dataArray.count / 8 == 0) {
//            return 1;
//        }
//        return self.dataArray.count / 8 + 1;
    }else{
        return 1;
    }
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.allBtn.isSelected) {
        
         NSInteger count = self.dataArray.count;
        if (section == count/8) {
            return count % 8;
        }else{
            return 8;
        }
        
        
//        NSInteger count = self.dataArray.count;
//        if (count / 8 == 0) {
//            return count % 8;
//        }
//        return 8;
        
    }else{
       return self.dataArray.count;
    }
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //type @[1,3,4]
    
    __weak __typeof(self)weakSelf = self;
    if (self.allBtn.isSelected) {
        NSInteger index = indexPath.row + indexPath.section * 8;
        HomeDetail *detail = self.homeInfo.list[index];
        HomeThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ThuCELLID forIndexPath:indexPath ];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *rowNum;
        NSString *titleColorStr;
        NSString *segColorStr;
        //type  book 1,space 2, lesson 3,activity 4, article 5
        if (indexPath.row == 0 || indexPath.row == 1){
            rowNum = @"0";
        }else if (indexPath.row == 2 || indexPath.row == 3){
             rowNum = @"1";
        }else if (indexPath.row == 4 || indexPath.row == 5){
             rowNum = @"2";
        }else{
             rowNum = @"3";
        }
         NSArray *typeArray = [self getImgArray:detail];
        if (indexPath.section % 3 ==0) {
           
            NSMutableArray *imgTypeArray = [NSMutableArray array];
            for (int i = 0; i < typeArray.count; i++) {
                NSString *imgName = [NSString stringWithFormat:@"0_%@_%@",rowNum,typeArray[i]];
                [imgTypeArray addObject:imgName];
            }
            [dic setObject:imgTypeArray forKey:@"type"];
            NSString *colorStr = self.backColorArray[0][indexPath.row];
            titleColorStr = self.titleColorArray[0][indexPath.row];
              segColorStr = self.segColorArray[0][indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:colorStr];
        }else if (indexPath.section % 3 == 1){
            //NSArray *typeArray = @[@"1",@"2",@"3",@"4",@"5"];
            NSMutableArray *imgTypeArray = [NSMutableArray array];
            for (int i = 0; i < typeArray.count; i++) {
                NSString *imgName = [NSString stringWithFormat:@"1_%@_%@",rowNum,typeArray[i]];
                [imgTypeArray addObject:imgName];
            }
            [dic setObject:imgTypeArray forKey:@"type"];
            NSString *colorStr = self.backColorArray[1][indexPath.row];
             titleColorStr = self.titleColorArray[1][indexPath.row];
              segColorStr = self.segColorArray[1][indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:colorStr];
        }else{
            //NSArray *typeArray = @[@"1",@"3",@"5"];
            NSMutableArray *imgTypeArray = [NSMutableArray array];
            for (int i = 0; i < typeArray.count; i++) {
                NSString *imgName = [NSString stringWithFormat:@"2_%@_%@",rowNum,typeArray[i]];
                [imgTypeArray addObject:imgName];
            }
            [dic setObject:imgTypeArray forKey:@"type"];
            NSString *colorStr = self.backColorArray[2][indexPath.row];
            titleColorStr = self.titleColorArray[2][indexPath.row];
            segColorStr = self.segColorArray[2][indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithHexString:colorStr];
        }
       
        [cell configeData:detail andDic:dic];
        [cell configureCellColor:titleColorStr andSegColor:segColorStr];
        return cell;
    }else{
        HomeDetail *detail = self.homeInfo.list[indexPath.row];
        
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath ];
        [cell configeData:detail];
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        cell.clickCallBack = ^{
            [weakSelf pushToPeople:detail];
        };
        cell.shareClickBack = ^(NSString *shareStr) {
             [weakSelf shareMyScreen:shareStr];
        };
        cell.collcetClickBack = ^{
            [weakSelf didCollectRequest:detail.detailID andIndex:indexPath.row];
        };
        cell.praiseClickBack = ^{
          // [weakSelf didPraiseRequest:detail.detailID];
        };
        cell.doneEditCallBack = ^(NSString *shareStr) {
            CGFloat offY = indexPath.row * (DEVICE_HEIGHT - statusBarAndNavigationBarHeight);
            [weakSelf.homeCollectionView setContentOffset:CGPointMake(0, offY)];
            //[weakSelf.homeCollectionView setContentOffset:CGPointMake(0, offY) animated:YES];
            [weakSelf shareMyScreen:shareStr];
        };
        return cell;
    }


}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.allBtn.isSelected) {
        return CGSizeMake(DEVICE_WIDTH * 0.83, 20);
    }
    return CGSizeMake(0, 0);
}

#pragma mark -- 每个collectionView大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.allBtn.isSelected) {
        CGFloat width = (DEVICE_WIDTH * 0.83 - AdaptedWidthValue(14)*2) / 2;
        CGFloat height = (DEVICE_HEIGHT - statusBarAndNavigationBarHeight - 20 - AdaptedHeightValue(8)*4) / 4;
        return CGSizeMake(width,height);
    }else{
       return CGSizeMake(DEVICE_WIDTH * 0.83, DEVICE_HEIGHT - statusBarAndNavigationBarHeight);
    }
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.allBtn.isSelected) {//20  13
        
        return UIEdgeInsetsMake(AdaptedHeightValue(8), AdaptedWidthValue(14),0,0);
    }else{
        
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (self.allBtn.isSelected) {
         return AdaptedWidthValue(14);
    }else{
       return 0;
    }
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.allBtn.isSelected) {
         return AdaptedHeightValue(8);
    }else{
       return 0;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.allBtn.isSelected) {
        NSInteger index = indexPath.row + indexPath.section * 8;
        HomeDetail *detail = self.homeInfo.list[index];
        [self pushToPeople:detail];
        
    }
   
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat hh = DEVICE_HEIGHT - statusBarAndNavigationBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSInteger page = offsetY / hh ;
    NSLog(@"%f   %f   %ld",offsetY,hh , (long)page);
    self.pageLabel.attributedText = [self pageTextAttribute:[NSString stringWithFormat:@"%ld",page + 1]];
//    if (page == 2) {
//        [self.dataArray addObject:@"1"];
//    }
//    [self.homeCollectionView reloadData];
}
-(void)pushToPeople:(HomeDetail *)data{
    
    PeopleViewController *vc = [[PeopleViewController alloc] init];
    vc.homeDetail = data;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)shareMyScreen:(NSString *)shareStr{
    __weak __typeof(self)weakSelf = self;
    //截屏分享
    UIImage *testImg = [self convertImageFromView:self.colBackView];
    UIImage *smallImg = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, DEVICE_WIDTH * 0.83, statusBarAndNavigationBarHeight)];
    UIImage *shareImg = [self getImage:smallImg addToBigImage:testImg];
    // UIImageWriteToSavedPhotosAlbum(testImg, self, nil, nil);
    UmengShareview *share = [[UmengShareview alloc] initWithImage:shareImg];
    share.UmengShareViewCallback = ^(int i){
        NSLog(@"111111");
    };
    share.UmengShareViewSuccessCallback = ^(NSInteger index) {

        [weakSelf addShareInfoRequest:index :shareStr];
    };
    [share show];
    
}

//截屏
- (UIImage*)convertImageFromView:(UIView *)view{
    
    
    //不加scale图片截屏会模糊
    CGFloat width = view.bounds.size.width;
    CGFloat height = view.bounds.size.height;

    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height),NO, [UIScreen mainScreen].scale);
    
    //绘制图形上下文
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    CGRect r = CGRectMake(0,0,width,height);
    UIRectClip(r);
    [view.layer renderInContext:ref];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
    
}

- (UIImage *)getImage:(UIImage *)smallImage addToBigImage:(UIImage *)bigImage{
    
    
   // CGSize size = CGSizeMake(bigImage.size.width, bigImage.size.height + statusBarAndNavigationBarHeight);
    CGSize size = CGSizeMake(DEVICE_WIDTH,DEVICE_HEIGHT);
    
    // UIGraphicsBeginImageContext(size);
    
    CGFloat off_X = DEVICE_WIDTH * 0.1;
    UIGraphicsBeginImageContextWithOptions(size,NO, [UIScreen mainScreen].scale);
    
    [bigImage drawInRect:CGRectMake(off_X, 0, bigImage.size.width, bigImage.size.height)];
    
    [smallImage drawInRect:CGRectMake(off_X,  bigImage.size.height, smallImage.size.width, smallImage.size.height)];
    
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
    
}

-(NSArray *)getImgArray:(HomeDetail *)detail{
    
    NSMutableArray *mArr = [NSMutableArray array];
    // = @[@"homebook",@"homespace",@"homelesson",@"homeactivity",@"homearticle"];
    [mArr addObject:@"0"];
    if (detail.isbook) {
        [mArr addObject:@"1"];
    }
    if (detail.isspace) {
        [mArr addObject:@"2"];
    }
    if (detail.iscurriculum) {
        [mArr addObject:@"3"];
    }
    if (detail.isactivity) {
        [mArr addObject:@"4"];
    }
    if (detail.isproduct) {
        [mArr addObject:@"5"];
    }
    return [mArr copy];
    
}
- (UIImage *)imageWithColor:(UIColor *)aColor Rect:(CGRect)aRect {
    
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
- (NSAttributedString *) pageTextAttribute:(NSString *) purStr
{
//    加粗;
//    [UILabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
//    加粗并且倾斜
//    [UILabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:20]];
    NSAttributedString *priceAttribute = [[NSAttributedString alloc] initWithString:purStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-light" size:65]}];
    return priceAttribute;
    
}
- (NSAttributedString *) totalPageTextAttribute:(NSString *)totalStr{
    //[UIFont fontWithName:@"Helvetica-Oblique" size:35]  [UIFont fontWithName:@"Helvetica-Bold" size:35]
    //NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:@" / " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:35]}];
                                                                                                                      
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:totalStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:35]}];
  //  [priceAttribute appendAttributedString:endAttribute];
    
//    NSAttributedString *iconAttribute = [[NSAttributedString alloc] initWithString:@" <" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    [priceAttribute appendAttributedString:iconAttribute];
    
    return endAttribute;
}
#pragma mark setter
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font icon:(NSString *)icon{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    if (icon) {
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    
    return btn;
    
}

-(NSArray *)titleColorArray{
    
    if (!_titleColorArray) {
        _titleColorArray = @[@[@"3d4433",@"3d4433",@"364838",@"364838",@"3c4d47",@"3c4d47",@"473c36",@"473c36"],
                             @[@"503d2f",@"503d2f",@"503836",@"503836",@"364838",@"364838",@"5a526a",@"5a526a"],
                             @[@"2f474c",@"2f474c",@"5b4f5e",@"5b4f5e",@"634851",@"634851",@"4f5173",@"4f5173"]
                             ];
    }
    return _titleColorArray;
}
-(NSArray *)segColorArray{//18
    
    if (!_segColorArray) {
        _segColorArray = @[@[@"d5dace",@"d5dace",@"bcc8be",@"bcc8be",@"bbc9c5",@"bbc9c5",@"bdb3ac",@"bdb3ac"],
                             @[@"dbc3b6",@"dbc3b6",@"dac1bf",@"dac1bf",@"c5b9bd",@"c5b9bd",@"b9b5c1",@"b9b5c1"],
                             @[@"87a5ae",@"87a5ae",@"aea5b2",@"aea5b2",@"b7abb1",@"b7abb1",@"8c8cab",@"8c8cab"]
                             ];
    }
    return _segColorArray;
    
}
-(NSArray *)backColorArray{
    
    if (!_backColorArray) {
        _backColorArray = @[@[@"e7eae3",@"e7eae3",
                              @"d3ddd5",@"d3ddd5",
                              @"d3dcd9",@"d3dcd9",
                              @"d4cdc7",@"d4cdc7"],
                            @[@"e7d4c6",@"e7d4c6",
                              @"e8d3d2",@"e8d3d2",
                              @"dcd6d8",@"dcd6d8",
                              @"d2cfd8",@"d2cfd8"],
                            @[@"adcfd8",@"adcfd8",
                              @"d3ccd6",@"d3ccd6",
                              @"c8c2c5",@"c8c2c5",
                              @"a6a6c3",@"a6a6c3"]
                            ];
    }
    return _backColorArray;
    
}
-(MineVCTransform *)mineTransform{
    
    if (!_mineTransform) {
        _mineTransform = [[MineVCTransform alloc] init];
    }
    
    return _mineTransform;
    
}
@end
