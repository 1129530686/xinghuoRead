//
//  JUDIAN_READ_ WithdrawController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_WithdrawController.h"
#import "JUDIAN_READ_WithDrawCell.h"
#import "JUDIAN_READ_failCell.h"



@interface JUDIAN_READ_WithdrawController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_WithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)loadData{
    
    
}

#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if(!_tableView){
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:ViewFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_WithDrawCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_WithDrawCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_failCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_failCell"];
        
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

- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}



- (void)withDrawAction{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
        JUDIAN_READ_failCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_failCell" forIndexPath:indexPath];
        [cell setWithDrawDataWithBaseModel:self.arr indexPath:indexPath];
        return cell;
    }else{
        JUDIAN_READ_WithDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_WithDrawCell" forIndexPath:indexPath];
        [cell setWithDrawDataWithBaseModel:self.arr indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 66;
    }else{
        return 80;
    }
}


@end
