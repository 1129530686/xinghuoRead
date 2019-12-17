//
//  AppDelegate.m
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_ContentBrowseController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_LaunchAdController.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_IAPShare.h"
#import <Bugly/Bugly.h>
#import "UIWindow+JUDIAN_READ_Window.h"
#import <GTSDK/GeTuiSdk.h>
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_LaunchController.h"
#import "GTCountSDK.h"
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // Only if you have Flutter Plugins
#import "JUDIAN_READ_SortNameController.h"
#import "JUDIAN_READ_CoinRecordController.h"
#import "GDTSplashAd.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@interface JUDIAN_READ_AppDelegate ()<WXApiDelegate,GeTuiSdkDelegate, UNUserNotificationCenterDelegate,CustomAlertViewDelegate>


@property (nonatomic,strong) AFNetworkReachabilityManager *reachManager;
@property (nonatomic,strong) JUDIAN_READ_LaunchAdController  *launchVC;
@property (nonatomic, strong) GDTSplashAd *gdtSplashAd;
@end

@implementation JUDIAN_READ_AppDelegate

//网络判断
- (AFNetworkReachabilityManager *)reachManager{
    if (!_reachManager) {
        _reachManager = [AFNetworkReachabilityManager sharedManager];
        [_reachManager startMonitoring];
    }
    return _reachManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.applicationIconBadgeNumber = 0;
    
    //注册广告
    [BUAdSDKManager setAppID:CHUAN_SHAN_JIA_AD_APP_ID];
    [BUAdSDKManager setIsPaidApp:NO];

    //崩溃日志收集
    [Bugly startWithAppId:APP_BUGLY_ID];
    //网络监听
    [self checkNet];
    //向微信注册
    [self configUSharePlatforms];
    //注册推送
    [self registRemotion];
    //初始化控制器
    [self initVC];
    //同步充值记录
    [[JUDIAN_READ_IAPShare sharedHelper] sychronizeChargeHistory];
    
    [JUDIAN_READ_TestHelper updateFictionCache];
    
    //记录启动时间
    [self recordLaunchTime];
    
    //注册flutter
    [self registFluter];
    
    self.needShow = YES;
    return YES;
}

- (void)registFluter{
//    NSString *str = @"/firstpage";
//    self.flutterEngine = [[FlutterEngine alloc] initWithName:str project:nil];
//    [self.flutterEngine runWithEntrypoint:nil];
//    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
//    
}




- (void)initVC{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *NotFirstLoad = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotFirstLoad"];
    if (NotFirstLoad) {
        [self launchSplashAd];
    }else {
        [NSUserDefaults saveUserDefaults:@"NotFirstLoad" value:@"isYES"];
        JUDIAN_READ_LaunchController *vc = [[JUDIAN_READ_LaunchController alloc]init];
        [self.window setRootViewController:vc];
    }
}


- (void)launchSplashAd {
    
#if _APP_SPLASH_AD_TYPE_ == 2
    JUDIAN_READ_LaunchAdController *vc = [[JUDIAN_READ_LaunchAdController alloc]init];
    self.launchVC = vc;
    self.window.rootViewController = vc;
#else
    JUDIAN_READ_LaunchAdController *vc = [[JUDIAN_READ_LaunchAdController alloc]init];
    self.launchVC = vc;
    JUDIAN_READ_MainViewController *tabVC = [[JUDIAN_READ_MainViewController alloc]init];
    [self.window setRootViewController:tabVC];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
        imgV.backgroundColor = kColorWhite;
        imgV.image = [UIImage imageNamed:@"start_page_icon"];
        imgV.contentMode = UIViewContentModeCenter;
        
        self.gdtSplashAd = [[GDTSplashAd alloc] initWithAppId:GDT_AD_APP_ID
                                                  placementId:GDT_SPLASH_AD_ID];
        
        NSInteger screenHeight = SCREEN_HEIGHT;
        UIImage *splashImage = [UIImage imageNamed:@"app_splash_normal"];
        if (isIPhoneXSeries()) {
            splashImage = [UIImage imageNamed:@"app_splash_x"];
        } else if (screenHeight <= 568) {
            splashImage = [UIImage imageNamed:@"app_splash_small"];
        }
        else if (iPhone6Plus) {
            splashImage = [UIImage imageNamed:@"app_splash_plus"];
        }
        
        
        self.gdtSplashAd.backgroundImage = splashImage;
        
        self.gdtSplashAd.delegate = self.launchVC;
        self.gdtSplashAd.fetchDelay = 10;
        [self.gdtSplashAd loadAdAndShowInWindow:self.window withBottomView:imgV skipView:nil];
    }
    


