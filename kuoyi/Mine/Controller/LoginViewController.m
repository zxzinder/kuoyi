//
//  LoginViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "LoginViewController.h"
#import "ImageCodeCheckView.h"
#import <Masonry.h>
#import "KYNetService.h"
#import "CryptographicTools.h"
#import "UtilsMacro.h"
#import <BlocksKit+UIKit.h>
#import "UIColor+TPColor.h"
#import "HLYHUD.h"
#import "VendorMacro.h"
#import <UMSocialCore/UMSocialCore.h>
#import "Customer.h"
#import <YYModel.h>
#import "CustomerManager.h"
#import "EnumHeader.h"
#import "ChangePwdViewController.h"
#import "BaseWebViewController.h"
#import "ReturnUrlTool.h"
#import "UserMarkViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>
//登录
@property (nonatomic, strong) UIView *loginBackView;

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *showPwdBtn;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetpwdBtn;
@property (nonatomic, strong) UILabel *quickLabel;

@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UIButton *wbBtn;
//注册
@property (nonatomic, strong) UIView *regisView;

@property (nonatomic, strong) UITextField *nameTF;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIButton *clearPhoneBtn;

@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *clearCodeBtn;
@property (nonatomic, strong) UIButton *sendCodeBtn;

@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *regPwdTF;

@property (nonatomic, strong) UIButton *registBtn;

//底部
@property (nonatomic, strong) UIButton *turnBtn;
@property (nonatomic, strong) UILabel *weblinkLabel;
@property (nonatomic, strong) UILabel *remindLabel;


@property (nonatomic, strong) ImageCodeCheckView *pooCodeView;

@property (nonatomic, assign) NSInteger                number;
@property (nonatomic, strong) NSTimer                  *codeTimer;

@property (nonatomic, copy) void(^loginSuccessBlock)(void);


@end

@implementation LoginViewController

