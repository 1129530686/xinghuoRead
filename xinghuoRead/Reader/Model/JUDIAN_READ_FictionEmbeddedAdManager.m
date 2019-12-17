//
//  JUDIAN_READ_ FictionEmbeddedAdManager.m
//  xinghuoRead
//
//  Created by judian on 2019/9/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionEmbeddedAdManager.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_BuCellAdView.h"

#import "JUDIAN_READ_BuImageAdView.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_VipCustomPromptView.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"
#import "GDTRewardVideoAd.h"
#import "JUDIAN_READ_CoreTextManager.h"


#define READ_CHAPTER_UPPER_LIMIT 10
#define MAX_AD_COUNT 2000

@interface JUDIAN_READ_FictionEmbeddedAdManager ()<
BUVideoAdViewDelegate,
BUNativeAdDelegate,
BURewardedVideoAdDelegate,

BUNativeAdsManagerDelegate,
BUNativeAdDelegate,

GDTUnifiedNativeAdDelegate,
GDTUnifiedNativeAdViewDelegate,
GDTRewardedVideoAdDelegate>

@property (nonatomic, strong)BURewardedVideoAd* rewardedVideoAd;
@property (nonatomic, strong) GDTRewardVideoAd *gdtRewardVideoAd;

@property (nonatomic, weak) JUDIAN_READ_BottomCellAdView* bottomAdView;
@property (nonatomic, strong) JUDIAN_READ_BuImageAdView* middleAdView;

@property(nonatomic, strong)GDTUnifiedNativeAd* bottomGdtNativeAd;
@property(nonatomic, strong)GDTUnifiedNativeAd* middleGdtNativeAd;
@property(nonatomic, strong)GDTUnifiedNativeAdDataObject* middleGdtAdDataObject;


@property(nonatomic, assign)BOOL hasAds;
@property(nonatomic, assign)NSInteger adType;

@property(nonatomic, strong)dispatch_source_t adTimer;
@property (nonatomic, weak)UIView* emptyView;

@property(nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@property(nonatomic, strong)BUNativeAdsManager * csjAdManager;
@property(nonatomic, strong)BUNativeAd *csjNativemodel;
@property(nonatomic, assign)NSInteger adCount;

@end


@implementation JUDIAN_READ_FictionEmbeddedAdManager

+ (instancetype)createEmbeddedAdManager:(NSInteger)type {
    JUDIAN_READ_FictionEmbeddedAdManager* manager = [[JUDIAN_READ_FictionEmbeddedAdManager alloc] init];
    manager.adType = type;
    manager.adCount = 0;
    if (type == FICTION_EMBEDDED_AD) {
        manager.userChapterCountDictionary = [NSMutableDictionary dictionary];
    }
    return manager;
}

- (void)addBottomAdView:(UIViewController*)controller {
    
    if (_bottomAdView) {
        return;
    }
    _viewController = controller;
    JUDIAN_READ_BottomCellAdView* adView = [[JUDIAN_READ_BottomCellAdView alloc] init];
    
    _bottomAdView = adView;
    [_viewController.view addSubview:adView];
    
    NSInteger adHeight = 63;
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    [adView setViewStyle];
    [adView addGdtView];
    adView.unifiedNativeAdView.delegate = self;
    adView.unifiedNativeAdView.viewController = _viewController;
    
    WeakSelf(that);
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.viewController.view.mas_left);
        make.right.equalTo(that.viewController.view.mas_right);
        make.height.equalTo(@(adHeight));
        make.bottom.equalTo(that.viewController.view.mas_bottom).offset(-bottomOffset);
    }];
    
    if (bottomOffset > 0) {
        UIView* emptyView = [[UIView alloc] init];
        _emptyView = emptyView;
        [controller.view addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(that.viewController.view.mas_left);
            make.right.equalTo(that.viewController.view.mas_right);
            make.height.equalTo(@(bottomOffset));
            make.bottom.equalTo(that.viewController.view.mas_bottom);
        }];
    }
    
    [self setViewStyle];
    
#if 0
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [adView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adView.mas_left);
        make.right.equalTo(adView.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(adView.mas_top);
    }];
#endif
}


- (void)setViewStyle {
    [_bottomAdView setBottomViewStyle];
    [_middleAdView setViewStyle];
    _emptyView.backgroundColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
}


