//
//  BaseTableViewCell.m
//
//  Created by hu on 16/6/1.
//  Copyright © 2016年. All rights reserved.
//

#import "JUDIAN_READ_BaseViewController.h"
#import "JUDIAN_READ_BookStoreController.h"
#import "JUDIAN_READ_BookShelfController.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_BookShelfController.h"
#import "JUDIAN_READ_DiscoveryController.h"
#import "JUDIAN_READ_MyController.h"

#import "JUDIAN_READ_BannarWebController.h"

#import "JUDIAN_READ_ContentBrowseController.h"


@interface JUDIAN_READ_BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JUDIAN_READ_BaseViewController

- (instancetype)init{
    if (self = [super init]) {
        self.pageSize = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.hideBar animated:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MBProgressHUD hideHUDForView:kKeyWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCanNotBack = NO;
    self.view.backgroundColor = kColorWhite;
    if (self.navigationController) {
        self.navigationController.navigationBar.translucent = NO;
    }
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    pan.delegate = self;
    [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    [self.navigationController.view addGestureRecognizer:pan];
    self.pan = pan;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 滑动开始触发事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count >= 2) {
        UIViewController *VC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
        UIViewController *VC1 = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
        BOOL a = [VC isKindOfClass:[JUDIAN_READ_NovelDescriptionViewController class]]&& [VC1 isKindOfClass:[JUDIAN_READ_ContentBrowseController class]];
        BOOL b = [VC isKindOfClass:[JUDIAN_READ_BookShelfController class]]&& [VC1 isKindOfClass:[JUDIAN_READ_ContentBrowseController class]];
        BOOL c = [VC isKindOfClass:[JUDIAN_READ_DiscoveryController class]]&& [VC1 isKindOfClass:[JUDIAN_READ_ContentBrowseController class]];
        BOOL d = [VC1 isKindOfClass:[JUDIAN_READ_MyController class]];
        BOOL e = [VC1 isKindOfClass:[JUDIAN_READ_BannarWebController class]];
        if (a || b || c || d || e) {
            return NO;
        }
    }
    
    CGPoint point = [self.pan translationInView:self.view];
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }else if (point.x <= 0) {
        //当滑动是向右滑的时候，不可滑动
        return NO;
    }
    return YES;
}




@end
