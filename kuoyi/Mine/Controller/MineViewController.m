//
//  MineViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/28.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MineViewController.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "SettingViewController.h"
#import "UINavigationController+WXSTransition.h"
#import "UmengShareview.h"
#import "BaseWebView.h"
#import "UIColor+TPColor.h"
#import "UtilsMacro.h"
#import "UIImage+Generate.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "TalkPeopleViewController.h"
#import "StoryCollectViewController.h"
#import "OccupySpaceViewController.h"
#import "MyLessonViewController.h"
#import "MyActivityViewController.h"
#import "MessageiewController.h"
#import "ShopCartViewController.h"
#import "ManageAddressViewController.h"
#import "MyOrderViewController.h"
#import "CustomerManager.h"
#import <UIImageView+WebCache.h>
#import "NotificationMacro.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "MineVCTransform.h"


static NSString *CELLID = @"mineCell";
@interface MineViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *rightBtn;


@property (nonatomic, strong) UIView *midView;

@property (nonatomic, strong) UIView *redView;

@property (nonatomic, strong) UIView *avatorBackView;
@property (nonatomic, strong) UIImageView *avatorImgView;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) UIImageView *levelImgView;

@property (nonatomic, strong) UIView *staticView; //38 210
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;


@property (nonatomic, strong) UITableView *mineTableView;

@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) BaseWebView *webView;

@property (nonatomic, copy) NSArray *dataSourceArray;
@property (nonatomic, copy) NSArray *dataSourceImgArray;
@property (nonatomic, copy) NSArray *midImgArray;
@property (nonatomic, copy) NSArray *midNameArray;