- (void)addMiddleAdView:(UIViewController*)controller container:(UIView*)container frame:(CGRect)frame {

    _viewController = controller;
    
    if (frame.size.width > 0) {
        
        _middleAdView = [[JUDIAN_READ_BuImageAdView alloc] init];
        
        CGRect contentViewFrame = [[JUDIAN_READ_CoreTextManager shareInstance] getContentViewFrame];
        _middleAdView.frame = CGRectMake(0, contentViewFrame.size.height - frame.origin.y - frame.size.height, contentViewFrame.size.width, frame.size.height);
        [container addSubview:_middleAdView];
        
        [_middleAdView addGdtView];
        _middleAdView.unifiedNativeAdView.delegate = self;
        _middleAdView.unifiedNativeAdView.viewController = _viewController;
        
        [_middleAdView addFailureView];
        
        [self setViewStyle];
        
        if (_adCount > MAX_AD_COUNT) {
            _adCount = 0;
        }
        
        if (_adCount % 2 == 0) {
            [_middleGdtNativeAd loadAdWithAdCount:1];
        }
        else {
            [self loadCsjAdData];
        }
        
        _adCount++;
    }
    
}

- (void)updateViewStyle {
    [_bottomAdView setBottomViewStyle];
}


#pragma mark 穿山甲图文广告

- (void)loadCsjAdData {
    
    BUNativeAdsManager *adManager = [[BUNativeAdsManager alloc]init];
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = CHUAN_SHAN_JIA_FEED_ID;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionTop;
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot.isSupportDeepLink = YES;
    adManager.adslot = slot;
    adManager.delegate = self;
    self.csjAdManager = adManager;
    
    [adManager loadAdDataWithCount:1];
    
}


- (void)buildEmbeddedCsjAdView:(BUNativeAd*)nativeAd {
    if (!nativeAd) {
        return;
    }
    
    if (!_middleAdView) {
        return;
    }
    
    [_middleAdView removeFailureView];
    [_middleAdView removeGdtView];
    
    [nativeAd unregisterView];
    nativeAd.rootViewController = _viewController;
    nativeAd.delegate = self;
    
    [_middleAdView buildView:nativeAd];
    
    [nativeAd registerContainer:_middleAdView withClickableViews:@[_middleAdView]];
}



- (void)buildBottomCsjAdView:(BUNativeAd*)nativeAd {
    if (!nativeAd) {
        return;
    }
    
    if (!_bottomAdView) {
        return;
    }
    
    [_bottomAdView removeGdtView];
    
    [nativeAd unregisterView];
    nativeAd.rootViewController = _viewController;
    nativeAd.delegate = self;
    
    [_bottomAdView buildView:nativeAd];
    
    [nativeAd registerContainer:_bottomAdView withClickableViews:@[_bottomAdView]];
}

- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        that.csjNativemodel = obj;

        if (that.adType == FICTION_EMBEDDED_AD) {
            [that buildEmbeddedCsjAdView:obj];
        }
        else {
            [that buildBottomCsjAdView:obj];
        }
    }];
}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    //[_middleAdView addFailureView];
    if (_adType == FICTION_EMBEDDED_AD) {
        [_middleGdtNativeAd loadAdWithAdCount:1];
    }
    else {
        [_bottomGdtNativeAd loadAdWithAdCount:1];
    }
    
}


#pragma mark 广点通图文广告

- (void)initGDTBottomAdData {
    self.bottomGdtNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_BOOK_INTRODUCTION_AD_ID];
    self.bottomGdtNativeAd.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.bottomGdtNativeAd.delegate = self;
    [self.bottomGdtNativeAd loadAdWithAdCount:1];
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"阅读器底部广告"];
    
    [self autoRefreshAd];
}


- (void)refreshBottomAd:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects{

    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"阅读器底部广告"];
    
    GDTUnifiedNativeAdDataObject* gdtAdDataObject = unifiedNativeAdDataObjects[0];
    [_bottomAdView buildGdtView:gdtAdDataObject];
    
    _bottomAdView.unifiedNativeAdView.delegate = self;
    _bottomAdView.unifiedNativeAdView.viewController = _viewController;
    _bottomAdView.unifiedNativeAdView.logoView.hidden = YES;
    [_bottomAdView.unifiedNativeAdView registerDataObject:gdtAdDataObject clickableViews:@[_bottomAdView.unifiedNativeAdView]];

}



- (void)initGDTMiddleAdData:(UIViewController*)controller {
    self.viewController = controller;
    self.middleGdtNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_FICTION_AD_ID_1];
    self.middleGdtNativeAd.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.middleGdtNativeAd.delegate = self;
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"阅读器中间广告"];
}


