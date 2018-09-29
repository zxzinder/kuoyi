//
//  PayAddressTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/9.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "PayAddressTableViewCell.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"

@interface PayAddressTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *detailAddressLabel;
@property (nonatomic, strong) UILabel *defaultLabel;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation PayAddressTableViewCell

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
    __weak __typeof(self)weakSelf = self;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    //104
    self.defaultLabel = [self createLabelWithColor:@"f20804" font:10];
    self.defaultLabel.text = @"默认地址";
    [self.contentView addSubview:self.defaultLabel];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        make.left.equalTo(self.contentView.mas_left).offset(38);
    }];
    
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"编辑" attributes:@{NSUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"17a7af"]}];
    self.editBtn = [self createBtnWithColor:@"17a7af" font:12];
    [self.editBtn setImage:[UIImage imageNamed:@"addressedit"] forState:UIControlStateNormal];
    [self.editBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [self.contentView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(self.defaultLabel.mas_centerY);
    }];
    self.editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [self.editBtn bk_addEventHandler:^(id sender) {
        
        if (weakSelf.editCallBack) {
            weakSelf.editCallBack();
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nameLabel = [self createLabelWithColor:@"000000" font:12];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(38);
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    self.mobileLabel = [self createLabelWithColor:@"000000" font:12];
    [self.contentView addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-38);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    self.addressLabel = [self createLabelWithColor:@"000000" font:12];
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    
    self.detailAddressLabel = [self createLabelWithColor:@"000000" font:12];
    [self.contentView addSubview:self.detailAddressLabel];
    [self.detailAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(5);
    }];
}
-(void)configureCellWithData:(NSDictionary *)data{
    
    self.mobileLabel.text = data[@"phone"];//@"13980187654";
    self.nameLabel.text = data[@"name"];//@"阿萨德";
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
