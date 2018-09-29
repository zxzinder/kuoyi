//
//  ContentView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/26.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "ContentView.h"
#import "UIColor+TPColor.h"
#import "UtilsMacro.h"
#import <Masonry.h>
#import "BookView.h"
#import "SpaceView.h"
#import "ActivityView.h"
#import "ArticleView.h"
#import "HomeDetail.h"
#import "KYNetService.h"
#import "HLYHUD.h"
#import "PeopleInfo.h"
#import "ReturnUrlTool.h"
#import "BaseWebView.h"
#import "LessonWebView.h"
#import "StoryWebView.h"


#define titleHeight 64
#define IMG_TAG 2000
@interface ContentView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *titleScrollView;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) StoryWebView *storyWebView;
@property (strong, nonatomic) UIScrollView *contentScrollView;

// 选中按钮
@property (nonatomic, weak) UIButton *setTitleButton;
//选中图片
@property (nonatomic, weak) UIImageView *setImgView;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *imgs;

@property (nonatomic, copy) NSMutableArray *titleArr;
@property (nonatomic, copy) NSMutableArray *imgArray;
@property (nonatomic, copy) NSMutableArray *imgSelectArray;

@property (nonatomic, strong) HomeDetail *detailData;
@property (nonatomic, strong) PeopleInfo *info;

@property (nonatomic, assign) BOOL isShowScrollContent;
@property (nonatomic, assign) CGFloat contentScrollHeght;

@end

@implementation ContentView

-(instancetype)initWithData:(HomeDetail *)detail andPeopleInfo:(PeopleInfo *)info{
    
    self = [super init];
    if (self) {
        self.contentScrollHeght = DEVICE_HEIGHT - 80 - statusBarAndNavigationBarHeight - titleHeight;
        self.detailData = detail;
        self.info = info;
        [self setBotContent];
        
        _contentScrollView.contentSize = CGSizeMake(_titleArr.count * DEVICE_WIDTH, 0);
        [self addSubview:self.titleScrollView];
        //[self addSubview:self.contentScrollView];
        [self setupTitle];
        [self addChildView];
        [self p_initUI];
    }
    return self;
    
}
-(void)setBotContent{
    
    if (self.detailData.isbook) {
        [self.titleArr addObject:@"书"];
        [self.imgArray addObject:@"bookbanner"];
        [self.imgSelectArray addObject:@"book_selected"];
    }
    if (self.detailData.isspace) {
        [self.titleArr addObject:@"空间"];
        [self.imgArray addObject:@"spacebanner"];
        [self.imgSelectArray addObject:@"space_selected"];
    }
    if (self.detailData.iscurriculum) {
        [self.titleArr addObject:@"课程"];
        [self.imgArray addObject:@"lessonbanner"];
        [self.imgSelectArray addObject:@"lesson_selected"];
    }
    if (self.detailData.isactivity) {
        [self.titleArr addObject:@"活动"];
        [self.imgArray addObject:@"activitybanner"];
        [self.imgSelectArray addObject:@"activity_selected"];
    }
    if (self.detailData.isproduct) {
        [self.titleArr addObject:@"物品"];
        [self.imgArray addObject:@"articlebanner"];
        [self.imgSelectArray addObject:@"article_selected"];
    }
    
    //_titleArr = @[@"书",@"空间",@"课程",@"活动",@"物品"];
    //_imgSelectArray = @[@"bookbanner",@"spacebanner",@"lessonbanner", @"activitybanner", @"articlebanner"];
   // _imgArray = @[@"bookbanner",@"spacebanner", @"lessonbanner", @"activitybanner",  @"articlebanner"];
    
}
-(void)p_initUI{
      __weak __typeof(self)weakSelf = self;
    
    CGFloat titleH = titleHeight;
    BOOL isHide = NO;
    if (self.titleArr.count == 0) {
         titleH = 0;
         isHide = YES;
        self.contentScrollHeght = DEVICE_HEIGHT - 80 - statusBarAndNavigationBarHeight - titleH - tabbarSafeBottomMargin;
    }
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.size.height.mas_equalTo(titleH);
    }];
 //   DEVICE_HEIGHT - 75  - statusBarAndNavigationBarHeight - titleHeight - 64
    UIView *segView = [[UIView alloc] init];
    segView.hidden = isHide;
    segView.backgroundColor = [UIColor colorWithHexString:@"c4c5c5"];//f2f2f2
    [self.titleScrollView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.titleScrollView);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 1));
    }];
    
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [UIColor colorWithHexString:@"7b7c7c"];//
    [self addSubview:self.midView];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.titleScrollView.mas_top);
    }];
    
    self.storyWebView = [[StoryWebView alloc] initWithIdList:self.info.article_list andFrameHeight:self.contentScrollHeght];//[[StoryWebView alloc] initWithData:self.detailData.detailID];
    [self.midView addSubview:self.storyWebView];
    [self.storyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.midView);
    }];
    [self.storyWebView configureCollection:self.info.is_collection];
    self.storyWebView.rewardCallback = ^(NSString *uuid) {
        if (weakSelf.rewardCallback) {
            weakSelf.rewardCallback(uuid);
        }
    };
    self.storyWebView.getWebDataCallback = ^(NSDictionary *webDic, BOOL isShare) {
        if (weakSelf.getWebDataCallback) {
            weakSelf.getWebDataCallback(webDic,isShare);
        }
    };  
    
    [self.midView addSubview:self.contentScrollView];
    self.contentScrollView.alpha = 0;
    self.contentScrollView.frame = CGRectMake(0, self.contentScrollHeght, DEVICE_WIDTH, self.contentScrollHeght);
