//
//  HomeCollectionViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/24.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import <SDCycleScrollView.h>
#import "UtilsMacro.h"
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import "HomeDetail.h"
#import <BlocksKit+UIKit.h>
#import "NSString+TPValidator.h"


@interface HomeCollectionViewCell()<SDCycleScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UIButton *pageBtn;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *midBackView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *tfView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *btnsView;

//@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIImageView *commentImgView;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIImageView *praiseImgView;
@property (nonatomic, strong) UILabel *prasieLabel;

@property (nonatomic, strong) UIImageView *collectImgView;
@property (nonatomic, strong) UIImageView *shareImgView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) HomeDetail *detail;

@end


@implementation HomeCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void) p_init{
    
    self.cycleScrollView = [[SDCycleScrollView alloc] init];
    self.cycleScrollView.imageURLStringsGroup = @[];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScroll = NO;
    self.cycleScrollView.showPageControl = NO;
    
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.size.height.mas_equalTo(DEVICE_WIDTH * 0.83 * 1.22);
    }];
    
    UIView *pageView = [[UIView alloc] init];//
    pageView.alpha = 0.3;
    pageView.layer.cornerRadius = 6;
    pageView.backgroundColor = [UIColor colorWithHexString:@"c4d5fd"];
    [self.contentView addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
    
    
    self.pageBtn = [self createBtnWithColor:@"fffff" font:12 icon:nil isTopImage:NO];
    self.pageBtn.layer.cornerRadius = 6;
//    NSString *pageStr = [NSString stringWithFormat:@"1 / %lu",[data.img count]];
//    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//colorWithHexString:@"adaeba"
    self.pageBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.pageBtn];
    [self.pageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(40, 15));
    }];
//    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 500, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
//    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;  CGRectMake(0, 0,w , w*1.25)
    CGFloat w = DEVICE_WIDTH * 0.83;
    CGFloat nameFont = 25;
    CGFloat nameTop = -1;
    CGFloat midTop = 4;
    CGFloat midFont = 15;
    CGFloat backHeight = 45;
    CGFloat comOffset = 12;
    CGFloat segBot = 33;
    if (is55InchScreen || isiPhoneXScreen) {
        
        nameFont = 30;
        nameTop = 5;
        midTop = 8;
        midFont = 18;
        backHeight = 52;
         comOffset = 15;
        segBot = 37;
    }
    __weak __typeof(self)weakSelf = self;
    self.nameLabel = [self createLabelWithColor:@"3c3c3c" font:nameFont];
