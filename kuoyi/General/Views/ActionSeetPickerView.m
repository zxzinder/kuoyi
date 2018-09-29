//
//  ActionSeetPickerView.m
//  TransportPassenger
//
//  Created by 文 闻 on 15/11/3.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#import "ActionSeetPickerView.h"
#import "UtilsMacro.h"
#import <BlocksKit+UIKit.h>
#import <Masonry.h>
#import "UIColor+TPColor.h"


#define ToobarHeight 40

const static NSInteger showViewHeight = 259;
@interface ActionSeetPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIView           *backGroundView;
@property(nonatomic,strong)NSArray          *plistArray;
@property(nonatomic,strong)NSMutableArray   *dicKeyArray;
@property(nonatomic,strong)NSDictionary     *levelTwoDic;
@property(nonatomic,strong)UIPickerView     *pickerView;
@property(nonatomic,strong)UIView           *toolbar;

@property(nonatomic,assign)BOOL             isLevelArray;
@property(nonatomic,assign)BOOL             isLevelString;
@property(nonatomic,assign)BOOL             isLevelDic;
@property (nonatomic, assign) BOOL isShowRemind;
@property(nonatomic,strong)NSString         *resultString;
@property(nonatomic,strong)NSMutableArray   *state;
@property(nonatomic,strong)NSMutableArray   *city;

@property(nonatomic,strong)UIDatePicker     *datePicker;
@property(nonatomic,strong)NSMutableArray   *componentArray;

@property(nonatomic,strong)NSString         *plistName;

@property(nonatomic,assign)NSDate           *defaulDate;
@property (nonatomic, strong) NSArray       *originalData;
@property (nonatomic, strong) UIView        *backView;
//专车包车
@property(nonatomic,strong)NSString         *hourString;
@property(nonatomic,strong)NSString         *minuteString;

@property(nonatomic, copy)NSArray *midDataArray;

//默认时间
@property (nonatomic, assign) NSInteger selectDay;
@property (nonatomic, assign) NSInteger selectHour;
@property (nonatomic, assign) NSInteger selectMin;

@end

@implementation ActionSeetPickerView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUpBackGroundView];
    }
    return self;
}

- (instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self = [super init];
    if (self) {
        self.plistName = plistName;
        self.plistArray = [self p_getPlistArrayByplistName:plistName];
        [self p_setUpPickView];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array andMidArray:(NSArray *)midArray isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        self.plistArray         = array;
        self.midDataArray = midArray;
        [self p_setArrayClass:array];
        [self p_setUpPickView];
    }
    return self;
}
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler {
    self=[super init];
    if (self) {
        self.plistArray         = array;
        [self p_setArrayClass:array];
        [self p_setUpPickView];
    }
    return self;
}
- (instancetype)initPickviewWithArray:(NSArray *)array isShowRemindTitle:(BOOL)isShowRemindTitle {
    self=[super init];
    if (self) {
        self.plistArray         = array;
        self.isShowRemind = isShowRemindTitle;
        [self p_setArrayClass:array];
        [self p_setUpPickView];
    }
    return self;
}
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        self.defaulDate = defaulDate;
        [self p_setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
    }
    return self;
}

#pragma mark - Private Method

- (NSArray *)p_getPlistArrayByplistName:(NSString *)plistName {
    NSString *path  = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray  *array = [[NSArray alloc] initWithContentsOfFile:path];
    [self p_setArrayClass:array];
    return array;
}

- (void)p_setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode  = datePickerMode;
    datePicker.backgroundColor = [UIColor lightGrayColor];
    if (self.defaulDate) {
        [datePicker setDate:self.defaulDate];
    }
    self.datePicker = datePicker;
    datePicker.frame        = CGRectMake(0, ToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    [self addSubview:datePicker];
}

- (void)p_setArrayClass:(NSArray *)array {
    
    self.dicKeyArray = [[NSMutableArray alloc] init];
    
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            self.isLevelArray   = YES;
            self.isLevelString  = NO;
            self.isLevelDic     = NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            self.isLevelString  = YES;
            self.isLevelArray   = NO;
            self.isLevelDic     = NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            self.isLevelDic     = YES;
            self.isLevelString  = NO;
            self.isLevelArray   = NO;
            self.levelTwoDic    = levelTwo;
            [self.dicKeyArray addObject:[self.levelTwoDic allKeys] ];
        }
    }
}

