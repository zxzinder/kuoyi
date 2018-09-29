//
//  CTAlertView.m
//  TransportDriver
//
//  Created by 李齐 on 16/5/26.
//  Copyright © 2016年 Sichuan Yun Ze Zheng Yuan Technology Co.,. All rights reserved.
//

#import "CTAlertView.h"
#import "HLYHUD.h"
#import "VendorMacro.h"
#import "UIColor+TPColor.h"
#import <Masonry.h>

@interface CTAlertView ()<CTAlertViewDelegate>

@property (strong,nonatomic) UIView *alertview;
@property (strong,nonatomic) UIView *backgroundview;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *detailLabel;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *details;
@property (nonatomic, copy) NSAttributedString *attrDetails;
@property (strong,nonatomic) NSString *cancelButtonTitle;
@property (strong,nonatomic) NSString *okButtonTitle;
@property (copy, nonatomic) void (^actionCallBack)(NSInteger index);
@property (strong, nonatomic) UIView   *lineView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *okButton;
@property (strong, nonatomic) UIImage *orderingImage;
@property (nonatomic, assign) BOOL isAttrText;

@end


@implementation CTAlertView

- (instancetype)initWithTitle:(NSString *)title Details:(NSString *)details  OkButton:(NSString *)okButton {
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.details = details;
        self.okButtonTitle = okButton;
        [self setUp:NO];
        [self p_updateUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton {
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.details = details;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        [self setUp:NO];
    }
    return self;
}

-(instancetype)initWithDifferentColorTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.details = details;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        [self setUp:YES];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton IsAttrText:(BOOL)isAttrText{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.details = details;
        self.okButtonTitle = okButton;
        self.cancelButtonTitle = cancelButton;
        self.isAttrText = isAttrText;
        [self setUp:NO];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title AttrDetails:(NSAttributedString *)attrDetails CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.attrDetails = attrDetails;
        self.okButtonTitle = okButton;
        self.cancelButtonTitle = cancelButton;
        [self setUp:NO];
    }
    return self;
}
- (void)show:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    [view insertSubview:self atIndex:1];
//    [view addSubview:self];
    self.alertview.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alertview.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

+ (void)showAlertViewWithTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton DoneButton:(NSString *)doneButton callBack:(void (^)(NSInteger))callBack {
        CTAlertView *alertView = [[CTAlertView alloc] initWithTitle:title Details:details CancelButton:cancelButton OkButton:doneButton];
        alertView.delegate = alertView;
        alertView.actionCallBack = callBack;
        [alertView show:nil];
}

+(void)showAlertViewWithTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton DoneButton:(NSString *)doneButton image:(UIImage *)image view:(UIView *)view callBack:(void (^)(NSInteger))callBack{
    CTAlertView *alertView = [[CTAlertView alloc] initWithTitle:title Details:details CancelButton:cancelButton OkButton:doneButton];
    alertView.delegate = alertView;
    alertView.actionCallBack = callBack;
    alertView.orderingImage = image;
    [alertView p_configePictureView:image];
    [alertView show:view];
}

+(void)showAlertViewWithDifferentColorTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton DoneButton:(NSString *)doneButton callBack:(void (^)(NSInteger))callBack{
    CTAlertView *alertView = [[CTAlertView alloc] initWithDifferentColorTitle:title Details:details CancelButton:cancelButton OkButton:doneButton];
    alertView.delegate = alertView;
    alertView.actionCallBack = callBack;
    [alertView show:nil];
}

-(void)p_configePictureView:(UIImage *)image{
    [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.alertview.mas_top).offset(100);
    }];
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    self.pictureView.image = image;
}

