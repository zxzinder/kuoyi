//
//  UserInfoViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "FileCacheTool.h"
#import "SettingDataSource.h"
#import <BlocksKit+UIKit.h>
#import "LNAddressSelectView.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "CustomerManager.h"
#import "CTAlertView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <UIImageView+WebCache.h>
#import "NotificationMacro.h"
#import "ActionSeetPickerView.h"
#import "ChangePhoneViewController.h"


#define TF_TAG 1000
#define ACTION_TAG 1234
static NSString *CELLID = @"userCell";
@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ActionSeetPickViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) NSArray *dataSourceArray;

@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, copy) NSString *selectAddress;

@property (nonatomic, strong) Customer *customer;

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, copy) NSArray *sexArray;
@property (nonatomic, copy) NSArray *constellationArray;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 //   self.view.backgroundColor = [UIColor redColor];
    self.customer = [CustomerManager sharedInstance].customer;
    self.dataSourceArray = @[@[@"头像"],
                             @[@"昵称",@"手机号",@"星座",@"性别",@"所在地",@"个人介绍"]
                            // @[@"QQ",@"微信",@"新浪微博"]
                             ];
    self.sexArray = @[@"男",@"女",@"中性"];
    self.constellationArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
      __weak __typeof(self)weakSelf = self;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"请完善个人资料";
    //right
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 30, 20);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"17a7af"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.rightBtn bk_addEventHandler:^(id sender) {
        [weakSelf saveUserInfo];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.selectAddress = [NSString stringWithFormat:@"%@,%@,%@",self.customer.province,self.customer.city,self.customer.district_county];
    [self p_initUI];
 
}

