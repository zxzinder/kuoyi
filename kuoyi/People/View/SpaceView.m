//
//  SpaceView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/29.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "SpaceView.h"
#import "UIColor+TPColor.h"
#import "UIImage+Generate.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import "SpaceInfo.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import "BaseWebView.h"
#import "ReturnUrlTool.h"
#import "SpaceWebView.h"
#import <BlocksKit+UIKit.h>




#define MENUBTN_HW 50
static NSString *CELLID = @"spaceCell";
@interface SpaceView()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *cityLabel;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *contentLabel;


@property (nonatomic, strong) UIView *typeView;

@property (nonatomic, strong) UIButton *hotelBtn;
@property (nonatomic, strong) UIButton *spaceBtn;

@property (nonatomic, strong) UICollectionView *botCollectionView;

@property (nonatomic, assign) NSInteger pid;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong)  SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) BaseWebView *webView;

@property (nonatomic, strong) SpaceInfo *info;

@property (nonatomic, strong) SpaceWebView *spaceWebView;


@end

@implementation SpaceView

-(instancetype)initWithPId:(NSInteger)pid{
    
    self = [super init];
    if (self) {
        self.pid = pid;
       
        [self getSpaceRequest];
    }
    
    return self;
    
}
-(void)p_initUI{

    self.titleLabel = [self createLabelWithColor:@"3c3c3c" font:22];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    //self.titleLabel.text = @"“妙语生花”灵活小巧";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    
    self.cityLabel = [self createLabelWithColor:@"3c3c3c" font:9];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:9];
    //self.cityLabel.text = @"成都";
    [self addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    if (self.info.imgs.count > 0) {
        NSMutableArray *imgMArr = [NSMutableArray array];
        for (int i = 0; i < [self.info.imgs count]; i++) {
            [imgMArr addObject:self.info.imgs[i][@"url"]];
        }
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:imgMArr];
    }else{
       self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:NO imageNamesGroup:@[@"b1.jpg"]];
    }
   
    
    CGFloat scrollHeight = DEVICE_WIDTH * 0.4;
    
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.showPageControl = NO;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.left.right.equalTo(self);
        make.size.height.mas_equalTo(scrollHeight);
    }];
    
