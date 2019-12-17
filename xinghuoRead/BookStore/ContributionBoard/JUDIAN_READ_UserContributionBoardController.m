//
//  JUDIAN_READ_UserContributionBoardController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserContributionBoardController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_ContributionBoardTipCell.h"
#import "JUDIAN_READ_ContributionBoardTop3Cell.h"
#import "JUDIAN_READ_UserContributionInfoCell.h"
#import "JUDIAN_READ_UserContributionModel.h"
#import "JUDIAN_READ_UserContributionHistoryController.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"
#import "JUDIAN_READ_MyInfoController.h"

#define ContributionBoardTipCell @"ContributionBoardTipCell"
#define ContributionBoardTop3Cell @"ContributionBoardTop3Cell"
#define UserContributionInfoCell @"UserContributionInfoCell"

#define APPRECIATE_BUTTON_HEIGHT 40

@interface JUDIAN_READ_UserContributionBoardController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, strong)JUDIAN_READ_ContributionBoardTipCell* tipCell;
@property(nonatomic, weak)JUDIAN_READ_UserEarningsNavigationView* navigationView;

@property(nonatomic, strong)NSMutableArray* top3Array;
@property(nonatomic, strong)NSMutableArray* contributionArray;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, weak)UIView* bgView;
@property(nonatomic, assign)NSInteger topOffset;
@property(nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@property(nonatomic, weak)JUDIAN_READ_ContributionBoardTipView* tipView;
@property(nonatomic, weak)JUDIAN_READ_UserContributionView* userContributionView;
@end

@implementation JUDIAN_READ_UserContributionBoardController


+ (void)enterUserContributionBoard:(UINavigationController*)navigationController {
    
    JUDIAN_READ_UserContributionBoardController* viewController = [[JUDIAN_READ_UserContributionBoardController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addGradientLayer];
    
    _pageIndex = 1;
    [self addNavigationView];
    [self addContributionTipView];
    [self addUserContributionView];
    [self addBgView];
    
    [self addTableView];
    [self addBottomButton];
    
    [self loadUserContributionList];
}

-(void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        [_bgView clipCorner:CGSizeMake(10, 10) corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
}

- (void)addGradientLayer {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(0xE8, 0x1D, 0x52).CGColor, (__bridge id)RGB(0xfc, 0x53, 0x46).CGColor];
    //gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view.layer addSublayer:gradientLayer];
    
}



- (void)addContributionTipView {
    
    JUDIAN_READ_ContributionBoardTipView* tipView = [[JUDIAN_READ_ContributionBoardTipView alloc] init];
    _tipView = tipView;
    [self.view addSubview:tipView];
    CGFloat height = [tipView getCellHeight];
    height = ceil(height);
    
    WeakSelf(that);
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(14);
        make.right.equalTo(that.view.mas_right).offset(-14);
        make.top.equalTo(that.navigationView.mas_bottom);
        make.height.equalTo(@(height));
    }];
}



- (void)addUserContributionView {

    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        return;
    }
    
    JUDIAN_READ_UserContributionView* userContributionView = [[JUDIAN_READ_UserContributionView alloc] init];
    [self.view addSubview:userContributionView];
    _userContributionView = userContributionView;
    WeakSelf(that);
    [userContributionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(7);
        make.right.equalTo(that.view.mas_right).offset(-7);
        make.top.equalTo(that.tipView.mas_bottom);
        make.height.equalTo(@(100));
    }];
    
}


- (void)addHeadView {
    
    CGFloat bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIView* headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
}

- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    _navigationView = view;
    [view updateEarningsNavigation:@"贡献榜" rightTitle:@"打赏记录"];
    view.backgroundColor = [UIColor clearColor];;
    [self.view addSubview:view];
    

    WeakSelf(that);
    view.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"back"]) {
            [that.navigationController popViewControllerAnimated:YES];
        }
        else {
            [JUDIAN_READ_UserContributionHistoryController enterContributionHistory:that.navigationController block:^(id  _Nullable args) {
                [that loadTop20Hisotry];
            }];
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

    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    NSInteger inset = 27 + APPRECIATE_BUTTON_HEIGHT;
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, inset, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgView addSubview:tableView];
    
    _tipCell = [[JUDIAN_READ_ContributionBoardTipCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ContributionBoardTipCell];
    //[tableView registerClass:[JUDIAN_READ_ContributionBoardTop3Cell class] forCellReuseIdentifier:ContributionBoardTop3Cell];
    [tableView registerClass:[JUDIAN_READ_UserContributionInfoCell class] forCellReuseIdentifier:UserContributionInfoCell];
 
    _topOffset =  [_tipCell getCellHeight];
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(that.navigationView.mas_bottom);
        make.top.equalTo(that.bgView.mas_top);
        make.bottom.equalTo(that.bgView.mas_bottom);
        make.left.equalTo(that.bgView.mas_left).offset(0);
        make.right.equalTo(that.bgView.mas_right).offset(-0);
    }];
    
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [that loadTop20Hisotry];
    }];
    
    [header setBackgroundColor:[UIColor clearColor]];
    tableView.mj_header = header;
    //header.stateLabel.textColor = [UIColor whiteColor];
    //header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        that.pageIndex++;
        [that loadUserContributionList];
    }];
    //foot.stateLabel.textColor = [UIColor whiteColor];
    tableView.mj_footer = foot;
}



