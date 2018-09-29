//
//  OrderTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/10.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "OrderTableViewCell.h"
#import <Masonry.h>
#import <BlocksKit+UIKit.h>
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <UIImageView+WebCache.h>


@interface OrderTableViewCell()

@property (nonatomic, strong) UIImageView *proImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation OrderTableViewCell

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
    self.proImgView = [[UIImageView alloc] init];
    self.proImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.proImgView];
    [self.proImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(38);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.nameLabel = [self createLabelWithColor:@"000000" font:14];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(14);
        make.top.equalTo(self.proImgView.mas_top);
    }];
    
    self.descLabel = [self createLabelWithColor:@"585757" font:12];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    self.priceLabel = [self createLabelWithColor:@"f20804" font:15];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).offset(25);
    }];
    
    self.countLabel = [self createLabelWithColor:@"595858" font:15];//13 9
    self.countLabel.font = [UIFont boldSystemFontOfSize:15];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.size.height.mas_equalTo(1);
    }];
}
-(void)configureCellWithData:(NSDictionary *)data{
    CGFloat price = [data[@"goods_price"] floatValue];
    self.priceLabel.attributedText = [self setPriceTextAttribute:@"CNY " with:[NSString stringWithFormat:@"%.2f",price]];
    //self.priceLabel.text =  [NSString stringWithFormat:@"CNY %@元",data[@"goods_price"]];//@"CNY 2000元";
    self.nameLabel.text = [NSString stringWithFormat:@"%@",data[@"goods_title"]];//@"禅学研习";
    self.descLabel.text = [NSString stringWithFormat:@"%@",data[@"title_two"]];// @"伍宝亲自编写教案，执教中华茶道课程。";
    [self.proImgView sd_setImageWithURL:[NSURL URLWithString:data[@"goods_img"]] placeholderImage:[UIImage imageNamed:@""]];
    self.countLabel.attributedText = [self setCountTextAttribute:@"x" with:[NSString stringWithFormat:@"%@",data[@"goods_num"]]];
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",data[@"price"]];//@"￥25.00";
//    self.nameLabel.text = @"《够用就好》第一期";
//    self.descLabel.text = @"(附赠《可末先生日记》1本)";
//    self.proImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, 80, 80)];
}
- (NSAttributedString *) setCountTextAttribute:(NSString *) purStr with:(NSString *)peoStr
{
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:purStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9]}];
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:peoStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    [priceAttribute appendAttributedString:endAttribute];
    
    return priceAttribute;
    
}
- (NSAttributedString *) setPriceTextAttribute:(NSString *) purStr with:(NSString *)peoStr
{
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(5 * (CGFloat)M_PI / 180), 1, 0, 0);//设置反射。倾斜角度。
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName :[UIFont systemFontOfSize:15].fontName matrix:matrix];//取得系统字符并设置反射。
    //self.priceLabel.font = [UIFont fontWithDescriptor:desc size :15];
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:purStr attributes:@{NSFontAttributeName : [UIFont fontWithDescriptor:desc size :15]}];
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",peoStr] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
    [priceAttribute appendAttributedString:endAttribute];
    
    return priceAttribute;
    
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