@property (nonatomic, strong) MineVCTransform *mineTransform;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.dataSourceArray = @[@[@"我的课程"],@[@"我的活动"],@[@"购物车",@"我的订单",@"地址管理"]];
    self.dataSourceImgArray = @[@[@"minelesson"],@[@"mineactivity"],@[@"shopcar",@"mineorder",@"mineaddress"]];
    self.midNameArray = @[@"可聊的人",@"故事收藏",@"占领空间",@"提醒"];
    self.midImgArray = @[@"talk",@"story",@"minespace",@"remind"];
    [self p_initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImg) name:kNotificationUpdateHeadImg object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
        self.navigationController.delegate = nil;
    [self getUserInfoRequest];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
      self.navigationController.navigationBar.hidden = NO;
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUpdateHeadImg object:nil];
    
}
-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
//topView
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"6d6e70"];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(statusBarHeight);
        make.size.height.mas_equalTo(navigationBarHeight);
    }];
    self.nameLabel = [self createLabelWithColor:@"ffffff" font:18];

    [self.topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
    }];
    
    //right
    UIImage *rightButtonIcon = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [self.rightBtn setImage:rightButtonIcon forState:UIControlStateNormal];
    [self.rightBtn bk_addEventHandler:^(id sender) {
        [weakSelf goToSetting];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-14);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    
    UIImageView *addShareImgView = [[UIImageView alloc] init];
    addShareImgView.image = [UIImage imageNamed:@"addshare"];
    addShareImgView.contentMode = UIViewContentModeScaleAspectFit;
    addShareImgView.userInteractionEnabled = YES;
    [self.topView addSubview:addShareImgView];
    [addShareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [addShareImgView bk_whenTapped:^{
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
        [weakSelf shareBtnHandled];
    }];
    
//midView
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.midView];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.size.height.mas_equalTo(250);//178
    }];
    
    self.avatorBackView = [[UIView alloc] init];
    self.avatorBackView.backgroundColor = [UIColor whiteColor];
    self.avatorBackView.layer.cornerRadius = 35;
    [self.midView addSubview:self.avatorBackView];
    [self.avatorBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_top).offset(19);
        make.centerX.equalTo(self.midView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [self.avatorBackView bk_whenTapped:^{
        if ([CustomerManager sharedInstance].isLogin) {
            UserInfoViewController *vc = [[UserInfoViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
     
    }];
    self.avatorImgView = [[UIImageView alloc] init];
    //self.avatorImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatorImgView.layer.cornerRadius = 33;
    self.avatorImgView.layer.masksToBounds = YES;
    [self.avatorBackView addSubview:self.avatorImgView];
    [self.avatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatorBackView);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    [self updateHeadImg];
    //61 61   c3d2d8
    
    UIView *camaraBackView = [[UIView alloc] init];
    camaraBackView.backgroundColor = [UIColor colorWithHexString:@"c3d2d8"];
    camaraBackView.layer.cornerRadius = 10;
    [self.midView addSubview:camaraBackView];
    [camaraBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.avatorBackView.mas_right);
        make.bottom.equalTo(self.avatorBackView.mas_bottom);
    }];
    
    UIImageView *cmrImgView = [[UIImageView alloc] init];
    cmrImgView.image = [UIImage imageNamed:@"headphoto"];
    [camaraBackView addSubview:cmrImgView];
    [cmrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(camaraBackView);
    }];
    
    self.levelImgView = [[UIImageView alloc] init];
    self.levelImgView.image = [UIImage imageNamed:@"levelcolor"];
    self.levelImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.midView addSubview:self.levelImgView];
    [self.levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.midView.mas_centerX);
        make.top.equalTo(self.avatorBackView.mas_bottom).offset(9);
       // make.size.mas_equalTo(CGSizeMake(38, 30));
    }];
    
    self.staticView = [[UIView alloc] init];
    self.staticView.backgroundColor = [UIColor whiteColor];
    self.staticView.layer.cornerRadius = 19;
    self.staticView.layer.borderWidth = 1;
    self.staticView.layer.borderColor = [UIColor colorWithHexString:@"c4d2d6"].CGColor;
    [self.midView addSubview:self.staticView];

    [self.staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.midView.mas_centerX);
        make.top.equalTo(self.levelImgView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(210, 38));
    }];
    
    self.praiseBtn = [self createBtnWithColor:@"000000" font:11 icon:nil];
    self.praiseBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.praiseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld\n点赞",(long)[CustomerManager sharedInstance].customer.fabulous] forState:UIControlStateNormal];
    [self.staticView addSubview:self.praiseBtn];//数字13大小
    
    
    self.commentBtn = [self createBtnWithColor:@"000000" font:11 icon:nil];
    self.commentBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld\n评论",(long)[CustomerManager sharedInstance].customer.danmu_len] forState:UIControlStateNormal];
    [self.staticView addSubview:self.commentBtn];
    
    self.shareBtn = [self createBtnWithColor:@"000000" font:11 icon:nil];
    self.shareBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld\n分享",(long)[CustomerManager sharedInstance].customer.share] forState:UIControlStateNormal];
    [self.staticView addSubview:self.shareBtn];
    
    CGFloat labelWidth = 210/3;
    NSArray *labelsArray = @[self.praiseBtn,self.commentBtn,self.shareBtn];
    [labelsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [labelsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labelWidth);
        make.size.height.mas_equalTo(38);
        make.top.equalTo(self.staticView.mas_top);
    }];
    
    
    UIView *segViewA = [[UIView alloc] init];
    segViewA.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.commentBtn addSubview:segViewA];
    [segViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentBtn.mas_left);
        make.size.width.mas_equalTo(1);
        make.top.equalTo(self.commentBtn.mas_top).offset(5);
        make.bottom.equalTo(self.commentBtn.mas_bottom).offset(-5);
    }];
    
    UIView *segViewB = [[UIView alloc] init];
    segViewB.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.commentBtn addSubview:segViewB];
    [segViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentBtn.mas_right);
        make.size.width.mas_equalTo(1);
        make.top.equalTo(self.commentBtn.mas_top).offset(5);
        make.bottom.equalTo(self.commentBtn.mas_bottom).offset(-5);
    }];
    
    
    UIView *midTitleView = [[UIView alloc] init];
    midTitleView.backgroundColor = [UIColor whiteColor];
    [self.midView addSubview:midTitleView];
    [midTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.midView);
        make.size.height.mas_equalTo(70);
    }];
    CGFloat viewWidth = DEVICE_WIDTH / 4;
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (int i = 0 ; i < self.midNameArray.count; i++) {
        UIView *singleView = [[UIView alloc] init];
        singleView.backgroundColor = [UIColor whiteColor];
//
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.contentMode = UIViewContentModeScaleAspectFit;
//        imgView.image = [UIImage imageNamed:self.midImgArray[i]]; //[UIImage imageWithColor:[UIColor randomRGBColor]Rect:CGRectMake(0, 0, viewWidth/2, 30)];
//        [singleView addSubview:imgView];
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(singleView.mas_top).offset(10);
//            make.centerX.equalTo(singleView.mas_centerX);
//        }];
//        imgView.userInteractionEnabled = YES;
//        [imgView bk_whenTapped:^{
//            NSLog(@"111111");
//            [weakSelf imgViewClickAction:i];
//        }];
        UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgView setAdjustsImageWhenHighlighted:NO];
        [imgView setImage:[UIImage imageNamed:self.midImgArray[i]] forState:UIControlStateNormal];
        [singleView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(singleView.mas_top).offset(10);
            make.centerX.equalTo(singleView.mas_centerX);
        }];