//    //加透明
//    UIView *pageView = [[UIView alloc] init];//
//    pageView.alpha = 0.3;
//    pageView.layer.cornerRadius = 6;
//    pageView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
//    [self addSubview:pageView];
//    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-14);
//        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(-5);
//        make.size.mas_equalTo(CGSizeMake(40, 15));
//    }];
    
    self.pageBtn = [self createBtnWithColor:@"fffff" font:12 icon:nil];
    self.pageBtn.layer.cornerRadius = 6;
    NSString *pageStr = [NSString stringWithFormat:@"1/%lu",[self.info.imgs count]];
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//
    self.pageBtn.backgroundColor = [UIColor colorWithHexString:@"adaeba"];
    [self addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    self.typeLabel = [self createLabelWithColor:@"3c3c3c" font:18];
    self.typeLabel.font = [UIFont boldSystemFontOfSize:18];
    self.typeLabel.text = @"实体店";
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(14);
    }];
    
    
    self.typeView = [[UIView alloc] init];
    self.typeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.typeView];
    self.typeView.layer.borderColor = [UIColor colorWithHexString:@"0000ff"].CGColor;
    self.typeView.layer.borderWidth = 2;
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        //make.centerX.equalTo(self.menuView.mas_centerX);
        make.right.equalTo(self.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(MENUBTN_HW, MENUBTN_HW * 2));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
    //NSString *str = @"这个宽敞的花园平房可爱的夏天的感觉。两间双人卧室，开放式起居区，大厨房和美丽的湿室。靠近皇后公园站和所有巴士。商店非常靠近，还靠近皇后公园站和所有巴士。";
    self.contentLabel.numberOfLines = 3;
   // self.contentLabel.attributedText = [self changeLabelStyle:str];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.right.equalTo(self.typeView.mas_left).offset(-20);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10);
    }];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.botCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.botCollectionView.backgroundColor = [UIColor whiteColor];
    self.botCollectionView.showsHorizontalScrollIndicator = NO;
    self.botCollectionView.pagingEnabled = YES;
    self.botCollectionView.delegate = self;
    self.botCollectionView.dataSource =self;
    self.botCollectionView.bounces = NO;
    [self addSubview:self.botCollectionView];
    
    [self.botCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(30);//40
    }];
    
    [self.botCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    
}
-(void)p_initTypeBtn{
    
     __weak __typeof(self)weakSelf = self;
    self.spaceBtn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
    self.spaceBtn.tag = 10000 + 2;
    self.spaceBtn.backgroundColor = [UIColor whiteColor];
    self.spaceBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.spaceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.spaceBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.spaceBtn bk_addEventHandler:^(id sender) {
        [weakSelf getSpaceListRequest:weakSelf.info.sid andSpaceType:@"1"];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.typeView addSubview:self.spaceBtn];
   
    
    self.hotelBtn = [self createBtnWithColor:@"0000ff" font:15 icon:nil];
    self.hotelBtn.tag = 10000 + 1;
    self.hotelBtn.backgroundColor = [UIColor whiteColor];
    self.hotelBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.hotelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.hotelBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.hotelBtn bk_addEventHandler:^(id sender) {
        [weakSelf getSpaceListRequest:weakSelf.info.sid andSpaceType:@"2"];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.typeView addSubview:self.hotelBtn];
   
    
    UIView *typeSegView = [[UIView alloc] init];
    typeSegView.hidden = YES;
    typeSegView.backgroundColor = [UIColor colorWithHexString:@"0000ff"];
    [self.typeView addSubview:typeSegView];
    [typeSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.typeView);
        make.size.height.mas_equalTo(2);
        make.top.equalTo(self.typeView.mas_top).offset(MENUBTN_HW);
    }];
    
    if (self.info.minsu_count > 0) {
        NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"民宿\n%ld",(long)self.info.minsu_count] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
         [self.hotelBtn setAttributedTitle:titleAttribute forState:UIControlStateNormal];
    }
    if (self.info.kongjian_count > 0) {
        NSAttributedString *spaceAttribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"空间\n%ld",(long)self.info.kongjian_count] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0000ff"]}];
         [self.spaceBtn setAttributedTitle:spaceAttribute forState:UIControlStateNormal];
    }
    
    if (self.info.minsu_count > 0 && self.info.kongjian_count <= 0) {
        [self.typeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-14);
            make.size.mas_equalTo(CGSizeMake(MENUBTN_HW, MENUBTN_HW));
        }];
        [self.hotelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.typeView);
            make.size.height.mas_equalTo(MENUBTN_HW);
        }];
    }else if (self.info.minsu_count <= 0 && self.info.kongjian_count > 0){
        [self.typeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-14);
            make.size.mas_equalTo(CGSizeMake(MENUBTN_HW, MENUBTN_HW));
        }];
        [self.spaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.equalTo(self.typeView);
            make.size.height.mas_equalTo(MENUBTN_HW);
        }];
    }else if (self.info.minsu_count > 0 && self.info.kongjian_count > 0){
        typeSegView.hidden = NO;
        [self.spaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.typeView);
            make.size.height.mas_equalTo(MENUBTN_HW);
        }];
        [self.hotelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.typeView);
            make.size.height.mas_equalTo(MENUBTN_HW);
        }];
    }else{
        self.typeView.hidden = YES;
    }
}
-(void)getSpaceRequest{
    
    __weak __typeof(self)weakSelf = self;
    //[HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.store";
    NSDictionary *params = @{@"peopleid":@(self.pid)};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        weakSelf.info = [SpaceInfo yy_modelWithJSON:dict[@"data"]];
        [weakSelf p_initUI];
        weakSelf.titleLabel.text = weakSelf.info.title;
        weakSelf.contentLabel.attributedText = [self changeLabelStyle:weakSelf.info.introduce];
        weakSelf.cityLabel.text = weakSelf.info.city;
        [weakSelf getSpaceListRequest:weakSelf.info.sid andSpaceType:nil];
        [weakSelf p_initTypeBtn];
        NSLog(@"%@",dict);
    

    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}