-(void)setPickViewTag:(NSInteger)tagNumber
{
    self.pickerView.tag = tagNumber;
//    if (self.isLevelArray && tagNumber == 3000) {
//        [self.pickerView selectRow:5 inComponent:1 animated:YES];
//    }
}
-(void)setSelectedPickView:(NSInteger)day andHour:(NSInteger)hour andMin:(NSInteger)min{//包车 接送机的时间选择
    self.selectDay = day;
    self.selectHour = hour;
    self.selectMin = min;
    //|04月11日(Wed)|5|0
    self.resultString = [NSString stringWithFormat:@"|%@|%@|%@|",self.plistArray[0][day],self.plistArray[1][hour],self.plistArray[2][min]];
    [self.pickerView selectRow:day inComponent:0 animated:YES];
    [self.pickerView reloadComponent:1];
     [self.pickerView selectRow:hour inComponent:1 animated:YES];
    [self.pickerView reloadComponent:2];
     [self.pickerView selectRow:min inComponent:2 animated:YES];
    
}
- (void)p_setUpPickView {
    
    __weak __typeof(self)weakSelf = self;
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.backgroundColor         = [UIColor whiteColor];
    self.pickerView.delegate                = self;
    self.pickerView.dataSource              = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.backGroundView addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backGroundView.mas_left);
        make.right.equalTo(weakSelf.backGroundView.mas_right);
        make.bottom.equalTo(weakSelf.backGroundView.mas_bottom);
    }];

    [self p_setUpToolBar];
}

-(void)setExtraDataArray:(NSArray *)extraDataArray
{
    _extraDataArray = extraDataArray;
    self.originalData = self.plistArray;
    if (self.isLineRent) {
       self.plistArray = extraDataArray;
    }
    [self.pickerView reloadAllComponents];
    if (self.plistArray.count == 2) {
        self.hourString = self.plistArray[0][0];
        self.minuteString = self.plistArray[1][0];
    }
}
//-(void)setMidDataArray:(NSArray *)midDataArray{
//
//    _midDataArray = midDataArray;
//
//}
- (void)p_setUpBackGroundView {
    
    __weak __typeof(self)weakSelf = self;
    
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backGroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backGroundView];
    
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
}

- (void)p_setUpToolBar {
    self.toolbar    = [self p_setToolbarStyle];
    [self.backGroundView addSubview:self.toolbar];
    [self p_setToolbarWithPickViewFrame];
    
}

- (UIView *)p_setToolbarStyle {
    
    UIView *toolbar=[[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton *leftItem= [[UIButton alloc] initWithFrame:CGRectZero];
    leftItem.tag = 1111;
    [leftItem.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftItem setTitle:@"取消" forState:UIControlStateNormal];
    [leftItem  addTarget:self action:@selector(p_removeView) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:leftItem];
    
    [leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar.mas_centerY);
        make.left.equalTo(toolbar.mas_left).offset(10);
        make.height.equalTo(toolbar.mas_height);
        make.width.equalTo(@60);
    }];
    
    UIButton *rightItem= [[UIButton alloc] initWithFrame:CGRectZero];
    rightItem.tag = 2222;
    [rightItem.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightItem setTitle:@"确定" forState:UIControlStateNormal];
    [rightItem  addTarget:self action:@selector(a_doneClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:rightItem];
    
    [rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar.mas_centerY);
        make.right.equalTo(toolbar.mas_right).offset(-10);
        make.height.equalTo(toolbar.mas_height);
        make.width.equalTo(@60);
    }];
    if (_isShowRemind) {
        UILabel *midLabel = [[UILabel alloc] init];
        midLabel.text = @"选择上车时间地点";
        midLabel.textColor = [UIColor colorWithHexString:@"3c3c3c"];
        midLabel.font = [UIFont systemFontOfSize:17];
        midLabel.textAlignment = NSTextAlignmentCenter;
        [toolbar addSubview:midLabel];
        [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(toolbar.mas_centerY);
            make.centerX.equalTo(toolbar.mas_centerX);
            make.left.equalTo(leftItem.mas_right);
            make.right.equalTo(rightItem.mas_left);
        }];
    }
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor tp_lineColor];
    [toolbar addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightItem.mas_bottom);
        make.width.equalTo(toolbar.mas_width);
        make.height.equalTo(@1);
    }];
    
    return toolbar;
}

- (void)p_setToolbarWithPickViewFrame {

    if (_isShowRemind) {
        UILabel *remindLabel = [[UILabel alloc] init];
        remindLabel.text = @"请按照对应上车点的时间进行上车";
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.font = [UIFont systemFontOfSize:12];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [self.backGroundView addSubview:remindLabel];
        [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backGroundView);
            make.size.height.mas_equalTo(30);
            make.bottom.equalTo(self.pickerView.mas_top);
        }];
        [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backGroundView.mas_left);
            make.right.equalTo(self.backGroundView.mas_right);
            make.height.equalTo([NSNumber numberWithInteger:ToobarHeight]);
            make.bottom.equalTo(remindLabel.mas_top);
        }];
    }else{
        [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backGroundView.mas_left);
            make.right.equalTo(self.backGroundView.mas_right);
            make.height.equalTo([NSNumber numberWithInteger:ToobarHeight]);
            make.bottom.equalTo(self.pickerView.mas_top);
        }];
    }
  
}