#endif
    
    
}


- (void)registRemotion{
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GTCountSDK startSDKWithAppId:GT_APP_ID withChannelId:@"appstore"];
    [GeTuiSdk startSdkWithAppId:GT_APP_ID appKey:GT_APP_KEY appSecret:GT_APP_SECRET delegate:self];
    NSLog(@"%@",[GeTuiSdk clientId]);
    // 注册 APNs
    [self registerRemoteNotification];
}

- (void)configUSharePlatforms
{
    [MobClick setCrashReportEnabled:YES];
    
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:APP_UM_ID channel:@"App Store"];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:APP_WEIXIN_ID appSecret:APP_WEIXIN_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:APP_QQ_ID  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:APP_SINA_ID  appSecret:APP_SINA_SECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    NSString * deviceID =[UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@", deviceID);

    
}

- (void)checkNet{
    WeakSelf(weakSelf);
    //    weakSelf.isHaveNet = YES;
    [self.reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            weakSelf.isHaveNet = NO;
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:APP_NO_NETWORK_TIP toView:kKeyWindow];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BadNet" object:@{
                                                                                                      @"cmd":@"netError"
                                                                                                      }];
            
        }else{
            weakSelf.isHaveNet = YES;
        }
    }];
}

- (void)recordLaunchTime{
    if (![NSUserDefaults getUserDefaults:@"time1"] && ![NSUserDefaults getUserDefaults:@"time2"]) {
        NSString *str = [JUDIAN_READ_TestHelper changeDateToString:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss"];
        [NSUserDefaults saveUserDefaults:@"time1" value:str];
    }else if([NSUserDefaults getUserDefaults:@"time1"] && ![NSUserDefaults getUserDefaults:@"time2"]){
        NSString *str = [JUDIAN_READ_TestHelper changeDateToString:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss"];
        [NSUserDefaults saveUserDefaults:@"time2" value:str];
    }else{
        NSString *str = [NSUserDefaults getUserDefaults:@"time2"];
        [NSUserDefaults saveUserDefaults:@"time1" value:str];
        NSString *str1 = [JUDIAN_READ_TestHelper changeDateToString:[NSDate date] formatter:@"yyyy-MM-dd HH:mm:ss"];
        [NSUserDefaults saveUserDefaults:@"time2" value:str1];
    }
    
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    //UIViewController * controller = [self.window visibleViewController];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIViewController * controller = [self.window visibleViewController];
    NSString* className = [controller className];
    
    if([className isEqualToString:@"JUDIAN_READ_ContentBrowseController"]) {
        JUDIAN_READ_ContentBrowseController* viewController = (JUDIAN_READ_ContentBrowseController*)controller;
        [viewController saveCurrentModel];
        
        [[JUDIAN_READ_TextStyleManager shareInstance] archiveTextStyle];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    UIViewController * controller = [self.window visibleViewController];
    NSString* className = [controller className];
    
    if([className isEqualToString:@"JUDIAN_READ_UserEarningsViewController"]) {
        JUDIAN_READ_UserEarningsViewController* earningViewController = (JUDIAN_READ_UserEarningsViewController*)controller;
        [earningViewController showNotificationSettingView];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0){
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [3]:向个推服务器注册deviceToken 为了方便开发者，建议使用新方法
    [GeTuiSdk registerDeviceTokenData:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber+1];
//    application.applicationIconBadgeNumber += 1;
    // 将收到的APNs信息传给个推统计
    [self receiveRemotion:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    //NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *dic = response.notification.request.content.userInfo;
    [self receiveRemotion:dic];
    completionHandler();
}

#endif

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    if (offLine) {
//        [self receiveRemotion:payloadData];
    }
}

- (void)receiveRemotion:(NSDictionary *)dic{
    [GTCountSDK trackCountEvent:@"click_push_message" withArgs:@{@"操作系统":@"iOS"}];
    [MobClick event:@"click_push_message" attributes:@{@"system":@"iOS"}];

    [self remote:dic];//在线
    if (self.launchVC) {
        WeakSelf(obj);
        self.launchVC.launchBlock = ^{
            [obj remote:dic];//离线
        };
    }
}

- (void)remote:(NSDictionary *)dic{
    if(dic[@"payload"]){
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        [GeTuiSdk handleRemoteNotification:dic];
        NSData *jsonData = [dic[@"payload"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if ([self.window.rootViewController isKindOfClass:[JUDIAN_READ_MainViewController class]]){
            NSString *page_id = dic1[@"page_id"];
            JUDIAN_READ_MainViewController *vc = (JUDIAN_READ_MainViewController *)self.window.rootViewController;
            UINavigationController *navc = (UINavigationController *)vc.selectedViewController;
            if(page_id.intValue == 1001){
                NSString *nid = dic1[@"book_id"];
                if(nid){
                    [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source":@"推送消息"}];
                    [MobClick event:@"pv_app_introduce_page" attributes:@{@"source":@"推送消息"}];

                    [GTCountSDK trackCountEvent:@"click_push_getui" withArgs:@{@"system":@"iOS",@"bookId":nid}];
                    [MobClick event:@"click_push_getui" attributes:@{@"system":@"iOS",@"bookId":nid}];
                    [JUDIAN_READ_NovelDescriptionViewController enterDescription:navc bookId:nid bookName:@"" viewName:@"推送消息"];
                    [GTCountSDK trackCountEvent:@"click_push_message" withArgs:@{@"jump_pages":@"小说详情页"}];
                    [MobClick event:@"click_push_message" attributes:@{@"jump_pages":@"小说详情页"}];
                }
            }else if (page_id.intValue == 1002){
                NSString *title = dic1[@"web_url_title"] ? dic1[@"web_url_title"] : @"";
                NSString *url = dic1[@"web_url"] ? dic1[@"web_url"] : @"";
                JUDIAN_READ_BannarWebController *webVC = [JUDIAN_READ_BannarWebController new];
                webVC.title = title;
                webVC.url = url;
                [navc pushViewController:webVC animated:YES];
            }else if (page_id.intValue == 1003){
                NSString *page_detail = dic1[@"page_detail"];
                [self enterController:page_detail.intValue];
            }
        }
    }
}

- (void)enterController:(int)detail{
    NSString *str = @"书城";
    JUDIAN_READ_MainViewController *vc = (JUDIAN_READ_MainViewController *)self.window.rootViewController;
    UINavigationController *navc = (UINavigationController *)vc.selectedViewController;
    if (detail == 1) {
        vc.selectedIndex = 0;
        str = @"发现";
    }else if (detail == 2){
        vc.selectedIndex = 1;
        str = @"书架";
    }else if (detail == 3){
        vc.selectedIndex = 2;
        str = @"书城";
    }
    else if (detail == 4){
        str = @"福利商城页";
        JUDIAN_READ_BannarWebController *webVc = [JUDIAN_READ_BannarWebController shareInstance];
        webVc.title = @"福利商城";
        webVc.url = @"goldmall";
        [navc pushViewController:webVc animated:YES];
        
    }
    else if (detail == 5){
        str = @"元宝任务页";
        [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:navc];;
    }
    [GTCountSDK trackCountEvent:@"click_push_message" withArgs:@{@"jump_pages":str}];
    [MobClick event:@"click_push_message" attributes:@{@"jump_pages":str}];
}


/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


#pragma  alerv代理
- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (index == 1) {
        NSString * url = APPSTORE_URL;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isFirstLoad"];
    }
}




@end
