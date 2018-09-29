//
//  UserMarkCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/9/14.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "UserMarkCollectionViewCell.h"
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import "NSString+TPValidator.h"
#import <BlocksKit+UIKit.h>



@interface UserMarkCollectionViewCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *segView;

@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation UserMarkCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    
    __weak __typeof(self)weakSelf = self;
    
    self.leftLabel = [self createLabelWithColor:@"3c3c3c" font:17];
    [self.contentView addSubview:self.leftLabel];
   
    
    self.segView = [[UIView alloc] init];
    self.segView.backgroundColor = [UIColor colorWithHexString:@"f9fe07"];
    [self.contentView addSubview:self.segView];
    
    //
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"mark_select"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        //make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    [self.selectBtn bk_addEventHandler:^(id sender) {
        weakSelf.selectBtn.selected = !weakSelf.selectBtn.selected;
        if (weakSelf.selectCallBack) {
            weakSelf.selectCallBack(weakSelf.selectBtn.selected);
        }
    } forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)configureData:(NSDictionary *)data{
    
    NSString *markStr = data[@"title"];
    CGFloat lblWidth = [NSString caculateWidth:markStr font:17 size:CGSizeMake(200, 20)];
    self.leftLabel.text = markStr;
    
    if (data[@"is_select"] && [data[@"is_select"] integerValue] == 1) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_left).offset(20 + lblWidth + 2);
        make.size.height.mas_equalTo(20);
    }];//
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.left.equalTo(self.leftLabel.mas_left);
        make.right.equalTo(self.leftLabel.mas_right);
        make.size.height.mas_equalTo(3);
    }];
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
