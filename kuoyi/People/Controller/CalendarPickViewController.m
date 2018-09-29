//
//  CalendarPickViewController.m
//  kuoyi
//
//  Created by alexzinder on 2018/6/24.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "CalendarPickViewController.h"

#import "MLCalendarView.h"


@interface CalendarPickViewController ()

@property (nonatomic,strong)MLCalendarView * calendarView;
@end

@implementation CalendarPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.calendarView = [[MLCalendarView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    
    self.calendarView.backgroundColor = [UIColor whiteColor];
    
    self.calendarView.multiSelect = NO;
    
    self.calendarView.maxTotal = 1;
    
    [self.calendarView constructionUI];

    self.calendarView.cancelBlock = ^{
        
        [weakSelf.calendarView removeFromSuperview];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
       // [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.calendarView.selectBlock = ^(NSString *date) {
        
        if (weakSelf.selectCallback) {
            weakSelf.selectCallback(date);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.calendarView.multiSelectBlock = ^(NSString *beginDate, NSString *endDate, NSInteger total) {
        
        
    };
    
    [self.view addSubview:self.calendarView];
}


@end
