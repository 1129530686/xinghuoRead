//
//  MainTabBarViewController.m
//  health
//
//  Created by hu on 2017-06-02.
//  Copyright © 2017 hu. All rights reserved.
//

#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_BaseNavgationController.h"
#import "JUDIAN_READ_BookStoreController.h"
#import "JUDIAN_READ_BookShelfController.h"
#import "JUDIAN_READ_DiscoveryController.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_NovelSummaryModel.h"

@interface JUDIAN_READ_MainViewController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) JUDIAN_READ_DiscoveryController  *discoveryViewController;
@property (nonatomic,strong) JUDIAN_READ_BookStoreController  *bookStoreViewController;


@end

@implementation JUDIAN_READ_MainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildViewController];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)buildViewController {
    
    [self configureVC:@"JUDIAN_READ_DiscoveryController" imageName:@"tab_icon_found_eyes_default" selectImageName:@"tab_icon_found_eyes_selected" title:@"发现"];
    [self configureVC:@"JUDIAN_READ_BookShelfController" imageName:@"tab_icon_bookcase_default" selectImageName:@"tab_icon_bookcase_selected" title:@"书架"];
    [self configureVC:@"JUDIAN_READ_BookStoreController" imageName:@"tab_icon_Book city_default" selectImageName:@"tab_icon_Book city_selected" title:@"书城"];
    [self configureVC:@"JUDIAN_READ_BookShelfController" imageName:@"tab_icon_bookcase_default" selectImageName:@"tab_icon_bookcase_selected" title:@"我的"];
    self.delegate = self;
    [self setCustomStyle];
    
}



- (void)configureVC:(NSString *)vcString imageName:(NSString *)imageN selectImageName:(NSString *)selectedImageN title:(NSString *)title{
    UIViewController *vc = [[NSClassFromString(vcString) alloc]init];
    if ([vc isKindOfClass:[JUDIAN_READ_DiscoveryController class]]) {
        self.discoveryViewController = (JUDIAN_READ_DiscoveryController *)vc;
    }
    else if ([vc isKindOfClass:[JUDIAN_READ_BookStoreController class]]) {
        self.bookStoreViewController = (JUDIAN_READ_BookStoreController *)vc;
    }
    
    JUDIAN_READ_BaseNavgationController *navVC = [[JUDIAN_READ_BaseNavgationController alloc]initWithRootViewController:vc];
    vc.tabBarItem.image = [[UIImage imageNamed:imageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.title = title;
    [self addChildViewController:navVC];
}

#pragma mark 自定义样式
- (void)setCustomStyle {
    
    [[UITabBar appearance] setTranslucent:NO];
    //底色
    [[UINavigationBar appearance] setBarTintColor:kColorWhite];
    [[UINavigationBar appearance] setTranslucent:NO];
    //左右button颜色
    [[UINavigationBar appearance] setTintColor:kColor51];
    //NavBar title颜色
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:kColor51,NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    //TabBar样式
    [[UITabBar appearance] setBarTintColor:kColorWhite];
    [[UITabBar appearance] setTintColor:kThemeColor];
    
    //TaBBarItem文字
    [[UITabBarItem appearance]  setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor100} forState:UIControlStateNormal];
    [[UITabBarItem appearance]  setTitleTextAttributes:@{NSForegroundColorAttributeName:kThemeColor} forState:UIControlStateSelected];
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -4);
    
    //搜索栏样式
    [[UISearchBar appearance] setBarTintColor:kColorWhite];
    
    //设置分割线颜色
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, SCREEN_WIDTH, 0.5)];
    view.backgroundColor = KSepColor;
    [[UITabBar appearance] insertSubview:view atIndex:0];
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *navc = (UINavigationController *)viewController;
    
    if ([navc.topViewController isKindOfClass:[JUDIAN_READ_DiscoveryController class]]) {//self.selectedIndex == 0 &&
        self.discoveryViewController.pageSize = 1;
        [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":@"信息流"}];
        [MobClick event:@"click_refresh" attributes:@{@"page":@"信息流"}];
        
        [self.discoveryViewController loadData:NO];
    }
    else if ([navc.topViewController isKindOfClass:[JUDIAN_READ_BookStoreController class]]) {//self.selectedIndex == 2 &&
        [self.bookStoreViewController getSelectPage:NO isReset:YES];
        UIScrollView *scr = self.bookStoreViewController.scrView.subviews[self.bookStoreViewController.selectItem];
        [scr.mj_header beginRefreshing];
        [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"书城"}];
        [MobClick event:@"click_infor_flow" attributes:@{@"pageFlow":@"书城"}];
    }
    else {
        [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"书架"}];
        [MobClick event:@"click_infor_flow" attributes:@{@"pageFlow":@"书架"}];
    }
    
#if 0
    if (![navc.topViewController isKindOfClass:[JUDIAN_READ_DiscoveryController class]]) {//self.selectedIndex == 0 &&
        if ([navc.topViewController isKindOfClass:[JUDIAN_READ_BookStoreController class]]) {
            [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"书城"}];
            [MobClick event:@"click_infor_flow" attributes:@{@"pageFlow":@"书城"}];
            
        }else{
            [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"书架"}];
            [MobClick event:@"click_infor_flow" attributes:@{@"pageFlow":@"书架"}];
            
        }
    }
#endif
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[JUDIAN_READ_DiscoveryController class]]) {
        [MobClick event:click_bottom_menu attributes:@{@"type":@"发现"}];
        [GTCountSDK trackCountEvent:click_bottom_menu withArgs:@{@"type":@"发现"}];
    }else if ([viewController isKindOfClass:[JUDIAN_READ_BookShelfController class]]){
        [MobClick event:click_bottom_menu attributes:@{@"type":@"书架"}];
        [GTCountSDK trackCountEvent:click_bottom_menu withArgs:@{@"type":@"书架"}];
    }else{
        [MobClick event:click_bottom_menu attributes:@{@"type":@"书城"}];
        [GTCountSDK trackCountEvent:click_bottom_menu withArgs:@{@"type":@"书城"}];
        
    }
    
}

- (void)checkNet{
    self.selectedIndex = 0;
}


- (void)enterFictionBrowseViewController {

    WeakSelf(that);
    [JUDIAN_READ_NovelSummaryModel buildExpecialBookModel:^(JUDIAN_READ_NovelSummaryModel* model) {
       
        if (!model) {
            return;
        }
        
        if (model.nid.length <= 0 || model.bookname.length <= 0) {
            return;
        }
        
        NSDictionary* dictionary = @{
                                     @"bookId": model.nid,
                                     @"bookName": model.bookname,
                                     @"chapterCount": @"",
                                     @"position" : @""
                                     };
        
        NSString* name = @"单本拉起阅读器";
        [MobClick event:@"pv_app_reading_page" attributes:@{@"accessSource": name}];
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"accessSource":name}];
        
        [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:that.discoveryViewController.navigationController book:dictionary viewName:name];
        
    }];
    
}

@end