- (instancetype)initWithLoginSuccessBlock:(void (^)(void))block
{
    self = [super init];
    if (self) {
        self.loginSuccessBlock = block;
    }
    return self;
}
-(void)dealloc{
    
    [self.codeTimer invalidate];
    self.codeTimer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view.
    [self p_initUI];
    [self p_initRegisteView];
    [self p_initCommonUI];
    //忘记密码UI
    // 13547941405/123456
    //[self loginReq];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)p_initCommonUI{
    
    __weak typeof(self)weakSelf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navgation_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(a_backButtonAction)];
    
    
    UIView *topSegView = [[UIView alloc] init];
    topSegView.backgroundColor = [UIColor colorWithHexString:@"c0c0c0"];
    [self.view addSubview:topSegView];
    [topSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.size.height.mas_equalTo(1);
        make.top.equalTo(self.view).offset(0);
    }];
    self.remindLabel = [self createLabelWithColor:@"595858" font:13];
    self.remindLabel.attributedText = [self remindTextAttribute:@"使用可以，表示您已同意" with:@"用户使用协议"];
    [self.view addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-74);
    }];
    self.remindLabel.userInteractionEnabled = YES;
    [self.remindLabel bk_whenTapped:^{
        BaseWebViewController *vc = [[BaseWebViewController alloc] init];
        vc.urlString = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeAgreement andDetailId:kWebProtocolTypeAgreement];
        vc.naviTitle = @"用户协议";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    self.weblinkLabel = [self createLabelWithColor:@"595858" font:15];
    self.weblinkLabel.text = @"www.KUOYILIFE.com";
    [self.view addSubview:self.weblinkLabel];
    [self.weblinkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.remindLabel.mas_top).offset(-15);
    }];
    
    self.turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.turnBtn setTitle:@"还没账号？快来注册" forState:UIControlStateNormal];
    [self.turnBtn setTitle:@"已有账号，去登录" forState:UIControlStateSelected];
    [self.turnBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    self.turnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.turnBtn.selected = NO;
    [self.view addSubview:self.turnBtn];
    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.weblinkLabel.mas_top).offset(-15);
    }];
    [self.turnBtn bk_addEventHandler:^(id sender) {
        weakSelf.turnBtn.selected = !weakSelf.turnBtn.selected;
        if (weakSelf.turnBtn.selected) {
            weakSelf.regisView.hidden = NO;
            weakSelf.loginBackView.hidden = YES;
            weakSelf.title = @"注册";
        }else{
            weakSelf.loginBackView.hidden = NO;
            weakSelf.regisView.hidden = YES;
            weakSelf.title = @"登录";
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)p_initUI{
    
      __weak typeof(self)weakSelf = self;
    CGFloat offsetY = 0;
//    if (iOS11) {
//        offsetY = statusBarAndNavigationBarHeight;
//    }
    self.loginBackView = [[UIView alloc] init];
    [self.view addSubview:self.loginBackView];
    [self.loginBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(offsetY);
        make.size.height.mas_equalTo(DEVICE_HEIGHT * 0.5);
    }];
   
    self.accountTF = [[UITextField alloc] init];
    self.accountTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    [self.loginBackView addSubview:self.accountTF];
    self.accountTF.placeholder = @"邮箱/手机号";
    self.accountTF.font = [UIFont systemFontOfSize:15];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBackView.mas_top).offset(40);
        make.left.equalTo(self.loginBackView.mas_left).offset(47);
        make.right.equalTo(self.loginBackView.mas_right).offset(-47);
        make.size.height.mas_equalTo(20);
    }];
    
    UIView *accoutpSegView = [[UIView alloc] init];
    accoutpSegView.backgroundColor = [UIColor colorWithHexString:@"c0c0c0"];
    [self.loginBackView addSubview:accoutpSegView];
    [accoutpSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.accountTF);
        make.top.equalTo(self.accountTF.mas_bottom).offset(18);
        make.size.height.mas_equalTo(1);
    }];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    self.clearBtn.frame = CGRectMake(0, 0, 30, 30);
    self.accountTF.rightView = self.clearBtn;
    self.accountTF.rightViewMode = UITextFieldViewModeAlways;
    [self.clearBtn bk_whenTapped:^{
        weakSelf.accountTF.text = @"";
    }];
    
    self.pwdTF = [[UITextField alloc] init];
    [self.loginBackView addSubview:self.pwdTF];
     self.pwdTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.pwdTF.placeholder = @"密码";
    self.pwdTF.secureTextEntry = YES;
    self.pwdTF.selected = NO;
    [self.pwdTF setFont:[UIFont systemFontOfSize:15]];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTF.mas_bottom).offset(36);
        make.left.equalTo(self.accountTF.mas_left);
        make.right.equalTo(self.accountTF.mas_right);
        make.height.equalTo(@20);
    }];
    
    UIView *pwdSegView = [[UIView alloc] init];
    pwdSegView.backgroundColor = [UIColor colorWithHexString:@"c0c0c0"];
    [self.loginBackView addSubview:pwdSegView];
    [pwdSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.pwdTF);
        make.top.equalTo(self.pwdTF.mas_bottom).offset(18);
        make.size.height.mas_equalTo(1);
    }];
    
    self.showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showPwdBtn setImage:[UIImage imageNamed:@"showpwd"] forState:UIControlStateNormal];
    self.showPwdBtn.frame = CGRectMake(0, 0, 30, 30);
    self.pwdTF.rightView = self.showPwdBtn;
    self.pwdTF.rightViewMode = UITextFieldViewModeAlways;
    [self.showPwdBtn bk_whenTapped:^{
        weakSelf.showPwdBtn.selected = !weakSelf.showPwdBtn.selected;
        weakSelf.pwdTF.secureTextEntry = !weakSelf.showPwdBtn.selected;
    }];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.backgroundColor = [UIColor whiteColor];
    self.loginButton.layer.cornerRadius = 23;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderColor = [UIColor colorWithHexString:@"15a8af"].CGColor;
    self.loginButton.layer.borderWidth = 1;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    [self.loginButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.loginButton bk_addEventHandler:^(id sender) {
        [weakSelf a_loginButtonAction];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.loginBackView addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46);
        make.left.equalTo(self.accountTF.mas_left);
        make.right.equalTo(self.accountTF.mas_right);
        make.top.equalTo(pwdSegView.mas_bottom).offset(19);
    }];
    
    self.forgetpwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetpwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetpwdBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    [self.forgetpwdBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.loginBackView addSubview:self.forgetpwdBtn];
    [self.forgetpwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginBackView.mas_centerX);
        make.top.equalTo(self.loginButton.mas_bottom).offset(15);
    }];
    [self.forgetpwdBtn bk_addEventHandler:^(id sender) {
        ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqBtn setImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];
    [self.loginBackView addSubview:self.qqBtn];
    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.loginBackView.mas_bottom);
    }];
    [self.qqBtn bk_addEventHandler:^(id sender) {
        [weakSelf qqLogin];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [self.loginBackView addSubview:self.wechatBtn];
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qqBtn.mas_centerY);
        make.right.equalTo(self.qqBtn.mas_left).offset(-15);
    }];
    [self.wechatBtn bk_addEventHandler:^(id sender) {
        [weakSelf wechatLogin];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.wbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wbBtn setImage:[UIImage imageNamed:@"wblogin"] forState:UIControlStateNormal];
    [self.loginBackView addSubview:self.wbBtn];
    [self.wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.qqBtn.mas_centerY);
        make.left.equalTo(self.qqBtn.mas_right).offset(15);
    }];
    [self.wbBtn bk_addEventHandler:^(id sender) {
        [weakSelf getAuthWithUserInfoFromSina];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.quickLabel = [self createLabelWithColor:@"ababab" font:15];
    self.quickLabel.text = @"快捷登录";
    [self.loginBackView addSubview:self.quickLabel];
    [self.quickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_left);
        make.bottom.equalTo(self.qqBtn.mas_top).offset(-15);
    }];
    
    
    
   
