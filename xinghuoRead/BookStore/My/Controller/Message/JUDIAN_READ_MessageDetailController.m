//
//  JUDIAN_READ_MessageDetailController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/27.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_MessageDetailController.h"
#import "JUDIAN_READ_MessageCell.h"
#import "JUDIAN_READ_MessageDetailCell.h"


@interface JUDIAN_READ_MessageDetailController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *arr;
@property (nonatomic,strong) NSMutableArray  *timeArr;

@end

@implementation JUDIAN_READ_MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackColor;
    if (self.type == 0) {
        self.title = @"追书宝小助手";
    }else{
        self.title = @"系统通知";
    }
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
        _tableView.backgroundColor = kBackColor;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_MessageDetailCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_MessageDetailCell"];
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

- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr  = [NSMutableArray arrayWithObjects:@"1321",@"1321",@"1321",@"1321",@"1321", nil];
    }
    return _timeArr;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count + 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_MessageDetailCell" forIndexPath:indexPath];
    [cell setDetailDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    [view addSubview:lab];

    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.height.mas_equalTo(20);
    }];
    NSString *str = [NSString stringWithFormat:@"  %@  ",self.timeArr[section]];
    [lab setText:str titleFontSize:12 titleColot:kColorWhite];
    [lab doBorderWidth:0 color:nil cornerRadius:8];
    lab.backgroundColor = RGB(221, 221, 221);
    
    return view;
}

@end
