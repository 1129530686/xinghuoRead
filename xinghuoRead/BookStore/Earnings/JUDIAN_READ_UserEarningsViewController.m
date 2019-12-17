//
//  JUDIAN_READ_UserEarningsViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_PointsSegmentView.h"
#import "JUDIAN_READ_UserReceiveGoldCoinsContainer.h"
#import "JUDIAN_READ_UserCheckInDayCell.h"
#import "JUDIAN_READ_UserReadTimeSpanCell.h"
#import "JUDIAN_READ_UserReceiveGoldCoinCell.h"
#import "JUDIAN_READ_UserCheckInEmptyCell.h"
#import "JUDIAN_READ_UserCheckInAdvertiseCell.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_UserDayEarningsTipCell.h"
#import "JUDIAN_READ_UserEarningsTaskCell.h"
#import "JUDIAN_READ_UserCheckInGoldListModel.h"
#import "JUDIAN_READ_UserActionSuccessDialog.h"
#import "JUDIAN_READ_UserDurationRewardModel.h"
#import "JUDIAN_READ_UserCheckInViewController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_InviteFriendController.h"
#import "JUDIAN_READ_UserBriefViewController.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_CoinRecordController.h"
#import "JUDIAN_READ_VipCustomPromptView.h"

#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>

#define RECEIVED_GOLD_COIN_COUNT(count) [NSString stringWithFormat:@"恭喜你获得%@元宝", count]
#define SWITCH_BUTTON_TAG 100

@interface JUDIAN_READ_UserEarningsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
GDTUnifiedNativeAdDelegate,
GDTUnifiedNativeAdViewDelegate,
BURewardedVideoAdDelegate,

BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate
>
@property(nonatomic, weak)UIImageView* checkInImageView;
@property(nonatomic, weak)UILabel* timeSpanLabel;
@property(nonatomic, weak)UIImageView* headImageView;

@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, strong)GDTUnifiedNativeAd* gdtNativeAd;
@property(nonatomic, strong)GDTUnifiedNativeAdDataObject* gdtAdDataObject;

@property(nonatomic, assign)BOOL hasAds;
@property(nonatomic, copy)NSArray* taskArray;

@property (nonatomic, strong)BURewardedVideoAd *rewardedVideoAd;

@property (nonatomic, strong)JUDIAN_READ_UserDurationRewardModel* durationRewardModel;
@property (nonatomic, strong)NSArray* otherTaskArray;

@property(nonatomic, weak)JUDIAN_READ_UserEarningsNavigationView* navigationView;
@property (nonatomic, strong)JUDIAN_READ_UserCheckInGoldListModel* checkInRuleModel;
@property(nonatomic, copy)NSString* goldCoinOfVideo;

@property(nonatomic, assign)NSInteger numbersOfSecion;
@property(nonatomic, weak)UIView* notificationView;

@property(nonatomic, strong)BUNativeAdsManager* adManager;
@property(nonatomic, strong)BUNativeAd *csjAdModel;

@property(nonatomic, weak)UIViewController* viewControllerOfToast;
@end

@implementation JUDIAN_READ_UserEarningsViewController


+ (void)entryEarningsViewController:(UINavigationController*)navigationController {
    JUDIAN_READ_UserEarningsViewController* viewController = [[JUDIAN_READ_UserEarningsViewController alloc]init];
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numbersOfSecion = 1;
    self.view.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    [self addHeadView];

    [self addNavigationView];
    [self addTableView];
    
    [self initRewardVedioView];
    
    //[self initGDTAdData];
    [self loadAdsData];
    
    [self checkVersion];
}


-(void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    
    [self loadTaskData];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [_navigationView updateTitle:@"元宝任务" rightTitle:@"元宝兑换"];
    
    [self addNotificationView];
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
    
    NSInteger offset = [self getPlusOffset];
    
    WeakSelf(that);
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(that.view.mas_top);
        make.height.equalTo(@(133 + topOffset + offset));
    }];
    
}




- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    _navigationView = view;
    [view updateTitle:@"元宝任务" rightTitle:@""];
    [self.view addSubview:view];
    
    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            NSArray* array = that.navigationController.viewControllers;
            UIViewController* webViewController = nil;
            for (UIViewController* viewController in array) {
                if ([viewController isKindOfClass:[JUDIAN_READ_BannarWebController class]]) {
                    webViewController = viewController;
                    break;
                }
            }
            
            if (webViewController) {
                [that.navigationController popToViewController:webViewController animated:YES];
            }
            else {
                JUDIAN_READ_BannarWebController *vc = [JUDIAN_READ_BannarWebController shareInstance];
                vc.title = @"福利商城";
                vc.url = @"goldmall";
                [that.navigationController pushViewController:vc animated:YES];
            }

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
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, 28, 0);
    [tableView registerClass:[JUDIAN_READ_UserCheckInDayCell class] forCellReuseIdentifier:@"UserCheckInDayCell"];
    [tableView registerClass:[JUDIAN_READ_UserReadTimeSpanCell class] forCellReuseIdentifier:@"UserReadTimeSpanCell"];
    [tableView registerClass:[JUDIAN_READ_UserReceiveGoldCoinCell class] forCellReuseIdentifier:@"UserReceiveGoldCoinCell"];
    [tableView registerClass:[JUDIAN_READ_UserCheckInEmptyCell class] forCellReuseIdentifier:@"UserCheckInEmptyCell"];
    [tableView registerClass:[JUDIAN_READ_UserCheckInAdvertiseCell class] forCellReuseIdentifier:@"UserCheckInAdvertiseCell"];
    [tableView registerClass:[JUDIAN_READ_UserDayEarningsTipCell class] forCellReuseIdentifier:@"UserDayEarningsTipCell"];
    [tableView registerClass:[JUDIAN_READ_UserEarningsTaskCell class] forCellReuseIdentifier:@"UserEarningsTaskCell"];
    [tableView registerClass:[JUDIAN_READ_UserGoldCountCell class] forCellReuseIdentifier:@"UserGoldCountCell"];
    
    
    [self.view addSubview:tableView];
    

    WeakSelf(that);
    CGFloat topOffset = 0;
    CGFloat bottomOffset = 0;
    if (iPhoneX) {
        topOffset = 24;
        bottomOffset = 34;
    }
    
    NSInteger offset = [self getPlusOffset];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        //make.top.equalTo(that.view.mas_top).offset(79 + topOffset);
        make.top.equalTo(that.headImageView.mas_bottom).offset(-70 - offset);
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];

}


- (NSInteger)getPlusOffset {
    
    NSInteger offset = 0;
    if (iPhone6Plus) {
        offset = 20;
    }
    
    return offset;
}


- (void)initRewardVedioView {
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = CHUAN_SHAN_JIA_REWARD_VEDIO_USER_ID;
    //model.isShowDownloadBar = YES;
    
    self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:CHUAN_SHAN_JIA_REWARD_VEDIO_ID rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;

}


