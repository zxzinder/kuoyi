//
//  TimePickView.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/24.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "TimePickView.h"
#import "MLCalendarView.h"
#import "UtilsMacro.h"

@interface TimePickView()

@property (nonatomic,strong)MLCalendarView * calendarView;

@end

@implementation TimePickView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self p_initUI];
    }
    
    return self;
    
}

-(void)p_initUI{
    
    self.calendarView = [[MLCalendarView alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, self.bounds.size.height - 300)];
    
    self.calendarView.backgroundColor = [UIColor whiteColor];
    
    self.calendarView.multiSelect = NO;
    
    self.calendarView.maxTotal = 1;
    
    [self.calendarView constructionUI];
    
    __weak typeof(self) weakSelf = self;
    
    self.calendarView.cancelBlock = ^{
        [weakSelf p_hide];
       // [weakSelf.calendarView removeFromSuperview];
    };
    
    self.calendarView.selectBlock = ^(NSString *date) {
        
        
    };
    self.calendarView.multiSelectBlock = ^(NSString *beginDate, NSString *endDate, NSInteger total) {
        
        
    };
    
    [self addSubview:self.calendarView];
    
}

-(void)p_show{
    [WindowView addSubview:self];
    [WindowView bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    }];
    
}

-(void)p_hide{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
