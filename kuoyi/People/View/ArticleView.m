//
//  ArticleView.m
//  kuoyi
//
//  Created by alexzinder on 2018/2/5.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ArticleView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import "ArticleCollectionViewCell.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "NormalContent.h"
#import <YYModel.h>
#import "ArticleWebView.h"
#import <UIImageView+WebCache.h>


static NSString *CELLID = @"articleCell";
@interface ArticleView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *topImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UICollectionView *artiCollectionView;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong) ArticleWebView *articleWebView;

@end

@implementation ArticleView

-(instancetype)initWithPId:(NSInteger)pid{
    
    self = [super init];
    if (self) {
        self.pid = pid;
        [self p_initUI];
        [self getGoodsRequest];
    }
    
    return self;
    
}
-(void)p_initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.topImgView = [[UIImageView alloc] init];
//    self.topImgView.image = [UIImage imageWithColor:[UIColor randomRGBColor] Rect:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_WIDTH * 0.22)];
    [self addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.size.height.mas_equalTo(DEVICE_WIDTH * 0.22);
    }];
    CGFloat titleOffset = 23;
    CGFloat contentOffset = 13;
    CGFloat collectionOffset = 26;
    if (!is55InchScreen) {
        titleOffset = 13;
        contentOffset = 10;
        collectionOffset = 13;
    }
    
    self.titleLabel = [self createLabelWithColor:@"000000" font:22];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //self.titleLabel.text = @"李茶德：“好生活，配好茶。”";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topImgView.mas_bottom).offset(titleOffset);
    }];
    
    self.contentLabel = [self createLabelWithColor:@"000000" font:12];
   // NSString *str = @"李茶德是来自香港的时尚生活品牌，进军内地2年内，设计奖精致用料考究融入设计师词汇，对材质色彩与文理进行发散性创造，呈现对平凡的日常细节的精致考究，身体力行全新的生活价值观——无用的实用主义。";
    //self.contentLabel.attributedText = [self changeLabelStyle:str];
    self.contentLabel.numberOfLines = 3;
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.right.equalTo(self.mas_right).offset(-14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(contentOffset);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.artiCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.artiCollectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.artiCollectionView.showsHorizontalScrollIndicator = NO;
    self.artiCollectionView.pagingEnabled = YES;
    self.artiCollectionView.delegate = self;
    self.artiCollectionView.dataSource =self;
    self.artiCollectionView.bounces = NO;
    [self addSubview:self.artiCollectionView];
    
    CGFloat imgHeight = (DEVICE_WIDTH - 14 *2 - 16 * 3) / 4;
    CGFloat lblHeight = 35;
    CGFloat segHeight = 35;
    [self.artiCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(collectionOffset);
        make.size.height.mas_equalTo(imgHeight *2 + lblHeight *2 + segHeight);
    }];
    
    [self.artiCollectionView registerClass:[ArticleCollectionViewCell class] forCellWithReuseIdentifier:CELLID];

    
}


-(void)getGoodsRequest{
    
    __weak __typeof(self)weakSelf = self;
    NSString *url = @"v1.goods";
    NSDictionary *params = @{@"peopleid":@(self.pid)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        weakSelf.dataArray = dict[@"data"];
        [weakSelf.artiCollectionView reloadData];
        NSDictionary *topData = dict[@"brand"];
        if (topData[@"title"]) {
            weakSelf.titleLabel.text = topData[@"title"];
            weakSelf.contentLabel.attributedText =  [self changeLabelStyle:topData[@"info"]];;
            NSURL *url = [NSURL URLWithString:topData[@"appbanner"]];
            [self.topImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
       
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}

-(void)getGoodsDetailRequest:(NSString *)gid{
    
    __weak __typeof(self)weakSelf = self;
    //    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.goods/info";
    NSDictionary *params = @{@"goodsid":gid};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        NSLog(@"%@",dict);
        [weakSelf generateWebView:dict[@"data"]];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)generateWebView:(NSDictionary *)data{

    self.articleWebView = [[ArticleWebView alloc] initWithData:data];
   
    [self addSubview:self.articleWebView];
    [self.articleWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return 1;
    
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    [cell configeData:self.dataArray[indexPath.row]];
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
    CGFloat cellW = (DEVICE_WIDTH - 14 *2 - 16 * 3) / 4;//87
   
    CGFloat cellH = (self.artiCollectionView.frame.size.height - 23) / 2;
    return CGSizeMake(cellW, cellH);
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (is55InchScreen) {
        return UIEdgeInsetsMake(0, 14, 0, 14);;
    }
    return UIEdgeInsetsMake(0, 14, 15, 14);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (is55InchScreen) {
         return 23;
    }
    return 5;
    
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 16;//24
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data = self.dataArray[indexPath.row];
    [self getGoodsDetailRequest:data[@"id"]];
    
}
-(NSAttributedString *)changeLabelStyle:(NSString *)str{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 2; //设置行间距
    
    paraStyle.hyphenationFactor=1.0;
    
    paraStyle.firstLineHeadIndent=0.0;
    
    paraStyle.paragraphSpacingBefore=0.0;
    
    paraStyle.headIndent=0;
    
    paraStyle.tailIndent=0;
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}


#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}

@end
