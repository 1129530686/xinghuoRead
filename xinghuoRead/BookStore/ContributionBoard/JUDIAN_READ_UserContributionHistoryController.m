//
//  JUDIAN_READ_UserContributionHistoryController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserContributionHistoryController.h"
#import "JUDIAN_READ_UserEarningsNavigationView.h"
#import "JUDIAN_READ_UserContributionMoneyCell.h"
#import "JUDIAN_READ_UserContributionModel.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"

#define UserContributionMoneyCell @"UserContributionMoneyCell"
#define APPRECIATE_BUTTON_HEIGHT 40

@interface JUDIAN_READ_UserContributionHistoryController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak)JUDIAN_READ_UserEarningsNavigationView* navigationView;
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, strong)NSMutableArray* historyArray;
@property(nonatomic, weak)UIButton* appreciateButton;
@property(nonatomic, copy)modelBlock payBlock;
@property(nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@end

@implementation JUDIAN_READ_UserContributionHistoryController


+ (void)enterContributionHistory:(UINavigationController*)navigationController block:(modelBlock)block {
#if 0
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (token.length <= 0) {
        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
        [navigationController pushViewController:loginVC animated:YES];
        return;
    }
#endif
    
    JUDIAN_READ_UserContributionHistoryController* viewController = [[JUDIAN_READ_UserContributionHistoryController alloc] init];
    viewController.payBlock = block;
    viewController.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyArray = [NSMutableArray array];
    self.pageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationView];
    
    [self addTableView];
    [self addBottomButton];
    
    [self loadHistoryData];
}


- (void)viewWillAppear:(BOOL)animated {
    self.hideBar = YES;
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)addNavigationView {
    
    JUDIAN_READ_UserEarningsNavigationView* view = [[JUDIAN_READ_UserEarningsNavigationView alloc]init];
    _navigationView = view;
    [view updateUserBriefNavigation:@"打赏记录" rightTitle:@""];
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
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    JUDIAN_READ_BaseTableView* tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 27 + APPRECIATE_BUTTON_HEIGHT, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_UserContributionMoneyCell class] forCellReuseIdentifier:@"UserContributionMoneyCell"];
    
    
    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.navigationView.mas_bottom);
        make.bottom.equalTo(that.view.mas_bottom).offset(0);
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
    }];
    
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        that.pageIndex = 1;
        [that.historyArray removeAllObjects];
        [that loadHistoryData];
    }];
    
    //[header setBackgroundColor:READER_SETTING_PANEL_BUTTON_CLICKED_COLOR];
    tableView.mj_header = header;
    
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        that.pageIndex++;
        [that loadHistoryData];
    }];
    tableView.mj_footer = foot;
}




- (void)addBottomButton {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _appreciateButton = appreciateButton;
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
    return 66;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JUDIAN_READ_UserContributionMoneyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserContributionMoneyCell"];
    if (_historyArray.count > 0) {
        [cell updateCell:_historyArray[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 加载数据

- (void)loadHistoryData {
    
    NSString* pageIndexStr = [NSString stringWithFormat:@"%ld", (long)_pageIndex];
    
    WeakSelf(that);
    [JUDIAN_READ_UserContributionMoneyModel buildModel:^(NSArray* _Nullable array, NSNumber* _Nullable totalPage) {
        
        [that.tableView.mj_header endRefreshing];
        [that.tableView.mj_footer endRefreshing];
        
        if (totalPage.intValue <= 1) {
            that.tableView.mj_footer.hidden = YES;
        }
        else {
            that.tableView.mj_footer.hidden = NO;
        }
        
        if (totalPage.intValue <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
            });
            
            return;
        }
        
        if (that.pageIndex > totalPage.intValue) {
            [that.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }

        [that.historyArray addObjectsFromArray:array];
        [that.tableView reloadData];

    } pageIndex:pageIndexStr];

}



- (NSInteger)getTipViewTop {
    
    NSInteger top = 64;
    if (iPhoneX) {
        top = 88;
    }
    
    return top;
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
    [self.moneyManager appreciateMoney:dictonary source:@"我的赞赏记录"];
    
    
}



- (void)initAppriciateMoneyManager {
    if (_moneyManager) {
        return;
    }
    
    WeakSelf(that);
    _moneyManager = [[JUDIAN_READ_ApprecaiteMoneyManager alloc] initWithView:self.view];
    _moneyManager.block = ^(id  _Nullable args) {
        if (that.payBlock) {
            that.payBlock(nil);
        }
    };
}


@end
