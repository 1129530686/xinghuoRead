//
//  JUDIAN_READ_AppreciatedChapterListViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/9/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AppreciatedChapterListViewController.h"
#import "JUDIAN_READ_NovelNavigationContainer.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_UserAppreciatedItemModel.h"
#import "JUDIAN_READ_UserContributionInfoCell.h"
#import "JUDIAN_READ_BaseTableView.h"
#import "JUDIAN_READ_UserAppreciatedChapterModel.h"
#import "JUDIAN_READ_ApprecaiteMoneyManager.h"
#import "JUDIAN_READ_AppreciateMoneyViewController.h"

#define APPRECIATE_BUTTON_HEIGHT 40

@interface JUDIAN_READ_AppreciatedChapterListViewController ()
@property(nonatomic, weak)JUDIAN_READ_NovelNavigationContainer* navigationContainer;
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, strong)NSMutableArray* dataArray;
@property(nonatomic, weak)UIButton* appreciateButton;
@property(nonatomic, strong)JUDIAN_READ_ApprecaiteMoneyManager* moneyManager;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, copy)NSString* chapterId;
@end

@implementation JUDIAN_READ_AppreciatedChapterListViewController


+ (void)enterUserListViewController:(UINavigationController*)naviagtionViewController bookId:(NSString*)bookId chapterId:(NSString*)chapterId {
    JUDIAN_READ_AppreciatedChapterListViewController* viewController = [[JUDIAN_READ_AppreciatedChapterListViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.bookId = bookId;
    viewController.chapterId = chapterId;
    [naviagtionViewController pushViewController:viewController animated:YES];
}






- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageIndex = 1;
    _dataArray = [NSMutableArray array];
    
    [self addNavigationView];
    [self addTableView];
    [self addBottomButton];
    
    [self loadUserAppreciatedList:_pageIndex];
    
}



- (void)viewWillAppear:(BOOL)animated {
    self.hideBar = YES;
    [super viewWillAppear:animated];
    
    
}


- (void)addNavigationView {
    
    JUDIAN_READ_NovelNavigationContainer* container = [[JUDIAN_READ_NovelNavigationContainer alloc]init];
    _navigationContainer = container;
    [self.view addSubview:container];
    
    [container changeBarTransparent:1];
    [container setTitle:@"读者赞赏"];
    [container showShareButton:NO];
    
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGB(0xee, 0xee, 0xee);
    [container addSubview:lineView];
    
    
    CGFloat height = [self getNavigationHeight];
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(height));
        make.top.equalTo(that.view.mas_top);
    }];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.width.equalTo(container.mas_width);
        make.bottom.equalTo(container.mas_bottom).offset(-0.5);
    }];
    
    
    container.navigationBar.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"0"]) {
            [that popViewController];
        }
    };
    
}




- (void)addTableView {
    
    NSInteger yPosition = [self getNavigationHeight];
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    
    NSInteger height = SCREEN_HEIGHT - yPosition - bottomOffset;
    JUDIAN_READ_BaseTableView* tableView = [[JUDIAN_READ_BaseTableView alloc] initWithFrame:CGRectMake(0, yPosition, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 27 + APPRECIATE_BUTTON_HEIGHT, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.noticeTitle = @"您还没有赞赏过哟~";
    [tableView registerClass:[JUDIAN_READ_UserContributionInfoCell class] forCellReuseIdentifier:@"UserContributionInfoCell"];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    WeakSelf(that);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        that.pageIndex = 1;
        [that.dataArray removeAllObjects];
        [that loadUserAppreciatedList:that.pageIndex];
        
    }];
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        that.pageIndex++;
        [that loadUserAppreciatedList:that.pageIndex];
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
    [appreciateButton setTitle:@"我也要赞赏   >" forState:UIControlStateNormal];
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



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview delegate & datasource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    JUDIAN_READ_UserContributionInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserContributionInfoCell"];
    if (_dataArray.count > 0) {
        [cell updateChapterContribution:_dataArray[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 66;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark 加载记录
- (void)loadUserAppreciatedList:(NSInteger)index {
    
    NSString* pageIndexStr = [NSString stringWithFormat:@"%ld", index];
    
    
    if (!_bookId || !_chapterId) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"id": _bookId,
                                 @"chapnum": _chapterId,
                                 @"page":pageIndexStr,
                                 //@"pageSize":@"1000000"
                                 
                                 };
    
    WeakSelf(that);
    if(_pageIndex <= 1) {
        [MBProgressHUD showLoadingForView:_tableView];
    }
    
    [[JUDIAN_READ_NovelManager shareInstance] getUserAppreciateAvatarList:dictionary block:^(NSArray* array, NSNumber* total) {

        [MBProgressHUD hideHUDForView:that.tableView];

        [that.tableView.mj_header endRefreshing];
        [that.tableView.mj_footer endRefreshing];
        
        //NSString* pageSizeStr = dictionary[@"total_page"];
        //that.pageSize = [pageSizeStr intValue];
        
        //NSArray* appreciatedArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserAppreciatedItemModel class] json:array];
        
        if (array.count > 0) {
            [that.dataArray addObjectsFromArray:array];
        }
        
        if (that.pageIndex > total.integerValue) {
            [that.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [that.tableView reloadData];
    
    } needTotalPage:TRUE];
    
}


#pragma mark 赞赏
- (void)initAppriciateMoneyManager {
    if (_moneyManager) {
        return;
    }
    
    WeakSelf(that);
    _moneyManager = [[JUDIAN_READ_ApprecaiteMoneyManager alloc] initWithView:self.view];
    _moneyManager.block = ^(id  _Nullable args) {
        that.pageIndex = 1;
        [that.dataArray removeAllObjects];
        [that loadUserAppreciatedList:that.pageIndex];
    };
}

- (void)handleTouchEvent:(id)sender {
    
#if 0
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
#endif
    
    [JUDIAN_READ_AppreciateMoneyViewController enterAppreciateMoneyViewController:self.navigationController bookId:_bookId chapterId:_chapterId source:@"阅读器的章节赞赏" block:^(id  _Nullable args) {
        
    }];
    
    
}

@end