- (void)refreshMiddleAd:(GDTUnifiedNativeAdDataObject*) gdtAdDataObject{
    
    if (!_middleAdView) {
        return;
    }
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"阅读器中间广告"];
    
    [_middleAdView buildGdtView:gdtAdDataObject];
    
    [_middleAdView removeFailureView];
    
    _middleAdView.unifiedNativeAdView.delegate = self;
    _middleAdView.unifiedNativeAdView.viewController = _viewController;
    _middleAdView.unifiedNativeAdView.logoView.hidden = YES;
    _middleAdView.unifiedNativeAdView.hidden = NO;
    [_middleAdView.unifiedNativeAdView registerDataObject:gdtAdDataObject clickableViews:@[_middleAdView.unifiedNativeAdView]];
    
}




- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    if (unifiedNativeAdDataObjects) {
        _hasAds = TRUE;
        
        if (_adType == FICTION_BOTTOM_AD) {
            [self refreshBottomAd:unifiedNativeAdDataObjects];
        }
        else if (_adType == FICTION_EMBEDDED_AD) {
            _middleGdtAdDataObject = unifiedNativeAdDataObjects[0];
            [self refreshMiddleAd:unifiedNativeAdDataObjects[0]];
        }
        
    }
    else if(error) {
        _hasAds = FALSE;
#if 0
        if (_middleGdtAdDataObject) {
            [self refreshMiddleAd:_middleGdtAdDataObject];
        }
        else {
            [_middleAdView addFailureView];
        }
#else
        [self loadCsjAdData];
#endif
        
    }
}



- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"阅读器底部广告"];
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"阅读器底部广告"];
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    
}


- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


#pragma mark 定时器
- (void)autoRefreshAd {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _adTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_adTimer, DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    WeakSelf(that);
    dispatch_source_set_event_handler(_adTimer, ^{
        __strong typeof(that) strongSelf = that;
        
        if (strongSelf.adCount > MAX_AD_COUNT) {
            strongSelf.adCount = 0;
        }
        
        if (strongSelf.adCount % 2 == 0) {
            [strongSelf.bottomGdtNativeAd loadAdWithAdCount:1];
        }
        else {
            [strongSelf loadCsjAdData];
        }
        
        strongSelf.adCount++;
        
    });
    dispatch_resume(_adTimer);
    
}

#pragma mark 广点通激励视频
- (void)createGdtVideoAd {
    self.gdtRewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_REWARD_VIDEO_AD_ID];
    self.gdtRewardVideoAd.delegate = self;
    [self.gdtRewardVideoAd loadAd];

}

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName];
   // NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    NSString* dateString = [JUDIAN_READ_TestHelper getTodayString];
    NSString* countString = [NSUserDefaults getUserDefaults:dateString];
    
    if (countString.length > 0) {
        NSInteger count = (countString.integerValue + 1);
        NSString* newCountStr = [NSString stringWithFormat:@"%ld", count];
        [NSUserDefaults saveUserDefaults:dateString value:newCountStr];
    }
    else {
        [NSUserDefaults saveUserDefaults:dateString value:@"1"];
    }
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //self.statusLabel.text = [NSString stringWithFormat:@"%@ 视频文件加载成功", rewardedVideoAd.adNetworkName];
    
    [self.gdtRewardVideoAd showAdFromRootViewController:_viewController];
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //NSLog(@"视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已曝光", rewardedVideoAd.adNetworkName];
    //NSLog(@"广告已曝光");
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
   // self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已关闭", rewardedVideoAd.adNetworkName];
   // NSLog(@"广告已关闭");
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已点击", rewardedVideoAd.adNetworkName];
    //NSLog(@"广告已点击");
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
#if 0
    NSLog(@"%s",__FUNCTION__);
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error.code == 3002) {
        NSLog(@"网络连接超时");
    }
    
    NSLog(@"ERROR: %@", error);
#endif
    
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        [that loadRewardViedoAd];
    });
    
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    //NSLog(@"%s",__FUNCTION__);
    //NSLog(@"播放达到激励条件");
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
   // NSLog(@"%s",__FUNCTION__);
   // NSLog(@"视频播放结束");
}




#pragma mark 穿山甲激励视频回调
- (void)loadRewardViedoAd {

    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID;
    
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:CHUAN_SHAN_JIA_REWARD_VEDIO_ID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    
    [self.rewardedVideoAd loadAdData];
    [JUDIAN_READ_Reader_FictionCommandHandler addVedioAdEvent:@"ad_request"];
}


- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addVedioAdEvent:@"ad_success_request"];
    [self.rewardedVideoAd showAdFromRootViewController:self.viewController.navigationController];
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    
    
    
}

- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addVedioAdEvent:@"ad_success_show"];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    //BUD_Log(@"rewardedVideoAd video did close");
    
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    //BUD_Log(@"rewardedVideoAd video did click");
    [JUDIAN_READ_Reader_FictionCommandHandler addVedioAdEvent:@"ad_click"];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    //BUD_Log(@"rewardedVideoAd data load fail");
    
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        //BUD_Log(@"rewardedVideoAd play error");
    } else {
        //BUD_Log(@"rewardedVideoAd play finish");
    }
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    //BUD_Log(@"rewardedVideoAd verify failed");
    //BUD_Log(@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
    //BUD_Log(@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    //BUD_Log(@"rewardedVideoAd verify succeed");
    //BUD_Log(@"verify result: %@", verify ? @"success" : @"fail");
    //BUD_Log(@"Demo RewardName == %@", rewardedVideoAd.rewardedVideoModel.rewardName);
    //BUD_Log(@"Demo RewardAmount == %ld", (long)rewardedVideoAd.rewardedVideoModel.rewardAmount);
}



#pragma mark 激励视频广告弹窗
- (void)showVideoPrompt {
    
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];;
    BOOL showPrompt = showAdView && _userChapterCountDictionary.count >= READ_CHAPTER_UPPER_LIMIT;
    
    if (!showPrompt) {
        return;
    }
    
    
    NSString* isOnlyOne = [NSUserDefaults getUserDefaults:_ONLY_ONE_APPRECIATE_];
    NSString* rewardFlag = [JUDIAN_READ_Account currentAccount].rewardFlag;
    BOOL remoteRewardFlag = (![rewardFlag isEqual:[NSNull null]] && [rewardFlag isEqualToString:@"1"]);
    
    if ([isOnlyOne isEqualToString:@"1"] || remoteRewardFlag) {
        return;
    }
    
    WeakSelf(that);
    [JUDIAN_READ_VipCustomPromptView createAdPromptView:_viewController.view block:^(id  _Nonnull args) {
        
        NSDictionary* dictionary = @{@"type" : @"激励视频"
                                     };
        [MobClick event:@"click_jilivideo_ten_chapter" attributes:dictionary];
        [GTCountSDK trackCountEvent:@"click_jilivideo_ten_chapter" withArgs:dictionary];
        
        [that.userChapterCountDictionary removeAllObjects];
        
        NSString* dateString = [JUDIAN_READ_TestHelper getTodayString];
        NSString* countString = [NSUserDefaults getUserDefaults:dateString];
        if (countString.integerValue >= 2) {
            [that loadRewardViedoAd];
        }
        else {
            [that removeAdVideoHistory];
            [that createGdtVideoAd];
        }

    } cancel:^(id  _Nonnull args) {
        NSDictionary* dictionary = @{@"type" : @"打赏"
                                     };
        [MobClick event:@"click_jilivideo_ten_chapter" attributes:dictionary];
        [GTCountSDK trackCountEvent:@"click_jilivideo_ten_chapter" withArgs:dictionary];
        
        [that.userChapterCountDictionary removeAllObjects];
        
        
        NSDictionary *dictonary = @{
                                    @"payment_category":@"iap",
                                    @"product_id" : @"1",
                                    @"price" : @"8",
                                    @"nid" : @"0",
                                    @"chapnum" : @"0",
                                    @"type":@"ios",
                                    @"rewardType" : @"2"
                                    };
        
        [that initAppriciateMoneyManager];
        
        NSString* tip = [NSString stringWithFormat:@"阅读器内每%ld章的弹窗", (long)READ_CHAPTER_UPPER_LIMIT];
        [that.moneyManager appreciateMoney:dictonary source:tip];
    }];
    
    
}

- (void)removeAdVideoHistory {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currenDate =  [dateFormatter stringFromDate:yesterday];
    [NSUserDefaults removeUserDefaults:currenDate];
}



- (void)initAppriciateMoneyManager {
    if (_moneyManager) {
        return;
    }
    
    _moneyManager = [[JUDIAN_READ_ApprecaiteMoneyManager alloc] initWithView:_viewController.view];
    _moneyManager.isOnlyOneAppreciate = TRUE;
    _moneyManager.block = ^(id  _Nullable args) {
        
    };
}

#pragma mark 广告判断
- (BOOL)canLoadAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    return _hasAds && showAdView;
}


- (void)dealloc {
    
    if (_adTimer) {
        dispatch_cancel(_adTimer);
        _adTimer = nil;
    }
    
}

@end
