//
//  UmengShareview.h
//  
//
//  Created by YY on 16/10/27.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonView;
@class UmengShareview;

typedef void(^ButtonViewHandler)(ButtonView *buttonView);

@protocol ButtonViewDelegate <NSObject>

@optional
-(void)buttonItemHandled;

@end

@interface ButtonView : UIView

@property (nonatomic, weak) id <ButtonViewDelegate>delegate;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIButton *imageButton;

@property (nonatomic, weak) UmengShareview *activityView;

@property (nonatomic, assign) BOOL isShowActivityView;

- (id)initWithText:(NSString *)text image:(UIImage *)image handler:(ButtonViewHandler)handler;

@end

@interface UmengShareview : UIView

@property (nonatomic, copy) void (^UmengShareViewCallback)(int index);
@property (nonatomic, copy) void (^UmengShareViewSuccessCallback)(NSInteger index);
@property (nonatomic, strong) UIView *referView;

//@property (nonatomic, strong) NSString *titleText;

- (id)initWithData:(NSDictionary *)shareData referView:(UIView *)referView hasTitle:(BOOL) hasTitle isShowOther:(BOOL)isShowOther;

-(instancetype)initWithImage:(UIImage *)shareImg;

- (void)addButtonView:(ButtonView *)buttonView;

- (void)show;

- (void)hide;

@end