//    self.nameLabel = [[UILabel alloc] init]; Ming-Lt-HKSCS-UNI-H
//    self.nameLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
//    self.nameLabel.font = [UIFont fontWithName:@"SourceHanSerifCN-ExtraLight" size:nameFont];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(w * 1.25 + nameTop);
    }];
    
    self.midBackView = [[UIView alloc] init];
    self.midBackView.backgroundColor = [UIColor colorWithHexString:@"ffec01"];
    [self.contentView addSubview:self.midBackView];
    [self.midBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(midTop);
        make.size.height.mas_equalTo(backHeight);
    }];
    
    
    self.botView = [[UIView alloc] init];
    self.botView.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
    [self.contentView addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.size.height.mas_equalTo(21);
    }];
    
    self.leftLabel = [self createLabelWithColor:@"844915" font:midFont];
    //self.leftLabel.font = [UIFont fontWithName:@"SourceHanSerifCN-ExtraLight" size:midFont];
    [self.midBackView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midBackView.mas_left).offset(20);
        make.centerY.equalTo(self.midBackView.mas_centerY).offset(-backHeight/4);
    }];
    
    self.inputTF = [[UITextField alloc] init];
    self.inputTF.textColor = [UIColor colorWithHexString:@"844915"];
    self.inputTF.textAlignment = NSTextAlignmentLeft;
    self.inputTF.font = [UIFont systemFontOfSize:midFont];
    self.inputTF.delegate = self;
    self.inputTF.returnKeyType = UIReturnKeyDone;
    [self.midBackView addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).offset(2);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.size.mas_equalTo(100);
    }];
    
    self.tfView = [[UIView alloc] init];
    self.tfView.backgroundColor = [UIColor colorWithHexString:@"844915"];
    [self.contentView addSubview:self.tfView];
    [self.tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_left);
        make.bottom.mas_equalTo(self.leftLabel.mas_bottom);
        //make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(15, 1));
    }];
    
    self.rightLabel = [self createLabelWithColor:@"844915" font:midFont];
    //self.rightLabel.font = [UIFont fontWithName:@"SourceHanSerifCN-ExtraLight" size:midFont];
    [self.midBackView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTF.mas_right).offset(2);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
    }];
    
    self.infoLabel = [self createLabelWithColor:@"844915" font:midFont];
    //self.infoLabel.font = [UIFont fontWithName:@"SourceHanSerifCN-ExtraLight" size:midFont];
    [self.midBackView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midBackView.mas_left).offset(20);
        make.centerY.equalTo(self.midBackView.mas_centerY).offset(backHeight/4);
    }];
    NSString *str = @"UID犹如带点个性、梦想、复古、人文风味的面貌，呈现着当下80后其中之一的性格。做着自己喜欢的事情，去实现梦想，哪怕过程再艰辛也是种幸福。";
    CGFloat contentHeight = [NSString caculateHeight:str font:12 size:CGSizeMake(DEVICE_WIDTH * 0.83 - 40, MAXFLOAT)];
    self.contentLabel = [self createLabelWithColor:@"3c3c3c" font:12];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.midBackView.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        //make.size.height.mas_equalTo(contentHeight);
    }];
    
    self.btnsView = [[UIView alloc] init];
    self.btnsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.btnsView];
    [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.size.height.mas_equalTo(30);
    }];
    
    //c9caca
    
    UIView *botSegView = [[UIView alloc] init];
    botSegView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    [self.contentView addSubview:botSegView];
    [botSegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.size.height.mas_equalTo(1);
        make.bottom.equalTo(self.botView.mas_top).offset(-segBot);
    }];
    
    
    self.commentImgView = [[UIImageView alloc] init];
    self.commentImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.commentImgView.image = [UIImage imageNamed:@"comment"];
    [self.contentView addSubview:self.commentImgView];
    [self.commentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        //make.top.equalTo(self.btnsView.mas_bottom).offset(comOffset);
        make.top.equalTo(botSegView.mas_bottom).offset(5);
    }];
    
    self.commentLabel = [self createLabelWithColor:@"bfc0c0" font:12];
    self.commentLabel.text = @"";
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImgView.mas_right).offset(5);
        make.centerY.equalTo(self.commentImgView.mas_centerY);
    }];
    
    self.praiseImgView = [[UIImageView alloc] init];
    self.praiseImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.praiseImgView.image = [UIImage imageNamed:@"praise"];
    [self.contentView addSubview:self.praiseImgView];
    [self.praiseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel.mas_right).offset(20);
        make.centerY.equalTo(self.commentImgView.mas_centerY);
    }];
    self.praiseImgView.userInteractionEnabled = YES;
    [self.praiseImgView bk_whenTapped:^{
        if (weakSelf.praiseClickBack) {
            weakSelf.praiseClickBack();
        }
    }];
    self.prasieLabel = [self createLabelWithColor:@"bfc0c0" font:12];
    self.prasieLabel.text = @"";
    [self.contentView addSubview:self.prasieLabel];
    [self.prasieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseImgView.mas_right).offset(5);
        make.centerY.equalTo(self.commentImgView.mas_centerY);
    }];
    
    
    self.shareImgView = [[UIImageView alloc] init];
    self.shareImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.shareImgView.image = [UIImage imageNamed:@"share"];
    [self.contentView addSubview:self.shareImgView];
    [self.shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.commentImgView.mas_centerY);
    }];
    self.shareImgView.userInteractionEnabled = YES;
    [self.shareImgView bk_whenTapped:^{
        if (weakSelf.shareClickBack) {
            weakSelf.shareClickBack(weakSelf.inputTF.text);
        }
    }];
    
    self.collectImgView = [[UIImageView alloc] init];
    self.collectImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectImgView.image = [UIImage imageNamed:@"homecollect"];//
    [self.contentView addSubview:self.collectImgView];
    [self.collectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareImgView.mas_left).offset(-15);
        make.centerY.equalTo(self.commentImgView.mas_centerY);
    }];
    self.collectImgView.userInteractionEnabled = YES;
    [self.collectImgView bk_whenTapped:^{
        if (weakSelf.collcetClickBack) {
            weakSelf.collcetClickBack();
        }
    }];
    
 
    
    
}
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.tfView.hidden = YES;
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    [textField resignFirstResponder];
    if (self.doneEditCallBack) {
        self.doneEditCallBack(textField.text);
    }
    return YES;
    
}

