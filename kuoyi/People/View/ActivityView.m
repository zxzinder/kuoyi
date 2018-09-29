//
//  ActivityView.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/4.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ActivityView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "NormalContent.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import <BlocksKit+UIKit.h>
#import "BaseWebView.h"
#import "ReturnUrlTool.h"
#import "ActivityWebView.h"


static NSString *CELLID = @"activityCell";
@interface ActivityView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *activityImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UILabel *showTimeLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *addressDetailLabel;

@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *shareTimeLabel;

@property (nonatomic, strong) UILabel *hostLabel;
@property (nonatomic, strong) UILabel *designLabel;
@property (nonatomic, strong) UILabel *supportLabel;

@property (nonatomic, strong) UICollectionView *activityCollectionView;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSMutableArray *dataArray;

@property (nonatomic, strong) BaseWebView *webView;

@property (nonatomic, strong) ActivityWebView *activityWebView;

@property (nonatomic, assign) NSInteger hotActId;

@end


@implementation ActivityView

-(instancetype)initWithPId:(NSInteger)pid{
    
    self = [super init];
    if (self) {
        self.pid = pid;
        [self p_initUI];
        [self getHotActivity];
        [self getActivityRequest];
    }
    
    return self;
    
}
-(void)p_initUI{
        __weak __typeof(self)weakSelf = self;
    CGFloat timeOffset = 10;
    CGFloat titleFont = 13;
    CGFloat timeFont = 20;
    CGFloat topH = 269;
    if (is55InchScreen || isiPhoneXScreen) {
        timeOffset = 20;
        titleFont = 15;
        timeFont = 26;
        topH = 309;
    }
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.size.height.mas_equalTo(topH);
    }];
    
    //w * 1.42
 
    self.timeLabel = [self createLabelWithColor:@"000000" font:timeFont];
    self.timeLabel.text = @"01/06";
    [self.topView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.top.equalTo(self.mas_top).offset(timeOffset);
    }];
    
    CGFloat imgW = AdaptedWidthValue(163);
    self.activityImgView = [[UIImageView alloc] init];
    self.activityImgView.image = [UIImage imageWithColor:[UIColor whiteColor]Rect:CGRectMake(0, 0, imgW, imgW*1.42)];
    self.activityImgView.userInteractionEnabled = YES;
    [self.topView addSubview:self.activityImgView];
    [self.activityImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(imgW, imgW * 1.42));
    }];
    [self.activityImgView bk_whenTapped:^{
        
        [weakSelf getActivityDetailInfo:[NSString stringWithFormat:@"%ld",(long)weakSelf.hotActId]];
    }];

    self.titleLabel = [self createLabelWithColor:@"000000" font:titleFont];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:titleFont];
    //self.titleLabel.text = @"成都5位女艺术家的柔软与坚韧 2018.1.6 - 1.21跨界艺术展";
    self.titleLabel.numberOfLines = 2;
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityImgView.mas_right).offset(24);
        make.top.equalTo(self.activityImgView.mas_top);
        make.right.equalTo(self.topView.mas_right).offset(-14);
    }];

    CGFloat labelFont = 15;
//    CGFloat normalSeg = 5;
//    CGFloat sectionSeg = 10;
    self.showLabel = [self createLabelWithColor:@"000000" font:labelFont];
    self.showLabel.numberOfLines = 0;
  //  self.showLabel.attributedText = attrStr;
    //self.showLabel.text = @"展览时间：";
    [self.topView addSubview:self.showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.right.equalTo(self.topView.mas_right).offset(-14);
    }];
//
//    self.showTimeLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    //self.showTimeLabel.text = @"2018年01月06日-01月21日";
//    [self.topView addSubview:self.showTimeLabel];
//    [self.showTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.showLabel.mas_bottom).offset(normalSeg);
//    }];
//
//    self.dayLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.dayLabel.text = @"每天14:30-16:30";
//    [self.topView addSubview:self.dayLabel];
//    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.showTimeLabel.mas_bottom).offset(normalSeg);
//    }];
//
//    self.addressLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.addressLabel.text = @"地点：";
//    [self.topView addSubview:self.addressLabel];
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.dayLabel.mas_bottom).offset(sectionSeg);
//    }];
//
//    self.addressDetailLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    //self.addressDetailLabel.text = @"成都远洋太古里M68-70号方所";
//    [self.topView addSubview:self.addressDetailLabel];
//    [self.addressDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.addressLabel.mas_bottom).offset(normalSeg);
//    }];
//
//    self.shareLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.shareLabel.text = @"分享会时间：";
//    [self.topView addSubview:self.shareLabel];
//    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.addressDetailLabel.mas_bottom).offset(sectionSeg);
//    }];
//
//    self.shareTimeLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.shareTimeLabel.text = @"2018年01月06日 下午15:10 方所咖啡厅二楼";
//    self.shareTimeLabel.numberOfLines = 2;
//    [self.topView addSubview:self.shareTimeLabel];
//    [self.shareTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.shareLabel.mas_bottom).offset(normalSeg);
//        make.right.equalTo(self.topView.mas_right).offset(-5);
//    }];
//
//    self.hostLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.hostLabel.text = @"主办方：知里与知外（I&OS）";
//    [self.topView addSubview:self.hostLabel];
//    [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.shareTimeLabel.mas_bottom).offset(sectionSeg);
//    }];
//
//    self.designLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.designLabel.text = @"设计者：王雪数";
//    [self.topView addSubview:self.designLabel];
//    [self.designLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.hostLabel.mas_bottom).offset(normalSeg);
//    }];
//
//    self.supportLabel = [self createLabelWithColor:@"000000" font:labelFont];
//    self.supportLabel.text = @"支持机构：方所、行动亚洲";
//    [self.topView addSubview:self.supportLabel];
//    [self.supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_left);
//        make.top.equalTo(self.designLabel.mas_bottom).offset(normalSeg);
//    }];

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.activityCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.activityCollectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.activityCollectionView.showsHorizontalScrollIndicator = NO;
    self.activityCollectionView.pagingEnabled = YES;
    self.activityCollectionView.delegate = self;
    self.activityCollectionView.dataSource =self;
    self.activityCollectionView.bounces = NO;
    [self addSubview:self.activityCollectionView];

    [self.activityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.topView.mas_bottom);//35
    }];

    [self.activityCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];


    
}