//    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.midView);
//    }];
    
    UIView *segTopView = [[UIView alloc] init];
    segTopView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];//
    [self addSubview:segTopView];
    [segTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.size.height.mas_equalTo(1);
    }];
    
}

-(void)addChildView{
    
    CGFloat viewW = DEVICE_WIDTH;
    CGFloat viewH = 0;
    CGFloat viewY = 0;
    
    NSInteger count = self.titleArr.count;
    
    self.contentScrollView.contentSize = CGSizeMake(count * viewW, 0);
    __weak __typeof(self)weakSelf = self;
    for (int i=0; i < count ; i++) {
        CGFloat viewX = i * viewW;
        viewH = DEVICE_HEIGHT - 75  - statusBarAndNavigationBarHeight - titleHeight;
        //UIView *conView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        backView.backgroundColor = [UIColor whiteColor];
        if ([self.titleArr[i] isEqualToString:@"书"]) {
     
            BookView *bookView = [[BookView alloc] initWithPId:self.detailData.detailID];
            [backView addSubview:bookView];
            [bookView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(backView);
//                make.top.equalTo(perView.mas_bottom);
                make.edges.equalTo(backView);
            }];

            [self.contentScrollView addSubview:backView];
        }else if ([self.titleArr[i] isEqualToString:@"空间"]) {

            SpaceView *spaceView = [[SpaceView alloc] initWithPId:self.detailData.detailID];
            [backView addSubview:spaceView];
            [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(backView);
//                make.top.equalTo(perView.mas_bottom);
                  make.edges.equalTo(backView);
            }];
            
            [self.contentScrollView addSubview:backView];
        }else if ([self.titleArr[i] isEqualToString:@"课程"]){

            LessonWebView *webView = [[LessonWebView alloc] initWithData:self.detailData.detailID];
            [backView addSubview:webView];
            [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(backView);
//                make.top.equalTo(perView.mas_bottom);
                  make.edges.equalTo(backView);
            }];
            [self.contentScrollView addSubview:backView];
        }else if ([self.titleArr[i] isEqualToString:@"活动"]){

            ActivityView *activityView = [[ActivityView alloc] initWithPId:self.detailData.detailID];
            [backView addSubview:activityView];
            [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(backView);
//                make.top.equalTo(perView.mas_bottom);
                  make.edges.equalTo(backView);
            }];
            
            [self.contentScrollView addSubview:backView];
        }else{

            ArticleView *arcView = [[ArticleView alloc] initWithPId:self.detailData.detailID];
            [backView addSubview:arcView];
            [arcView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(backView);
//                make.top.equalTo(perView.mas_bottom);
                  make.edges.equalTo(backView);
            }];
            
            [self.contentScrollView addSubview:backView];
        }
        
    }
    
}

