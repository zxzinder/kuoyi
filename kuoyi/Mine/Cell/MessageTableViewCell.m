//
//  MessageTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>
#import "MessageModel.h"

@interface MessageTableViewCell()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;


@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *infoLabel;

@end


@implementation MessageTableViewCell

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
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.size.height.mas_equalTo(65);
    }];
    
    
    self.titleLabel = [self createLabelWithColor:@"16a6ae" font:15];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.top.equalTo(self.topView.mas_top).offset(18);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.size.height.mas_equalTo(13);
    }];
    
    self.timeLabel = [self createLabelWithColor:@"999999" font:10];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.size.height.mas_equalTo(13);
        make.left.equalTo(self.topView.mas_left).offset(15);
    }];

    self.botView = [[UIView alloc] init];
    self.botView.hidden = YES;
    self.botView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.topView.mas_bottom);

    }];
    
    self.infoLabel = [self createLabelWithColor:@"595757" font:12];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.botView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left).offset(15);
        make.top.equalTo(self.botView.mas_top);
        make.right.equalTo(self.botView.mas_right).offset(-15);
        make.bottom.equalTo(self.botView.mas_bottom).offset(-19);
    }];
    
    UIView *segView = [[UIView alloc] init];
    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.contentView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.size.height.mas_equalTo(1);
    }];
    
}
-(void)configureCellWithData:(MessageModel *)data{
//    createtime = "<null>";
//    id = 2;
//    msg = "\U606d\U559c\U8d2d\U4e70\U6210\U529f\Uff0c\U6210\U4e3a\U6211\U4eec\U7684\U4f1a\U5458\Uff01\U54c8\U54c8\U54c8\U54c8\Uff0c\U54df\U54df\U5207\U514b\U95f9";
//    state = 0;
//    title = "\U8d2d\U4e70\U6210\U529f";
//    "user_uid" = ffdf22c1b7f5bb3fc1af1b382c23ba4f;
    self.titleLabel.text = data.msgData[@"title"];
    
    NSString *timeStampString  =[NSString stringWithFormat:@"%@",data.msgData[@"createtime"]];
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    self.timeLabel.text = dateString;
    if (data.msgData[@"state"] && [data.msgData[@"state"] integerValue] == 0) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"16a6ae"];
    }else{
        self.titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
    }
    if (data.isShowDetail) {
         self.botView.hidden = NO;
        self.infoLabel.text = data.msgData[@"msg"];
    }else{
        self.botView.hidden = YES;
    }
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
