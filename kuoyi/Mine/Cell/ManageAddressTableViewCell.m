//
//  ManageAddressTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ManageAddressTableViewCell.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import "UtilsMacro.h"


@interface ManageAddressTableViewCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *detailAddressLabel;

@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UIButton *editBtn;


@end

@implementation ManageAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        [self p_initUI];
    }
    
    return self;
}

-(void)p_initUI{
    
      __weak typeof(self) weakSelf = self;
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.size.height.mas_equalTo(50);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.botView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.botView);
        make.size.height.mas_equalTo(1);
    }];
    
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultBtn setImage:[UIImage imageNamed:@"shopUnSelect"] forState:UIControlStateNormal];
    [self.defaultBtn setImage:[UIImage imageNamed:@"shopSelect"] forState:UIControlStateSelected];
    [self.botView addSubview:self.defaultBtn];
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(25);
    }];
//    [self.defaultBtn bk_addEventHandler:^(id sender) {
//        self.defaultBtn.selected = !self.defaultBtn.selected;
//        if (weakSelf.selectCallBack) {
//            weakSelf.selectCallBack(self.defaultBtn);
//        }
//    } forControlEvents:UIControlEventTouchUpInside];
    
    self.defaultLabel = [self createLabelWithColor:@"000000" font:15];
    self.defaultLabel.text = @"默认地址";
    [self.botView addSubview:self.defaultLabel];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.botView.mas_centerY);
        make.left.equalTo(self.defaultBtn.mas_right).offset(10);
    }];
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"编辑" attributes:@{NSUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"17a7af"]}];
    self.editBtn = [self createBtnWithColor:@"17a7af" font:12];
    [self.editBtn setImage:[UIImage imageNamed:@"addressedit"] forState:UIControlStateNormal];
    [self.editBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [self.botView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.botView.mas_right).offset(-25);
        make.centerY.equalTo(self.botView.mas_centerY);
    }];
    self.editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [self.editBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.editCallBack) {
            weakSelf.editCallBack();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.botView.mas_top);
    }];
    
    //112  35  44
    CGFloat nameTop = 10;
    CGFloat detailBot = 10;
    if (is55InchScreen || isiPhoneXScreen) {
        nameTop = 12;
        detailBot = 12;
    }
    self.nameLabel = [self createLabelWithColor:@"000000" font:13];
    [self.topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(37);
        make.top.equalTo(self.topView.mas_top).offset(nameTop);
    }];
    
    self.mobileLabel = [self createLabelWithColor:@"000000" font:13];
    [self.topView addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-37);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    self.addressLabel = [self createLabelWithColor:@"000000" font:13];
    [self.topView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9);
    }];
    
    self.detailAddressLabel = [self createLabelWithColor:@"000000" font:13];
    [self.topView addSubview:self.detailAddressLabel];
    [self.detailAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        //make.top.equalTo(self.addressLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-detailBot);
    }];
}

-(void)configureCellWithData:(NSDictionary *)data{
//    city = "\U6cb3\U5317\U7701,\U90a2\U53f0\U5e02,\U4efb\U53bf";
//    createtime = 1529416232;
//    details = 123213;
//    "fixed_telephone" = "<null>";
//    id = 6;
//    name = "";
//    phone = 15200000001;
//    state = 1;
//    "user_uuid" = ffdf22c1b7f5bb3fc1af1b382c23ba4f;
//    uuid = "<null>";
    self.mobileLabel.text = data[@"phone"];//@"13980187654";
    self.nameLabel.text = data[@"name"];//@"阿萨德";
    NSString *cityStr = data[@"city"];
    if ([cityStr containsString:@","]) {
        cityStr = [cityStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
    }
    if (data[@"state"] && [data[@"state"] integerValue] == 1) {
        self.defaultBtn.selected = YES;
        self.defaultBtn.hidden = NO;
        self.defaultLabel.hidden = NO;
    }else{
        self.defaultBtn.selected = NO;
        self.defaultBtn.hidden = YES;
        self.defaultLabel.hidden = YES;
    }
    self.addressLabel.text = data[@"city"];//@"四川 成都";
    self.detailAddressLabel.text = data[@"details"];//@"高新区天府软件园E区6栋";
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
@end
