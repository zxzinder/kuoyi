//
//  BaseWebView.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/31.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "BaseWebView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import <BlocksKit+UIKit.h>


@interface BaseWebView()

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation BaseWebView
-(instancetype)initWithUrlString:(NSString *)urlString{
    
    self = [super init];
    if (self) {
        self.urlString = urlString;
        [self p_initUI];
    }
    return self;
    
}

-(void)p_initUI{
    
    __weak __typeof (self)weakSelf = self;
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSURL *url= [[NSURL alloc] initWithString:self.urlString];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self loadRequest:request];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"ppclose"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        //make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [self.closeBtn bk_addEventHandler:^(id sender) {
        [weakSelf p_hideView];
    } forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)p_hideView{
    
    self.alpha = 0;
    
}
-(void)configData{
    [self becomeFirstResponder];
    
    UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(flag:)];
    UIMenuController *menu =[UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
    
}
-(void)flag:(id)sender{
    [self copy:nil];
    UIPasteboard *pasteBoard =[UIPasteboard generalPasteboard];
    if (pasteBoard.string !=nil) {
        //DLog(@"%@", pasteBoard.string);
    }
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if(action == @selector(flag:)){
        
        return YES;
        
    }
    
    return NO;
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
