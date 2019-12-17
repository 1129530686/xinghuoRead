//
//  JUDIAN_READ_ChapterCatalogPanel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterCatalogPanel.h"
#import "JUDIAN_READ_ChapterTitleItem.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_BuCellAdView.h"
#import "JUDIAN_READ_ChapterNameTipItem.h"
#import "JUDIAN_READ_ChapterListItem.h"
#import "JUDIAN_READ_VerticalSlider.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"


#define CATALOG_WIDTH 300

@interface JUDIAN_READ_ChapterCatalogPanel ()<BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate>
@property(nonatomic, strong)UIControl* container;
@property(nonatomic, strong)JUDIAN_READ_BuCellAdView* adView;
@property(nonatomic, strong)JUDIAN_READ_ChapterListItem* listItem;
@property(nonatomic, strong) BUNativeAdsManager *adManager;
@property(nonatomic, weak)UIViewController* viewController;
@property(nonatomic, weak)JUDIAN_READ_VerticalSlider* slider;
@property(nonatomic, assign)BOOL hasAds;
@end


@implementation JUDIAN_READ_ChapterCatalogPanel

- (instancetype)initWithViewController:(UIViewController*)viewController {
 
    self = [super init];
    if (self) {
        _viewController = viewController;
        self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
        [self addViews];
        [self setViewStyle];
    }
    
    return self;
}


- (void)addViews {
    
    _hasAds = TRUE;
    
    _container = [[UIControl alloc] init];
    [self addSubview:_container];
    
    _titleItem = [[JUDIAN_READ_ChapterTitleItem alloc] init];
    [_container addSubview:_titleItem];
    
    _adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    [_container addSubview:_adView];
    
   // JUDIAN_READ_ChapterNameTipItem* nameTipItem = [[JUDIAN_READ_ChapterNameTipItem alloc] init];
   // [_container addSubview:nameTipItem];
    
    _listItem = [[JUDIAN_READ_ChapterListItem alloc] init];
    [_container addSubview:_listItem];
    

    NSInteger bottomOffset = 0;
    NSInteger topOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
        topOffset = 24;
    }
    
    
    WeakSelf(that);
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(-CATALOG_WIDTH);
        make.top.equalTo(that.mas_top);
        make.bottom.equalTo(that.mas_bottom);
        make.width.equalTo(@(CATALOG_WIDTH));
    }];
    
    NSInteger priority = 980;
    [_titleItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.top.equalTo(that.container.mas_top).offset(topOffset);
        make.height.equalTo(@(110)).priority(priority);
    }];
    
    
    BOOL needAd = [self canLoadAds];
    NSInteger adHeight = 0;
    if (needAd) {
        _adView.hidden = NO;
        adHeight = 60;
    }
    else {
        _adView.hidden = YES;
        adHeight = 0;
    }
    
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(adHeight)).priority(priority);
        make.top.equalTo(that.titleItem.mas_bottom);
    }];
    
    

    
    
    [_listItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.top.equalTo(that.adView.mas_bottom).priority(priority);
        make.bottom.equalTo(that.container.mas_bottom).offset(-bottomOffset);
    }];

    [self layoutIfNeeded];
    

    
    
    [self loadAdsData];
}



- (void)layoutSubviews {
    [super layoutSubviews];
}



- (void)addToKeyWindow:(UIView*)container {
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [container addSubview:self];
}



- (void)showView {
    
    [self setViewStyle];
    [_adView setViewStyle];
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(CATALOG_WIDTH, 0);
    }completion:^(BOOL finished) {
        
    }];
}



- (void)setViewStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _container.backgroundColor = RGB(0x33, 0x33, 0x33);
    }
    else {
        _container.backgroundColor = [UIColor whiteColor];
    }
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeSelf];
}




- (void)removeSelf {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(-CATALOG_WIDTH, 0);
    }completion:^(BOOL finished) {
#if 0
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                             @"cmd":@(kHideStatusViewCmd),
                                                                                             @"value":@(0)
                                                                                             }];
#endif
        [that removeFromSuperview];
    }];
}




- (void)reloadData:(NSArray*)array clickIndex:(NSInteger)clickIndex {
    _listItem.clickIndex = clickIndex;
    [_listItem realoadData:array];
    _titleItem.cacheCountLabel.text = [NSString stringWithFormat:@"共%ld章",  (long)array.count];

}



- (void)scrollToTop:(NSInteger)index {
    [_listItem scrollToTop:index];
}




- (void)showAdView {
    
    BOOL needAd = [self canLoadAds];
    NSInteger adHeight = 0;
    if (needAd) {
        _adView.hidden = NO;
        adHeight = 70;
    }
    else {
        _adView.hidden = YES;
        adHeight = 0;
    }
    
    [_adView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(adHeight));
    }];
}


#pragma mark 穿山甲广告

- (void)loadAdsData {
    
    BUNativeAdsManager *adManager = [[BUNativeAdsManager alloc]init];
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = CHUAN_SHAN_JIA_FEED_ID;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionTop;
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
#if 0
    BUSize* size = [[BUSize alloc]init];
    size.width = 63;
    size.height = 43;
    slot.imgSize = size;
#endif
    slot.isSupportDeepLink = YES;
    adManager.adslot = slot;
    adManager.delegate = self;
    self.adManager = adManager;
    
    [adManager loadAdDataWithCount:1];
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"阅读器页面目录banner广告"];
    
}




- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    _hasAds = TRUE;
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"阅读器页面目录banner广告"];
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BUNativeAd *model = obj;
        [that buildAdView:model];
    }];
    
    [self showAdView];
}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    _hasAds = FALSE;
    [self showAdView];
}





- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"阅读器页面目录banner广告"];
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"阅读器页面目录banner广告"];
}






- (void)buildAdView:(BUNativeAd*)nativeAd {
    
    [nativeAd unregisterView];
    nativeAd.rootViewController = _viewController;
    nativeAd.delegate = self;
    
    [_adView buildView:nativeAd];
    [nativeAd registerContainer:_adView withClickableViews:@[_adView]];
}


- (BOOL)canLoadAds {
    return FALSE;
    //BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:CHUAN_SHAN_JIA_SWITCH];
    //return _hasAds && showAdView;
}

@end
