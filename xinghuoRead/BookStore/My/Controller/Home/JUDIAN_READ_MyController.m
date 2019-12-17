//
//  JUDIAN_READ_MyController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/17.
//  Copyright © 2019年 judian. All rights reserved.
//


#import "JUDIAN_READ_MyHomeCell.h"
#import "JUDIAN_READ_MyHeadView.h"
#import "JUDIAN_READ_SuggestionController.h"
#import "JUDIAN_READ_AboutUsController.h"
#import "JUDIAN_READ_ProblemController.h"
#import "JUDIAN_READ_CacheRecordController.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_TaskController.h"
#import "JUDIAN_READ_SetController.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_ShelfTopView.h"
#import "JUDIAN_READ_InviteFriendController.h"
#import "JUDIAN_READ_MyController.h"
#import "JUDIAN_READ_MyInfoController.h"
#import "JUDIAN_READ_CoinRecordController.h"
#import "JUDIAN_READ_SortNameController.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_SuggestDetailController.h"
#import "JUDIAN_READ_MyIncomeController.h"
#import "JUDIAN_READ_MakeMoneyController.h"
#import "JUDIAN_READ_MessageController.h"
#import "JUDIAN_READ_RecruitSubordinateViewController.h"

#define DefTitles @[@"提现",@"收入记录",@"元宝任务",@"福利商城",@"消息"]
#define DefImgs @[@"my_icon_withdrawal",@"my_icon_income",@"my_icon_gold",@"my_icon_envelope",@"my_icon_members"]

@interface JUDIAN_READ_MyController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray  *leadArr;
@property (nonatomic,strong) UIView  *headSectionView;
@property (nonatomic,strong) JUDIAN_READ_MyHeadView  *headView;
@property (nonatomic,strong) UIView  *headBotView;


@property (nonatomic,strong) NSMutableArray *imgNameArr;
@property (nonatomic,strong) NSMutableArray  *vcArr;
@property (nonatomic,strong) NSString  *hobby;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) JUDIAN_READ_ShelfTopView  *bottomView;
@property (nonatomic,strong) UIView  *noticeView;


@end

@implementation JUDIAN_READ_MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self showView];
}

- (void)showView{
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    JUDIAN_READ_AppDelegate *del = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (settings.types == UIUserNotificationTypeNone && del.needShow) {
        [self.view addSubview:self.footView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    [self loadData];
    
};

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"isFirstIntoPersonCenter"] && [JUDIAN_READ_Account currentAccount].oldVip.intValue == 1) {
        [kKeyWindow addSubview:self.noticeView];
        [def setObject:@"isNot" forKey:@"isFirstIntoPersonCenter"];
    }
}

#pragma mark 网络请求
- (void)loadData{
    if ([JUDIAN_READ_Account currentAccount].token.length) {
        [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
            if (result) {
                [self updateVip];
                [self updateInvite];
                [self.headView setPersonInfoWithData:[JUDIAN_READ_Account currentAccount]];
                [self updateUI];
            }
        }];
    }
    [self updateVip];
    [self updateInvite];
    [self.headView setPersonInfoWithData:[JUDIAN_READ_Account currentAccount]];
    [self updateUI];
}

- (void)updateVip{
    if ([JUDIAN_READ_Account currentAccount].vip_type.intValue == 5) {
        if ([self.leadArr[1] containsObject:@"会员中心"]) {
            [self.leadArr[1] removeLastObject];
            [self.imgNameArr removeLastObject];
            [self.vcArr[1] removeLastObject];;
        }
        
    }else{
        if (![self.leadArr[1] containsObject:@"会员中心"]) {
            [self.leadArr[1] addObject:@"会员中心"];
            [self.imgNameArr addObject:@"my_icon_members"];
            [self.vcArr[1] addObject:@"JUDIAN_READ_VipController"];
        }
    }
}


- (void)updateUI{

    self.bottomView.imgName = @"my_icon_we2";

    [self.tableView reloadData];
}

