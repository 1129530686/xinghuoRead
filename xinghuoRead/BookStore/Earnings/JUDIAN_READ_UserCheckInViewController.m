//
//  JUDIAN_READ_UserCheckInViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCheckInViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserCheckInDayCell.h"
#import "JUDIAN_READ_UserCheckInRuleCell.h"
#import "JUDIAN_READ_UserDurationRewardModel.h"
#import "JUDIAN_READ_BuCellAdView.h"
#import "JUDIAN_READ_UserCheckInGoldListModel.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_UserActionSuccessDialog.h"

#define UserCheckInDayCell @"UserCheckInDayCell"
#define UserCheckInRuleCell @"UserCheckInRuleCell"


@interface JUDIAN_READ_UserCheckInViewController ()
<UITableViewDelegate,
UITableViewDataSource,
BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, weak)UIImageView* headImageView;
@property(nonatomic, strong)JUDIAN_READ_UserCheckInRuleCell* ruleCell;
@property(nonatomic, weak)JUDIAN_READ_BuCellAdView* adView;
@property(nonatomic, strong)JUDIAN_READ_UserCheckInGoldListModel* goldCoinListModel;
@property(nonatomic, strong)BUNativeAdsManager* adManager;
@property(nonatomic, assign)BOOL hasAds;
@property(nonatomic, weak)JUDIAN_READ_UserEarningsViewController* sourceViewController;
@end

@implementation JUDIAN_READ_UserCheckInViewController


+ (void)enterUserCheckInViewController:(UINavigationController*)navigationController viewContoller:(JUDIAN_READ_UserEarningsViewController*)sourceViewController {
    
    JUDIAN_READ_UserCheckInViewController* viewController = [[JUDIAN_READ_UserCheckInViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.sourceViewController = sourceViewController;
    [navigationController pushViewController:viewController animated:YES];

}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    _hasAds = YES;
    [self addHeadView];
    [self addNavigationView];
    [self addTableView];
    [self addAdView];
    
    [self loadCheckInModel];
    [self loadAdsData];
    
    [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"qiandao_show_times": @"签到页面"}];
    [MobClick event:@"make_money_task" attributes:@{@"qiandao_show_times": @"签到页面"}];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)addHeadView {
    UIImageView* headImageView = [[UIImageView alloc]init];
    _headImageView = headImageView;
    headImageView.image = [UIImage imageNamed:@"earning_head_image"];
    [self.view addSubview:headImageView];
    
    NSInteger topOffset = 0;
    if (iPhoneX) {
        topOffset = 24;
    }
    
    WeakSelf(that);
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(133 + topOffset));
    }];
    
}


- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    [view updateEarningsNavigation:@"签到" rightTitle:@""];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            
        }
    };
    
    CGFloat height = 64;
    if (iPhoneX) {
        height = 88;
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(height));
    }];
    
}



- (void)addTableView {
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    tableView.scrollEnabled = NO;
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[JUDIAN_READ_UserCheckInDayCell class] forCellReuseIdentifier:UserCheckInDayCell];
    //[tableView registerClass:[JUDIAN_READ_UserCheckInRuleCell class] forCellReuseIdentifier:UserCheckInRuleCell];
    _ruleCell = [[JUDIAN_READ_UserCheckInRuleCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:UserCheckInRuleCell];
    
    [self.view addSubview:tableView];
    
    WeakSelf(that);
    CGFloat bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.headImageView.mas_bottom).offset(-55);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
}



- (void)addAdView {
    
    JUDIAN_READ_BuCellAdView* adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    
    _adView = adView;
    [adView setDefaultStyle];
    adView.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [self.view addSubview:adView];
    
    NSInteger adHeight = 70;
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [adView addSubview:lineView];
    
    
    WeakSelf(that);
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(adHeight));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adView.mas_left);
        make.right.equalTo(adView.mas_right);
        make.height.equalTo(@(0.5));
        make.top.equalTo(adView.mas_top);
    }];
}



#pragma mark tableview代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 175;
    }
    
    return [_ruleCell getCellHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JUDIAN_READ_UserCheckInDayCell* cell = [tableView dequeueReusableCellWithIdentifier:UserCheckInDayCell];
        [cell updateCell:_goldCoinListModel];
        WeakSelf(that);
        cell.block = ^(id  _Nullable args) {
            
            NSString* token = [JUDIAN_READ_Account currentAccount].token;
            if (!token) {
                [that enterLoginViewController];
                return;
            }
            
            
            [JUDIAN_READ_UserCheckInDayCountModel checkIn:^(NSString*  _Nullable count) {
                if (count.length > 0) {
                    
                    NSString* days = that.goldCoinListModel.signin_days;
                    if (days.length <= 0) {
                        days = @"";
                    }
                    
                    [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"checkIn": days}];
                    [MobClick event:@"make_money_task" attributes:@{@"checkIn": days}];
                    
                    //NSString* tip = [NSString stringWithFormat:@"恭喜你获得%@元宝", count];
                    //[MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:that];

                    [JUDIAN_READ_UserActionSuccessDialog createPromptView:self.view count:count title:@"签到成功" block:^(id  _Nullable args) {
                        [that.sourceViewController loadRewardVedio:that];
                    }];
                    
                    
                    [JUDIAN_READ_Account currentAccount].allow_signin = @"0";
                    
                    [that loadCheckInModel];
                }
            }];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        _ruleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _ruleCell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
}

- (void)enterLoginViewController {
    
    JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}


#pragma mark 加载数据
- (void)loadCheckInModel {
    WeakSelf(that);
    [JUDIAN_READ_UserCheckInGoldListModel buildModel:^(id  _Nullable args) {
        that.goldCoinListModel = args;
        [that.tableView reloadData];
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
    slot.isSupportDeepLink = YES;
    adManager.adslot = slot;
    adManager.delegate = self;
    self.adManager = adManager;
    
    [adManager loadAdDataWithCount:1];
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"签到页面banner广告"];
}


- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"签到页面banner广告"];
    _hasAds = TRUE;
    _adView.hidden = !_hasAds;
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BUNativeAd *model = obj;
        [that setAdModel:model];
    }];

}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    _hasAds = FALSE;
    _adView.hidden = !_hasAds;
}


- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"介绍页banner广告"];
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页banner广告"];
}


- (void)setAdModel:(BUNativeAd*)nativeAd {
    [_adView buildView:nativeAd];
    
    [nativeAd unregisterView];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    [nativeAd registerContainer:self.adView withClickableViews:@[self.adView]];
}

#pragma mark 广告判断
- (BOOL)canLoadAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    return _hasAds && showAdView;
}

@end