- (void)addNotificationView {
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (settings.types != UIUserNotificationTypeNone) {
        [_notificationView removeFromSuperview];
        return;
    }

    UIView* notificationView = [[UIView alloc] init];
    _notificationView = notificationView;
    [self.view addSubview:notificationView];
    
    notificationView.backgroundColor = [UIColor whiteColor];
    notificationView.layer.cornerRadius = 7;
    
    notificationView.layer.shadowOpacity = 0.5;
    notificationView.layer.shadowColor = RGB(0x65, 0x65, 0x65).CGColor;
    notificationView.layer.shadowRadius = 3;
    notificationView.layer.shadowOffset = CGSizeMake(0, 1);
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = RGB(0x33, 0x33, 0x33);
    titleLabel.text = @"重要信息早知道";
    [notificationView addSubview:titleLabel];
    
    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textColor = RGB(0x66, 0x66, 0x66);
    contentLabel.text = @"开启通知，第一时间了解新书、赚钱福利";
    [notificationView addSubview:contentLabel];
    
    //67 27
    UIButton* switchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    switchButton.tag = SWITCH_BUTTON_TAG;
    [switchButton addTarget:self action:@selector(handleNotificationTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    [switchButton setBackgroundImage:[UIImage imageNamed:@"notification_swich_image"] forState:(UIControlStateNormal)];
    [notificationView addSubview:switchButton];
    
    UIButton* closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    closeButton.tag = SWITCH_BUTTON_TAG + 1;
    [closeButton addTarget:self action:@selector(handleNotificationTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"notification_close_image"] forState:(UIControlStateNormal)];
    [notificationView addSubview:closeButton];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    WeakSelf(that);
    [notificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(14);
        make.right.equalTo(that.view.mas_right).offset(-14);
        make.height.equalTo(@(67));
        make.bottom.equalTo(that.view).offset(-17 - bottomOffset);
    }];
    
    
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(67));
        make.height.equalTo(@(27));
        make.right.equalTo(notificationView.mas_right).offset(-20);
        make.centerY.equalTo(notificationView.mas_centerY);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notificationView.mas_left).offset(14);
        make.right.equalTo(notificationView.mas_right).offset(-10);
        make.height.equalTo(@(15));
        make.top.equalTo(notificationView.mas_top).offset(16);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(notificationView.mas_left).offset(14);
        make.right.equalTo(notificationView.mas_right).offset(-10);
        make.height.equalTo(@(13));
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(20));
        make.height.equalTo(@(22));
        make.right.equalTo(notificationView.mas_right);
        make.top.equalTo(notificationView.mas_top);
    }];
    
}

- (void)handleNotificationTouch:(UIButton*)sender {
    
    if(sender.tag == SWITCH_BUTTON_TAG) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingURL];
    }
    else {
        [[sender superview] removeFromSuperview];
    }
    
}



- (void)showNotificationSettingView {
    [self addNotificationView];
}


