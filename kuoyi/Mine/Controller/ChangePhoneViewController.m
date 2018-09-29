//
//  ChangePhoneViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/9/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "LNAddressSelectView.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "EnumHeader.h"

@interface ChangePhoneViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UIButton *clearPhoneBtn;

@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *clearCodeBtn;
@property (nonatomic, strong) UIButton *sendCodeBtn;

@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, assign) NSInteger                number;
@property (nonatomic, strong) NSTimer                  *codeTimer;


@end

@implementation ChangePhoneViewController
-(void)dealloc{
    
    [self.codeTimer invalidate];
    self.codeTimer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机号";
    [self p_initUI];
    // Do any additional setup after loading the view.
}

- (void)p_initUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self)weakSelf = self;
    CGFloat tfHeight = 20;
    CGFloat tfSeg = 36;
    
    self.phoneTF = [[UITextField alloc] init];
    [self.view addSubview:self.phoneTF];
    self.phoneTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.phoneTF.placeholder = @"手机号";
    self.phoneTF.delegate = self;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.font = [UIFont systemFontOfSize:15];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight + 20);
        make.left.equalTo(self.view.mas_left).offset(47);
        make.right.equalTo(self.view.mas_right).offset(-47);
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
    [self.view addSubview:self.sendCodeBtn];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTF.mas_centerY).offset(tfSeg + tfHeight);
        make.right.equalTo(self.phoneTF.mas_right);
        make.size.mas_equalTo(CGSizeMake(97, 26));
    }];
    [self.sendCodeBtn bk_addEventHandler:^(id sender) {
        [weakSelf sendCodeAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.codeTF = [[UITextField alloc] init];
    [self.view addSubview:self.codeTF];
    self.codeTF.placeholder = @"6位验证码";
    self.codeTF.delegate = self;
    self.codeTF.textColor = [UIColor colorWithHexString:@"a9acab"];
    self.codeTF.font = [UIFont systemFontOfSize:15];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(tfSeg);
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right).offset(- 97 - 5);
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
    
    self.changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changeBtn.backgroundColor = [UIColor whiteColor];
    self.changeBtn.layer.cornerRadius = 23;
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.layer.borderColor = [UIColor colorWithHexString:@"15a8af"].CGColor;
    self.changeBtn.layer.borderWidth = 1;
    [self.changeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.changeBtn setTitleColor:[UIColor colorWithHexString:@"2ebac2"] forState:UIControlStateNormal];
    [self.changeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.changeBtn bk_addEventHandler:^(id sender) {
        [weakSelf p_confirmAction];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeBtn];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46);
        make.left.equalTo(self.phoneTF.mas_left);
        make.right.equalTo(self.phoneTF.mas_right);
        make.top.equalTo(self.codeTF.mas_bottom).offset(19 + 18);
    }];
    
    //下划线
    CGFloat offX = 0;
    for (int i = 0; i < 2; i++) {
        offX = 18 + (tfSeg + tfHeight) * i;
        UIView *segView = [[UIView alloc] init];
        segView.backgroundColor = [UIColor colorWithHexString:@"c0c0c0"];
        [self.view addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.phoneTF);
            make.size.height.mas_equalTo(1);
            make.top.equalTo(self.phoneTF.mas_bottom).offset(offX);
        }];
    }
    
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
-(void)p_confirmAction{
    
    [self.view endEditing:YES];
    __weak typeof(self)weakSelf = self;
    if ([self.phoneTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请先填写账号" addToView:nil];
    }else if ([self.codeTF.text isEqualToString:@""]){
        [HLYHUD showHUDWithMessage:@"请先填写验证码" addToView:nil];
    }else{
        [weakSelf changePhoneRequest];
    }
    
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

#pragma mark request

-(void)sendCodeRequest{
    
    [self.view endEditing:YES];
    NSString *url = @"v1.user/sendMsg";
    NSDictionary *params = @{@"phone":self.phoneTF.text,@"type":@(ChangePhoneCode)};
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

-(void)changePhoneRequest{
    
//    __weak typeof(self)weakSelf = self;
//    NSDictionary *params = @{@"phone":self.phoneTF.text,@"code":self.codeTF.text};
//    NSString *url = @"v1.user/reminderPwd";
//    [HLYHUD showLoadingHudAddToView:nil];
//    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
//        [HLYHUD hideAllHUDsForView:nil];
//        [HLYHUD showHUDWithMessage:@"修改成功" addToView:nil];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//
//    } fail:^(NSDictionary *dict) {
//        [HLYHUD hideAllHUDsForView:nil];
//        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
//    }];
    if (self.finishCallback) {
        self.finishCallback(self.phoneTF.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
@end
