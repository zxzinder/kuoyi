//
//  WriteAddressViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "WriteAddressViewController.h"
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "LNAddressSelectView.h"
#import "KYNetService.h"
#import "HLYHUD.h"

#define TF_TAG 2000
static NSString * CELLID = @"writeCell";
@interface WriteAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UITableView *addressTableView;

@property (nonatomic, strong) UITextView *addressTextView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, strong) UISwitch *defaultSwitch;

@end

@implementation WriteAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    self.dataArray = @[@"收货人",@"所在地区",@"街道地址",@"联系电话",@"设置默认地址"];
    // Do any additional setup after loading the view.
    [self p_initUI];
    if (self.addressData) {
        self.addressStr = self.addressData[@"city"];
    }
}

-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.addressTableView.delegate         = self;
    self.addressTableView.dataSource       = self;
    self.addressTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.addressTableView.showsVerticalScrollIndicator = NO;
    self.addressTableView.scrollEnabled = NO;
    self.addressTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
   
    [self.view addSubview:self.addressTableView];
    [self.addressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(9 + statusBarAndNavigationBarHeight);
        make.size.height.mas_equalTo(43 * 4 + 84);
    }];
    
    self.saveBtn = [self createBtnWithColor:@"ffffff" font:16];//0.82
    self.saveBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.addressTableView.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH * 0.82, 43));
    }];
    [self.saveBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.isEdit) {
            [weakSelf updateUserAddressRequest];
        }else{
            [weakSelf addUserAddressRequest];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

-(void)addUserAddressRequest{
    
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:TF_TAG];
    UITextField *telTF = (UITextField *)[self.view viewWithTag:TF_TAG + 3];
    if ([nameTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写真实姓名" addToView:nil];
    }else if ([self.addressStr isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请选择所在地区" addToView:nil];
    }else if ([telTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写电话" addToView:nil];
    }else if ([self.addressTextView.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写详细地址" addToView:nil];
    }else{
        __weak __typeof(self)weakSelf = self;
        [HLYHUD showLoadingHudAddToView:nil];
        NSString *url = @"v1.address/add";
        NSDictionary *params = @{@"address_name":nameTF.text,
                                 @"address_phone":telTF.text,
                                 @"address_city":self.addressStr,
                                 @"address_details":self.addressTextView.text,
                                 @"address_state":self.defaultSwitch.isOn ? @"1":@"0"};
        [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
            [HLYHUD hideAllHUDsForView:nil];
            NSLog(@"%@",dict);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(NSDictionary *dict) {
            [HLYHUD hideAllHUDsForView:nil];
            [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
        }];
    }
    
   
    
    
}

-(void)updateUserAddressRequest{
    
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:TF_TAG];
    UITextField *telTF = (UITextField *)[self.view viewWithTag:TF_TAG + 3];
    if ([nameTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写真实姓名" addToView:nil];
    }else if ([self.addressStr isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请选择所在地区" addToView:nil];
    }else if ([telTF.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写电话" addToView:nil];
    }else if ([self.addressTextView.text isEqualToString:@""]) {
        [HLYHUD showHUDWithMessage:@"请填写详细地址" addToView:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.address/edit";
    NSDictionary *params = @{@"address_name":nameTF.text,
                             @"address_phone":telTF.text,
                             @"address_city":self.addressStr,
                             @"address_details":self.addressTextView.text,
                             @"address_state":self.defaultSwitch.isOn ? @"1":@"0",
                             @"id":self.addressData[@"id"]
                             };
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 2) {
        return 84;
    }
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self)weakSelf = self;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell andIndexPath:indexPath];
    return cell;
    
    
}
-(void)configureCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    UILabel *leftLabel = [self createLabelWithColor:@"000000" font:15];
    leftLabel.text = self.dataArray[indexPath.row];
    [cell.contentView addSubview:leftLabel];
//    if (indexPath.row == 4) {
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(24);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
//    }else{
//        leftLabel.frame = CGRectMake(24, 12, 50, 20);
//         [self changeAlignmentRightAndLeft:leftLabel];
//    }
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [cell.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.size.height.mas_equalTo(1);
    }];
    
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        UITextField *telTF = [[UITextField alloc] init];
        telTF.placeholder = indexPath.row == 0 ? @"请填写真实姓名" : @"请填写可联系到的电话";
        telTF.textColor = [UIColor colorWithHexString:@"585757"];
        telTF.delegate = self;
        telTF.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 3) {
            telTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        telTF.tag = TF_TAG + indexPath.row;
        if (self.addressData) {
            telTF.text = indexPath.row == 0 ? self.addressData[@"name"] : self.addressData[@"phone"];
        }
        [cell.contentView addSubview:telTF];
        [telTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(24 + 60 + 21);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
        }];
        telTF.font = [UIFont systemFontOfSize:12];
        [telTF setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        [telTF setValue:[UIColor colorWithHexString:@"585757"] forKeyPath:@"_placeholderLabel.textColor"];
    }else if (indexPath.row == 1){
        
        //rightIcon
        UIImageView *rightImgView = [[UIImageView alloc] init];
        rightImgView.image = [UIImage imageNamed:@"rightIcon"];
        [cell.contentView addSubview:rightImgView];
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        
        UILabel *rightLabel = [self createLabelWithColor:@"585757" font:12];
        rightLabel.text = @"请选择";
        [cell.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImgView.mas_left).offset(-14);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        
        
        UILabel *midLabel = [self createLabelWithColor:@"585757" font:12];
        midLabel.text = self.addressStr;
        [cell.contentView addSubview:midLabel];
        [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.right.equalTo(rightLabel.mas_left).offset(-5);
            make.left.equalTo(cell.contentView.mas_left).offset(24 + 60 + 21);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(200, 15));
        }];
        
        
    }else if (indexPath.row == 2){
        [leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(24);
            make.top.equalTo(cell.contentView.mas_top).offset(15);
        }];
        self.addressTextView = [[UITextView alloc] init];
        self.addressTextView.font = [UIFont systemFontOfSize:12];;
        self.addressTextView.keyboardType = UIKeyboardTypeDefault;
        self.addressTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.addressTextView.delegate = self;
        self.addressTextView.textColor = [UIColor colorWithHexString:@"585757"];
        if (self.addressData) {
           self.addressTextView.text = self.addressData[@"details"];
        }else{
           self.addressTextView.text = @"请输入详细地址信息";
        }
        
        [cell.contentView addSubview:self.addressTextView];
        [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.contentView.mas_left).offset(24 + 60 + 21);
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.top.equalTo(leftLabel.mas_top).offset(-5);
            make.size.height.mas_equalTo(84 - 15 - 10);
        }];
    }else if (indexPath.row == 4){
        [cell.contentView addSubview:self.defaultSwitch];
        if (self.addressData) {
            if (self.addressData[@"state"] && [self.addressData[@"state"] integerValue] == 1) {
                self.defaultSwitch.on = YES;
            }else{
                self.defaultSwitch.on = NO;
            }
        }
        [self.defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
    }
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        LNAddressSelectView *pickerView = [[LNAddressSelectView alloc] init];
        __weak typeof(self) weakSelf = self;
        pickerView.refreshInfoBlock = ^(NSString *infoStr, NSString *code) {
            //weakSelf.addressLabel.text = [infoStr stringByReplacingOccurrencesOfString:@" " withString:@","];
            //self.code = code;
            weakSelf.addressStr = infoStr;
           // [weakSelf.addressTableView reloadData];
            [weakSelf.addressTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.view addSubview:pickerView];
    }
    
}
- (void)changeAlignmentRightAndLeft:(UILabel *)label {
    
    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :label.font}  context:nil].size;
    
    CGFloat margin = (label.frame.size.width - textSize.width) / (label.text.length - 1);
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedString addAttribute:NSKernAttributeName value:number range:NSMakeRange(0,label.text.length -1)];
    
    label.attributedText = attributedString;
    
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入详细地址信息"]) {
        textView.text = @"";
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        self.self.addressTextView.text = @"请输入详细地址信息";
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
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return btn;
    
}
-(UISwitch *)defaultSwitch{
    
    if (!_defaultSwitch) {
        _defaultSwitch = [[UISwitch alloc] init];
        _defaultSwitch.on = YES;
        _defaultSwitch.onTintColor = [UIColor colorWithHexString:@"2ebac2"];
    }
    
    return _defaultSwitch;
    
}
@end