-(void)p_initUI{
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.userTableView.delegate         = self;
    self.userTableView.dataSource       = self;
    self.userTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.userTableView.showsVerticalScrollIndicator = NO;
    self.userTableView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    self.userTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.userTableView];
    CGFloat offsetY = 0;
    if (iOS11) {
        offsetY = statusBarAndNavigationBarHeight;
    }
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(offsetY);
    }];
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 72;
    }else if (indexPath.section == 1){
        return 59;
    }else{
        return 48;
    }
    
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
    if (indexPath.section == 2 && indexPath.row == 1) {
        
    }else if (indexPath.section == 0 && indexPath.row == 0){
        [self UpdateIcon];
    }else if (indexPath.section == 1 ){
        if (indexPath.row == 1) {
            ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
            vc.finishCallback = ^(NSString * _Nonnull newPhone) {
                UITextField *mobileTF = (UITextField *)[self.view viewWithTag:TF_TAG + 1];
                mobileTF.text = newPhone;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            ActionSeetPickerView *picker = [[ActionSeetPickerView alloc] initPickviewWithArray:self.constellationArray isHaveNavControler:YES];
            picker.delegate = self;
            picker.tag = ACTION_TAG + indexPath.row;
            [picker setToolbarTintColor:[UIColor whiteColor]];
            [picker setLeftTintColor:[UIColor tp_lightGaryTextColor]];
            [picker setRightTintColor:[UIColor colorWithHexString:@"17a7af"]];
            [picker show];
        }else if (indexPath.row == 3){
            ActionSeetPickerView *picker = [[ActionSeetPickerView alloc] initPickviewWithArray:self.sexArray isHaveNavControler:YES];
            picker.delegate = self;
            picker.tag = ACTION_TAG + indexPath.row;
            [picker setToolbarTintColor:[UIColor whiteColor]];
            [picker setLeftTintColor:[UIColor tp_lightGaryTextColor]];
            [picker setRightTintColor:[UIColor colorWithHexString:@"17a7af"]];
            [picker show];
        }
        else if (indexPath.row == 4){
            
            LNAddressSelectView *pickerView = [[LNAddressSelectView alloc] init];
            __weak typeof(self) weakSelf = self;
            
            pickerView.refreshInfoBlock = ^(NSString *infoStr, NSString *code) {
                weakSelf.selectAddress = infoStr;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:1];
                [weakSelf.userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.view addSubview:pickerView];
        }

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
    
    
    UILabel *leftLabel = [self createLabelWithColor:@"585757" font:15];
    leftLabel.text = self.dataSourceArray[indexPath.section][indexPath.row];
    [cell.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(25);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    if (indexPath.section == 0) {
        self.headImgView = [[UIImageView alloc] init];
        NSString *defaultHeadStr = [CustomerManager sharedInstance].customer.gender == 2 ? @"headgirl":@"headboy";
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[CustomerManager sharedInstance].customer.headimg] placeholderImage:[UIImage imageNamed:defaultHeadStr]];
        [cell.contentView addSubview:self.headImgView];
        [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-25);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }else if (indexPath.section == 1) {
        UITextField *contentTF = [[UITextField alloc] init];
        NSString *content;
        NSString *textColor;
        if (indexPath.row == 0) {
            textColor = @"16a5b0";
             content = self.customer.nickname;
        }else if (indexPath.row == 1){
            textColor = @"fe6c6c";
            content = self.customer.mobile;
            contentTF.enabled = NO;
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
        }else if (indexPath.row == 2){
            textColor = @"b4b4b5";
            contentTF.enabled = NO;
            if (self.customer.constellation && ![self.customer.constellation isEqualToString:@""]) {
                content = self.customer.constellation;
            }else{
                content = @"请选择";
            }
            
        }else if (indexPath.row == 3){
            textColor = @"b4b4b5";
            contentTF.enabled = NO;
            if (self.customer.gender == 0) {
               content = @"未选择";
            }else{
               content = self.sexArray[self.customer.gender - 1];
            }
            
        }else if (indexPath.row == 4){
            textColor = @"b4b4b5";
            contentTF.enabled = NO;
            content = self.selectAddress;
        }else{//5
            textColor = @"b4b4b5";
            content = self.customer.info;
        }
        contentTF.returnKeyType = UIReturnKeyDone;
        contentTF.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:contentTF];
        [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-30);
            make.left.equalTo(cell.contentView.mas_left).offset(120);
            make.centerY.equalTo(leftLabel.mas_centerY);
        }];
        contentTF.tag = TF_TAG + indexPath.row;
        contentTF.delegate = self;
        contentTF.font = [UIFont systemFontOfSize:14];
        // [contentTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//        [contentTF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        contentTF.text = content; //self.infoArray[indexPath.section][@"passengerName"];
    
        contentTF.textColor = [UIColor colorWithHexString:textColor];
  
      
    }

    
    
    //rightIcon
    UIImageView *rightImgView = [[UIImageView alloc] init];
    rightImgView.image = [UIImage imageNamed:@"rightIcon"];
    rightImgView.hidden = YES;
    [cell.contentView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    if (indexPath.section == 1) {
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3  || indexPath.row == 4) {
            rightImgView.hidden = NO;
        }
    }
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [cell.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    if (indexPath.section == 2) {
        UILabel *rightLabel = [self createLabelWithColor:@"999999" font:15];
        [cell.contentView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(rightImgView.mas_left).offset(-10);
        }];
    }

}