//    self.pooCodeView = [[ImageCodeCheckView alloc] init];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    [self.pooCodeView addGestureRecognizer:tap];
//    [self.view addSubview:self.pooCodeView];
//    [self.pooCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(50);
//        make.top.equalTo(self.view.mas_top).offset(100);
//        make.size.mas_equalTo(CGSizeMake(82, 32));
//    }];
//
}

-(void)p_initRegisteView{
     __weak typeof(self)weakSelf = self;
    CGFloat tfHeight = 20;
    CGFloat tfSeg = 36;
    self.regisView = [[UIView alloc] init];
    self.regisView.hidden = YES;
    [self.view addSubview:self.regisView];
    [self.regisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.size.height.mas_equalTo(DEVICE_HEIGHT * 0.6);
    }];
    
    self.nameTF = [[UITextField alloc] init];
    [self.regisView addSubview:self.nameTF];
    self.nameTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.nameTF.placeholder = @"昵称";
    self.nameTF.font = [UIFont systemFontOfSize:15];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.regisView.mas_top).offset(40);
        make.left.equalTo(self.regisView.mas_left).offset(47);
        make.right.equalTo(self.regisView.mas_right).offset(-47);
        make.size.height.mas_equalTo(tfHeight);
    }];
    
    
    self.phoneTF = [[UITextField alloc] init];
    [self.regisView addSubview:self.phoneTF];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.phoneTF.placeholder = @"手机号";
    self.phoneTF.delegate = self;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.font = [UIFont systemFontOfSize:15];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTF.mas_bottom).offset(tfSeg);
        make.left.equalTo(self.nameTF.mas_left);
        make.right.equalTo(self.nameTF.mas_right);
        make.size.height.mas_equalTo(tfHeight);
    }];
    
    
    self.clearPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearPhoneBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    self.clearPhoneBtn.frame = CGRectMake(0, 0, 30, 30);
    self.phoneTF.rightView = self.clearPhoneBtn;
    self.phoneTF.rightViewMode = UITextFieldViewModeAlways;
    [self.clearPhoneBtn bk_whenTapped:^{
        weakSelf.phoneTF.text = @"";
    }];
    
    self.sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendCodeBtn.backgroundColor = [UIColor whiteColor];
    self.sendCodeBtn.layer.cornerRadius = 4;
    self.sendCodeBtn.layer.masksToBounds = YES;
    self.sendCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"15a8af"].CGColor;
    self.sendCodeBtn.layer.borderWidth = 1;
    [self.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    [self.sendCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.regisView addSubview:self.sendCodeBtn];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTF.mas_centerY).offset(tfSeg + tfHeight);
        make.right.equalTo(self.nameTF.mas_right);
        make.size.mas_equalTo(CGSizeMake(97, 26));
    }];
    [self.sendCodeBtn bk_addEventHandler:^(id sender) {
        [weakSelf sendCodeAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.codeTF = [[UITextField alloc] init];
    [self.regisView addSubview:self.codeTF];
    self.codeTF.placeholder = @"6位验证码";
    self.codeTF.delegate = self;
    self.codeTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.codeTF.font = [UIFont systemFontOfSize:15];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(tfSeg);
        make.left.equalTo(self.nameTF.mas_left);
        make.right.equalTo(self.nameTF.mas_right).offset(- 97 - 5);
        make.size.height.mas_equalTo(tfHeight);
    }];
    
    self.clearCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearCodeBtn setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    self.clearCodeBtn.frame = CGRectMake(0, 0, 30, 30);
    self.codeTF.rightView = self.clearCodeBtn;
    self.codeTF.rightViewMode = UITextFieldViewModeAlways;
    [self.clearCodeBtn bk_whenTapped:^{
        weakSelf.codeTF.text = @"";
    }];
    
    
//    self.emailTF = [[UITextField alloc] init];
//    [self.regisView addSubview:self.emailTF];
//    self.emailTF.placeholder = @"邮箱";
//    self.emailTF.textColor = [UIColor colorWithHexString:@"a9acab"];
//    self.emailTF.font = [UIFont systemFontOfSize:15];
//    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.codeTF.mas_bottom).offset(tfSeg);
//        make.left.equalTo(self.nameTF.mas_left);
//        make.right.equalTo(self.nameTF.mas_right);
//        make.size.height.mas_equalTo(tfHeight);
//    }];
//
    self.regPwdTF = [[UITextField alloc] init];
    [self.regisView addSubview:self.regPwdTF];
    self.regPwdTF.placeholder = @"密码";
    self.regPwdTF.secureTextEntry = YES;
    self.regPwdTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.regPwdTF.font = [UIFont systemFontOfSize:15];
    [self.regPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).offset(tfSeg);
        make.left.equalTo(self.nameTF.mas_left);
        make.right.equalTo(self.nameTF.mas_right);
        make.size.height.mas_equalTo(tfHeight);
    }];
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registBtn.backgroundColor = [UIColor whiteColor];
    self.registBtn.layer.cornerRadius = 23;
    self.registBtn.layer.masksToBounds = YES;
    self.registBtn.layer.borderColor = [UIColor colorWithHexString:@"15a8af"].CGColor;
    self.registBtn.layer.borderWidth = 1;
    [self.registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    [self.registBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.registBtn bk_addEventHandler:^(id sender) {
        [weakSelf a_registerButtonAction];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.regisView addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46);
        make.left.equalTo(self.nameTF.mas_left);
        make.right.equalTo(self.nameTF.mas_right);
        make.top.equalTo(self.regPwdTF.mas_bottom).offset(19 + 18);
    }];
    
    //下划线
    CGFloat offX = 0;
    for (int i = 0; i < 4; i++) {
        offX = 18 + (tfSeg + tfHeight) * i;
        UIView *segView = [[UIView alloc] init];
        segView.backgroundColor = [UIColor colorWithHexString:@"c0c0c0"];
        [self.regisView addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.nameTF);
            make.size.height.mas_equalTo(1);
            make.top.equalTo(self.nameTF.mas_bottom).offset(offX);
        }];
    }
}
- (void)a_backButtonAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)sendCodeAction{
    
    if ([self.phoneTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请先填写电话" addToView:nil];
    }else if (self.phoneTF.text.length != 11){
         [HLYHUD showHUDWithMessage:@"请先填写正确的电话" addToView:nil];
    }else{
        [self sendCodeRequest];
        
    }
    
}
- (void)a_loginButtonAction {
    
    if ([self.accountTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请先填写账号" addToView:nil];
    }else if ([self.pwdTF.text isEqualToString:@""]){
        [HLYHUD showHUDWithMessage:@"请先填写密码" addToView:nil];
    }else{
        [self loginReq];
    }
    
}
- (void)a_registerButtonAction {
    [self.view endEditing:YES];
    __weak typeof(self)weakSelf = self;
    if ([self.phoneTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请先填写账号" addToView:nil];
    }else if ([self.regPwdTF.text isEqualToString:@""]){
        [HLYHUD showHUDWithMessage:@"请先填写密码" addToView:nil];
    }else if ([self.codeTF.text isEqualToString:@""]){
        [HLYHUD showHUDWithMessage:@"请先填写验证码" addToView:nil];
    }else if ([self.nameTF.text isEqualToString:@""]){
        [HLYHUD showHUDWithMessage:@"请先填写昵称" addToView:nil];
    }else{
        [self checkCodeRequestSuccess:^{
            [weakSelf registerReq];
        } fail:^{
            
        }];
        
    }
    
}

#pragma mark request

-(void)sendCodeRequest{
    
    [self.view endEditing:YES];
    NSString *url = @"v1.user/sendMsg";
    NSDictionary *params = @{@"phone":self.phoneTF.text,@"type":@(RegisterCode)};
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        
        self.number = 60;
        [self.sendCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
        self.sendCodeBtn.enabled = NO;
        if (!_codeTimer) {
            self.codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(p_codeTimerStart:) userInfo:nil repeats:YES];
        }
        [self.sendCodeBtn setBackgroundColor:[UIColor tp_grayCommentBackgroundColor]];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
        
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
-(void)checkCodeRequestSuccess:(void(^)(void))success fail:(void(^)(void))fail{
    
    NSString *url = @"v1.user/checMsgCode";
    NSDictionary *params = @{@"phone":self.phoneTF.text,@"type":@(RegisterCode),@"code":self.codeTF.text};
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService GetHttpDataWithUrlStr:url Dic:params SuccessBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        if ([dict[@"error"] integerValue] == 0) {
            if (success) {
                success();
            }
        }else{
            if (fail) {
                fail();
            }
        }
      
    } FailureBlock:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        if (fail) {
            fail();
        }
    }];
    
}
-(void)loginReq{
    __weak typeof(self)weakSelf = self;
    NSString *pwd = [[CryptographicTools sharedInstance] base64StringFrom:self.pwdTF.text];
    pwd = [[CryptographicTools sharedInstance] md5StringFrom:pwd];
    NSString *accountStr = self.accountTF.text;//13547941405  123456
    NSDictionary *params = @{@"mobile":accountStr,@"password":pwd};
    NSString *url = @"v1.user/loginwithmobilepassword";
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
         NSLog(@"%@",dict);
        [[CustomerManager sharedInstance] updateCustomerWithDictionary:dict];
        [CustomerManager sharedInstance].customer.isLogin = YES;
        [[CustomerManager sharedInstance] saveNewDataWithCustomer:[CustomerManager sharedInstance].customer];
       // [self.navigationController popViewControllerAnimated:YES];
        
        [self dismissViewControllerAnimated:YES completion:^{
            // weakSelf.loginSuccessBlock == NULL ?: weakSelf.loginSuccessBlock();
            if (weakSelf.loginSuccessBlock) {
                weakSelf.loginSuccessBlock();
            }
        }];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
- (void)registerReq{
    __weak typeof(self)weakSelf = self;
    NSString *pwd = [[CryptographicTools sharedInstance] base64StringFrom:self.regPwdTF.text];
    pwd = [[CryptographicTools sharedInstance] md5StringFrom:pwd];
    NSDictionary *params = @{@"mobile":self.phoneTF.text,@"password":pwd,@"os":@"2",@"captcha":self.codeTF.text,@"nickname":self.nameTF.text};
    NSString *url = @"v1.user/registeruser";
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
//        weakSelf.loginBackView.hidden = NO;
//        weakSelf.regisView.hidden = YES;
//        weakSelf.title = @"登录";
//
        [[CustomerManager sharedInstance] updateCustomerWithDictionary:dict];
        [CustomerManager sharedInstance].customer.isLogin = YES;
        [[CustomerManager sharedInstance] saveNewDataWithCustomer:[CustomerManager sharedInstance].customer];
        UserMarkViewController *vc = [[UserMarkViewController alloc] init];
        vc.isFromRegister = YES;
        vc.finishCallback = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.loginSuccessBlock) {
                    weakSelf.loginSuccessBlock();
                }
            }];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)thirdLoginRequest:(NSDictionary *)loginData{
     __weak typeof(self)weakSelf = self;
    NSString *url = @"v1.user/thirdPartyLogin";
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService postDataWithUrl:url param:loginData success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        
//        if (dict[@"is_existence"] && [dict[@"is_existence"] integerValue] == 1) {
            //[HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
            [[CustomerManager sharedInstance] updateCustomerWithDictionary:dict];
//        }else{
//            [[CustomerManager sharedInstance] updateCustomerWithDictionary:loginData];
//        }
        [CustomerManager sharedInstance].customer.isLogin = YES;
        //Customer *model = [CustomerManager sharedInstance].customer;
        [[CustomerManager sharedInstance] saveNewDataWithCustomer:[CustomerManager sharedInstance].customer];
        //Customer *model2 = [CustomerManager sharedInstance].customer;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.loginSuccessBlock) {
                weakSelf.loginSuccessBlock();
            }
        }];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

