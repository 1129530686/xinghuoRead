//
//  JUDIAN_READ_AdsManager.m
//  xinghuoRead
//
//  Created by judian on 2019/6/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AdsManager.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"

@interface JUDIAN_READ_AdsManager ()<BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate,
BURewardedVideoAdDelegate,
GDTUnifiedNativeAdDelegate,
GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong)BUNativeAdsManager* adManager;

@property (nonatomic, strong)BURewardedVideoAd* rewardedVideoAd;
@property (nonatomic, strong)GDTUnifiedNativeAd* gdtNativeAd1;
@property (nonatomic, strong)GDTUnifiedNativeAd* gdtNativeAd2;

@property (nonatomic, assign)BOOL isLoadBuAds;
@property (nonatomic, assign)BOOL isLoadGdtAds;

@property (nonatomic, weak)UICollectionView* pageCollectionView;
@property (nonatomic, weak)UIViewController* viewController;
@property (nonatomic, weak)NSMutableDictionary* userReadChapterDictionary;
@property (nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@end


@implementation JUDIAN_READ_AdsManager


+ (instancetype)createAdsManager:(UIViewController*)viewController collectionView:(UICollectionView*)collectionView readChpater:(NSMutableDictionary*) readChpater{
    
    JUDIAN_READ_AdsManager* manager = [[JUDIAN_READ_AdsManager alloc]init];
    
    manager.pageCollectionView = collectionView;
    manager.viewController = viewController;
    manager.userReadChapterDictionary = readChpater;
    manager.isLoadBuAds = YES;
    manager.isLoadGdtAds = YES;
    
    [manager initAdsView];
    [manager initGDTAdData];

    return manager;
}




- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
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



#pragma mark 广点通广告
- (void)initGDTAdData {
    
    self.gdtAdArray = [NSMutableArray array];
    
    self.gdtNativeAd1 = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_FICTION_AD_ID_1];
    self.gdtNativeAd1.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.gdtNativeAd1.delegate = self;
    
    self.gdtNativeAd2 = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_FICTION_AD_ID_2];
    self.gdtNativeAd2.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.gdtNativeAd2.delegate = self;
    
}

- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    if (unifiedNativeAdDataObjects) {
        
        _isLoadGdtAds = YES;
        
        if (_gdtAdArray.count == 1) {
            [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_success_request" index:0];
        }
        else if(_gdtAdArray.count == 2) {
            [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_success_request" index:1];
        }

        [_gdtAdArray addObjectsFromArray:unifiedNativeAdDataObjects];
        
        NSIndexPath* indexPath10 = [NSIndexPath indexPathForItem:0 inSection:1];
        NSIndexPath* indexPath12 = [NSIndexPath indexPathForItem:2 inSection:1];
        [self.pageCollectionView reloadItemsAtIndexPaths:@[indexPath10, indexPath12]];
    }
    else if(error) {
        _isLoadGdtAds = NO;
        [self.pageCollectionView reloadData];
    }

}


- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    if (unifiedNativeAdView.tag == 0) {
        [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_click" index:0];
    }
    else if(unifiedNativeAdView.tag == 1) {
        [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_click" index:1];
    }
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    //NSLog(@"广告被曝光");
    if (unifiedNativeAdView.tag == 0) {
        [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_success_show" index:0];
    }
    else if(unifiedNativeAdView.tag == 1) {
        [JUDIAN_READ_Reader_FictionCommandHandler addGdtAdEvent:@"ad_success_show" index:1];
    }
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    //NSLog(@"广告详情页已关闭");
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    //NSLog(@"广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    //NSLog(@"广告详情页面即将打开");
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    //NSLog(@"视频广告状态变更");
}


#pragma mark 穿山甲广告
- (void)initAdsView {
    
    _adsDataArray = [NSMutableArray array];
    
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = CHUAN_SHAN_JIA_FEED_ID;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionBottom;
    
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot.isSupportDeepLink = YES;
    
    _adManager = [[BUNativeAdsManager alloc]init];
    _adManager.adslot = slot;
    _adManager.delegate = self;

}


- (void)loadAdData {
    
    BOOL needChuanShanJiaAd = [JUDIAN_READ_TestHelper needAdView:CHUAN_SHAN_JIA_SWITCH];
    BOOL needGuangDianTongAd = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    
    if (needChuanShanJiaAd) {
        [_adsDataArray removeAllObjects];
        
#if _GDT_AD_STATE_ == 1
        [_adManager loadAdDataWithCount:2];
        
        [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_request" index:2];
        [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_request" index:3];
#else
        [_adManager loadAdDataWithCount:4];
        
        [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_request" index:-1];
#endif
        
    }
    
    if (needGuangDianTongAd) {
#if _GDT_AD_STATE_ == 1
        [_gdtAdArray removeAllObjects];
        
        [_gdtNativeAd1 loadAdWithAdCount:1];
        [_gdtNativeAd2 loadAdWithAdCount:1];
        
        [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_request" index:0];
        [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_request" index:1];
#endif

    }

}


- (void)buildAdView:(BUNativeAd*)nativeAd cell:(JUDIAN_READ_AdSize250ViewCell*) cell {
    
    nativeAd.rootViewController = _viewController;
    nativeAd.delegate = self;
    
    [cell buildView:nativeAd];
   
    //[nativeAd unregisterView];
    [nativeAd registerContainer:cell withClickableViews:@[cell]];

}



- (void)buildMiniAdView:(BUNativeAd*)nativeAd cell:(JUDIAN_READ_MiniAdViewCell*) cell {
    
    nativeAd.rootViewController = _viewController;
    nativeAd.delegate = self;
    
    [cell buildView:nativeAd];
    
    //[nativeAd unregisterView];
    [nativeAd registerContainer:cell withClickableViews:@[cell]];
   
}



- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    [_adsDataArray addObjectsFromArray:nativeAdDataArray];
    [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_success_request" index:-1];

    _isLoadBuAds = TRUE;
    
    NSIndexPath* indexPath30 = [NSIndexPath indexPathForItem:0 inSection:3];
    NSIndexPath* indexPath32 = [NSIndexPath indexPathForItem:2 inSection:3];
    [self.pageCollectionView reloadItemsAtIndexPaths:@[indexPath30, indexPath32]];
}


- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    
    NSString* tip = @"";
    if (error && error.code > 0) {
        tip = [NSString stringWithFormat:@"穿山甲广告加载失败%ld", error.code];
    }
    else {
        tip = @"穿山甲广告加载失败";
    }
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"chuanShanjiaFailure" source:tip];
    
    _isLoadBuAds = FALSE;
    [self.pageCollectionView reloadData];
}


- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    
#if _GDT_AD_STATE_ == 1
    if (_adsDataArray.count > 1) {
        if (_adsDataArray[0] == nativeAd) {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEvent:@"ad_success_show" index:0];
        }
        else {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEvent:@"ad_success_show" index:1];
        }
    }
#else
    NSInteger count = _adsDataArray.count;
    for (NSInteger index = 0; index < count; index++) {
        if (_adsDataArray[index] == nativeAd) {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_success_show" index:index];
            break;
        }
    }
#endif
    
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
#if _GDT_AD_STATE_ == 1
    if (_adsDataArray.count > 1) {
        if (_adsDataArray[0] == nativeAd) {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEvent:@"ad_click" index:0];
        }
        else {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEvent:@"ad_click" index:1];
        }
    }
#else
    NSInteger count = _adsDataArray.count;
    for (NSInteger index = 0; index < count; index++) {
        if (_adsDataArray[index] == nativeAd) {
            [JUDIAN_READ_Reader_FictionCommandHandler addChuanShanJiaAdEventEx:@"ad_click" index:index];
            break;
        }
    }
#endif
    
}

#pragma mark 广告判断
- (BOOL)canLoadBuAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:CHUAN_SHAN_JIA_SWITCH];
    return _isLoadBuAds && showAdView;
}


- (BOOL)canLoadGdtAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    return _isLoadGdtAds && showAdView;
}


#pragma mark 激励视频广告
- (void)initRewardViedoAd {
#if 0
    if (!self.rewardedVideoAd) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID;
        model.isShowDownloadBar = YES;
        
        self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:CHUAN_SHAN_JIA_REWARD_VEDIO_ID rewardedVideoModel:model];
        self.rewardedVideoAd.delegate = self;
    }
#endif

    NSString* isOnlyOne = [NSUserDefaults getUserDefaults:_ONLY_ONE_APPRECIATE_];
    if ([isOnlyOne isEqualToString:@"1"]) {
        return;
    }
    
    WeakSelf(that);
    [JUDIAN_READ_VipCustomPromptView createAdPromptView:_viewController.view block:^(id  _Nonnull args) {

        NSDictionary* dictionary = @{@"type" : @"确定"
                                     };
        [MobClick event:@"click_jilivideo_ten_chapter" attributes:dictionary];
        
        [that.userReadChapterDictionary removeAllObjects];

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
        [that.moneyManager appreciateMoney:dictonary source:@"阅读器内每10章的弹窗"];
        
        //[that loadRewardViedoAd];
        
    } cancel:^(id  _Nonnull args) {
        NSDictionary* dictionary = @{@"type" : @"取消"
                                     };
        [MobClick event:@"click_jilivideo_ten_chapter" attributes:dictionary];
        [that.userReadChapterDictionary removeAllObjects];
    }];
    
    
}