//        [imgView bk_addEventHandler:^(id sender) {
//             [weakSelf imgViewClickAction:i];
//        } forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [self createLabelWithColor:@"221814" font:15];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = self.midNameArray[i];
        [singleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imgView.mas_centerX);
            make.top.equalTo(imgView.mas_bottom).offset(5);
        }];
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.backgroundColor = [UIColor clearColor];
        [singleView addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(singleView);
        }];
        [clickBtn bk_addEventHandler:^(id sender) {
            [weakSelf imgViewClickAction:i];
        } forControlEvents:UIControlEventTouchUpInside];
        //提醒数字距离 17  fe4d4e
        UIView *segView = [[UIView alloc] init];
        segView.backgroundColor = [UIColor colorWithHexString:@"f0f3f5"];
        [singleView addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(singleView);
            make.size.width.mas_equalTo(1);
        }];
        
        if (i == 3) {//提醒
            self.redView = [[UIView alloc] init];
            self.redView.backgroundColor = [UIColor colorWithHexString:@"fe5c54"];
            self.redView.layer.cornerRadius = 3;
            [singleView addSubview:self.redView];
            self.redView.hidden = YES;
            [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imgView.mas_top);
                make.right.equalTo(imgView.mas_right);
                make.height.and.width.equalTo(@6);
            }];
        }
        
        [midTitleView addSubview:singleView];
        [viewsArray addObject:singleView];
    }
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(70);
        make.top.equalTo(midTitleView.mas_top);
    }];
    

    
//botView
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.size.height.mas_equalTo(52);
    }];
    [self.botView bk_whenTapped:^{
        //[weakSelf shareBtnHandled];
        //[weakSelf dismissViewControllerAnimated:YES completion:nil];
        //weakSelf.topView.hidden = YES;
        [weakSelf setHideTopView];
        [weakSelf goToHomeVC];
        //[weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *myCountLabel = [self createLabelWithColor:@"000000" font:18];
    myCountLabel.text = @"我的账户";
      myCountLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.botView addSubview:myCountLabel];
    [myCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.botView);
    }];
    
    UIImageView *upImgView = [[UIImageView alloc] init];
    upImgView.image = [UIImage imageNamed:@"goup"];
    upImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.botView addSubview:upImgView];
    [upImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(myCountLabel.mas_centerY);
        make.left.equalTo(myCountLabel.mas_right).offset(5);
        //make.size.mas_equalTo(CGSizeMake(30, 30 * 0.83));
    }];
    
    UIImageView *mineImgView = [[UIImageView alloc] init];
    NSString *defaultMineStr = [CustomerManager sharedInstance].customer.gender == 2 ? @"minegirl":@"mineboy";
    mineImgView.image = [UIImage imageNamed:defaultMineStr];
    mineImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.botView addSubview:mineImgView];
    [mineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.botView.mas_right).offset(-24);
        make.centerY.equalTo(myCountLabel.mas_centerY);
        //make.size.mas_equalTo(CGSizeMake(30, 30 * 0.83));
    }];
//
//    UILabel *mineLabel = [self createLabelWithColor:@"000000" font:12];
//    mineLabel.font = [UIFont boldSystemFontOfSize:12];
//    mineLabel.text = @"我的";
//    [self.botView addSubview:mineLabel];
//    [mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(mineImgView.mas_centerX);
//        make.top.equalTo(mineImgView.mas_bottom);
//    }];
//
    
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.mineTableView.delegate         = self;
    self.mineTableView.dataSource       = self;
    self.mineTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.mineTableView.showsVerticalScrollIndicator = NO;
    self.mineTableView.bounces = NO;
    self.mineTableView.rowHeight = 44;
    self.mineTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.view addSubview:self.mineTableView];
    [self.mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.midView.mas_bottom);
        make.bottom.equalTo(self.botView.mas_top);
    }];
}
-(void)setHideTopView{
//
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed:@"可以logo"];
//    [self.topView addSubview:imageView];
    self.topView.backgroundColor = [UIColor whiteColor];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.topView);
