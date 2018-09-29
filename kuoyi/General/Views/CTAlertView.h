//
//  CTAlertView.h
//  TransportDriver
//
//  Created by 李齐 on 16/5/26.
//  Copyright © 2016年 Sichuan Yun Ze Zheng Yuan Technology Co.,. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTAlertView;

@protocol CTAlertViewDelegate <NSObject>

@optional
-(void)alertView:(CTAlertView *)alertView didClickButtonAtIndex:(NSUInteger)index;
@end

typedef enum : NSUInteger {
    TextAlignmentCenter = 0,
    TextAlignmentLeft
} DetailAlignment;

@interface CTAlertView : UIView
@property (nonatomic,weak) id <CTAlertViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImage *titleImage;
@property (nonatomic, copy) void (^callBack)(NSString *mileage);
@property (nonatomic, assign) DetailAlignment detailAlignment;
//
- (instancetype)initWithTitle:(NSString *) title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;
- (instancetype)initWithTitle:(NSString *)title Details:(NSString *)details  OkButton:(NSString *)okButton;
- (instancetype)initWithTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton IsAttrText:(BOOL)isAttrText;
- (instancetype)initWithDifferentColorTitle:(NSString *) title Details:(NSString *)details CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

-(instancetype)initWithTitle:(NSString *)title AttrDetails:(NSAttributedString *)attrDetails CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

- (void)p_configePictureView:(UIImage *)image;
- (void)show:(UIView *) view;
- (void)dismiss;
/**
 *  使用blcok回调的 alertView
 *
 *  @param title        标题
 *  @param details      详情
 *  @param isNeed       是否需要TextField
 *  @param cancelButton 取消按钮Title
 *  @param doneButton   确认按钮Title
 *  @param callBack     回调 参数：index
 */
+ (void)showAlertViewWithTitle:(NSString*)title Details:(NSString*)details CancelButton:(NSString*)cancelButton DoneButton:(NSString*)doneButton callBack:(void(^)(NSInteger buttonIndex))callBack;
+ (void)showAlertViewWithTitle:(NSString*)title Details:(NSString*)details CancelButton:(NSString*)cancelButton DoneButton:(NSString*)doneButton image:(UIImage *)image view:(UIView *)view callBack:(void(^)(NSInteger buttonIndex))callBack;
+ (void)showAlertViewWithDifferentColorTitle:(NSString *)title Details:(NSString *)details CancelButton:(NSString *)cancelButton DoneButton:(NSString *)doneButton callBack:(void(^)(NSInteger buttonIndex))callBack;


@end
