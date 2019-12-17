//
//  YYNavgationController.m
//  health
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 hu. All rights reserved.
//

#import "JUDIAN_READ_BaseNavgationController.h"

@interface JUDIAN_READ_BaseNavgationController ()

@property (nonatomic,strong) UIView  *NAVfootView;


@end

@implementation JUDIAN_READ_BaseNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSepColor];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if (self.viewControllers.count >= 1 ) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_return_black"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)setSepColor{
    for (UIView *view in self.navigationBar.subviews) {
        //去除系统导航栏分割线
        if (CGRectGetHeight([view frame]) <= 1) {
            view.hidden = YES;
        }
    }
    self.NAVfootView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    //添加自定义分割线
    self.NAVfootView.backgroundColor = KSepColor;
    [self.navigationBar addSubview:self.NAVfootView];
    [self.navigationBar bringSubviewToFront:self.NAVfootView];
    
}

@end

