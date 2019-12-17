//
//  JUDIAN_READ_MyIncomeController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MyIncomeController.h"
#import "JUDIAN_READ_CoinCell.h"
#import "JUDIAN_READ_WithdrawController.h"
#import "JUDIAN_READ_MakeMoneyController.h"


@interface JUDIAN_READ_MyIncomeController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *arr;
@property (nonatomic,strong) UIButton  *withDrawBtn;



@end

@implementation JUDIAN_READ_MyIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收入";
    [self addItem];
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [kKeyWindow addSubview:self.withDrawBtn];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.withDrawBtn removeFromSuperview];
}

- (void)addItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(detailAction)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontSize14, NSFontAttributeName,kColor51, NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)detailAction{
    JUDIAN_READ_WithdrawController *vc = [JUDIAN_READ_WithdrawController new];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_CoinCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_CoinCell"];
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

- (UIButton *)withDrawBtn{
    if (!_withDrawBtn) {
        _withDrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withDrawBtn addTarget:self action:@selector(withDrawAction) forControlEvents:UIControlEventTouchUpInside];
        [_withDrawBtn setBackgroundImage:[UIImage imageNamed:@"bounced_btn"] forState:UIControlStateNormal];
        [_withDrawBtn setText:@"提现" titleFontSize:16 titleColot:kColorWhite];
        _withDrawBtn.frame = CGRectMake((SCREEN_WIDTH-207)/2, SCREEN_HEIGHT - 40-33- BottomHeight, 207, 40);
    }
    return _withDrawBtn;
}

- (void)withDrawAction{
    JUDIAN_READ_MakeMoneyController *vc = [JUDIAN_READ_MakeMoneyController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_CoinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_CoinCell" forIndexPath:indexPath];
    [cell setIncomeDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}



@end
