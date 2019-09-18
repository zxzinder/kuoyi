//
//  BookView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/27.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "BookView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import <UIImageView+WebCache.h>
#import "BaseWebView.h"
#import "ReturnUrlTool.h"
#import "BookWebView.h"

static NSString *CELLID = @"bookCell";
@interface BookView()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UICollectionView *botCollectionView;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSDictionary *bookData;

@property (nonatomic, strong) BaseWebView *webView;
@property (nonatomic, strong) BookWebView *bookWebView;

@property (nonatomic, copy) NSArray *detailList;


@end

@implementation BookView

-(instancetype)initWithPId:(NSInteger)pid{
    
    self = [super init];
    if (self) {
        self.pid = pid;
       // [self p_initUI];
        [self getBookRequest];
       // [self getBookDetailList];
    }
    
    return self;
    
}
-(void)p_initUI{
    
    NSMutableArray *imgMArr = [NSMutableArray array];
    for (int i = 0; i < [self.bookData[@"banner"] count]; i++) {
        [imgMArr addObject:self.bookData[@"banner"][i][@"url"]];
    }
    //
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:imgMArr];
    CGFloat scrollHeight = DEVICE_WIDTH * 0.4;
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"b1.jpg",@"b2.jpg",@"b3.jpg"]];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.size.height.mas_equalTo(scrollHeight);
    }];
    
    //加透明
    UIView *pageView = [[UIView alloc] init];//
    pageView.alpha = 0.3;
    pageView.layer.cornerRadius = 6;
    pageView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    [self addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.pageBtn = [self createBtnWithColor:@"fffff" font:12 icon:nil];
    self.pageBtn.layer.cornerRadius = 6;
    NSString *pageStr = [NSString stringWithFormat:@"1/%lu",[self.bookData[@"banner"] count]];
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//
    //self.pageBtn.backgroundColor = [UIColor colorWithHexString:@"adaeba"];
    [self addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    CGFloat titleFont = 20;
    CGFloat titleTop = 10;
    CGFloat botColTop = 10;
    CGFloat midHeight = 115;
    if (is55InchScreen || isiPhoneXScreen) {
        titleFont = 22;
        titleTop = 15;
        botColTop = 20;
        midHeight = 130;
    }
    
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.midView];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(cycleScrollView.mas_bottom);
        make.size.height.mas_equalTo(midHeight);
    }];
    
    self.titleLabel = [self createLabelWithColor:@"3c3c3c" font:titleFont];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:titleFont];
    //self.titleLabel.text = @"《LOST》旅行是一种态度";
    [self.midView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.midView.mas_centerX);
        make.top.equalTo(self.midView.mas_top).offset(titleTop);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
    NSString *str = @"《LOST》是一本有关旅行和自我发现的杂志。在这本杂志里，你看到的是真是的故事和来自五湖四海不同背景的人民内心深处的思考和顿悟。坚信旅行的意义不在于华丽的酒店和名胜景点，而在于把自己彻底融入一个陌生的周遭去体会那种不适，并从中领悟。";
    self.contentLabel.numberOfLines = 4;
    //self.contentLabel.attributedText = [self changeLabelStyle:str];
    [self.midView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.midView.mas_centerX);
        make.left.equalTo(self.midView.mas_left).offset(14);//14
        make.right.equalTo(self.midView.mas_right).offset(-14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(titleTop);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.botCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.botCollectionView.backgroundColor = [UIColor whiteColor];
    self.botCollectionView.showsHorizontalScrollIndicator = NO;
    //self.botCollectionView.pagingEnabled = YES;
    self.botCollectionView.delegate = self;
    self.botCollectionView.dataSource = self;
    self.botCollectionView.bounces = NO;
    [self addSubview:self.botCollectionView];
    
    [self.botCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.midView.mas_bottom).offset(botColTop);
    }];
    
    [self.botCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    
}

