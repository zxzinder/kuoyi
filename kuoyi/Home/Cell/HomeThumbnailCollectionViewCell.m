//
//  HomeThumbnailCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/25.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "HomeThumbnailCollectionViewCell.h"
#import "UtilsMacro.h"
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import "HomeDetail.h"
#import <UIImageView+WebCache.h>

@interface HomeThumbnailCollectionViewCell()


@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *segView;

@property (nonatomic, strong) UIView *btnsView;

@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end


@implementation HomeThumbnailCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void) p_init{
    //0.6
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    CGFloat cellHeight = self.frame.size.height;
    CGFloat cellWidth = self.frame.size.width;
    self.topImgView = [[UIImageView alloc] init];

    [self.contentView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.size.height.mas_equalTo(cellWidth * 0.6);
    }];
    CGFloat segViewBot = 26;
    CGFloat nameFont = 16;
    if (is55InchScreen || isiPhoneXScreen) {
        nameFont = 18;
        segViewBot = 34;
    }
    self.segView = [[UIView alloc] init];
    self.segView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.contentView addSubview:self.segView];
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        //make.top.equalTo(self.topImgView.mas_bottom).offset(segViewTop);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-segViewBot);
        make.size.height.mas_equalTo(1);
    }];
    
    self.nameLabel = [self createLabelWithColor:@"314a37" font:nameFont];

    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(self.segView.mas_top).offset(-segViewTop/2);
        make.top.equalTo(self.topImgView.mas_bottom).offset(3);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    
    self.btnsView = [[UIView alloc] init];
    self.btnsView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.btnsView];
    [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.segView.mas_bottom);
    }];
    
}
-(void)configeData:(HomeDetail *)detail andDic:(NSDictionary *)data{
    NSArray *typeArray = data[@"type"];
    if (detail.img.count > 0) {
        NSURL *imgurl = [NSURL URLWithString:detail.fengmian];//detail.img[0][@"url"]
        [self.topImgView sd_setImageWithURL:imgurl placeholderImage:[self imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 1, 1)]];
    }else{
        self.topImgView.image = [self imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 1, 1)];

    }
    
    self.nameLabel.text = detail.name;
    CGFloat cellHeight = self.frame.size.height ;
    CGFloat btnsViewHeight = cellHeight * 0.4 * 0.6;
    CGFloat btnX,btnY,btnW,btnH;
    NSInteger count = typeArray.count;
    btnX = 10;
    btnY = 3;
    if (is55InchScreen || isiPhoneXScreen) {
         btnY = 7;
    }
   
    btnW = 19;//btnsViewHeight-15;
    btnH = 19;//btnsViewHeight-15;
    for(UIView *view in [self.btnsView subviews]){//移除所有view
        [view removeFromSuperview];
    }
    for (int i = 0; i < count; i++) {
        btnX = 5 + i * btnW + i * 3;
//        UIButton *btn = [self createBtnWithColor:@"844915" font:10 icon:nil];
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//       // [self setButtonContentCenter:btn];
//        btn.titleEdgeInsets = UIEdgeInsetsMake(btnW ,-btnW, 0,0);
//        btn.imageEdgeInsets = UIEdgeInsetsMake(-10 ,0, 0,0);
//        [btn setImage:[self imageWithColor:[UIColor redColor] Rect:CGRectMake(0, 0, btnW, btnW)] forState:UIControlStateNormal];
//        [btn setTitle:@"book" forState:UIControlStateNormal];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:typeArray[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self.btnsView addSubview:imgView];
    }
    
}
-(void)configureCellColor:(NSString *)titleColor andSegColor:(NSString *)segColor{
    
    self.nameLabel.textColor = [UIColor colorWithHexString:titleColor];
    self.segView.backgroundColor = [UIColor colorWithHexString:segColor];
    
}
- (UIImage *)imageWithColor:(UIColor *)aColor Rect:(CGRect)aRect {
    
    UIGraphicsBeginImageContext(aRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
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
@end