- (void)addBgView {
    
    UIView* bgView = [[UIView alloc] init];
    _bgView = bgView;
    bgView.backgroundColor = [UIColor whiteColor];
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        //bottomOffset = 34;
    }
    
    WeakSelf(that);
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        [self.view addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(that.tipView.mas_bottom);
            make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
            make.left.equalTo(that.view.mas_left).offset(17);
            make.right.equalTo(that.view.mas_right).offset(-17);
        }];
    }
    else {
        [self.view insertSubview:bgView belowSubview:_userContributionView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(that.userContributionView.mas_bottom).offset(-7);
            make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
            make.left.equalTo(that.view.mas_left).offset(17);
            make.right.equalTo(that.view.mas_right).offset(-17);
        }];
    }

}



- (void)addBottomButton {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
       // bottomOffset = 34;
    }
    
    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [appreciateButton setBackgroundImage:[UIImage imageNamed:@"user_appeciate_money_tip"] forState:UIControlStateNormal];
    appreciateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [appreciateButton setTitle:APP_I_WILL_APPRECIATE_MONEY_TIP forState:UIControlStateNormal];
    [appreciateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [appreciateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:appreciateButton];
    
    
    WeakSelf(that);
    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(207));
        make.centerX.equalTo(that.view.mas_centerX);
        make.height.equalTo(@(APPRECIATE_BUTTON_HEIGHT));
        make.bottom.equalTo(that.view.mas_bottom).offset(-27 - bottomOffset);
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [_tipCell getCellHeight];
        }
        
        if (indexPath.row == 1) {
            return 173 + 24;
        }
    }
    
    if (indexPath.section == 1) {
        return 66;
    }
    
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return _contributionArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _tipCell;
        }
    }
    
    
    if (indexPath.section == 1) {
        JUDIAN_READ_UserContributionInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:UserContributionInfoCell];
        if (_contributionArray.count > 0) {
            [cell updateUserContribution:_contributionArray[indexPath.row] row:(indexPath.row)];
        }
        cell.layer.zPosition = 1000;
        return cell;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (_contributionArray.count > 0) {
            JUDIAN_READ_UserContributionModel* model = _contributionArray[indexPath.row];
            [self enterUserHomeViewController:model];
        }
    }
}



- (void)enterUserHomeViewController:(JUDIAN_READ_UserContributionModel*) model {
    JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
    vc.uid_b = model.uidb;
    if ([[JUDIAN_READ_Account currentAccount].uid isEqualToString:model.uidb]) {
        vc.isSelf = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark 加载数据
- (void)loadUserContributionList {
    
    if (!_top3Array) {
        _top3Array = [NSMutableArray array];
    }
    
    if (!_contributionArray) {
        _contributionArray = [NSMutableArray array];
    }
    
    NSString* pageIndexStr = [NSString stringWithFormat:@"%ld", (long)_pageIndex];
    WeakSelf(that);
    
    [JUDIAN_READ_UserContributionModel buildModel:^(NSArray*  _Nullable array, NSNumber*  _Nullable totalPage) {
        NSInteger count = array.count;
    
        [that.tableView.mj_header endRefreshing];
        [that.tableView.mj_footer endRefreshing];
        
        if (that.pageIndex > totalPage.intValue) {
            if(totalPage.intValue <= 1) {
                that.tableView.mj_footer.hidden = YES;
            }
            else {
                that.tableView.mj_footer.hidden = NO;
            }
            
            [that.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        if (totalPage.intValue <= 1) {
            that.tableView.mj_footer.hidden = YES;
        }
        else {
            that.tableView.mj_footer.hidden = NO;
        }

        if (count >= 3) {
            
            NSInteger index = 0;
#if 0
            if (that.top3Array.count <= 0) {
                for (; index < 3; index++) {
                    [that.top3Array addObject:array[index]];
                }
            }
#endif

            for (; index < count; index++) {
                [that.contributionArray addObject:array[index]];
            }
        }

        [that.tableView reloadData];
        
    } pageIndex:pageIndexStr];

}


- (void)loadTop20Hisotry {
    self.pageIndex = 1;
    [self.top3Array removeAllObjects];
    [self.contributionArray removeAllObjects];
    [self loadUserContributionList];
}


#pragma mark 赞赏
- (void)handleTouchEvent:(id)sender {
    
    NSDictionary *dictonary = @{
                                @"payment_category":@"iap",
                                @"product_id" : @"1",
                                @"price" : @"8",
                                @"nid" : @"0",
                                @"chapnum" : @"0",
                                @"type":@"ios",
                                @"rewardType" : @"2"
                                };
    
    [self initAppriciateMoneyManager];
    [self.moneyManager appreciateMoney:dictonary source:@"书架的贡献榜"];
    
    
}



- (void)initAppriciateMoneyManager {
    if (_moneyManager) {
        return;
    }
    
    WeakSelf(that);
    _moneyManager = [[JUDIAN_READ_ApprecaiteMoneyManager alloc] initWithView:self.view];
    _moneyManager.block = ^(id  _Nullable args) {
        [that loadTop20Hisotry];
    };
}

- (void)dealloc {
    
}

@end