- (void)updateInvite{
//    if ([JUDIAN_READ_Account currentAccount].token) {
//        if (![self.leadArr[0] containsObject:@"消息"]) {
//            self.vcArr[0][0] = @"JUDIAN_READ_WeChatLoginController";
//            self.vcArr[0][1] = @"JUDIAN_READ_WeChatLoginController";
//            [self.leadArr[0] insertObject:@"消息" atIndex:4];
//            [self.imgNameArr insertObject:@"my_icon_invite_code" atIndex:4];
//            [self.vcArr[0] insertObject:@"JUDIAN_READ_SuggestDetailController" atIndex:4];
//        }
//    }else{
//        if ([self.leadArr[0] containsObject:@"消息"]) {
//            [self.leadArr[0] removeObjectAtIndex:4];
//            [self.imgNameArr removeObjectAtIndex:4];
//            [self.vcArr[0] removeObjectAtIndex:4];
//        }
//    }
    [self updateFrame];
}

- (void)updateFrame{
    NSArray *titles = self.leadArr[0];
    for (int i = 0; i < [titles count]; i++) {
        JUDIAN_READ_ShelfTopView *view = (JUDIAN_READ_ShelfTopView *)self.headBotView.subviews[i];
        CGFloat width = SCREEN_WIDTH/titles.count;
        view.frame = CGRectMake(i*width, 20, width, 80-20);
        [view changeTopViewFrame:CGRectMake(0, 0, width, 28) bottomFrame:CGRectMake(0, 32, width, 13)];
    }
    JUDIAN_READ_ShelfTopView *view = (JUDIAN_READ_ShelfTopView *)self.headBotView.subviews.lastObject;
    view.hidden = [JUDIAN_READ_Account currentAccount].token ? NO : YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = kBackColor;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.leadArr[1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_MyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseHomeCell" forIndexPath:indexPath];
    [cell setHomeDataWithModel:self.leadArr[1] indexPath:indexPath];
    cell.switchBlock = ^{
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row == 2 || indexPath.row == 4) && ![JUDIAN_READ_Account currentAccount].token) {
        JUDIAN_READ_WeChatLoginController *vc = [JUDIAN_READ_WeChatLoginController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == [self.vcArr[1] count] - 4) {
        [self join];
        return;
    }
    
    if (indexPath.row == 2) {
#if 1
        [JUDIAN_READ_InviteFriendController enterInviteFriendController:self.navigationController];
#else
        [JUDIAN_READ_RecruitSubordinateViewController enterRecruitSubordinateController:self.navigationController];
#endif
        [GTCountSDK trackCountEvent:@"Invite_friends" withArgs:@{@"source":@"我的"}];
        [MobClick event:@"Invite_friends" attributes:@{@"source":@"我的"}];
        return;
    }
    
    NSString* viewControllerName = [self getControllerName:indexPath];
    if (viewControllerName.length > 0) {
        JUDIAN_READ_BaseViewController *vc = (JUDIAN_READ_BaseViewController *)[NSClassFromString(viewControllerName) new];
        if (indexPath.row == [self.vcArr[1] count] - 1) {
            JUDIAN_READ_BannarWebController *vc1 = (JUDIAN_READ_BannarWebController *)vc;
            NSMutableString *requestPath = [NSMutableString stringWithString:API_HOST_NAME];
            [requestPath appendString:_USER_FAQ_LINK_];
            vc1.url = requestPath;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (NSString*)getControllerName:(NSIndexPath*)indexPath {
    
    if (indexPath.section >= self.vcArr.count) {
        return @"";
    }
    
    NSArray* subArray = self.vcArr[1];
    if (indexPath.row >= subArray.count) {
        return @"";
    }
    
    NSString* name = self.vcArr[1][indexPath.row];
    return name;
}


- (BOOL)join{
    return [JUDIAN_READ_TestHelper joinQQGroup];
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-55)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headSectionView;
        _tableView.backgroundColor = kColorWhite;
        _tableView.rowHeight = 50;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_MyHomeCell class]) bundle:nil] forCellReuseIdentifier:@"ReuseHomeCell"];
    }
    return _tableView;
}

- (UIView *)headSectionView{
    if (!_headSectionView) {
        _headSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170+90)];
        _headSectionView.backgroundColor = kColorWhite;
        [_headSectionView addSubview:self.headView];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 10)];
        sepView.backgroundColor = kBackColor;
        [_headSectionView addSubview:sepView];
        
        [_headSectionView addSubview:self.headBotView];
        
    }
    return _headSectionView;
}