#pragma mark tableview代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSInteger offset = [self getPlusOffset];
        return 70 + offset;
    }
    
    
    if (indexPath.section == 1) {
        return 66;
    }
    
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 44;
        }
        
        if (indexPath.row == 1) {
            return 7 * 20 + 6 * 27;
        }
        
        if (indexPath.row == 2) {
            return 10;
        }
        
        if (indexPath.row == 3) {
            BOOL needAd = [self canLoadAds];
            if (!needAd) {
                return 0.01;
            }
            
            return 70;
        }
        
        //if (indexPath.row == 4) {
        //    return 10;
        //}
        
        if (indexPath.row == 4) {
            return 52;
        }
    }

    
    if (indexPath.section == 3) {
        return 66.0f;
    }
    
    if (indexPath.section == 4) {
        return 28;
    }
    
    return 0;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return _numbersOfSecion;
    }
    
    if (section == 2) {
        return 5;
    }
    
    if (section == 3) {
        if (_taskArray.count > 2) {
            JUDIAN_READ_TaskModel* model = _taskArray[2];
            if (model.count.intValue <= 0) {
                return _taskArray.count - 1;
            }
        }
        
        return _taskArray.count;
    }
    
    if (section == 4) {
        return 1;
    }
    
    return 0;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        JUDIAN_READ_UserGoldCountCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserGoldCountCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCell];
        WeakSelf(that);
        cell.block = ^(NSString*  _Nullable args) {
            if ([args isEqualToString:@"login"]) {
                [that handleTouchEvent:nil];
            }
            else {
                [that enterMyColdCoinViewController];
            }
            
        };
        return cell;
    }

    if (indexPath.section == 1) {
        WeakSelf(that);
        JUDIAN_READ_UserEarningsTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserEarningsTaskCell"];
        cell.block = ^(id  _Nullable args) {
            if (indexPath.row == 0) {
                [JUDIAN_READ_UserCheckInViewController enterUserCheckInViewController:that.navigationController viewContoller:that];
            }
            else {
                
                [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"click_update_button": @"1"}];
                [MobClick event:@"make_money_task" attributes:@{@"click_update_button": @"1"}];
                
                NSString *str = [NSString stringWithFormat:APPSTORE_URL ];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }

        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_otherTaskArray.count > 0) {
            BOOL checkIn = (_checkInRuleModel.today_signin.intValue == 1);
            [cell updateTask:_otherTaskArray[indexPath.row] isCheckIn:checkIn];
        }
        
        if (indexPath.row == 1) {
            cell.lineView.hidden = NO;
        }
        else {
            cell.lineView.hidden = NO;
        }

        return cell;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            JUDIAN_READ_UserReadTimeSpanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserReadTimeSpanCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString* token = [JUDIAN_READ_Account currentAccount].token;
            if (token.length <= 0) {
                [cell updateTimeSpan:@"0"];
            }
            else {
                [cell updateTimeSpan:_durationRewardModel.duration];
            }
            return cell;
        }
        
        if (indexPath.row == 1) {
            
            
            JUDIAN_READ_UserReceiveGoldCoinCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserReceiveGoldCoinCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WeakSelf(that);
            cell.block = ^(NSNumber*  _Nullable args) {
                
                NSString* token = [JUDIAN_READ_Account currentAccount].token;
                if (token.length <= 0) {
                    [that handleTouchEvent:nil];
                    return;
                }
                
                JUDIAN_READ_UserIgnotsModel* model = that.durationRewardModel.rule[args.intValue];
                [JUDIAN_READ_UserDurationRewardModel receiveGoldCoin:^(NSString*  _Nullable count) {
                    if (count.length > 0) {
                        [that loadTaskData];
                        
                        [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
                            //NSString* count = [JUDIAN_READ_Account currentAccount].totalCoins;
                            [that.tableView reloadData];
                        }];
                        
                        //NSString* tip = RECEIVED_GOLD_COIN_COUNT(count);
                        //[MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:that];
                        [that showPromptView:count];
                        
                        NSString* duration = model.min;
                        if (duration.length <= 0) {
                            duration = @"";
                        }
                        
                        [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"time": duration}];
                        [MobClick event:@"make_money_task" attributes:@{@"time": duration}];
                    
                    }

                } duration:model.min];
            };
            [cell updateCell:_durationRewardModel.rule duration:_durationRewardModel.duration];
            return cell;
        }
        
        if (indexPath.row == 2) {
            JUDIAN_READ_UserCheckInEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCheckInEmptyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row == 3) {
            JUDIAN_READ_UserCheckInAdvertiseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCheckInAdvertiseCell"];
#if 0
            cell.unifiedNativeAdView.delegate = self;
            if (_gdtAdDataObject) {
                [cell buildGdtView:_gdtAdDataObject];
                cell.unifiedNativeAdView.delegate = self;
                cell.unifiedNativeAdView.viewController = self;
                cell.unifiedNativeAdView.logoView.hidden = YES;
                [cell.unifiedNativeAdView registerDataObject:_gdtAdDataObject clickableViews:@[cell.unifiedNativeAdView]];
            }
#else
            [self setAdModel:_csjAdModel view:cell];
#endif
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            BOOL needAd = [self canLoadAds];
            if (needAd) {
                cell.hidden = NO;
            }
            else {
                cell.hidden = YES;
            }
            
            return cell;
        }
        
        //if (indexPath.row == 4) {
        //    JUDIAN_READ_UserCheckInEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCheckInEmptyCell"];
        //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    return cell;
        //}
        
        if (indexPath.row == 4) {
            JUDIAN_READ_UserDayEarningsTipCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserDayEarningsTipCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }

    if (indexPath.section == 3) {
        JUDIAN_READ_UserEarningsTaskCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserEarningsTaskCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger count = self.taskArray.count;
        if (count > 0) {
            NSInteger row = indexPath.row;
            BOOL checkIn = (_checkInRuleModel.today_signin.intValue == 1);
            [cell updateTask:self.taskArray[row] isCheckIn:checkIn];
        }
        
        if (indexPath.row == (count - 1)) {
            cell.lineView.hidden = YES;
        }
        else {
            cell.lineView.hidden = NO;
        }
        
        
        WeakSelf(that);
        cell.block = ^(id  _Nullable args) {
            NSString* token = [JUDIAN_READ_Account currentAccount].token;
            if (token.length <= 0) {
                [that handleTouchEvent:nil];
                return;
            }
            
            if (indexPath.row == 0) {
                [JUDIAN_READ_VipCustomPromptView createVideoAdPromptView:that.view block:^(id  _Nonnull args) {
                    [that loadRewardVedio:that];
                } cancel:^(id  _Nonnull args) {
                    
                }];
            }
            else if(indexPath.row == 1) {
                [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"source":@"赚钱任务"}];
                [JUDIAN_READ_InviteFriendController enterInviteFriendController:that.navigationController];
            }
            else {
                [JUDIAN_READ_UserBriefViewController enterUserBriefViewController:that.navigationController];
            }
        };
    
        return cell;
    }
    
    
    if (indexPath.section == 4) {
        JUDIAN_READ_UserCheckInEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserCheckInEmptyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}


