//
//  HotPeopleTableViewCell.m
//  kuoyi
//
//  Created by alexzinder on 2019/4/3.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import "HotPeopleTableViewCell.h"
#import <Masonry.h>
#import "UtilsMacro.h"
#import "UIColor+TPColor.h"
#import <BlocksKit+UIKit.h>
#import "UIWebView+CancelIndicator.h"

@interface HotPeopleTableViewCell()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *hotPeopleWebView;

@end

@implementation HotPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        [self p_initUI];
    }
    
    return self;
}

-(void)p_initUI{
//    self.contentView.backgroundColor = [UIColor randomRGBColor];
    __weak __typeof (self)weakSelf = self;
    self.hotPeopleWebView = [[UIWebView alloc] init];
    self.hotPeopleWebView.delegate = self;
    self.hotPeopleWebView.scalesPageToFit = YES;
    self.hotPeopleWebView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.hotPeopleWebView];
    [self.hotPeopleWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = [UIColor clearColor];
    [clickBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.webClickCallback) {
            weakSelf.webClickCallback();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
//    UIView *segView = [[UIView alloc] init];
//    segView.backgroundColor = [UIColor colorWithHexString:@"e0e8eb"];
//    [self.contentView addSubview:segView];
//    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(10);
//        make.right.equalTo(self.contentView.mas_right).offset(-10);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.size.height.mas_equalTo(10);
//    }];
//
    
}
-(void)configeCellData:(NSString *)urlString{
    
    NSURL *webUrl= [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:webUrl];
    [self.hotPeopleWebView loadRequest:request];
    [UIWebView cancelScrollIndicator:self.hotPeopleWebView];

    
}
@end