- (void)setupTitle{
    //184 750
    NSInteger count = self.titleArr.count;
    CGFloat w = DEVICE_WIDTH * 0.75;
    CGFloat btnW = w / count;
    CGFloat btnY = 0;
    CGFloat btnH = titleHeight;//self.titleScrollView.frame.size.height;
    
    //72, 1px 7b7c7c   f7f8f8
    
    //添加标题label
    if (count > 0) {
        for (NSInteger i = 0; i < count; i++) {
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            //[btn setTitle:[NSString stringWithFormat:@"%@",self.titleArr[i]] forState:UIControlStateNormal] ;
            /**
             
             */
            
            
            CGFloat btnX = i *btnW;
            //6a6a6a  a0a0a0
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
            [btn addTarget:self action:@selector(chick:andView:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:self.imgArray[i]];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.top.equalTo(btn.mas_top).offset(8);
                // make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            imgView.tag = IMG_TAG + i;
            
            CGFloat lblFont = 12;
            if (is55InchScreen) {
                lblFont = 12;
            }
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.text = _titleArr[i];
            nameLabel.font = [UIFont systemFontOfSize:lblFont];
            [btn addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn.mas_centerX);
                make.bottom.equalTo(btn.mas_bottom).offset(-5);
            }];
            
            [self.buttons addObject:btn];
            [self.imgs addObject:imgView];
            [self.titleScrollView addSubview:btn];
            //        if (i == 0)
            //        {
            //            [self chick:btn andView:imgView] ;
            //        }
        }
        
        self.titleScrollView.contentSize = CGSizeMake(DEVICE_WIDTH, btnH);//self.titleArr.count *btnW
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"c4c5c5"];//f0f3f5
        [self.titleScrollView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleScrollView.mas_top).offset(10);
            
            make.size.mas_equalTo(CGSizeMake(1, titleHeight - 20));
            make.left.equalTo(self.titleScrollView.mas_left).offset(count * btnW);
        }];
    }
    
    
    
}
// 按钮点击
- (void)chick:(UIButton *)btn andView:(UIImageView *)botView
{
   
    if (!self.isShowScrollContent) {
        NSUInteger i = btn.tag;
        [self setTitleBtn:btn andView:self.imgs[i]];
        CGFloat a = DEVICE_WIDTH;
        
        CGFloat x = i * a;
        
        [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        self.isShowScrollContent = YES;
        self.contentScrollView.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.contentScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, self.contentScrollHeght);
        }];
        if (self.titleBtnCallback) {
            self.titleBtnCallback();
        }
    }else{
        
        NSUInteger i = btn.tag;
        [self setTitleBtn:btn andView:self.imgs[i]];
        CGFloat a = DEVICE_WIDTH;
        
        CGFloat x = i * a;
        
        [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        
        
    }
   
}
// 选中按钮
- (void)setTitleBtn:(UIButton *)btn andView:(UIImageView *)botView
{
    //[self.setTitleButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    self.setTitleButton.backgroundColor = [UIColor colorWithHexString:@"f7f8f8"];
    self.setTitleButton.transform = CGAffineTransformIdentity;
    if (self.setImgView) {
        self.setImgView.image = [UIImage imageNamed:self.imgArray[self.setImgView.tag - IMG_TAG]];
        
    }
    if (btn) {
        NSInteger imgTag = botView.tag;
        // [btn setTitleColor:[UIColor colorWithHexString:@"fc7754"] forState:UIControlStateNormal];
        // btn.backgroundColor = [UIColor colorWithHexString:@"6a6a6a"];
        btn.transform = CGAffineTransformMakeScale(1, 1);
        botView.image = [UIImage imageNamed:self.imgSelectArray[imgTag - IMG_TAG]];
    }

    self.setTitleButton = btn;
    self.setImgView = botView;
}
-(void)hideMidView{
    self.isShowScrollContent = NO;
    self.setTitleButton = nil;
    [self setTitleBtn:nil andView:nil];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentScrollView.frame = CGRectMake(0, self.contentScrollHeght, DEVICE_WIDTH, self.contentScrollHeght);
        self.contentScrollView.alpha = 0;
    }];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = 0;
    CGFloat x = self.contentScrollView.contentOffset.x;
    CGFloat a = DEVICE_WIDTH;
    pageIndex=  x / a;
    //[self.titleScrollView setContentOffset:CGPointMake(DEVICE_WIDTH/self.titleArr.count, 0) animated:YES];
    [self setTitleBtn:self.buttons[pageIndex] andView:self.imgs[pageIndex]];
}
#pragma mark - Setter
-(UIScrollView *)titleScrollView{
    
    if (_titleScrollView == nil) {
        _titleScrollView = [[UIScrollView alloc]init];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.backgroundColor =  [UIColor colorWithHexString:@"f7f8f8"];
        _titleScrollView.bounces = NO;
    }
    return _titleScrollView;
}
-(UIScrollView *)contentScrollView{
    
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.backgroundColor =  [UIColor colorWithHexString:@"efefef"];
        _contentScrollView.contentSize = CGSizeMake(_titleArr.count * DEVICE_WIDTH, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.scrollEnabled = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
    }
    return _contentScrollView;
}
- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
-(NSMutableArray *)imgs{
    
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    
    return _imgs;
    
}
-(NSMutableArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    
    return _titleArr;
    
}
-(NSMutableArray *)imgArray{
    
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    
    return _imgArray;
    
}
-(NSMutableArray *)imgSelectArray{
    
    if (!_imgSelectArray) {
        _imgSelectArray = [NSMutableArray array];
    }
    
    return _imgSelectArray;
    
}
@end
