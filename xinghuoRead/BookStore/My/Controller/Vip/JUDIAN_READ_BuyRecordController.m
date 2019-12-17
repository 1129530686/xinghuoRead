//
//  JUDIAN_READ_BuyRecordController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/30.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BuyRecordController.h"
#import "JUDIAN_READ_BuyRecordCell.h"
#import "JUDIAN_READ_BuyRecordModel.h"


@interface JUDIAN_READ_BuyRecordController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_BuyRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买记录";
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)loadData{
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [JUDIAN_READ_MyTool getGuestChargeListWithParams:@{} completionBlock:^(id result, id error) {
            if (result) {
                //下拉刷新
                if (!self.isPullDown) {
                    [self.arr removeAllObjects];
                }
                //没有更多
                if([result count] < 20){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.arr addObjectsFromArray:result];
            }
            self.isPullDown = NO;
            [self.tableView reloadData];
        }];

    }else{
        [JUDIAN_READ_MyTool getBuyRecordWithParams:@{@"page":[NSString stringWithFormat:@"%ld",self.pageSize]} completionBlock:^(id result, id error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (result) {
                //下拉刷新
                if (!self.isPullDown) {
                    [self.arr removeAllObjects];
                }
                //没有更多
                if([result count] < 20){
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.arr addObjectsFromArray:result];
            }
            self.isPullDown = NO;
            [self.tableView reloadData];
        }];
    }
}


#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:ViewFrame];
        _tableView.rowHeight = 60;
        _tableView.noticeTitle = @"你还没有购买过哦～";
        _tableView.noitceOperateImage = @"purchase_btn";
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.verticalSpace = -60;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_BuyRecordCell class]) bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_BuyRecordCell"];
        WeakSelf(weakself);
        _tableView.emptyCallBack = ^(int type){
            if(type == 1){
                weakself.pageSize = 1;
                [weakself loadData];
            }else{
                [weakself.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_BuyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_BuyRecordCell" forIndexPath:indexPath];
    [cell setDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
