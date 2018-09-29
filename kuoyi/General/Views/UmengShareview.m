//
//  UmengShareview.m
//
//
//  Created by YY on 16/10/27.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "UmengShareview.h"
#import "UtilsMacro.h"
#import "Dotline.h"
#import "HLYHUD.h"
#import <UMSocialCore/UMSocialCore.h>
#import <Masonry.h>
#import "UIColor+TPColor.h"
#import <SDWebImageManager.h>

#define BUTTON_VIEW_WIDTH DEVICE_WIDTH / 4
#define BUTTON_VIEW_HEIGHT 90
#define BUTTON_VIEW_FONT_SIZE 13.f
#define CONTENTHEIGHT 110
#pragma mark - ButtonView

@interface ButtonView ()

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) ButtonViewHandler handler;

@end

@implementation ButtonView

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

-(id)initWithText:(NSString *)text image:(NSString *)image handler:(ButtonViewHandler)handler{
    
    self = [super init];
    if (self) {
        self.text = text;
        self.image = image;
        if (handler) {
            self.handler = handler;
        }
        [self p_initUI];
    }
    return self;
}

-(void)p_initUI{
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.text = self.text;
    self.textLabel.textColor = [UIColor tp_darkGaryTextColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageButton setImage:[UIImage imageNamed:self.image] forState:UIControlStateNormal];
    [self.imageButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.imageButton];
    
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@20);
    }];
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.textLabel.mas_top).offset(-5);
        make.top.equalTo(self.mas_top).offset(5);
    }];
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.handler) {
        self.handler(self);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonItemHandled)]) {
        [self.delegate buttonItemHandled];
    }
}


@end

@interface UmengShareview ()<ButtonViewDelegate> //UMSocialUIDelegate
@property (nonatomic, strong) NSDictionary *shareDic;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, assign) BOOL isHasTitle;
@property (nonatomic, assign) BOOL isShowOther;//是否显示微信以外的按钮
@end

@implementation UmengShareview

-(void)dealloc{
    NSLog(@"%s", __func__);
}

-(id)initWithData:(NSDictionary *)shareData referView:(UIView *)referView hasTitle:(BOOL)hasTitle isShowOther:(BOOL)isShowOther{
    
    self = [super init];
    if (self) {
        self.shareDic = shareData;
        self.isHasTitle = hasTitle;
        self.referView = referView ? referView : [UIApplication sharedApplication].keyWindow;
        self.isShowOther = isShowOther;
        [self p_initUI];
    }
    return  self;
}

-(instancetype)initWithImage:(UIImage *)shareImg{
    
    self = [super init];
    if (self) {
        self.shareImg = shareImg;
        self.referView =  [UIApplication sharedApplication].keyWindow;
        self.isShowOther = YES;
        [self p_initUI];
    }
    return  self;
    
}