-(void)getHotActivity{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.activity/host";
    NSDictionary *params = @{@"peopleid":@(self.pid)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        
        NormalContent *model = [NormalContent yy_modelWithJSON:dict[@"data"]];
        weakSelf.titleLabel.text = model.title;
       // weakSelf.addressDetailLabel.text = model.info;
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.info  dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:15.0f] } documentAttributes:nil error:nil];
        weakSelf.showLabel.attributedText = attrStr;
        weakSelf.timeLabel.text = model.date;
        if (model.fengmian) {
            NSURL *url = [NSURL URLWithString:model.fengmian];
            [weakSelf.activityImgView sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 1, 1)]];
        }
        weakSelf.hotActId = model.nid;
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getActivityRequest{
    [self.dataArray removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.activity";
    NSDictionary *params = @{@"peopleid":@(self.pid)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        
        NSArray *listData = dict[@"list"];
        if (listData.count > 0) {
            for (int i = 0; i < listData.count; i++) {
                NormalContent *model = [NormalContent yy_modelWithJSON:listData[i]];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.activityCollectionView reloadData];
        }
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}

-(void)getActivityDetailInfo:(NSString *)actid{
    
    NSString *url = @"v1.activity/info";
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSDictionary *params = @{@"activityid":actid};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [weakSelf generateWebView:dict[@"data"]];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}

-(void)generateWebView:(NSDictionary *)data{
    self.activityWebView = [[ActivityWebView alloc] initWithData:data];
    [self addSubview:self.activityWebView];
    [self.activityWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

//    NSString *url = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeActivity andDetailId:nid];
//    self.webView = [[BaseWebView alloc] initWithUrlString:url];
//    self.webView.alpha = 0;
//    [self addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger count = self.dataArray.count;
    if (count % 4 == 0) {
        count = count / 4;
    }else{
        count = count / 4 + 1;
    }
    
    return count;
    
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.dataArray.count;

    NSInteger fullSection = count / 4;
    if (section < fullSection) {
        return 4;
    }else{
        return count % 4;
    }
    //return 4;
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    __weak __typeof(self)weakSelf = self;
    NSLog(@"%ld",(long)indexPath.row);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    
    NSInteger count = self.dataArray.count;
    
    NSInteger fullSection = count / 4;
    if (indexPath.section > fullSection - 1 && indexPath.row > count % 4 - 1) {
        cell.hidden = YES;
    }else{
        [self configureCell:cell andIndexPath:indexPath];

    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

#pragma mark -- 每个collectionView大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = (DEVICE_WIDTH - 14 *2 - 11 * 3) / 4;
    CGFloat cellH = self.activityCollectionView.frame.size.height;
    return CGSizeMake(cellW, cellH);
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 14, 0, 14);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 11;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    NormalContent *content = self.dataArray[indexPath.row];
    [self getActivityDetailInfo:[NSString stringWithFormat:@"%ld",(long)content.nid]];
    
}

-(void)configureCell:(UICollectionViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    
    NormalContent *content = self.dataArray[indexPath.row];
    CGFloat timeFont = 20;
    if (is55InchScreen || isiPhoneXScreen) {
        timeFont = 26;
    }
    UILabel *timeLabel = [self createLabelWithColor:@"000000" font:timeFont];
    timeLabel.font = [UIFont boldSystemFontOfSize:timeFont];
    timeLabel.text = content.date;
    [cell.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.top.equalTo(cell.contentView.mas_top);
    }];
    
    UIImageView *contentImgView = [[UIImageView alloc] init];
    if (content.fengmian) {
        NSURL *url = [NSURL URLWithString:content.fengmian];
        [contentImgView sd_setImageWithURL:url placeholderImage:[UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 1, 1)]];
    }else{
        contentImgView.image = [UIImage imageWithColor:[UIColor whiteColor] Rect:CGRectMake(0, 0, 1, 1)];
    }
  
    [cell.contentView addSubview:contentImgView];
    [contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(7);
        make.left.equalTo(cell.contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(cell.frame.size.width, cell.frame.size.width * 1.41));
    }];
}

#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