- (void)setUp:(BOOL)isDifferentColor{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.6;
    [self addSubview:self.backgroundview];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    self.alertview = [[UIView alloc] init];
    self.alertview.layer.cornerRadius = 5;
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    [self addSubview:self.alertview];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.contentMode = UIViewContentModeScaleToFill;
    self.pictureView = image;
    [self.alertview addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.alertview.mas_left);
        make.right.equalTo(self.alertview.mas_right);
        make.top.equalTo(self.alertview.mas_top);
        make.height.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor tp_blackTextColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertview.mas_top).offset(30);
        make.left.equalTo(self.alertview.mas_left).offset(10);
        make.right.equalTo(self.alertview.mas_right).offset(-10);
    }];
    
    UILabel *details = [[UILabel alloc] init];
    details.textColor = [UIColor tp_darkGaryTextColor];
    details.font = [UIFont systemFontOfSize:14];
    self.detailLabel = details;
    details.numberOfLines = 0;    
    details.textAlignment = NSTextAlignmentCenter;
    [self.alertview addSubview:details];
    [details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_right);
        make.left.equalTo(self.alertview.mas_left).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    if (self.attrDetails) {
        details.attributedText = self.attrDetails;
    }else{
        if (self.isAttrText) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.details dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            details.attributedText = attrStr;
        }else{
            details.text = self.details;
            
        }
    }
   
    
    self.okButton = [self createButtonWithTitle:self.okButtonTitle];
    self.okButton.tag = OKBUTTON_TAG;
    [self.alertview addSubview:self.okButton];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.alertview.mas_left);
        make.right.equalTo(self.alertview.mas_centerX);
        
        make.top.equalTo(details.mas_bottom).offset(25);
        make.height.equalTo(@44);
    }];
    

    
    self.cancelButton = [self createButtonWithTitle:self.cancelButtonTitle];
    self.cancelButton.tag = CANCELBUTTON_TAG;
    [self.alertview addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.okButton.mas_right);
        make.right.equalTo(self.alertview.mas_right);
        make.top.equalTo(details.mas_bottom).offset(25);
        make.height.equalTo(@44);
    }];
    
    //if (isDifferentColor) {
    UIView *oklineView = [[UIView alloc] init];
    oklineView.backgroundColor = [UIColor tp_lightGaryBackgroundColor];
    [self.okButton addSubview:oklineView];
    [oklineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.okButton.mas_left);
        make.right.equalTo(self.okButton.mas_right);
        make.top.equalTo(self.okButton.mas_top);
        make.height.mas_equalTo(1);
    }];
    //}
    
    
    self.lineView = [[UIView alloc] init];
    [self.lineView setBackgroundColor:[UIColor whiteColor]];
    [self.alertview addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertview.mas_centerX);
        make.width.equalTo(@1);
        make.height.equalTo(@44);
        make.top.equalTo(self.okButton.mas_top);
    }];
   
    [self.alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
        make.bottom.equalTo(self.okButton.mas_bottom);
    }];
}

- (void)p_updateUI {
    [self.lineView removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    
    [self.okButton mas_updateConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(self.alertview.mas_left);
        make.right.equalTo(self.alertview.mas_right);
    }];
}

-(void)setDetailAlignment:(DetailAlignment)detailAlignment{
    _detailAlignment = detailAlignment;
    if (detailAlignment == TextAlignmentLeft) {
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        if (self.details) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:10];//调整行间距
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.details attributes:
                                                    @{
                                                      NSParagraphStyleAttributeName : paragraphStyle,
                                                      NSForegroundColorAttributeName : [UIColor tp_darkGaryTextColor],
                                                      NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                      }];
            self.detailLabel.attributedText = attributedString;
        }

    }
}

#pragma mark -  private function

- (UIButton *)createButtonWithTitle:(NSString *)title{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:self.okButtonTitle]) {
        
        [button setTitleColor:[UIColor colorWithHexString:@"17a7af"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        
    }else{
        [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"17a7af"]];
    }

    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(alertView:didClickButtonAtIndex:)]) {
        [self.delegate alertView:self didClickButtonAtIndex:(button.tag)];
    }
    [self dismiss];
}

- (void)click:(UITapGestureRecognizer *)sender{
    CGPoint tapLocation = [sender locationInView:self.backgroundview];
    CGRect alertFrame = self.alertview.frame;
    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
        [self dismiss];
    }
}

- (void)dismiss{
    self.alpha = 0.0;
    [self removeFromSuperview];
    self.alertview = nil;
}

#pragma mark - CTAlertViewDelegate

- (void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index {
    if (self.actionCallBack) {
        self.actionCallBack(index/100 - 1);
    }
}
#pragma mark - Setter
- (void)setTitleImage:(UIImage *)titleImage {
    if (_titleImage != titleImage) {
        _titleImage = titleImage;
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertview.mas_centerX).offset(-15);
            make.top.equalTo(self.alertview.mas_top).offset(30);
            make.right.equalTo(self.alertview.mas_right).offset(-10);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:titleImage];
        [self.alertview addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@26);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        }];
    }
}
@end