- (void)loadRewardViedoAd {
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

#pragma mark 设置广告数据

- (void)buildBuAdsDataWithBigView:(JUDIAN_READ_AdSize250ViewCell*)cell index:(NSInteger)index {
    
    BOOL showAdView = [self canLoadBuAds];
    cell.hidden = !showAdView;
    
    if (self.adsDataArray.count > index) {
        BUNativeAd* nativeAd = self.adsDataArray[index];
        [self buildAdView:nativeAd cell:cell];
    }

}

- (void)buildBuAdsDataWithMiniView:(JUDIAN_READ_MiniAdViewCell*)cell index:(NSInteger)index {
    
    BOOL showAdView = [self canLoadBuAds];
    cell.hidden = !showAdView;
    
    if (self.adsDataArray.count > 0) {
        BUNativeAd* nativeAd = self.adsDataArray[0];
        [self buildMiniAdView:nativeAd cell:cell];
    }
}




- (void)buildGdtAdsData:(JUDIAN_READ_GdtAdSize250ViewCell*)cell index:(NSInteger)index {
    
    BOOL showAdView = [self canLoadGdtAds];
    cell.hidden = !showAdView;
    
    if (self.gdtAdArray.count > 0) {
        
        if ((index < self.gdtAdArray.count)) {
            
            GDTUnifiedNativeAdDataObject* nativeAd = self.gdtAdArray[index];
            cell.unifiedNativeAdView.tag = index;
            cell.unifiedNativeAdView.delegate = self;
            cell.unifiedNativeAdView.viewController = _viewController;
            [cell buildGdtView:nativeAd];
            cell.unifiedNativeAdView.logoView.hidden = YES;
            [cell.unifiedNativeAdView registerDataObject:nativeAd clickableViews:@[cell.unifiedNativeAdView]];
        }
    }

}


- (void)computeAdDscriptionHeight:(NSInteger)index width:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount {
    
    NSString* text = @"";
    if ((index == 0 || index == 1) && self.gdtAdArray.count > 0) {
        if ((index < self.gdtAdArray.count)) {
            GDTUnifiedNativeAdDataObject* nativeAd = self.gdtAdArray[index];
            text = nativeAd.desc;
        }
    }
    else if(index == 2) {
        
        if (self.adsDataArray.count > 1) {
            BUNativeAd* nativeAd = self.adsDataArray[1];
            text = nativeAd.data.AdDescription;
        }
    }
    
    NSAttributedString* attributedString = [JUDIAN_READ_AdsManager createAttributedText:text color:[UIColor whiteColor]];
    [JUDIAN_READ_AdsManager computeAttributedTextHeight:attributedString width:width height:height lineCount:lineCount];
    
}


+ (void)computeAttributedTextHeight:(NSAttributedString*)attributedString width:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount {
    
    if (attributedString.length <= 0) {
        return;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    
    CGFloat maxHeight = 10000;
    CGRect pathRect = CGRectMake(0, 0, width, maxHeight);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pathRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(textFrame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), lineOrigins);
    
    *lineCount = count;
    
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    
    if (count >= 2) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, 1);;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        *height = ceil(maxHeight - lineOrigins[1].y + (NSInteger)descent + 1);
    }
    
    
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(textFrame);
    
}


+ (NSMutableAttributedString*)createAttributedText:(NSString*)text color:(UIColor*)color {
    
    if (text.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    
    return attributedText;
}




+ (CTFrameRef)getTextFrameRef:(CGRect)frame attributedString:(NSAttributedString*)attributedString {
    
    if (!attributedString) {
        return nil;
    }
    
    CGPathRef pathRef = [JUDIAN_READ_AdsManager createRectanglePathRef:frame];
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frameRef = NULL;
    frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [attributedString length]), pathRef, NULL);
    CFRelease(frameSetterRef);
    
    return frameRef;
}



+ (CGPathRef)createRectanglePathRef:(CGRect)layoutFrame {
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layoutFrame.size.width, layoutFrame.size.height)];
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}


@end