#pragma mark - Action Target

- (void)a_remove {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)a_doneClick
{
    
    if (self.pickerView) {
        
        if (self.resultString) {
            
        } else {
            if ( self.isLevelString ) {
                
                self.resultString = [NSString stringWithFormat:@"%@",self.plistArray[0]];
                
            }else if ( self.isLevelArray ){
                
                self.resultString = @"";
                
                for (int i = 0; i < self.plistArray.count; i++) {
                    
                    self.resultString = [NSString stringWithFormat:@"%@|%@",_resultString,_plistArray[i][0]];
                }
            }else if (self.isLevelDic){
                
                if (self.state == nil) {
                    self.state                  = self.dicKeyArray[0][0];
                    NSDictionary *dicValueDic   = self.plistArray[0];
                    self.city                   = [dicValueDic allValues][0][0];
                }
                if (self.city == nil){
                    NSInteger cIndex = [self.pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic   = self.plistArray[cIndex];
                    self.city                   = [dicValueDic allValues][0][0];
                    
                }
                self.resultString = [NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    } else if (self.datePicker) {
        self.resultString = [NSString stringWithFormat:@"%@",_datePicker.date];
    }
    if (self.isLineRent) {//专车包车
        if(!self.hourString){
            self.hourString = self.plistArray[0][0];
        }
        if (!self.minuteString) {
            self.minuteString = self.plistArray[1][0];
        }
        self.resultString = [NSString stringWithFormat:@"%@:%@",self.hourString,self.minuteString];
    }
    
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:self.resultString];
    }
    [self p_removeView];
}


#pragma Public Method

- (void)setPickViewColer:(UIColor *)color {
    self.pickerView.backgroundColor = color;
}

- (void)setLeftTintColor:(UIColor *)color{
    self.toolbar.tintColor = color;
    UIButton *button1 = (UIButton*)[self.toolbar viewWithTag:1111];
    [button1 setTitleColor:color forState:UIControlStateNormal];
}

-(void)setRightTintColor:(UIColor *)color
{
    self.toolbar.tintColor = color;
    UIButton *button2 = (UIButton*)[self.toolbar viewWithTag:2222];
    [button2 setTitleColor:color forState:UIControlStateNormal];
}

- (void)setToolbarTintColor:(UIColor *)color{
    self.toolbar.backgroundColor = color;
}

- (void)show{
    [self p_configbackView];
    [self p_startAnimate];
    
}

- (void)remove{
    [self a_remove];
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    NSInteger component;
    if (self.isLevelArray) {
        component = self.plistArray.count;
    } else if (self.isLevelString){
        component = 1;
    }else if(self.isLevelDic){
        component = [self.levelTwoDic allKeys].count * 2;
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSeetPickerView:WillLoadCompoent:)]) {
        [self.delegate actionSeetPickerView:self WillLoadCompoent:pickerView];
    }
    
    return component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowArray=[[NSArray alloc] init];
    if (self.isLevelArray) {
        rowArray = self.plistArray[component];
    }else if (self.isLevelString){
        rowArray = self.plistArray;
    }else if (self.isLevelDic){
        NSInteger pIndex    = [pickerView selectedRowInComponent:0];
        NSDictionary *dic   = self.plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component % 2 == 1) {
                    rowArray = dicValue;
                }else{
                    rowArray = self.plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if ([self.delegate respondsToSelector:@selector(ViewForPickerViewRow)]) {
        if (!pickerLabel) {
            pickerLabel = (UILabel*)[self.delegate ViewForPickerViewRow];
        }
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    }
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

#pragma mark - UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UILabel *label = (UILabel *)[self.pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component];
    label.textColor = [UIColor colorWithHexString:@"17a7af"];//[UIColor tp_yellowTextColor];
    NSString *rowTitle = nil;
    if (self.isLevelArray) {
        rowTitle = self.plistArray[component][row];
    }else if (self.isLevelString){
        rowTitle = self.plistArray[row];
    }else if (self.isLevelDic){
        NSInteger pIndex    = [pickerView selectedRowInComponent:0];
        NSDictionary *dic   = self.plistArray[pIndex];
        if(component % 2 == 0) {
            rowTitle = self.dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]] && component % 2 == 1){
                NSArray *bb = aa;
                if (bb.count > row) {
                    rowTitle = aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if ([self.delegate respondsToSelector:@selector(actionSeetPickerView:widthForComponent:)]) {
        return [self.delegate actionSeetPickerView:pickerView widthForComponent:component];
    }
    
    if (self.isLevelString) {
        return DEVICE_WIDTH;
    }else if (self.isLevelArray){
        if (self.plistArray.count == 2) {
            return  DEVICE_WIDTH / 3;
        }
        return DEVICE_WIDTH/self.plistArray.count;
    }else{
        return DEVICE_WIDTH/[self numberOfComponentsInPickerView:pickerView];
    }
    
    return DEVICE_WIDTH;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger count = self.extraDataArray.count;
    if (self.extraDataArray != nil) {
        
        if (count == 2) {//专车页面包车
            if (component == 0 && row == 0) {
                self.plistArray = self.extraDataArray;
            }else if (row == [self.extraDataArray[0] count] - 1 && component == 0){
                 self.plistArray = @[self.extraDataArray[0],self.originalData[count - 1]];
            }else if (row > 0 && row < [self.extraDataArray[0] count] - 1  && component == 0) {
                self.plistArray = @[self.extraDataArray[0],self.midDataArray[1]];
            }
            if (component == 0) {
                self.hourString = self.plistArray[0][row];
            }else{
                self.minuteString = self.plistArray[1][row];
            }
            [pickerView reloadComponent:1];
            return;
        }else{
            if ((component == 0 && row == 0) || (component == 1 && row == 0)) {
                self.plistArray = self.extraDataArray;
            }
            if (component == 1 && row != 0) {
                
                self.plistArray = @[self.originalData[0],self.extraDataArray[1],self.originalData[count - 1]];
            }
            if ((component == 0 && row != 0) || [pickerView selectedRowInComponent:0] != 0) {
                self.plistArray = self.originalData;
            }
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
        }
    }
    
    if (self.isLineRent) {
        self.hourString = self.plistArray[0][0];
        self.minuteString = self.plistArray[1][0];
        if (component == 0) {
            self.hourString = self.plistArray[0][row];
        }else{
            self.minuteString = self.plistArray[1][row];
        }
        return;
    }
    
    if (self.isLevelDic && component % 2 == 0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (self.isLevelString) {
        self.resultString = self.plistArray[row];
        
    }else if (self.isLevelArray){
        self.resultString = @"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i = 0; i < self.plistArray.count; i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                self.resultString = [NSString stringWithFormat:@"%@|%@",self.resultString,self.plistArray[i][cIndex]];
            }else{
                if (i == 0) {
                    NSInteger index = [self.plistArray[i] count] > self.selectDay ? self.selectDay : [self.plistArray[i] count] - 1;
                    self.resultString = [NSString stringWithFormat:@"%@|%@",self.resultString,self.plistArray[i][index]];
                }else if (i == 1){
                     NSInteger index = [self.plistArray[i] count] > self.selectHour ? self.selectHour : [self.plistArray[i] count] - 1;
                    self.resultString = [NSString stringWithFormat:@"%@|%@",self.resultString,self.plistArray[i][index]];
                }else if (i == 2){
                     NSInteger index = [self.plistArray[i] count] > self.selectMin ? self.selectMin : [self.plistArray[i] count] - 1;
                    self.resultString = [NSString stringWithFormat:@"%@|%@",self.resultString,self.plistArray[i][index]];
                }
               
            }
        }
    }else if (self.isLevelDic){
        if (component==0) {
            self.state =self.dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic = self.plistArray[cIndex];
            NSArray *dicValueArray = [dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                self.city = dicValueArray[row];
            }
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    if ([self.delegate respondsToSelector:@selector(pickerViewRowHeight)]) {
        return [self.delegate pickerViewRowHeight];
    }
    
    return 44;
}

#pragma mark -blackView
- (void)p_startAnimate {
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.backView.alpha = 0.4f;
    } completion:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat h = showViewHeight;
    
    if (self.isShowRemind) {
        h = showViewHeight + 30;
    }
    
    self.frame     = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, h);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.frame = CGRectMake(0, DEVICE_HEIGHT - h, DEVICE_WIDTH, h);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)p_configbackView {
    __weak __typeof (self)weakSelf = self;
    self.backView = [[UIView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    
    self.backView.hidden          = NO;
    self.backView.alpha           = 0;
    self.backView.backgroundColor = [UIColor blackColor];
    [self.backView bk_whenTapped:^{
        [weakSelf p_removeView];
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}

- (void)p_removeView {
    self.backView.userInteractionEnabled = NO;
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backView.alpha = 0;
        CGFloat h = showViewHeight;
        
        if (self.isShowRemind) {
            h = showViewHeight + 30;
        }
        weakSelf.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, h);
    } completion:^(BOOL finished) {
        [weakSelf.backView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

#pragma Getter

- (NSArray *)plistArray {
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

- (NSArray*)componentArray {
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}


@end