-(void)saveUserInfo{
    
    NSLog(@"1111");
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:TF_TAG];
    UITextField *mobileTF = (UITextField *)[self.view viewWithTag:TF_TAG + 1];
    UITextField *xzTF = (UITextField *)[self.view viewWithTag:TF_TAG + 2];
    UITextField *infoTF = (UITextField *)[self.view viewWithTag:TF_TAG + 5];
    NSArray *addressArray;
    if ([self.selectAddress containsString:@","]) {
       addressArray = [self.selectAddress componentsSeparatedByString:@","];
    }else{
        addressArray = @[@"",@"",@""];
    }
    
    NSDictionary *params = @{@"head_img":self.customer.headimg ? self.customer.headimg :@"",
                             @"nick_name":nameTF.text ? nameTF.text:@"",
                             @"phone":mobileTF.text ? mobileTF.text:@"",
                             @"email":self.customer.email ? self.customer.email :@"",
                             @"sex":@(self.customer.gender ? self.customer.gender :0),
                             @"date_birth":self.customer.birthday ? self.customer.birthday :@"",
                             @"province":addressArray[0],
                             @"city":addressArray[1],
                             @"county":addressArray[2],
                             @"introduce":infoTF.text ? infoTF.text:@"",
                             @"constellation":self.customer.constellation ? self.customer.constellation :@"",
                             };
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.user/updateInfo";
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [HLYHUD showHUDWithMessage:@"保存成功！" addToView:nil];
        self.customer.province = addressArray[0];
        self.customer.city = addressArray[1];
        self.customer.district_county = addressArray[2];
        self.customer.info = infoTF.text;
        self.customer.nickname = nameTF.text;
        self.customer.mobile = mobileTF.text;
        [[CustomerManager sharedInstance] updateCustomer];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateHeadImg object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        if (dict[@"error"] && [dict[@"error"] integerValue] == 400) {
             [HLYHUD showHUDWithMessage:dict[@"data"] addToView:nil];
        }else{
             [HLYHUD showHUDWithMessage:dict[@"message"] addToView:nil];
        }
       
    }];
}
-(void)UpdateIcon{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"相册",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)uploadPhotoAndControllerWithImage:(UIImage*)image
{
    //2. 利用时间戳当做图片名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *imageName = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
    
    //3. 图片二进制文件
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    NSLog(@"upload image size: %ld k", (long)(imageData.length / 1024));
    [HLYHUD showLoadingHudAddToView:nil];
    [KYNetService upload:imageData FileName:fileName MimeType:@"image/jpeg" sucess:^(NSDictionary *dic) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dic);
        self.customer.headimg = dic[@"headimg"];
    } error:^(NSError *error) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:@"上传头像失败!" addToView:nil];
    }];
}
-(void)goToCarmera:(NSUInteger)sourceType{
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
#pragma mark - image picker delegte

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *imgData = UIImageJPEGRepresentation(image , 0.5);
        if (image) {
            self.headImgView.image = [UIImage imageWithData:imgData];
           // weakSelf.headImage.image = [UIImage imageWithData:imgData];
          //  weakSelf.headImgData = imgData;
            [weakSelf uploadPhotoAndControllerWithImage:image];
            
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)p_configAlertView {
    
    [CTAlertView showAlertViewWithTitle:@"小贴士"  Details:@"相机权限被关闭啦，请到设置->易来客运->相机中打开相机权限就行了。" CancelButton:@"取消" DoneButton:@"去设置" callBack:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {//App-Prefs:root=Privacy  LOCATION_SERVICES
            NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
}
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSUInteger sourceType = 0;
    
    switch (buttonIndex) {
        case 0:{
            // 相册
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self goToCarmera:sourceType];
            break;
        }
        case 1:{
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                //[HLYHUD showHUDWithMessage:@"请允许易来客运访问你的相机" addToView:nil];
                [self p_configAlertView];
            }else{
                // 判断是否支持相机
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    // 拍照
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self goToCarmera:sourceType];
                }else{
                    [HLYHUD showHUDWithMessage:@"当前设备不支持拍照功能!" addToView:nil];
                    return;
                }
            }
            
            break;
        }
        case 2:{
            return;
        }
    }
    
    
}

#pragma mark ActionSeetPickViewDelegate
- (void)toobarDonBtnHaveClick:(ActionSeetPickerView *)pickView resultString:(NSString *)resultString {
   
    NSLog(@"%@",resultString);
    if (pickView.tag - ACTION_TAG == 3) {//性别
        for (int i = 0; i<self.sexArray.count; i++) {
            if ([resultString isEqualToString:self.sexArray[i]]) {
                self.customer.gender = i+1;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:1];
                [self.userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            }
        }
    }else{
        self.customer.constellation = resultString;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        [self.userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tfTag = textField.tag;
    if (tfTag == TF_TAG + 1) {//手机
        if(range.location > 10){
            return NO;
        }
    }else if (tfTag == TF_TAG){//姓名
        if(range.location > 10){
            return NO;
        }
    }
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
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
