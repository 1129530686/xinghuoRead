//
//  JUDIAN_READ_LaunchAdController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/10.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_LaunchAdController.h"
#import <BUAdSDK/BUSplashAdView.h>
#import "JUDIAN_READ_MainViewController.h"


@interface JUDIAN_READ_LaunchAdController ()<BUSplashAdDelegate>

@property (nonatomic, strong) BUSplashAdView *splashView;
@property (nonatomic, strong) GDTSplashAd *gdtSplashAd;
@end

@implementation JUDIAN_READ_LaunchAdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if _APP_SPLASH_AD_TYPE_ == 2
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:CHUAN_SHAN_JIA_OPEN_SCREEN_AD_ID frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    splashView.delegate = self;
    splashView.rootViewController = self;
    [splashView loadAdData];//请求
    [MobClick event:@"ad_request" attributes:@{source_record:ad_launch_screen}];
    self.splashView = splashView;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    imgV.backgroundColor = kColorWhite;
    imgV.image = [UIImage imageNamed:@"start_page_icon"];
    imgV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imgV];
    [self.view addSubview:splashView];
#else

#endif
}

//
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    
    JUDIAN_READ_MainViewController *tabVC = [[JUDIAN_READ_MainViewController alloc]init];
    [kKeyWindow setRootViewController:tabVC];
    if (self.launchBlock) {
        self.launchBlock();
    }
}

//请求失败
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    JUDIAN_READ_MainViewController *tabVC = [[JUDIAN_READ_MainViewController alloc]init];
    [kKeyWindow setRootViewController:tabVC];
    if (self.launchBlock) {
        self.launchBlock();
    }
}

//请求成功
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd{
    [MobClick event:ad_success_request attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_success_request withArgs:@{source_record:ad_launch_screen}];
    
}

//点击
- (void)splashAdDidClick:(BUSplashAdView *)splashAd{
    [MobClick event:ad_click attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_click withArgs:@{source_record:ad_launch_screen}];
    
}

//展示
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd{
    [MobClick event:ad_success_show attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_success_show withArgs:@{source_record:ad_launch_screen}];
    
}

- (void)splashAdWillClose:(BUSplashAdView *)splashAd{
    //    [MobClick event:ad_skip_start_up attributes:@{ad_skip_start_up:@"跳过开屏广告"}];
}


#pragma mark 广点通回调
#pragma mark - GDTSplashAdDelegate
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
    [MobClick event:ad_success_request attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_success_request withArgs:@{source_record:ad_launch_screen}];
    
    if (self.launchBlock) {
        self.launchBlock();
    }
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    //NSLog(@"%s%@",__FUNCTION__,error);
    
    if (self.launchBlock) {
        self.launchBlock();
    }
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
    [MobClick event:ad_success_show attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_success_show withArgs:@{source_record:ad_launch_screen}];
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
    [MobClick event:ad_click attributes:@{@"source":ad_launch_screen}];
    [GTCountSDK trackCountEvent:ad_click withArgs:@{source_record:ad_launch_screen}];
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
    self.gdtSplashAd = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    //NSLog(@"%s",__FUNCTION__);
}

@end
