//
//  JUDIAN_READ_SuggestDetailController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SuggestDetailController.h"
#import "JUDIAN_READ_SuggestDetailCell.h"


@interface JUDIAN_READ_SuggestDetailController ()
@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *dataArr;



@end

@implementation JUDIAN_READ_SuggestDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的反馈";
    [self.view addSubview:self.tableView];
    [self loadData];
    
}


- (void)loadData{
    if (!self.type) {
        self.type = @"0";
    }
    NSMutableDictionary *dic = [@{@"type":self.type,@"pageSize":@"20",@"page":[NSString stringWithFormat:@"%ld",self.pageSize]} mutableCopy];
    if ([JUDIAN_READ_Account currentAccount].token) {
        [dic setObject:[JUDIAN_READ_Account currentAccount].uid forKey:@"uid_b"];
    }
    [JUDIAN_READ_MyTool getReplyListWithParams:dic completionBlock:^(id _Nullable result, id _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (result) {
            //下拉刷新
            if (!self.isPullDown) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:result];
            //没有更多
            if ([result count] < 20){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        self.isPullDown = NO;
        [self.tableView reloadData];
        
    }];
    
}


- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_SuggestDetailCell class]) bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_SuggestDetailCell"];
        WeakSelf(weakself);
        _tableView.emptyCallBack = ^(int type){
            weakself.pageSize = 1;
            [weakself loadData];
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

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_SuggestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_SuggestDetailCell" forIndexPath:indexPath];
    [cell setDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

@end
