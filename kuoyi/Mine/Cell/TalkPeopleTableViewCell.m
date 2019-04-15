//
//  TalkPeopleTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/4/3.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "TalkPeopleTableViewCell.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import "TalkPeopleModel.h"
#import <UIImageView+WebCache.h>
#import <BlocksKit+UIKit.h>


@interface TalkPeopleTableViewCell()


@property (nonatomic, strong) UIImageView *collectImgView;
@property (nonatomic, strong) UILabel *collectLabel;

@property (nonatomic, strong) UIImageView *likeImgView;
@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, strong) UIImageView *shareImgView;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIImageView *commentImgView;
@property (nonatomic, strong) UILabel *commentLabel;


@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *briefLabel;

@property (nonatomic, strong) UIImageView *descImgView;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *typeView;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *titleImgArray;

@end

@implementation TalkPeopleTableViewCell

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
        self.titleArray = @[@"故事",@"书",@"空间",@"课程",@"活动",@"产品"];
        self.titleImgArray = @[@"talk_book",@"talk_book",@"talk_space",@"talk_lesson",@"talk_activity",@"talk_article"];
        [self p_initUI];
    }
    
    return self;
}

-(void)p_initUI{
     __weak __typeof(self)weakSelf = self;
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.size.height.mas_equalTo(94);
    }];
    
    CGFloat imgSizeHW = 67;
    self.headImgView = [[UIImageView alloc] init];
    self.headImgView.layer.cornerRadius = imgSizeHW/2;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.borderColor = [UIColor colorWithHexString:@"e2eaeb"].CGColor;
    //self.headImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, imgSizeHW, imgSizeHW)];
    [self.topView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(imgSizeHW, imgSizeHW));
    }];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView bk_whenTapped:^{
        if (weakSelf.headImgCallBack) {
            weakSelf.headImgCallBack();
        }
    }];
    
    self.nameLabel = [self createLabelWithColor:@"335b6b" font:15];
    //self.nameLabel.text = @"梁博";
    [self.topView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_top).offset(15);
    }];
    
    self.briefLabel = [self createLabelWithColor:@"335b6b" font:10];
    //self.briefLabel.text = @"LetterPress创始人";
    [self.topView addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    
//    self.descLabel = [self createLabelWithColor:@"585855" font:10];
//    self.descLabel.text = @"综合人气指数 300度";
//    [self.topView addSubview:self.descLabel];
//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.topView.mas_right).offset(-10);
//        make.centerY.equalTo(self.nameLabel.mas_centerY);
//    }];
    
    self.descImgView = [[UIImageView alloc] init];
    self.descImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.descImgView.image = [UIImage imageNamed:@"talk_delete"];
    [self.topView addSubview:self.descImgView];
    [self.descImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    
    UIView *botSegView = [[UIView alloc] init];
    botSegView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
    [self.topView addSubview:botSegView];
    [botSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.topView);
        make.size.height.mas_equalTo(1);
    }];
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    UIView *staticView = [[UIView alloc] init];
    staticView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.botView addSubview:staticView];
    [staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.botView);
        make.size.width.mas_equalTo(DEVICE_WIDTH * 0.35);
    }];

    self.commentLabel = [self createLabelWithColor:@"7e949a" font:10];
    self.commentLabel.text = @"";
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    [staticView addSubview:self.commentLabel];

    self.likeLabel = [self createLabelWithColor:@"7e949a" font:10];
    self.likeLabel.text = @"";
    self.likeLabel.textAlignment = NSTextAlignmentCenter;
    [staticView addSubview:self.likeLabel];

    self.shareLabel = [self createLabelWithColor:@"7e949a" font:10];
    self.shareLabel.text = @"";
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    [staticView addSubview:self.shareLabel];

    self.collectLabel = [self createLabelWithColor:@"7e949a" font:10];
    self.collectLabel.text = @"";
    self.collectLabel.textAlignment = NSTextAlignmentCenter;
    [staticView addSubview:self.collectLabel];

    NSArray *labelsArray = @[self.commentLabel,self.likeLabel,self.shareLabel,self.collectLabel];
    [labelsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [labelsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.mas_equalTo(12);
        make.bottom.equalTo(staticView.mas_bottom).offset(-10);
    }];
    self.commentImgView = [[UIImageView alloc] init];
    self.commentImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.commentImgView.image = [UIImage imageNamed:@"talk_comment"];
    [staticView addSubview:self.commentImgView];
    [self.commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentLabel.mas_top);
        make.centerX.equalTo(self.commentLabel.mas_centerX);
    }];

    self.likeImgView = [[UIImageView alloc] init];
    self.likeImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.likeImgView.image = [UIImage imageNamed:@"talk_praise"];
    [staticView addSubview:self.likeImgView];
    [self.likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.likeLabel.mas_top);
        make.centerX.equalTo(self.likeLabel.mas_centerX);
    }];

    self.shareImgView = [[UIImageView alloc] init];
    self.shareImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.shareImgView.image = [UIImage imageNamed:@"talk_share"];
    [staticView addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.shareLabel.mas_top);
        make.centerX.equalTo(self.shareLabel.mas_centerX);
    }];
    self.collectImgView = [[UIImageView alloc] init];
    self.collectImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectImgView.image = [UIImage imageNamed:@"talk_collect"];
    [staticView addSubview:self.collectImgView];
    [self.collectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectLabel.mas_top);
        make.centerX.equalTo(self.collectLabel.mas_centerX);
    }];
    
   
    
    
    self.typeView = [[UIView alloc] init];
    self.typeView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.botView addSubview:self.typeView];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(staticView.mas_right);
        make.right.top.bottom.equalTo(self.botView);
    }];

    

}

