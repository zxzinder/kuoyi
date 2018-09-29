//
//  RootTabBarController.m
//  kuoyi
//
//  Created by alexzinder on 2018/1/22.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomeViewController.h"
#import "UIColor+TPColor.h"


@interface RootTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UINavigationController *homeNavigationController;

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.tabBar.translucent = YES;
    self.tabBar.hidden = YES;
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    self.homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    [self addChildViewController:self.homeNavigationController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