-(void)getBookRequest{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.book";
    NSDictionary *params = @{@"peopleid":@(self.pid)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        weakSelf.bookData = dict[@"data"];
        [weakSelf p_initUI];
        weakSelf.titleLabel.text = dict[@"data"][@"label"];
        weakSelf.contentLabel.attributedText = [self changeLabelStyle:dict[@"data"][@"info"]];
        //[weakSelf generateWebView];
        [weakSelf.botCollectionView reloadData];
        [self getBookDetailList];
        NSLog(@"%@",dict);
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}

-(void)getBookDetailList{
    
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.bookStage";
    NSDictionary *params = @{@"id":self.bookData[@"id"]};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
//        id = 21;   fengmian
//        price = 150;
//        title = "\U300aLOST\U300bISSUE Five";
        self.detailList = dict[@"list"];
        [self.botCollectionView reloadData];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
}
-(void)getBookDetailInfo:(NSString *)bookid{
    
     NSString *url = @"v1.bookStage/info";
    __weak __typeof(self)weakSelf = self;
    [HLYHUD showLoadingHudAddToView:nil];
    NSDictionary *params = @{@"stageid":bookid};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        NSLog(@"%@",dict);
        [self generateWebView:dict[@"data"]];
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideAllHUDsForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return 1;
    
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.detailList.count;
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    //cell.contentView.backgroundColor = [UIColor colorWithHexString:@"d1ddd6"];
    [self configureCell:cell andIndex:indexPath.row];
    
//    if (indexPath.row > 0) {
//        cell.hidden = YES;
//    }else{
//        cell.hidden = NO;
//    }
    
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
    CGFloat cellW = (DEVICE_WIDTH - 14 *2 - 12 *2) / 3;// 10  16  
    CGFloat cellH = self.botCollectionView.frame.size.height;
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
    
    return 12;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   //
     NSDictionary *data = self.detailList[indexPath.row];
    [self getBookDetailInfo:data[@"id"]];
}
-(void)configureCell:(UICollectionViewCell *)cell andIndex:(NSInteger)index{
    //
    
    for (UIView *view in [cell.contentView subviews]){
        [view removeFromSuperview];
    }
    
    NSDictionary *data = self.detailList[index];
    UIImageView *imgView = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:data[@"fengmian"]];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    [cell.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(cell.contentView);
        make.size.height.mas_equalTo((DEVICE_WIDTH - 10 *4 - 12 *2) / 3);
    }];
    //30   26
    CGFloat titleTop = 6;
    CGFloat priceTop = 5;
    if (is55InchScreen || isiPhoneXScreen) {
        titleTop = 10;
        priceTop = 9;
    }
    UILabel *titleLabel = [self createLabelWithColor:@"000000" font:12];
    titleLabel.text = data[@"title"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.top.equalTo(imgView.mas_bottom).offset(titleTop);
    }];
    
    UILabel *priceLabel = [self createLabelWithColor:@"000000" font:10];
    priceLabel.text = [NSString stringWithFormat:@"CNY %@",data[@"price"]] ;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.top.equalTo(titleLabel.mas_bottom).offset(priceTop);
    }];
    
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
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}
-(void)generateWebView:(NSDictionary *)data{
//    NSInteger bid = [self.bookData[@""] integerValue];
//    NSString *url = [ReturnUrlTool getUrlByWebType:kWebProtocolTypeBook andDetailId:bid];
//    self.webView = [[BaseWebView alloc] initWithUrlString:url];
//    self.webView.alpha = 0;
//    [self addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    self.bookWebView = [[BookWebView alloc] initWithData:data];
    //self.bookWebView.alpha = 0;
    [self addSubview:self.bookWebView];
    [self.bookWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"---滚动第%ld张图片", (long)index);
    NSString *page = [NSString stringWithFormat:@"%ld/4",(long)index + 1];
    [self.pageBtn setTitle:page forState:UIControlStateNormal];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
//    if (self.clickCallBack) {
//        self.clickCallBack();
//    }
    if (self.bookWebView) {
        self.bookWebView.alpha = 1;
    }
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
