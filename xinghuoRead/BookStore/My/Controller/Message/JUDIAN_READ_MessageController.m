//
//  JUDIAN_READ_MessageController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//
#import "JUDIAN_READ_MessageCell.h"
#import "JUDIAN_READ_MessageController.h"
#import "JUDIAN_READ_MessageDetailController.h"

@interface JUDIAN_READ_MessageController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *arr;

@end

@implementation JUDIAN_READ_MessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
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
        _tableView.rowHeight = 66;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_MessageCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_MessageCell"];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count+4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_MessageCell" forIndexPath:indexPath];
    [cell setMessageDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_MessageDetailController *vc = [JUDIAN_READ_MessageDetailController new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