-(void)p_initUI{
    NSString *content = self.shareDic[@"shareDesContent"];
    NSString *title = self.shareDic[@"shareDesTitle"];
    //CGFloat height = [content boundingRectWithSize:CGSizeMake(DEVICE_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor tp_lightGaryTextColor]} context:nil].size.height;
    //if (_isHasTitle) {
    //    self.viewHeight = CONTENTHEIGHT + 40 + height;
    //}else{
        self.viewHeight = CONTENTHEIGHT;
    //}
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);

    self.blackView = [[UIView alloc] initWithFrame:self.frame];
    self.blackView.userInteractionEnabled = YES;
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewTapped)];
    [self.blackView addGestureRecognizer:tap];
    [self addSubview:self.blackView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT - self.viewHeight, DEVICE_WIDTH, self.viewHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
//    if (_isHasTitle) {
//        UILabel *textLabel = [[UILabel alloc] init];
//        textLabel.text = title;
//        textLabel.font = [UIFont systemFontOfSize:16];
//        textLabel.textColor = [UIColor tp_darkGaryTextColor];
//        [self.contentView addSubview:textLabel];
//        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.top.equalTo(self.contentView.mas_top).offset(10);
//            make.height.mas_equalTo(20);
//        }];
//        
//        self.contentLabel = [[UILabel alloc] init];
//        self.contentLabel.text = content;
//        self.contentLabel.textColor = [UIColor tp_darkGaryTextColor];
//        self.contentLabel.font = [UIFont systemFontOfSize:14];
//        self.contentLabel.numberOfLines = 0;
//        [self.contentView addSubview:self.contentLabel];
//        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(textLabel.mas_left);
//            make.right.equalTo(textLabel.mas_right);
//            make.top.equalTo(textLabel.mas_bottom).offset(5);
//            make.height.mas_equalTo(height + 10);
//        }];
//        
//        Dotline *dotLine = [[Dotline alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:dotLine];
//        [dotLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.top.equalTo(self.contentView.mas_bottom).offset(-(BUTTON_VIEW_HEIGHT + 6));
//        }];
//    }
    NSArray *titleArray;
    NSArray *imageNameArray;
    
    __weak typeof(self) weakSelf = self;
    __weak NSString *shareTitle = self.shareDic[@"title"];
    __block UIImage *shareImage;
    NSString *shareImgaeUrl;
    NSString *shareDesContent;
    NSString *shareLinkUrl;
    if (self.isShowOther) {
        titleArray = @[@"微信好友",@"朋友圈",@"QQ",@"微博"];
        imageNameArray = @[@"wechat",@"wechat",@"qqlogin",@"wblogin"];
        shareTitle = self.shareDic[@"shareDesTitle"];
        shareImgaeUrl = self.shareDic[@"shareImageUtl"];
        shareDesContent = self.shareDic[@"content"];
        shareLinkUrl = self.shareDic[@"shareLinkUrl"];//self.shareDic[@"wxUrl"];
    }else{//分享活动页和推荐页
        titleArray = @[@"微信好友",@"朋友圈"];
        imageNameArray = @[@"微信",@"朋友圈"];
        shareTitle = self.shareDic[@"shareDesTitle"];
        shareImgaeUrl = self.shareDic[@"shareImageUrl"];
        shareDesContent = self.shareDic[@"shareDesContent"];
        shareLinkUrl = self.shareDic[@"shareLinkUrl"];
    }
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:shareImgaeUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (finished) {
            if (!image) {
                image = [UIImage imageNamed:@"share_image"];
            }
            shareImage = image;
        }
    }];
    
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:shareImgaeUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (finished) {
//            if (!image) {
//                image = [UIImage imageNamed:@"share_image"];
//            }
//            shareImage = image;
//        }
//    }];
    for (int i = 0; i < titleArray.count; i++) {
        ButtonView *btn = [[ButtonView alloc] initWithText:titleArray[i] image:imageNameArray[i] handler:^(ButtonView *buttonView) {
            if (weakSelf.UmengShareViewCallback) {
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMSocialPlatformType platformType = UMSocialPlatformType_WechatSession;
                if (self.shareImg) {
                    UMShareImageObject *imageObj =[[UMShareImageObject alloc] init]; //[UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:shareImg];
                    [imageObj setShareImage:self.shareImg];
                    messageObject.shareObject = imageObj;
                }else{
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDesContent thumImage:shareImage];
                    //设置网页地址
                    shareObject.webpageUrl = shareLinkUrl;
                    
                    messageObject.shareObject = shareObject;
                }     
                if (i == 0) {
                    platformType = UMSocialPlatformType_WechatSession;
                }else if (i == 1) {
                    platformType = UMSocialPlatformType_WechatTimeLine;
                }else if (i == 2) {
                     platformType = UMSocialPlatformType_QQ;

                }else if (i == 3) {
                     platformType = UMSocialPlatformType_Sina;
                }
                [weakSelf shareWebPageToPlatformType:platformType UMSocialMessageObject:messageObject andSelectInde:i];
                weakSelf.UmengShareViewCallback(i);
            }
        }];
        btn.delegate = self;
        [weakSelf.contentView addSubview:btn];
        if (self.isShowOther) {
            btn.frame = CGRectMake(i * BUTTON_VIEW_WIDTH, self.viewHeight - BUTTON_VIEW_HEIGHT, BUTTON_VIEW_WIDTH, BUTTON_VIEW_HEIGHT);
        }else{
           btn.frame = CGRectMake(i * BUTTON_VIEW_WIDTH*2 + BUTTON_VIEW_WIDTH/2, self.viewHeight - BUTTON_VIEW_HEIGHT, BUTTON_VIEW_WIDTH, BUTTON_VIEW_HEIGHT);
        }
   
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType UMSocialMessageObject:(UMSocialMessageObject *)messageObject andSelectInde:(NSInteger)selectIndex{
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[self currntViewController] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [HLYHUD showHUDWithMessage:@"分享失败" addToView:nil];
        }else{
            if (self.UmengShareViewSuccessCallback) {
                
                NSInteger type;//1微信 2QQ 3新浪 4豆瓣
                if (selectIndex == 0 || selectIndex == 1) {
                    type = 1;
                }else if (selectIndex == 2){
                    type = 2;
                }else{
                    type = 3;
                }
                self.UmengShareViewSuccessCallback(type);
            }else{
                [HLYHUD showHUDWithMessage:@"分享成功！" addToView:nil];
            }
        }
    }];
}
/// 获取所在的视图控制器
- (UIViewController *)currntViewController {
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
- (void)addButtonView:(ButtonView *)buttonView
{
    [self.buttonArray addObject:buttonView];
    buttonView.activityView = self;
}

-(void)blackViewTapped{
    [self hide];
}

-(void)buttonItemHandled{
    [self hide];
}

-(void)show{
    [self.referView addSubview:self];
    [self setNeedsUpdateConstraints];
    self.alpha = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