- (void)tapClick:(UITapGestureRecognizer*)tap{
    [self.pooCodeView changeCode];
}
- (void) p_codeTimerStart:(NSTimer *)timer {
    if (self.number<=0) {
        self.number = 60;
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.sendCodeBtn setBackgroundColor:[UIColor whiteColor]];
        [self.sendCodeBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
        [self.codeTimer invalidate];
        self.codeTimer = nil;
        return;
    }
    self.number--;
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒",self.number] forState:UIControlStateNormal];
    
}

- (NSAttributedString *) remindTextAttribute:(NSString *) firStr with:(NSString *)secStr{
    
    NSMutableAttributedString *startAttribute = [[NSMutableAttributedString alloc] initWithString:firStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"595858"],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    [startAttribute appendAttributedString:[[NSMutableAttributedString alloc] initWithString:secStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2ebac2"],NSFontAttributeName:[UIFont systemFontOfSize:14],NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}]];
    return startAttribute;
    
}


// 在需要进行获取用户信息的UIViewController中加入如下代码
- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            //[HLYHUD showHUDWithMessage:@"授权登录成功" addToView:self.view];
            NSMutableDictionary *loginResult = [NSMutableDictionary dictionary];
            [loginResult setValue:resp.uid forKey:@"openid"];
            [loginResult setValue:@(WBLogin) forKey:@"login_class"];
            [loginResult setValue:resp.name forKey:@"nickname"];
            [loginResult setValue:resp.iconurl forKey:@"headimg"];
            NSString *sexStr = @"0";
            if ([resp.unionGender isEqualToString:@"男"]) {
                sexStr = @"1";
            }else if ([resp.unionGender isEqualToString:@"女"]){
                sexStr = @"2";
            }
            [loginResult setValue:sexStr forKey:@"sex"];
            [loginResult setValue:sexStr forKey:@"gender"];
            [loginResult setValue:@"2" forKey:@"machine_class"];
            
            [loginResult setValue:resp.originalResponse[@"province"] forKey:@"province"];
            [loginResult setValue:resp.originalResponse[@"city"] forKey:@"city"];
            [loginResult setValue:@"" forKey:@"district"];
            [loginResult setValue:@"" forKey:@"machinecode"];
            [self thirdLoginRequest:loginResult];
        }
    }];
}
- (void)wechatLogin{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            //[HLYHUD showHUDWithMessage:@"授权登录成功" addToView:self.view];
            NSMutableDictionary *loginResult = [NSMutableDictionary dictionary];
            [loginResult setValue:resp.openid forKey:@"openid"];
            [loginResult setValue:@(WechatLogin) forKey:@"login_class"];
            [loginResult setValue:resp.name forKey:@"nickname"];
            [loginResult setValue:resp.iconurl forKey:@"headimg"];
            NSString *sexStr = @"0";
            if ([resp.unionGender isEqualToString:@"男"]) {
                sexStr = @"1";
            }else if ([resp.unionGender isEqualToString:@"女"]){
                sexStr = @"2";
            }
            [loginResult setValue:sexStr forKey:@"sex"];
            [loginResult setValue:sexStr forKey:@"gender"];
            [loginResult setValue:@"2" forKey:@"machine_class"];
            
            [loginResult setValue:resp.originalResponse[@"province"] forKey:@"province"];
            [loginResult setValue:resp.originalResponse[@"city"] forKey:@"city"];
            [loginResult setValue:@"" forKey:@"district"];
            [loginResult setValue:@"" forKey:@"machinecode"];
            [self thirdLoginRequest:loginResult];
            
        }
    }];
    
}
- (void)qqLogin{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ unionid: %@", resp.unionId);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
//            [HLYHUD showHUDWithMessage:@"tencentDidLogin Success" addToView:self.view];
            NSMutableDictionary *loginResult = [NSMutableDictionary dictionary];
            [loginResult setValue:resp.openid forKey:@"openid"];
            [loginResult setValue:@(QQLogin) forKey:@"login_class"];
            [loginResult setValue:resp.name forKey:@"nickname"];
            [loginResult setValue:resp.iconurl forKey:@"headimg"];
            NSString *sexStr = @"0";
            if ([resp.unionGender isEqualToString:@"男"]) {
                sexStr = @"1";
            }else if ([resp.unionGender isEqualToString:@"女"]){
                sexStr = @"2";
            }
            [loginResult setValue:sexStr forKey:@"sex"];
            [loginResult setValue:sexStr forKey:@"gender"];
            [loginResult setValue:@"2" forKey:@"machine_class"];
            
            [loginResult setValue:resp.originalResponse[@"province"] forKey:@"province"];
            [loginResult setValue:resp.originalResponse[@"city"] forKey:@"city"];
            [loginResult setValue:@"" forKey:@"district"];
            [loginResult setValue:@"" forKey:@"machinecode"];
            [self thirdLoginRequest:loginResult];
        }
    }];
}

#pragma mark -- <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.phoneTF]) {
        if(range.location > 10){
            return NO;
        }
    }else if ([textField isEqual:self.codeTF]){
        if(range.location > 5){
            return NO;
        }
    }
    
    return YES;
    
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
@end