- (UIView *)headBotView{
    if (!_headBotView) {
        _headBotView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 80)];
        NSArray *titles = DefTitles;
        NSArray *imgs = DefImgs;
        WeakSelf(obj);
        for (int i = 0; i < [titles count]; i++) {
            CGFloat width = SCREEN_WIDTH/titles.count;
            JUDIAN_READ_ShelfTopView *view = [[JUDIAN_READ_ShelfTopView alloc]initWithFrame:CGRectMake(i*width, 20, width, 80-20) imagesName:imgs[i] title:titles[i]];
            [view changeTopViewFrame:CGRectMake(0, 0, width, 28) bottomFrame:CGRectMake(0, 32, width, 13)];
            view.bottomTextFont = kFontSize12;
            [_headBotView addSubview:view];
            if (i == 4) {
                self.bottomView = view;
            }
            view.touchBlock = ^{
                if (i == 2) {
                    [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:self.navigationController];
                    [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"source":@"我的"}];
                    [MobClick event:@"make_money_task" attributes:@{@"source":@"我的"}];
                    return;
                }
                if (i == 3) {
                    JUDIAN_READ_BannarWebController *vc = [JUDIAN_READ_BannarWebController shareInstance];
                    vc.title = @"福利商城";
                    vc.url = @"goldmall";
                    [obj.navigationController pushViewController:vc animated:YES];
                    return;
                }
                
                JUDIAN_READ_BaseViewController *vc = (JUDIAN_READ_BaseViewController *)[NSClassFromString(obj.vcArr[0][i]) new];
                [obj.navigationController pushViewController:vc animated:YES];
                
            };
        }

    
    }
    return _headBotView;
}





