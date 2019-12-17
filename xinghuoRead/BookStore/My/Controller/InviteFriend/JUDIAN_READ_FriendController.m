//
//  JUDIAN_READ_FriendController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_FriendController.h"
#import "JUDIAN_READ_FriendCell.h"
#import "JUDIAN_READ_MyInfoController.h"
#import "JUDIAN_READ_InviteFriendModel.h"
#import "JUDIAN_READ_UserShareCodeMenu.h"
#import <Photos/Photos.h>
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_InviteFriendPosterView.h"

@interface JUDIAN_READ_FriendController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) UIButton  *coinBtn;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) JUDIAN_READ_UserShareCodeMenu  *shareCodeMenu;
@property (nonatomic,strong) UIView  *headView;

@property (nonatomic,strong) NSMutableArray  *arr;


@end

@implementation JUDIAN_READ_FriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我邀请的好友";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    [self loadData];
}

#pragma mark 网络请求
- (void)loadData{
    NSMutableDictionary *dic = [@{@"uidb" :[JUDIAN_READ_Account currentAccount].uid} mutableCopy];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"page"];
    [JUDIAN_READ_MyTool getInviteFriendListWithParams:dic completionBlock:^(id result,id error){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (result) {
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
        }else{
        }
        self.isPullDown = NO;
        [self.tableView reloadData];
    }];
}




#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if(!_tableView){
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_FriendCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_FriendCell"];
        
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

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Content - 40 - 27, SCREEN_WIDTH, 40)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((SCREEN_WIDTH-207)/2, 0, 207, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"bounced_btn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bounced_btn"] forState:UIControlStateHighlighted];
        [btn setText:@"邀请更多好友" titleFontSize:17 titleColot:kColorWhite];
        [btn addTarget:self action:@selector(showShareMenu) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
    }
    return _footView;
}


- (void)showShareMenu {
    
    _shareCodeMenu = [[JUDIAN_READ_UserShareCodeMenu alloc]init];
    _shareCodeMenu.frame = self.view.bounds;
    [self.view addSubview:_shareCodeMenu];
    
    WeakSelf(that);
    _shareCodeMenu.block = ^(id  _Nullable args) {
        if (that.touchBlock) {
            that.touchBlock(args, nil);
        }
    };
    
    [_shareCodeMenu showView];
}




- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (UIView *)headView{
    if (!_headView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
        para.lineSpacing = 3;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1好友登录后的3天内，要阅读5分钟，才算邀请成功哦~" attributes:@{NSFontAttributeName: kFontSize12,NSForegroundColorAttributeName:kColor153,NSParagraphStyleAttributeName:para}];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 50)];
        lab.numberOfLines = 0;
        lab.attributedText = att;
        [view addSubview:lab];
        _headView = view;
    }
    return _headView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成功邀请好友数（%@）",[self.arr.firstObject pages]]];
    [att addAttributes:@{NSForegroundColorAttributeName:kColor51} range:NSMakeRange(0, 7)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 50)];
    [lab setText:@"" titleFontSize:14 titleColot:kThemeColor];
    lab.numberOfLines = 0;
    lab.attributedText = att;
    [view addSubview:lab];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_FriendCell" forIndexPath:indexPath];
    [cell setFriendDataWithBaseModel:self.arr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_InviteFriendModel *info = self.arr[indexPath.row];
    JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
    //vc.uid_b = info.uidb;
    if ([info isKindOfClass:[JUDIAN_READ_InviteFriendModel class]]) {
        vc.uid_b = info.uidb;
    }

    if ([[JUDIAN_READ_Account currentAccount].uid isEqualToString:info.ID]) {
        vc.isSelf = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



@end
