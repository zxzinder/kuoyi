//
//  ActionSeetPickerView.h
//  TransportPassenger
//
//  Created by 文 闻 on 15/11/3.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSeetPickerView;

@protocol ActionSeetPickViewDelegate <NSObject>

@optional
- (void)toobarDonBtnHaveClick:(ActionSeetPickerView *)pickView resultString:(NSString *)resultString;

- (UIView *)ViewForPickerViewRow;

- (CGFloat)pickerViewRowHeight;

- (CGFloat)actionSeetPickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component;

- (void)actionSeetPickerView:(ActionSeetPickerView*)view WillLoadCompoent:(UIPickerView*)pickerView;

@end



@interface ActionSeetPickerView : UIView

@property(nonatomic,weak) id<ActionSeetPickViewDelegate> delegate;
@property (nonatomic, copy) void (^addSubViewWhenShow)(UIView *view);
@property(nonatomic, copy)NSArray *extraDataArray;

@property (nonatomic,assign) BOOL isLineRent;

- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;
- (instancetype)initPickviewWithArray:(NSArray *)array andMidArray:(NSArray *)midArray isHaveNavControler:(BOOL)isHaveNavControler;
- (instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;

- (instancetype)initPickviewWithArray:(NSArray *)array isShowRemindTitle:(BOOL)isShowRemindTitle;

- (void)setPickViewColer:(UIColor *)color;

- (void)setLeftTintColor:(UIColor *)color;

- (void)setRightTintColor:(UIColor *)color;

- (void)setToolbarTintColor:(UIColor *)color;

- (void)setPickViewTag:(NSInteger) tagNumber;

-(void)setSelectedPickView:(NSInteger)day andHour:(NSInteger)hour andMin:(NSInteger)min;//包车 接送机的时间选择

- (void)show;

- (void)remove;

@end