#pragma mark - SDCycleScrollViewDelegate
                                          
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
        NSLog(@"---点击了第%ld张图片", (long)index);
    if (self.clickCallBack) {
        self.clickCallBack();
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
     NSLog(@"---滚动第%ld张图片", (long)index);
    NSString *page = [NSString stringWithFormat:@"%ld / %lu",(long)index + 1,self.detail.img.count];
    [self.pageBtn setTitle:page forState:UIControlStateNormal];
}

-(void)configeData:(HomeDetail *)data{
    self.detail = data;
    if (data.img && data.img.count > 0) {
        
        NSMutableArray *imgMArr = [NSMutableArray array];
        for (int i = 0; i < data.img.count; i++) {
            [imgMArr addObject:data.img[i][@"url"]];
        }
        self.cycleScrollView.imageURLStringsGroup = imgMArr;
    }else{
        self.cycleScrollView.imageURLStringsGroup = @[@"1.jpg"];
    }
    NSString *pageStr = [NSString stringWithFormat:@"1 / %lu",[data.img count]];
    [self.pageBtn setTitle:pageStr forState:UIControlStateNormal];//colorWithHexString:@"adaeba"
    self.nameLabel.text = data.name;
    self.leftLabel.text = @"我想拥有 {";
    self.rightLabel.text = @"} 发型";
    self.infoLabel.text = @"快说出来，告诉我。";
    self.inputTF.text = @"";
    self.commentLabel.text = data.comment;
    self.prasieLabel.text = data.fabulous;
    if (data.is_collection > 0) {
        self.collectImgView.image = [UIImage imageNamed:@"homecollect_select"];
    }else{
        self.collectImgView.image = [UIImage imageNamed:@"homecollect"];
    }
    //计算两行的高度
    self.contentLabel.attributedText = [self changeLabelStyle:data.info];
    NSArray *imgNameArray = [self getImgArray:data];
    
    CGFloat imgX,imgY,imgW,imgH;
    imgX = 0;
    imgY = 0;
    imgW = 30;
    imgH = 30;
    NSInteger imgCount = imgNameArray.count;
    if (imgCount > 0) {

        for (UIView *view in [self.btnsView subviews]){
            [view removeFromSuperview];
        }
        for (int i = 0; i < imgCount; i++) {
            imgX = i * imgW + i * 7;
            UIImageView *typeImgView = [[UIImageView alloc] init];
            //typeImgView.contentMode = UIViewContentModeScaleAspectFit;
            typeImgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
            typeImgView.image = [UIImage imageNamed:imgNameArray[i]];
            [self.btnsView addSubview:typeImgView];
        }
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
    
    paraStyle.headIndent=0;
    
    paraStyle.tailIndent=0;
    
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
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
-(NSArray *)getImgArray:(HomeDetail *)detail{
    
    NSMutableArray *mArr = [NSMutableArray array];
   // = @[@"homebook",@"homespace",@"homelesson",@"homeactivity",@"homearticle"];
    [mArr addObject:@"homestory"];
    if (detail.isbook) {
        [mArr addObject:@"homebook"];
    }
    if (detail.isspace) {
         [mArr addObject:@"homespace"];
    }
    if (detail.iscurriculum) {
        [mArr addObject:@"homelesson"];
    }
    if (detail.isactivity) {
        [mArr addObject:@"homeactivity"];
    }
    if (detail.isproduct) {
        [mArr addObject:@"homearticle"];
    }
    return [mArr copy];
    
}
#pragma mark setter
-(UILabel *)createLabelWithColor:(NSString *)color font:(CGFloat)font{
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:font];
    
    return lbl;
    
}
-(UIButton *)createBtnWithColor:(NSString *)color font:(CGFloat)font icon:(NSString *)icon isTopImage:(BOOL)isTopImage{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    if (icon) {
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
//
    if (isTopImage) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(30 ,-30, 0,0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-10 ,0, 0,0);
    }
   
    return btn;
    
}
@end