-(void)configureCellWithData:(TalkPeopleModel *)model{
//    {
//        class = 1;
//        createtime = 1530111649;
//        id = 59;
//        info =                 {
//            activity = 1; 活动
//            book = 1;     书
//            collect = 2;  收藏
//            course = 1;   课程
//            fabulous = 2; 点赞
//            goods = 0;    物品
//            headimg = "/uploadfile/20180526/8d686976abf34a946d1f108a5884524d.jpg";
//            labels = "\U72ec\U7acb\U51fa\U7248\U4eba";
//            "people_name" = Nelson;
//            "share_count" = 0; 分享
//            store = 0;    故事
//        };
//        "order_id" = 29;
//        "user_uid" = 0;
//    }
    self.nameLabel.text = model.peopleData[@"info"][@"people_name"] ? model.peopleData[@"info"][@"people_name"]:@"";
    self.briefLabel.text = model.peopleData[@"info"][@"labels"] ? model.peopleData[@"info"][@"labels"]:@"";
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.peopleData[@"info"][@"headimg"]] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    NSInteger titleCount = self.titleArray.count;
    CGFloat lblW = DEVICE_WIDTH * 0.65/ titleCount;
    CGFloat lblH = 12;
    CGFloat lblX = 0;
    if (model.isShowDetail) {
        for (UIView *view in [self.typeView subviews]){
            [view removeFromSuperview];
        }
        self.botView.hidden = NO;

        self.commentLabel.text = [NSString stringWithFormat:@"%@", model.peopleData[@"info"][@"comment"]];//
        self.likeLabel.text = [NSString stringWithFormat:@"%@",model.peopleData[@"info"][@"fabulous"]];
        self.shareLabel.text = [NSString stringWithFormat:@"%@",model.peopleData[@"info"][@"share"]];
        self.collectLabel.text = [NSString stringWithFormat:@"%@",model.peopleData[@"info"][@"collect"]];
        
        NSMutableArray *numByType = [NSMutableArray array];
        [numByType addObject:model.peopleData[@"info"][@"story"]];
        [numByType addObject:model.peopleData[@"info"][@"book"]];
        [numByType addObject:model.peopleData[@"info"][@"store"]];//story
        [numByType addObject:model.peopleData[@"info"][@"course"]];
        [numByType addObject:model.peopleData[@"info"][@"activity"]];
        [numByType addObject:model.peopleData[@"info"][@"goods"]];
        
        for (int i = 0; i< titleCount; i++) {
            lblX = lblW * i;
            
            UILabel *label = [self createLabelWithColor:@"7e949a" font:10];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%@ %@",self.titleArray[i], numByType[i]];
            label.frame = CGRectMake(lblX, 30, lblW, lblH);
            [self.typeView addSubview:label];
            
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [UIImage imageNamed:self.titleImgArray[i]];
            [self.typeView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(label.mas_top);
                make.centerX.equalTo(label.mas_centerX);
            }];
        }
        
        UIView *segView = [[UIView alloc] init];
        segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
        [self.typeView addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeView.mas_left);
            make.centerY.equalTo(self.typeView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1, 32));
        }];
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
@end
