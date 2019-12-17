//
//  JUDIAN_READ_CoinRecordController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/21.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CoinRecordController.h"
#import "JUDIAN_READ_CoinHeadFooterView.h"
#import "JUDIAN_READ_CoinCell.h"
#import "JUDIAN_READ_GoldCoinModel.h"
#import "JUDIAN_READ_GoldCoinListModel.h"
#import "JUDIAN_READ_UserEarningsViewController.h"


@interface JUDIAN_READ_CoinRecordController ()
@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIButton  *coinBtn;
@property (nonatomic,strong) JUDIAN_READ_GoldCoinModel  *info;

@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_CoinRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的元宝";
    [self.view addSubview:self.tableView];
    [self loadData];
}

#pragma mark 网络请求
- (void)loadData{
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.pageSize]};
    [JUDIAN_READ_MyTool getMyCoinListWithParams:dic completionBlock:^(id result,id error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (result) {
            self.info = error;
            self.tableView.tableFooterView = nil;
            //下拉刷新
            if (!self.isPullDown) {
                [self.arr removeAllObjects];
            }
            [self.arr addObjectsFromArray:result];
            //没有更多
            if ([result count] < 20){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self updateInfo];
        self.isPullDown = NO;
        [self.tableView reloadData];
    }];
}

- (void)updateInfo{
    JUDIAN_READ_GoldCoinModel *model = self.info;
    [self.coinBtn setTitle:model.goldCoins forState:UIControlStateNormal];
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if(!_tableView){
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:ViewFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66;
        _tableView.noitceOperateImage = @"default_btn_make_money";
        _tableView.backgroundColor = kBackColor;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_CoinCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_CoinCell"];
        [_tableView registerClass:[JUDIAN_READ_CoinHeadFooterView class] forHeaderFooterViewReuseIdentifier:@"JUDIAN_READ_CoinHeadFooterView"];
        WeakSelf(weakself);
        _tableView.emptyCallBack = ^(int type){
            if (type == 1) {
                weakself.pageSize = 1;
                [weakself loadData];
            }else{
                [GTCountSDK trackCountEvent:@"make_money_task" withArgs:@{@"resource":@"我的金币页"}];
                [MobClick event:@"make_money_task" attributes:@{@"resource":@"我的金币页"}];
                [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:weakself.navigationController];
            }
        };
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isPullDown = NO;
            weakself.pageSize = 1;
            [weakself loadData];
        }];
        
        MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            weakself.isPullDown = YES;
            weakself.pageSize++;
            [weakself loadData];
        }];
        _tableView.mj_footer = foot;
        foot.stateLabel.textColor = kColor153;
        foot.stateLabel.font = kFontSize12;
        [foot setTitle:BOTTOM_LINE_TIP forState:MJRefreshStateNoMoreData];
        [foot setImages:nil forState:MJRefreshStateNoMoreData];
        
    }
    return _tableView;
}

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _headView.backgroundColor = kColorWhite;
        
        self.coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.coinBtn setText:@"0" titleFontSize:24 titleColot:RGB(255, 160, 48)];
        [self.coinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [self.coinBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.coinBtn setImage:[UIImage imageNamed:@"ingots_big_tip"] forState:UIControlStateNormal];
        self.coinBtn.frame = CGRectMake(15, 21, SCREEN_WIDTH - 30, 24);
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.coinBtn.frame)+6, SCREEN_WIDTH-30, 13)];
        [lab setText:@"我的元宝" titleFontSize:14 titleColot:kColor100];
        lab.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:self.coinBtn];
        [_headView addSubview:lab];

    }
    return _headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JUDIAN_READ_GoldCoinListModel *model = self.arr[section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_CoinCell" forIndexPath:indexPath];
    [cell setCoinDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JUDIAN_READ_CoinHeadFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JUDIAN_READ_CoinHeadFooterView"];
    [view setCoinDataWithModel:self.arr[section]];
    return view;
}


@end