//    }];
}
-(void)imgViewClickAction:(NSInteger)index{
    
    if (index == 0) {
        TalkPeopleViewController *vc = [[TalkPeopleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        StoryCollectViewController *vc = [[StoryCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
        OccupySpaceViewController *vc = [[OccupySpaceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3){
        MessageiewController *vc = [[MessageiewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)updateHeadImg{
    
    NSString *defaultHeadStr = [CustomerManager sharedInstance].customer.gender == 2 ? @"headgirl":@"headboy";
    [self.avatorImgView sd_setImageWithURL:[NSURL URLWithString:[CustomerManager sharedInstance].customer.headimg] placeholderImage:[UIImage imageNamed:defaultHeadStr]];
    self.nameLabel.text = [CustomerManager sharedInstance].customer.nickname;
}
-(void)getUserInfoRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.user/getInfo";
    [KYNetService GetHttpDataWithUrlStr:url Dic:@{} SuccessBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        if (dict[@"msg_len"]) {
            NSInteger msgCount = [dict[@"msg_len"] integerValue];
            if (msgCount > 0) {
                weakSelf.redView.hidden = NO;
            }else{
                weakSelf.redView.hidden = YES;
            }
        }
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"%@\n点赞",dict[@"data"][@"fabulous"]] forState:UIControlStateNormal];
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%@\n评论",dict[@"data"][@"danmu_len"]] forState:UIControlStateNormal];
        [self.shareBtn setTitle:[NSString stringWithFormat:@"%@\n分享",dict[@"data"][@"share"]] forState:UIControlStateNormal];
    } FailureBlock:^(NSDictionary *dict) {
        
    }];
}
-(void)goToHomeVC{
    
    self.navigationController.delegate = self;
    self.mineTransform.transitionBeforeFrame = CGRectMake(0, -DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.mineTransform.transitionAfterFrame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPop){
        return self.mineTransform;
    }
    return nil;
    
    
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSourceArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat sectionH = 10;
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, DEVICE_WIDTH, sectionH);
    backView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
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
            ShopCartViewController *vc = [[ShopCartViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            MyOrderViewController *vc = [[MyOrderViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2){
            ManageAddressViewController *vc = [[ManageAddressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
      
        
    }else if (indexPath.section == 0){
        MyLessonViewController *vc = [[MyLessonViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
       
        MyActivityViewController *vc = [[MyActivityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        //        if ([pushedVC isKindOfClass:[UserProtocolViewController class]]) {
        //            pushedVC = [[UserProtocolViewController alloc] initWithTitle:item.title type:item.protocolType];
        //        }
        
        //        if ([pushedVC isKindOfClass:[SettingViewController class]]) {
        //            [(SettingViewController*)pushedVC setDataSource:item.childDataSource];
        //            pushedVC.title = item.title;
        //        }
              
    }
 
}




-(void)configureCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *leftImgView = [[UIImageView alloc] init];
    leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    leftImgView.image = [UIImage imageNamed:self.dataSourceImgArray[indexPath.section][indexPath.row]];
    [cell.contentView addSubview:leftImgView];
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(24);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        //make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *leftLabel = [self createLabelWithColor:@"595858" font:17];
    leftLabel.text = self.dataSourceArray[indexPath.section][indexPath.row];
    [cell.contentView addSubview:leftLabel];
    leftLabel.frame = CGRectMake(60, 12, 80, 20);
//    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(leftImgView.mas_right).offset(16);
//        make.centerY.equalTo(cell.contentView.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(80, 20));
//    }];
     [self changeAlignmentRightAndLeft:leftLabel];
    
    //rightIcon
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = [UIImage imageNamed:@"rightIcon"];
    [cell.contentView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-14);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [cell.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    UILabel *rightLabel = [self createLabelWithColor:@"595757" font:10];
    [cell.contentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(rightImgView.mas_left).offset(-12);
    }];
}
- (void)changeAlignmentRightAndLeft:(UILabel *)label {

    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :label.font}  context:nil].size;
    
    CGFloat margin = (label.frame.size.width - textSize.width) / (label.text.length - 1);
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedString addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,label.text.length -1)];
    
    label.attributedText = attributedString;
    
}


-(void)shareBtnHandled{
    NSDictionary *data = @{@"shareDesContent":@"测试测试测试测试测试内容内容内容",@"shareDesTitle":@"kuoyi分享",
                           @"shareImageUrl":@"http://192.168.1.12/picnull",@"shareLinkUrl":AppStoreUrl};
    UmengShareview *share = [[UmengShareview alloc] initWithData:data referView:nil hasTitle:NO isShowOther:YES];
    share.UmengShareViewCallback = ^(int i){
       
    };
    [share show];
}
-(void)goToSetting{
    SettingViewController *vc = [[SettingViewController alloc] init];
//    [self wxs_presentViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType =  WXSTransitionAnimationTypeSysPushFromRight;
//        transition.animationTime = 0.3;
//    }];
//
//    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType = WXSTransitionAnimationTypeSysPushFromRight;
//        transition.animationTime = 0.3;
//    }];
    [self.navigationController pushViewController:vc animated:YES];
    
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
-(MineVCTransform *)mineTransform{
    
    if (!_mineTransform) {
        _mineTransform = [[MineVCTransform alloc] init];
    }
    
    return _mineTransform;
    
}
@end