- (JUDIAN_READ_MyHeadView *)headView{
    if (!_headView) {
        WeakSelf(obj);
        _headView = [[JUDIAN_READ_MyHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        _headView.removeSelfBlock = ^{
            CATransition *transition1 = [CATransition animation];
            transition1.duration = 0.3;
            transition1.type = kCATransitionPush;
            transition1.subtype = kCATransitionFromRight;
            [obj.navigationController.view.layer addAnimation:transition1 forKey:nil];
            [obj.navigationController popViewControllerAnimated:YES];
        };
        _headView.indexBlock = ^(id result, id error) {
            NSString *str;
            if ([JUDIAN_READ_Account currentAccount].token) {
                if (![result intValue]) {
                    JUDIAN_READ_SortNameController *vc = [JUDIAN_READ_SortNameController new];
                    [obj.navigationController pushViewController:vc animated:YES];
                    str = @"昨日阅读排名的点击";
                    
                }else{
                    str = [result intValue] == 1 ? @"我的现金" : @"我的元宝";
                    if ([result intValue] == 1) {
                        JUDIAN_READ_MyIncomeController *vc = [JUDIAN_READ_MyIncomeController new];
                        [obj.navigationController pushViewController:vc animated:YES];
                    }else{
                        JUDIAN_READ_CoinRecordController *vc = [JUDIAN_READ_CoinRecordController new];
                        [obj.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                [GTCountSDK trackCountEvent:@"click_my" withArgs:@{str:str}];
                [MobClick event:@"click_my" attributes:@{str:str}];
                
            }else{
                JUDIAN_READ_WeChatLoginController *vc = [[JUDIAN_READ_WeChatLoginController alloc]init];
                [obj.navigationController pushViewController:vc animated:YES];
            }
        };
        
        _headView.loginBlock = ^(id result, id error) {
            if ([result intValue] != 2) {
                [GTCountSDK trackCountEvent:@"click_my" withArgs:@{@"touchPersonIcon":@"用户个人头像的点击"}];
                [MobClick event:@"click_my" attributes:@{@"touchPersonIcon":@"用户个人头像的点击"}];
                if ([result isEqualToString:@"1"]) {
                    JUDIAN_READ_WeChatLoginController *vc = [JUDIAN_READ_WeChatLoginController new];
                    [obj.navigationController pushViewController:vc animated:YES];
                }else{
                    JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
                    vc.isSelf = YES;
                    vc.uid_b = [JUDIAN_READ_Account currentAccount].uid;
                    [obj.navigationController pushViewController:vc animated:YES];
                }
            }else{
                JUDIAN_READ_VipController *vc = [JUDIAN_READ_VipController new];
                [obj.navigationController pushViewController:vc animated:YES];
            }
            
        };
    }
    return _headView;
}

- (NSMutableArray *)leadArr{
    if (!_leadArr) {
          NSMutableArray *arr0 = [JUDIAN_READ_Account currentAccount].token ? ([DefTitles mutableCopy]) :  ([@[@"提现",@"收入记录",@"元宝任务",@"福利商城"] mutableCopy]);
        
        NSMutableArray *arr = [JUDIAN_READ_Account currentAccount].vip_type.intValue != 5 ? ([@[@"每日签到提醒",@"书籍更新提醒",@"邀请好友",@"会员中心",@"缓存记录",@"客服QQ群",@"设置",@"关于我们",@"反馈与帮助"] mutableCopy]) :  ([@[@"每日签到提醒",@"书籍更新提醒",@"邀请好友",@"缓存记录",@"客服QQ群",@"设置",@"关于我们",@"反馈与帮助"] mutableCopy]);
        _leadArr = [NSMutableArray arrayWithObjects:arr0,arr,nil];
    }
    return _leadArr;
}

- (NSMutableArray *)imgNameArr{
    if (!_imgNameArr) {
        _imgNameArr = ![JUDIAN_READ_Account currentAccount].token ?
        ([DefImgs mutableCopy]): ([@[@"my_icon_friends",@"my_icon_envelope",@"my_icon_gold",@"my_icon_members"] mutableCopy]);
    }
    return _imgNameArr;
}

- (NSMutableArray *)vcArr{
    if (!_vcArr) {
        NSMutableArray *arr0 = [JUDIAN_READ_Account currentAccount].token ? ([@[@"JUDIAN_READ_MakeMoneyController",@"JUDIAN_READ_MyIncomeController",@"JUDIAN_READ_UserEarningsViewController",@"JUDIAN_READ_BannarWebController",@"JUDIAN_READ_MessageController"] mutableCopy]) :  ([@[@"JUDIAN_READ_WeChatLoginController",@"JUDIAN_READ_WeChatLoginController",@"JUDIAN_READ_UserEarningsViewController",@"JUDIAN_READ_BannarWebController",@"JUDIAN_READ_MessageController"] mutableCopy]);
        NSArray *arr = ([JUDIAN_READ_Account currentAccount].vip_type.intValue != 5) ? [@[@"",@"",@"JUDIAN_READ_InviteFriendController",@"JUDIAN_READ_VipController",@"JUDIAN_READ_CacheRecordController",@"",@"JUDIAN_READ_SetController",@"JUDIAN_READ_AboutUsController",@"JUDIAN_READ_BannarWebController"] mutableCopy]: [@[@"",@"",@"JUDIAN_READ_InviteFriendController",@"JUDIAN_READ_CacheRecordController",@"",@"JUDIAN_READ_SetController",@"JUDIAN_READ_AboutUsController",@"JUDIAN_READ_BannarWebController"] mutableCopy];
        _vcArr = [NSMutableArray arrayWithObjects:arr0,arr,nil];
    }
    return _vcArr;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(15, ScreenHeight-BottomHeight-10-67, SCREEN_WIDTH-30, 67)];
        _footView.backgroundColor = kColorWhite;
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:_footView.bounds];
        imgV.image = [UIImage imageNamed:@"my_sign_bg"];
        imgV.userInteractionEnabled = YES;
        [_footView addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
        [lab setText:@"重要信息早知道" titleFontSize:15 titleColot:kColor51];
        [imgV addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectZero];
        [lab1 setText:@"开启通知，第一时间了解新书、赚钱福利" titleFontSize:12 titleColot:kColor100];
        [imgV addSubview:lab1];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"notification_swich_image"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(openRemtotion) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"sign_window_close"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:btn1];
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(15);
        }];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.bottom.mas_equalTo(-16);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(-30);
        }];
        
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3);
            make.trailing.mas_equalTo(-7);
        }];
        
    }
    return _footView;
}

- (void)openRemtotion{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}

- (void)delAction{
    JUDIAN_READ_AppDelegate *del = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    del.needShow = NO;
    [self.footView removeFromSuperview];
}

- (UIView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[UIView alloc]initWithFrame:kKeyWindow.bounds];
        _noticeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-251)/2, 34+Height_NavBar, 251, 375/2)];
        imgV.image = [UIImage imageNamed:@"my_prompt"];
        [_noticeView addSubview:imgV];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"how_browse_guide_know"] forState:UIControlStateNormal];
        btn.frame = CGRectMake((SCREEN_WIDTH-133)/2, SCREEN_HEIGHT-97-40-BottomHeight, 133, 40);
        [btn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [_noticeView addSubview:btn];
        
    }
    return _noticeView;
}

- (void)dismissSelf{
    [self.noticeView removeFromSuperview];
}

- (void)dealloc{
    
}

@end