-(void)getSpaceListRequest:(NSInteger)sid andSpaceType:(NSString *)type{
    __weak __typeof(self)weakSelf = self;
  //  [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.StoreBranch";//1 空间 2 名宿
    NSDictionary *params;
    if (type && ![type isEqualToString:@""]) {
        params = @{@"storeid":@(sid),@"type":type};
    }else{
        params = @{@"storeid":@(sid)};
    }
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        
        weakSelf.dataArray = dict[@"list"];
        
        [weakSelf.botCollectionView reloadData];
        
    } fail:^(NSDictionary *dict) {
        [HLYHUD hideHUDForView:nil];
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
}

-(void)getSpaceDetailReq:(NSString *)branchId{
    __weak __typeof(self)weakSelf = self;
    //  [HLYHUD showLoadingHudAddToView:nil];
    NSString *url = @"v1.StoreBranch/info";
    NSDictionary *params = @{@"branchid":branchId};
    [KYNetService postDataWithUrl:url param:params success:^(NSDictionary *dict) {
       
        NSDictionary *detailData = dict[@"data"];
        [weakSelf generateWebView:detailData];
        [weakSelf.botCollectionView reloadData];
        
    } fail:^(NSDictionary *dict) {
       
        [HLYHUD showHUDWithMessage:dict[@"msg"] addToView:nil];
    }];
    
    
}

-(void)generateWebView:(NSDictionary *)data{
    __weak __typeof(self)weakSelf = self;
    self.spaceWebView = [[SpaceWebView alloc] initWithData:data];
    //self.bookWebView.alpha = 0;
    [self addSubview:self.spaceWebView];
    [self.spaceWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark -- 组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger count = self.dataArray.count;
    if (count % 3 == 0) {
        count = count / 3;
    }else{
        count = count / 3 + 1;
    }
    
    return count;
    
}

#pragma mark -- 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = self.dataArray.count;
    
    if (section == count/3) {
        return count % 3;
    }else{
        return 3;
    }
   
    
}

#pragma mark -- 内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(self)weakSelf = self;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self configureCell:cell andIndexPath:indexPath];
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
    CGFloat cellW = (DEVICE_WIDTH - 10 *2 - 19 *2) / 3;
    CGFloat cellH = self.botCollectionView.frame.size.height;
    return CGSizeMake(cellW, cellH);
    
}

#pragma mark -- collectionView距离上左下右位置设置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}


#pragma mark --  collectionView之间最小列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
    
}

#pragma mark -- collectionView之间最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 19;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.dataArray[indexPath.row];
    
    [self getSpaceDetailReq:data[@"id"]];
    
}

-(void)configureCell:(UICollectionViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data = self.dataArray[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:data[@"fengmian"]];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    [cell.contentView addSubview:imgView];
     //349 246
    CGFloat imgW = cell.frame.size.width;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(cell.contentView);
        make.size.height.mas_equalTo(imgW * 0.7);
    }];
    
    UILabel *titleLabel = [self createLabelWithColor:@"000000" font:12];
    titleLabel.text = data[@"title"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.top.equalTo(imgView.mas_bottom).offset(10);
    }];
    
    UILabel *priceLabel = [self createLabelWithColor:@"000000" font:10];
    priceLabel.text = [NSString stringWithFormat:@"CNY %@元/%@",data[@"price"],data[@"company"]];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.top.equalTo(titleLabel.mas_bottom).offset(9);
    }];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"---滚动第%ld张图片", (long)index);
    NSString *page = [NSString stringWithFormat:@"%ld/3",(long)index + 1];
    [self.pageBtn setTitle:page forState:UIControlStateNormal];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
//    if (self.clickCallBack) {
//        self.clickCallBack();
//    }
    if (self.webView) {
        self.webView.alpha = 1;
    }
    
}
-(NSAttributedString *)changeLabelStyle:(NSString *)str{
    NSMutableParagraphStyle*paraStyle = [[NSMutableParagraphStyle alloc]init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 2; //设置行间距
    
    paraStyle.hyphenationFactor=1.0;
    
    paraStyle.firstLineHeadIndent=0.0;
    
    paraStyle.paragraphSpacingBefore=0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    
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
