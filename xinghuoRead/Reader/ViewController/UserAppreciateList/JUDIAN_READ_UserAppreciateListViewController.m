//
//  JUDIAN_READ_UserAppreciateListViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/5/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserAppreciateListViewController.h"
#import "JUDIAN_READ_NovelNavigationContainer.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_UserAppreciatedItemModel.h"
#import "JUDIAN_READ_UserAppreciateListCell.h"
#import "JUDIAN_READ_BaseTableView.h"

@interface JUDIAN_READ_UserAppreciateListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak)JUDIAN_READ_NovelNavigationContainer* navigationContainer;
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, assign)NSInteger pageIndex;
//@property(nonatomic, assign)NSInteger pageSize;
@property(nonatomic, strong)NSMutableArray* dataArray;
@end

@implementation JUDIAN_READ_UserAppreciateListViewController



+ (void)enterViewController:(UINavigationController*)naviagtionViewController {
    UIViewController* viewController = [[JUDIAN_READ_UserAppreciateListViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    [naviagtionViewController pushViewController:viewController animated:YES];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageIndex = 1;
    _dataArray = [NSMutableArray array];
    
    [self addNavigationView];
    [self addTableView];
    
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
    [container setTitle:@"我的赞赏"];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.noticeTitle = @"您还没有赞赏过哟~";
    
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
    
    JUDIAN_READ_UserAppreciateListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appreciatedCell"];
    if (!cell) {
       cell = [[JUDIAN_READ_UserAppreciateListCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"appreciatedCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(_dataArray.count > 0) {
        JUDIAN_READ_UserAppreciatedItemModel* model = _dataArray[indexPath.row];
        [cell setAppreciatedInfoWithMode:model];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 60;
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
    [MBProgressHUD showLoadingForView:_tableView];
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getFictionAppreciateList:pageIndexStr block:^(id  _Nonnull parameter) {
        [MBProgressHUD hideHUDForView:that.tableView];
        
        [that.tableView.mj_header endRefreshing];
        [that.tableView.mj_footer endRefreshing];
        
        NSDictionary* dictionary = parameter;
        NSArray* array = dictionary[@"list"];
        NSString* pageSizeStr = dictionary[@"total_page"];
        that.pageSize = [pageSizeStr intValue];

        NSArray* appreciatedArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserAppreciatedItemModel class] json:array];
        
        if (appreciatedArray.count > 0) {
            [that.dataArray addObjectsFromArray:appreciatedArray];
        }
        
        if (that.pageIndex > that.pageSize) {
            [that.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        [that.tableView reloadData];
        
    }];
    
    
}



@end