#pragma mark 签到提示框
- (void)showPromptView:(NSString*)count {
    WeakSelf(that);
    [JUDIAN_READ_UserActionSuccessDialog createPromptView:self.view count:count title:@"领取成功" block:^(id  _Nullable args) {
        [that loadRewardVedio:that];
    }];
}


#pragma mark 加载福利任务
- (void)loadTaskData{
    
    WeakSelf(that);
    [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
        [that.tableView reloadData];
    }];
    
    
    [JUDIAN_READ_MyTool getTaskWithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            that.taskArray = result;
            [that.tableView reloadData];
        }
    }];
    

    [JUDIAN_READ_UserDurationRewardModel buildModel:^(id  _Nullable args) {
        that.durationRewardModel = args;
        [that.tableView reloadData];
    }];
    
    
    JUDIAN_READ_TaskModel* model1 = [[JUDIAN_READ_TaskModel alloc] init];
    model1.title = @"每日签到";
    model1.type = @"checkIn";

    
    JUDIAN_READ_TaskModel* model2 = [[JUDIAN_READ_TaskModel alloc] init];
    model2.title = @"更新到最新版本";
    model2.type = @"version";
    
    _otherTaskArray = @[model1, model2];
    

    [JUDIAN_READ_UserCheckInGoldListModel buildModel:^(id  _Nullable args) {
        
        that.checkInRuleModel = args;
        model1.coins = that.checkInRuleModel.gold_coin;
        model1.signDays = that.checkInRuleModel.signin_days;
        [that.tableView reloadData];
    }];
    
    [JUDIAN_READ_UserCheckInGoldListModel buildVersionModel:^(NSNumber*  _Nullable args) {
        model2.coins = [NSString stringWithFormat:@"%ld", (long)args.intValue];
        [that.tableView reloadData];
    }];
    
}


- (void)loadRewardVedio:(UIViewController*)viewController {
    _viewControllerOfToast = viewController;
    [self.rewardedVideoAd loadAdData];
    [MobClick event:ad_request attributes:@{@"source":ad_task}];
}


#pragma mark 广点通

- (void)initGDTAdData {
    
    self.gdtNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_BOOK_INTRODUCTION_AD_ID];
    self.gdtNativeAd.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.gdtNativeAd.delegate = self;
    [self.gdtNativeAd loadAdWithAdCount:1];
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"元宝任务banner广告"];
}

- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    if (unifiedNativeAdDataObjects) {
        _hasAds = TRUE;
        [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"元宝任务banner广告"];
        _gdtAdDataObject = unifiedNativeAdDataObjects[0];
        [_tableView reloadData];
    }
    else if(error) {
        _hasAds = FALSE;
        [_tableView reloadData];
    }
}



- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"元宝任务banner广告"];
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"元宝任务banner广告"];
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    
}


- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
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
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"元宝任务banner广告"];
}


- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"元宝任务banner广告"];
    _hasAds = TRUE;
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        that.csjAdModel = obj;
        [that.tableView reloadData];
    }];
    
}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    _hasAds = FALSE;

}


- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"介绍页banner广告"];
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页banner广告"];
}


- (void)setAdModel:(BUNativeAd*)nativeAd view:(JUDIAN_READ_UserCheckInAdvertiseCell*)view{
    if (!nativeAd) {
        return;
    }

    [view buildCsjView:nativeAd];
    [nativeAd unregisterView];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    [nativeAd registerContainer:view withClickableViews:@[view]];
}



#pragma mark 激励视频
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_success_request attributes:@{@"source":ad_task}];
    [GTCountSDK trackCountEvent:ad_success_request withArgs:@{@"source":ad_task}];

}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [self.rewardedVideoAd showAdFromRootViewController:self.navigationController];
}


- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_success_show attributes:@{@"source":ad_task}];
    [GTCountSDK trackCountEvent:ad_success_show withArgs:@{@"source":ad_task}];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (that.goldCoinOfVideo.length > 0) {
            NSString* tip = RECEIVED_GOLD_COIN_COUNT(that.goldCoinOfVideo);
            [MBProgressHUD showTipWithImage:tip image:[UIImage imageNamed:@"ingots_toast_tip"] toVc:that.viewControllerOfToast];
            that.goldCoinOfVideo = nil;
        }
    });
    
 
}

- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    [MobClick event:ad_click attributes:@{@"source":ad_task}];
    [GTCountSDK trackCountEvent:ad_click withArgs:@{@"source":ad_task}];
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {

}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (!error) {
        WeakSelf(that);
        [JUDIAN_READ_MyTool uploadLookRecordWithParams:@{} completionBlock:^(id result, id error) {
            if (result) {
                that.goldCoinOfVideo = result;
                [that loadTaskData];
            }else{
                
            }
        }];
    }
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {

}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{

}

#pragma mark 登录
- (void)handleTouchEvent:(id)sender {
    JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark 进入我的元宝
- (void)enterMyColdCoinViewController {
    JUDIAN_READ_CoinRecordController *vc = [JUDIAN_READ_CoinRecordController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark version

- (void)checkVersion{
    NSMutableDictionary *dic = [@{@"type":@"ios",@"versionNo":GET_VERSION_NUMBER} mutableCopy];
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (token.length > 0) {
        [dic setObject:[JUDIAN_READ_Account currentAccount].token forKey:@"token"];
    }
    WeakSelf(that);
    [JUDIAN_READ_MyTool getVersionWithParams:dic completionBlock:^(id result, id error) {
        if (result) {
            
            NSString* remoteVersion = result[@"version"];
            NSString* localVersion = GET_VERSION_NUMBER;
            
            remoteVersion = [remoteVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            localVersion = [localVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            NSInteger remoteVersionInt = [remoteVersion integerValue];
            NSInteger localVersionInt = [localVersion integerValue];
            
            //有新版本
            if ((remoteVersionInt > localVersionInt) ) {
                that.numbersOfSecion = 2;
                [self.tableView reloadData];
            }
            
        }
    }];
}


#pragma mark 广告判断
- (BOOL)canLoadAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    return _hasAds && showAdView;
}


- (void)dealloc {
    
    
}

@end
