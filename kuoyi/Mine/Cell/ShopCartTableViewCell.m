//
//  ShopCartTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/8.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ShopCartTableViewCell.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "UIImage+Generate.h"
#import <BlocksKit+UIKit.h>
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>


@interface ShopCartTableViewCell()


@property (nonatomic, strong) UIImageView *proImgView;

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, assign) NSInteger currentCount;

@end

@implementation ShopCartTableViewCell

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
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"shopUnSelect"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"shopSelect"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    [self.selectBtn bk_addEventHandler:^(id sender) {
        weakSelf.selectBtn.selected = !weakSelf.selectBtn.selected;
        if (weakSelf.selectCallBack) {
            weakSelf.selectCallBack(weakSelf.selectBtn.selected);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.proImgView = [[UIImageView alloc] init];
    self.proImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.proImgView];
    [self.proImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.selectBtn.mas_right).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(24 + 24);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = [UIColor clearColor];//self.contentView.backgroundColor;
    [self.contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.proImgView.mas_right).offset(14);
        make.top.bottom.right.equalTo(self.contentView);
    }];
    
    self.nameLabel = [self createLabelWithColor:@"000000" font:14];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.infoView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView.mas_left);
        make.top.equalTo(self.proImgView.mas_top);
        make.right.equalTo(self.infoView.mas_right).offset(-14);
    }];
    
    self.descLabel = [self createLabelWithColor:@"585757" font:12];
     self.descLabel.textAlignment = NSTextAlignmentLeft;
    [self.infoView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.infoView.mas_right).offset(-14);
    }];
    
    self.priceLabel = [self createLabelWithColor:@"f20804" font:15];
    //self.priceLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:15];
    [self.infoView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        //make.top.equalTo(self.descLabel.mas_bottom).offset(19);
        make.bottom.equalTo(self.infoView.mas_bottom).offset(-30);
    }];
    //NSUnderlineStyleAttributeName : [NSNumber numberWithBool:YES]
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"编辑" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    self.editBtn = [self createBtnWithColor:@"595757" font:12];
    [self.editBtn setImage:[UIImage imageNamed:@"shopedit"] forState:UIControlStateNormal];
    [self.editBtn setAttributedTitle:attribute forState:UIControlStateNormal];
    [self.infoView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.infoView.mas_right).offset(-14);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    self.editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [self.editBtn bk_addEventHandler:^(id sender) {
        weakSelf.editView.hidden = NO;
        weakSelf.infoView.hidden = YES;
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.countLabel = [self createLabelWithColor:@"595858" font:15];//13 9
    self.countLabel.font = [UIFont boldSystemFontOfSize:15];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.infoView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.mas_right);
        //make.top.equalTo(self.descLabel.mas_bottom).offset(19);
        make.bottom.equalTo(self.priceLabel.mas_bottom);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.infoView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView.mas_left);
        make.right.equalTo(self.infoView.mas_right);
        make.bottom.equalTo(self.infoView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    
    self.editView = [[UIView alloc] init];
    self.editView.hidden = YES;
    self.editView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.proImgView.mas_right).offset(14);
//        make.top.bottom.right.equalTo(self.contentView);
        make.edges.equalTo(self.contentView);
    }];
    
    self.numLabel = [self createLabelWithColor:@"000000" font:15];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.layer.borderWidth = 1;
    self.numLabel.layer.borderColor = [UIColor colorWithHexString:@"000000"].CGColor;
    [self.editView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.editView.mas_centerX).offset(30);
        make.top.equalTo(self.editView.mas_top).offset((103 - 80)/2);
        make.size.mas_equalTo(CGSizeMake(100, 33));
    }];
    
    self.minusBtn = [self createBtnWithColor:@"ffffff" font:15];
    self.minusBtn.backgroundColor = [UIColor blackColor];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.editView addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel.mas_left).offset(-3);
        make.centerY.equalTo(self.numLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23, 33));
    }];
    [self.minusBtn bk_addEventHandler:^(id sender) {
        [weakSelf a_minusProductCountAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.addBtn = [self createBtnWithColor:@"ffffff" font:15];
    self.addBtn.backgroundColor = [UIColor blackColor];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.editView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLabel.mas_right).offset(3);
        make.centerY.equalTo(self.numLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23, 33));
    }];
    
    [self.addBtn bk_addEventHandler:^(id sender) {
        [weakSelf a_addProductCountAction];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    self.remindLabel = [self createLabelWithColor:@"f20907" font:12];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.editView addSubview:self.remindLabel];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.numLabel.mas_centerX);
    }];
    
    self.finishBtn = [self createBtnWithColor:@"ffffff" font:13];
     self.finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.finishBtn.backgroundColor = [UIColor colorWithHexString:@"fb217d"];
    [self.editView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.editView);
        make.size.width.mas_equalTo(DEVICE_WIDTH * 0.16);
    }];
    
    [self.finishBtn bk_addEventHandler:^(id sender) {
        weakSelf.editView.hidden = YES;
        weakSelf.infoView.hidden = NO;
        if (weakSelf.addCountCallBack) {
            weakSelf.addCountCallBack(weakSelf.currentCount);
        }
    } forControlEvents:UIControlEventTouchUpInside];
}
-(void)configureCellWithData:(NSDictionary *)data{
    self.currentCount = 0;
    if (data[@"goods_num"]) {
        self.currentCount = [data[@"goods_num"] integerValue];
    }
    self.countLabel.attributedText = [self setCountTextAttribute:@"x" with:[NSString stringWithFormat:@"%@",data[@"goods_num"]]];
    CGFloat price = [data[@"goods_price"] floatValue];
    self.priceLabel.attributedText = [self setPriceTextAttribute:@"￥" with:[NSString stringWithFormat:@"%.2f",price]];
    //self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];//@"￥25.00";
    self.nameLabel.text = [NSString stringWithFormat:@"%@",data[@"goods_title"]];//@"《够用就好》第一期";
    self.descLabel.text = [NSString stringWithFormat:@"%@",data[@"describe"]];//@"(附赠《可末先生日记》1本)";
    self.proImgView.image = [UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 80, 80)];
//    if (data[@"goods_img"] && [data[@"goods_img"] isEqualToString:@"<null>"]) {
//          [self.proImgView sd_setImageWithURL:[NSURL URLWithString:data[@"goods_img"]] placeholderImage:[UIImage imageNamed:@""]];
//    }

    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    self.remindLabel.text = [NSString stringWithFormat:@"即将售罄，库存只有%@件",data[@"stock_num"]];//@"即将售罄，库存只有10件";
}
-(void)updateCellUI{
    
    [self.proImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(38);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.size.height.mas_equalTo(1);
    }];
}
-(void)a_addProductCountAction{
    
    self.currentCount ++ ;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
}
-(void)a_minusProductCountAction{
    
    if (self.currentCount > 0) {
        self.currentCount--;
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCount];
    }
    
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
    
    NSAttributedString *endAttribute = [[NSAttributedString alloc] initWithString:peoStr attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
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
