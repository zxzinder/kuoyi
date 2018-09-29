//
//  FeedBackViewController.m
//  TransportPassenger
//
//  Created by YY on 16/5/24.
//  Copyright © 2016年 AnzeInfo. All rights reserved.
//

#import "FeedBackViewController.h"
#import "HLYHUD.h"
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import "NSString+TPValidator.h"
#import "UtilsMacro.h"
#import "CTAlertView.h"
#import <BlocksKit+UIKit.h>
#import "KYNetService.h"
#import "HLYHUD.h"



#define TOTALTEXTCOUNT 500
static NSString *remindStr = @"   对我们工作的看法及建议";
@interface FeedBackViewController ()<UITextViewDelegate>

//@property (nonatomic, strong) AddAdviceAPIManager *apiManager;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UITextView *feedBackView;
@property (nonatomic, strong) UITextField *phoneTextField;
@end

@implementation FeedBackViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initUserinterface];
}

- (void) p_initUserinterface{
    
    __weak __typeof(self)weakSelf = self;
    self.title = @"我要反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e1e9ec"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_textViewDidChange:) name:@"UITextViewTextDidChangeNotification" object:self.feedBackView];


    self.feedBackView = [[UITextView alloc] init];
    self.feedBackView.delegate = self;
    self.feedBackView.font = [UIFont systemFontOfSize:15];
//    self.feedBackView.layer.borderColor = [UIColor tp_lineColor].CGColor;
//    self.feedBackView.layer.borderWidth = 1;
    self.feedBackView.text = remindStr;
    self.feedBackView.textColor = [UIColor tp_lightGaryTextColor];
    [self.view addSubview:self.feedBackView];
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(statusBarAndNavigationBarHeight+10);
        make.height.equalTo(@170);
    }];
    
//    UILabel *alertLabel = [[UILabel alloc] init];
//    alertLabel.text = @"(500字以内)";
//    alertLabel.font = [UIFont systemFontOfSize:14];
//    alertLabel.textColor = [UIColor colorWithRed:0.7843 green:0.7843 blue:0.7843 alpha:1.0];
//    _alertLabel = alertLabel;
//    [self.view addSubview:alertLabel];
//    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.feedBackView.mas_right).offset(-5);
//        make.bottom.equalTo(backGroundView.mas_bottom).offset(-5);
//    }];
    
    UIView *midView = [[UIView alloc] init];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feedBackView.mas_left);
        make.right.equalTo(self.feedBackView.mas_right);
        make.top.equalTo(self.feedBackView.mas_bottom).offset(20);
        make.size.height.mas_equalTo(44);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"联系方式：";
    titleLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [midView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midView.mas_left).offset(10);
        make.centerY.equalTo(midView.mas_centerY);
        make.width.priority(MASLayoutPriorityFittingSizeLevel);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:self.phoneTextField];
    UITextField *phoneField = [[UITextField alloc] init];
    self.phoneTextField = phoneField;
    phoneField.placeholder = @"  邮箱/手机号";
    phoneField.font = [UIFont systemFontOfSize:13];
    phoneField.layer.cornerRadius = 3;
    [midView addSubview:phoneField];
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(midView.mas_right);
    }];
    
    UIButton *kfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [kfBtn setTitle:@"可以客服" forState:UIControlStateNormal];
    [kfBtn setTitleColor:[UIColor colorWithHexString:@"4c787c"] forState:UIControlStateNormal];
    kfBtn.backgroundColor = [UIColor colorWithHexString:@"bfcdd2"];
    kfBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [kfBtn addTarget:self action:@selector(callKFteL) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kfBtn];
    [kfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedBackView.mas_right);
        make.top.equalTo(midView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 33));
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"发送" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"4c787c"];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn addTarget:self action:@selector(commitBtnHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.feedBackView.mas_left);
        make.top.equalTo(midView.mas_bottom).offset(10);
        make.right.equalTo(self.feedBackView.mas_right).offset(-3-60);
        make.size.height.mas_equalTo(33);
    }];
}
-(void)sendMessageRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.user/addFeedback";
    NSDictionary *params = @{@"info":self.feedBackView.text,@"mobile":self.phoneTextField.text};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
         [weakSelf a_dismissButtonAction];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}
#pragma mark  textViewDelegate
- (void) p_textViewDidChange:(NSNotification *) notification{
    
    UITextView *textView = (UITextView *) notification.object;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > TOTALTEXTCOUNT)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:TOTALTEXTCOUNT];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:TOTALTEXTCOUNT];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, TOTALTEXTCOUNT)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    _alertLabel.text = [NSString stringWithFormat:@"%ld / %d", textView.text.length, TOTALTEXTCOUNT];
}

- (void) p_textFieldDidChange:(NSNotification *) notification{
    
    UITextField *textView = (UITextField *) notification.object;
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > 11)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:11];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:11];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 11)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:remindStr]) {
        textView.text = @"";
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        self.feedBackView.text = remindStr;
    }
    return YES;
}

-(void)a_dismissButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) commitBtnHandle
{
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length != 0) {
        if ([self.phoneTextField.text isContainsEmoji] || ![self.phoneTextField.text isValidPhoneNumber]) {
            [HLYHUD showHUDWithMessage:@"您输入的电话号码有误" addToView:self.view];
            return;
        }
    }
    if ([_feedBackView.text isEqualToString:@""] || [_feedBackView.text isEqualToString:remindStr]) {
        
        [HLYHUD showHUDWithMessage:@"请输入正确的反馈意见" addToView:nil];
    }else{
        if ([_feedBackView.text isContainsEmoji]) {
            
            [HLYHUD showHUDWithMessage:@"不能输入表情符号哦~" addToView:self.view];
        }else{
            [HLYHUD showLoadingHudAddToView:nil];
            //[self.apiManager loadData];
            [self sendMessageRequest];
           
        }
    }
}

-(void)callKFteL{
    
    [CTAlertView showAlertViewWithTitle:@"客服电话" Details:serviceTel CancelButton:@"取消" DoneButton:@"确认拨打" callBack:^(NSInteger buttonIndex){
        
        if (buttonIndex == 1) {
            if (iOS10) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",serviceTel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                    if(!success) return ;
                }];
            }else{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",serviceTel];
                //拨打电话
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }
        
    }];
    
}

- (void) p_popNav
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
