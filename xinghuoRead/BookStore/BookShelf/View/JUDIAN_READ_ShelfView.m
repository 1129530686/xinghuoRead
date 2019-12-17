//
//  JUDIAN_READ_ShelfView.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_NorvelShelfCell.h"
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_ShelfView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_CustomAlertView.h"
#import "JUDIAN_READ_NovelManager.h"

#define TableHeight SCREEN_HEIGHT-Height_NavBar-Height_TabBar-40
//#define TableHeight SCREEN_HEIGHT-Height_NavBar-Height_TabBar-22-40-100

@interface JUDIAN_READ_ShelfView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CustomAlertViewDelegate>

@property (nonatomic,assign) BOOL  isPullDown;
@property (nonatomic,assign) int  page;
@property (nonatomic,assign) int  page1;//第二个
@property (nonatomic,assign) BOOL  select;
@property (nonatomic,assign) BOOL  select1;//第二个
@property (nonatomic,strong) NSMutableArray  *dataArray; //第二个
@property (nonatomic,strong) NSMutableArray  *dataArray1;
@property (nonatomic,assign) BOOL  isAllSected;
@property (nonatomic,strong) UIView  *operateView;
@property (nonatomic,strong) UIView  *operateView1;//第二个
@property (nonatomic,strong) NSMutableArray  *deleteArr1;
@property (nonatomic,strong) NSMutableArray  *deleteArr;//第二个
@property (nonatomic,assign) BOOL  isRequesting;
@property (nonatomic,strong) NSDictionary  *cancalLikeDic;



@end


@implementation JUDIAN_READ_ShelfView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.supScrView];
        self.selectItem = 0;
        self.page = 1;
        self.page1 = 1;
        self.backgroundColor = kColorWhite;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -3, SCREEN_WIDTH+4, 75/2.0)];
        imgV.image = [UIImage imageNamed:@"bookcase_bg_shadow"];
        [self addSubview:imgV];
        //        [self doBorderWidth:0.5 color:KSepColor cornerRadius:25];
    }
    return self;
}

#pragma mark 网络请求
//阅读记录
- (void)loadData:(BOOL)isReset{
    if (isReset) {
        [self getSelectPage:NO isReset:YES];
    }
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    UITableView *view = self.supScrView.subviews[1];
    if (!app.isHaveNet && !view.mj_footer.refreshing && [[self getSelectPage:NO isReset:NO] integerValue] == 1) {
        [MBProgressHUD hideHUDForView:self];
        [self.dataArray removeAllObjects];
        NSArray* array = [JUDIAN_READ_UserReadingModel getBookSummary];
        [self.dataArray addObjectsFromArray:array];
        [view reloadData];
    }
    if (!view.mj_footer.refreshing) {
        self.page1 = 1;
    }
    NSMutableDictionary *dic = [@{@"page":[NSString stringWithFormat:@"%d",self.page1],@"pageSize":@"20"} mutableCopy];
    if (self.page1 != 1) {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.dataArray.count] forKey:@"offset"];
    }
    [JUDIAN_READ_BookShelfTool getReadListWithParams:dic completionBlock:^(id result, id error) {
        [MBProgressHUD hideHUDForView:self];
        [view.mj_footer resetNoMoreData];
        if (view.mj_header.isRefreshing) {
            [view.mj_header endRefreshing];
        }
        if (view.mj_footer.isRefreshing) {
            [view.mj_footer endRefreshing];
        }
        self.isPullDown = NO;
        if (result) {
            //下拉刷新
            if (!view.mj_footer.refreshing || [[self getSelectPage:NO isReset:NO] integerValue] == 1) {
                [self.dataArray removeAllObjects];
                if (self.selectItem == 1) {
                    if (![result count]) {//服务器无数据
                        self.scrHeadView.subviews[2].hidden = YES;
                    }else{
                        self.scrHeadView.subviews[2].hidden = NO;
                    }
                }
                
            }
            //没有更多
            if([result count] < 20){
                if (view.editing == NO) {
                    if (!view.tableFooterView && [result count]) {
                        view.tableFooterView = self.footView;
                    }
                }
                [view.mj_footer endRefreshingWithNoMoreData];
            }else{
                if (view.tableFooterView) {
                    view.tableFooterView = nil;
                }
            }
            [self.dataArray addObjectsFromArray:result];
            if (self.select1) {
                for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray) {
                    model.isSelected = YES;
                }
            }else{
                for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray) {
                    if ([self.deleteArr containsObject:model.nid]) {
                        model.isSelected = YES;
                    }
                }
            }
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [view reloadData];

        });
        
    }];
}

- (void)loadDataLike:(BOOL)isReset{
    if (isReset) {
        [self getSelectPage:NO isReset:YES];
    }
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    UITableView *view = self.supScrView.subviews[0];
    
    if (!app.isHaveNet && !view.mj_footer.refreshing && [[self getSelectPage:NO isReset:NO] integerValue] == 1) {
        [view.mj_header endRefreshing];
        [view.mj_footer endRefreshing];
        [view.mj_footer resetNoMoreData];
        [MBProgressHUD hideHUDForView:self];
    }
    if (!view.mj_footer.refreshing) {
        self.page = 1;
    }
    NSMutableDictionary *dic = [@{@"page":[NSString stringWithFormat:@"%d",self.page],@"pageSize":@"20"} mutableCopy];
    if (self.page != 1) {
        [dic setObject:[NSString stringWithFormat:@"%ld",self.dataArray1.count] forKey:@"offset"];
    }
    [JUDIAN_READ_BookShelfTool LikeRecordListtWithParams:dic completionBlock:^(id result, id error) {
        [MBProgressHUD hideHUDForView:self];
        [view.mj_footer resetNoMoreData];
        if (view.mj_header.isRefreshing) {
            [view.mj_header endRefreshing];
        }
        if (view.mj_footer.isRefreshing) {
            [view.mj_footer endRefreshing];
        }
        if (result) {
            //下拉刷新
            if (!view.mj_footer.refreshing || [[self getSelectPage:NO isReset:NO] integerValue] == 1) {
                [self.dataArray1 removeAllObjects];
                if (self.selectItem == 0) {
                    if (![result count]) {//服务器无数据
                        self.scrHeadView.subviews[2].hidden = YES;
                    }else{
                        self.scrHeadView.subviews[2].hidden = NO;
                    }
                }
            }
            //没有更多
            if([result count] < 20){
                [view.mj_footer endRefreshingWithNoMoreData];
            }
            for (JUDIAN_READ_NovelSummaryModel *model in result) {
                if (model.is_favorite_book.intValue == 1) {
                    [self.dataArray1 addObject:model];
                }
            }
            if (self.select) {
                for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray1) {
                    model.isSelected = YES;
                }
            }else{
                for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray1) {
                    if ([self.deleteArr1 containsObject:model.nid]) {
                        model.isSelected = YES;
                    }
                }
            }
            
            
        }
        self.isPullDown = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [view reloadData];
        });
        
    }];
    
}

#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.supScrView.subviews[1]) {
        return self.dataArray.count;
    }else{
        JUDIAN_READ_NovelSummaryModel *model = self.dataArray1.firstObject;
        if (model.total.integerValue == self.dataArray1.count && tableView.editing == NO) {
            return self.dataArray1.count + 1;
        }else{
            return self.dataArray1.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.supScrView.subviews[0] && self.dataArray1.count == indexPath.row) {
        return iPhone6Plus ? 132 : 122;
    }
    return iPhone6Plus ? 117 : 107;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JUDIAN_READ_NorvelShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_NorvelShelfCell" forIndexPath:indexPath];
    cell.tintColor = kThemeColor;
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    NSMutableArray *arr = tableView.left == self.supScrView.subviews[1].left ? self.dataArray : self.dataArray1;
    UITableView *view = tableView;
    if (indexPath.row < arr.count) {
        JUDIAN_READ_NovelSummaryModel *model = arr[indexPath.row];
        if (model.isSelected) {
            [view selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            [view deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    NSInteger item = [tableView isEqual:self.supScrView.subviews[1]] ? 1 : 0;
    [cell setShelfDataWithModel:arr indexPath:indexPath selectItem:item isEditing:tableView.isEditing];
    if (indexPath.row < arr.count) {
        JUDIAN_READ_NovelSummaryModel *info = arr[indexPath.row];
        WeakSelf(obj);
        cell.deleteBlock = ^{//喜欢
            obj.isRequesting = YES;
            if (info.is_favorite_book.intValue) {
                NSDictionary *dic = @{@"nids":info.nid};
                self.cancalLikeDic = dic;
                [obj cancelLike:dic isSingle:YES];
            }else{
                NSMutableDictionary *dic = [@{@"nid":info.nid} mutableCopy];
                if ([JUDIAN_READ_Account currentAccount].uid) {
                    [dic setObject:[JUDIAN_READ_Account currentAccount].uid forKey:@"uid_b"];
                }
                [JUDIAN_READ_BookShelfTool addLikeRecordtWithParams:dic completionBlock:^(id result, id error) {
                    if (result) {
                        [GTCountSDK trackCountEvent:@"countid1" withArgs:@{@"collectBtnLocation":@"阅读记录"}];
                        [MobClick event:@"add_collection" attributes:@{@"source":@"阅读记录"}];
                        [MBProgressHUD showMessage:@"收藏成功"];
                        [self loadDataLike:YES];
                        info.is_favorite_book = @"1";
                        [view reloadData];
                    }else{
                        //                        [MBProgressHUD showMessage:@"收藏失败"];
                    }
                    obj.isRequesting = NO;
                }];
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* itemName = @"";
    
    if ([tableView isEqual:self.supScrView.subviews[0]]) {
        itemName = @"我的收藏";
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"我的收藏"}];
        [GTCountSDK trackCountEvent:@"operation_my_collection" withArgs:@{@"collectListTouch":@"收藏列表点击次数"}];
        [MobClick event:@"pv_app_reading_page" attributes:@{@"source":@"我的收藏"}];
        [MobClick event:@"operation_my_collection" attributes:@{@"collectListTouch":@"收藏列表点击次数"}];
    }else{
        itemName = @"阅读记录";
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"阅读记录"}];
        [MobClick event:@"operation_reading_records" attributes:@{@"readListTouch":@"阅读记录列表点击次数"}];
    }
    
    
    NSMutableArray *arr = tableView.left == self.supScrView.subviews[1].left ? self.dataArray : self.dataArray1;
    if (tableView.isEditing) {
        JUDIAN_READ_NovelSummaryModel *model = arr[indexPath.row];
        model.isSelected = YES;
        
        int i = 0;
        NSMutableArray *delArr = self.selectItem == 0 ? self.deleteArr1 : self.deleteArr;
        [delArr removeAllObjects];
        for (JUDIAN_READ_NovelSummaryModel *model in arr) {
            if (model.isSelected) {
                i++;
                [delArr addObject:model.nid];
            }
        }
        BOOL cellSelct;
        UIButton *btn = self.selectItem == 0 ? self.operateView.subviews.firstObject : self.operateView1.subviews.firstObject;
        if (i == arr.count) {
            if (self.selectItem == 0) {
                self.select = YES;
            }else{
                self.select1 = YES;
            }
            cellSelct = YES;
        }else{
            if (self.selectItem == 0) {
                self.select = NO;
            }else{
                self.select1 = NO;
            }
            cellSelct = NO;
        }
        NSString *str = cellSelct ? @"bookcase_management_check_sel" : @"bookcase_management_check";
        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        [tableView reloadData];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= arr.count) {
        [MobClick event:click_add_favorite_bookshelf attributes:@{click_add_favorite_bookshelf:@"书架添加喜欢的小说"}];
        if (self.selectBlcok) {
            self.selectBlcok(@"0",@"0");
        }
        
    }else{
        if (arr.count > 0) {
            [MobClick event:click_listbook_bookshelf attributes:@{click_listbook_bookshelf:@"书架点击小说列表"}];
            
            JUDIAN_READ_NovelSummaryModel *model = arr[indexPath.row];
            JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString* position = @"";
            if (app.isHaveNet) {
                //NSDictionary* chapterDictionary = [[JUDIAN_READ_NovelManager shareInstance].userReadingModel getChapterId:model.nid];
                //position = chapterDictionary ? chapterDictionary[@"position"] : @"";
            }
            else {
                //position = [[JUDIAN_READ_NovelManager shareInstance].userReadingModel getOfflinePosition:model.nid];
            }
            
            //if (!position) {
            //    position = @"";
            //}
            
            NSString *str = model.chapnum.length > 0 ? model.chapnum : @"";
            NSDictionary* dictionary = @{
                                         @"bookId":model.nid,
                                         @"bookName":model.bookname,
                                         @"chapterId": str,
                                         @"position" : position
                                         };
            if (self.selectBlcok) {
                self.selectBlcok(itemName,dictionary);
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr = tableView.left == self.supScrView.subviews[1].left ? self.dataArray : self.dataArray1;
    NSMutableArray *delArr = tableView.left == self.supScrView.subviews[1].left ? self.deleteArr : self.deleteArr1;
    JUDIAN_READ_NovelSummaryModel *model = arr[indexPath.row];
    [delArr removeObject:model.nid];
    UIButton *btn = tableView.left == self.supScrView.subviews[0].left ? self.operateView.subviews.firstObject : self.operateView1.subviews.firstObject;
    if (tableView.isEditing) {
        model.isSelected = NO;
        if (self.selectItem == 0) {
            self.select = NO;
        }else{
            self.select1 = NO;
        }
        NSString *str = @"bookcase_management_check";
        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        [tableView reloadData];
    }
}


#pragma mark tableview代理

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _footView.backgroundColor = kColorWhite;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"book_default_btn"] forState:UIControlStateNormal];
        [btn setContentMode:UIViewContentModeCenter];
        btn.frame = CGRectMake(100, 20, SCREEN_WIDTH-200, 40);
        [btn addTarget:self action:@selector(goBookStore) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
      
    }
    return _footView;
}

- (void)goBookStore{
    if (self.selectBlcok) {
        self.selectBlcok(@"0", @"0");
    }
}

- (UIView *)operateView{
    if (!_operateView) { //self.supScrView.height-50
        _operateView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT- Height_TabBar - 50, SCREEN_WIDTH, 50)];
        _operateView.backgroundColor = kBackColor;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 0, 54, 50);
        [btn setText:@"全选" titleFontSize:14 titleColot:kColor51];
        [btn addTarget:self action:@selector(selectAllCell:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"bookcase_management_check"] forState:UIControlStateNormal];
        [_operateView addSubview:btn];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setText:@"删除" titleFontSize:12 titleColot:kColorWhite];
        delBtn.frame = CGRectMake(SCREEN_WIDTH-75, 11, 60, 28);
        [delBtn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [delBtn doBorderWidth:0 color:nil cornerRadius:3];
        [_operateView addSubview:delBtn];
    }
    return _operateView;
}

- (UIView *)operateView1{
    if (!_operateView1) {
        _operateView1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT- Height_TabBar - 50, SCREEN_WIDTH, 50)];
        _operateView1.backgroundColor = kBackColor;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 0, 54, 50);
        [btn setText:@"全选" titleFontSize:14 titleColot:kColor51];
        [btn addTarget:self action:@selector(selectAllCell:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [btn setImage:[UIImage imageNamed:@"bookcase_management_check"] forState:UIControlStateNormal];
        [_operateView1 addSubview:btn];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setText:@"删除" titleFontSize:12 titleColot:kColorWhite];
        delBtn.frame = CGRectMake(SCREEN_WIDTH-75, 11, 60, 28);
        [delBtn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [delBtn doBorderWidth:0 color:nil cornerRadius:3];
        [_operateView1 addSubview:delBtn];
    }
    return _operateView1;
}


- (void)selectAllCell:(UIButton *)btn{
    BOOL cellSelct;
    NSMutableArray *delArr = self.selectItem == 1 ? self.deleteArr : self.deleteArr1;
    if (self.selectItem == 0) {
        self.select = !self.select;
        cellSelct = self.select;
    }else{
        self.select1 = !self.select1;
        cellSelct = self.select1;
    }
    NSString *str = cellSelct ? @"bookcase_management_check_sel" : @"bookcase_management_check";
    [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    
    NSArray *arr = self.selectItem ? self.dataArray : self.dataArray1;
    UITableView *view = self.supScrView.subviews[self.selectItem];
    int i = 0;
    for (JUDIAN_READ_NovelSummaryModel *model in arr) {
        model.isSelected = cellSelct;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (cellSelct) {
            [delArr addObject:model.nid];
            [view selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else{
            [delArr removeObject:model.nid];
            [view deselectRowAtIndexPath:indexPath animated:NO];
        }
        
        i++;
    }
}


- (void)deleteData{
    
    NSString *str = @"确定要移除这些书吗？";
    if (self.selectItem) {
        str = @"确定要移除这些记录吗？";
        if (!self.deleteArr.count) {
            return;
        }
    }else{
        if (!self.deleteArr1.count) {
            return;
        }
    }
    JUDIAN_READ_CustomAlertView *alert = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:nil message:str leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    alert.delegate = self;
}




- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataArray1{
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
}

- (NSMutableArray *)deleteArr{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

- (NSMutableArray *)deleteArr1{
    if (!_deleteArr1) {
        _deleteArr1 = [NSMutableArray array];
    }
    return _deleteArr1;
}

- (UIScrollView *)supScrView{
    if (!_supScrView) {
        _supScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, TableHeight)];
        _supScrView.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0);
        _supScrView.pagingEnabled = YES;
        _supScrView.bounces = NO;
        _supScrView.showsHorizontalScrollIndicator = NO;
        _supScrView.delegate = self;
        
        for (int i = 0; i < 2; i++) {
            JUDIAN_READ_BaseTableView *tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, TableHeight) style:UITableViewStylePlain];
            [tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_NorvelShelfCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_NorvelShelfCell"];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.allowsMultipleSelectionDuringEditing = YES;
            tableView.noitceOperateImage = @"";
            tableView.verticalSpace = -40;
            WeakSelf(weakself);
            
            if (i == 1) {
                tableView.noticeTitle = @"暂无阅读记录";
                tableView.noitceOperateImage = @"book_default_btn";
                tableView.emptyCallBack = ^(int type) {
                    if (type != 1) {
                        if (weakself.selectBlcok) {
                            weakself.selectBlcok(@"0",@"0");
                        }
                    }else{
                        weakself.page = 1;
                        [weakself loadData:YES];
                    }
                };
            }else{
                tableView.emptyCallBack = ^(int type) {
                    if (type != 1) {
                        if (weakself.selectBlcok) {
                            weakself.selectBlcok(@"0",@"0");
                        }
                    }else{
                        weakself.page1 = 1;
                        [weakself loadDataLike:YES];
                    }
                };
            }
            
            
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakself.isPullDown = NO;
                [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":@"书架"}];
                [MobClick event:@"click_refresh" attributes:@{@"page":@"书架"}];
                if (self.selectItem == 0) {
                    [weakself loadDataLike:YES];
                }else{
                    [weakself loadData:YES];
                }
            }];
            
            MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                weakself.isPullDown = YES;
                [weakself getSelectPage:YES isReset:NO];
                if (self.selectItem == 0) {
                    [weakself loadDataLike:NO];
                }else{
                    [weakself loadData:NO];
                }
            }];
            tableView.mj_footer = foot;
            foot.stateLabel.textColor = kColor153;
            foot.stateLabel.font = kFontSize12;
            [foot setTitle:@"" forState:MJRefreshStateNoMoreData];
            [foot setImages:nil forState:MJRefreshStateNoMoreData];
            [_supScrView addSubview:tableView];
        }
        [self addSubview:self.scrHeadView];
        [self addSubview:_supScrView];
        
    }
    return _supScrView;
}

- (UIView *)scrHeadView{
    if (!_scrHeadView) {
        _scrHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _scrHeadView.backgroundColor = kColorWhite;
        NSArray *arr = @[@"我的收藏",@"阅读记录",@"编辑"];
        for (int i = 0; i < 3; i++) {
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(85 * i, 0, 85, 40);
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            if (i == 0) {
                [btn1 setText:arr[i] titleFontSize:14 titleColot:kThemeColor];
            }else{
                [btn1 setText:arr[i] titleFontSize:14 titleColot:kColor51];
            }
            btn1.tag = 100+i;
            [btn1 addTarget:self action:@selector(scrTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 2) {
                btn1.hidden = YES;
                [btn1 setText:arr[i] titleFontSize:12 titleColot:kColor51];
                btn1.frame = CGRectMake(SCREEN_WIDTH-54, 0, 54, 40);
                btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            }
            
            [_scrHeadView addSubview:btn1];
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(2, 40-0.5, SCREEN_WIDTH-4, 0.5)];
        lineView.backgroundColor = KSepColor;
        self.lineView = lineView;
        lineView.hidden = YES;
        [_scrHeadView addSubview:lineView];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(self.selectItem*85 + (85-33)/2 , 40-2, 33, 2)];
        [sep doBorderWidth:0 color:nil cornerRadius:2];
        sep.backgroundColor = kThemeColor;
        self.selectItemView = sep;
        [_scrHeadView addSubview:sep];
        
        
        
    }
    return _scrHeadView;
}





- (void)scrTouch:(UIButton *)btn{
    if (btn.tag == 100) {
        [self changeUI:btn];
        self.selectItem = 0;
    }else if (btn.tag == 101){
        [self changeUI:btn];
        self.selectItem = 1;
    }else{
        self.page = self.page1 = 0;
        UIButton *op = self.selectItem == 0 ? self.operateView.subviews.firstObject : self.operateView1.subviews.firstObject;
        [op setImage:[UIImage imageNamed:@"bookcase_management_check"] forState:UIControlStateNormal];
        NSMutableArray *delArr = self.selectItem == 0 ? self.deleteArr1 : self.deleteArr;
        [delArr removeAllObjects];
        
        UITableView *view = self.supScrView.subviews[self.selectItem];
        NSString *str = view.isEditing ? @"编辑" : @"完成";
        [btn setTitle:str forState:UIControlStateNormal];
        UIView *opView = self.selectItem == 0 ? self.operateView : self.operateView1;
        NSArray *arr = self.selectItem ? self.dataArray : self.dataArray1;
        for (JUDIAN_READ_NovelSummaryModel *model in arr) {
            model.isSelected = NO;
        }
        if (view.isEditing) {
            [view setEditing:NO animated:YES];
            [opView removeFromSuperview];
            view.height = view.height + 50;
            view.tableFooterView = (self.selectItem == 1 && self.dataArray.count) ? self.footView : nil;
            
        }else{
            [view setEditing:YES animated:YES];
            //            [self.supScrView addSubview:opView];
            [self.superview.superview addSubview:opView];
            view.height = view.height - 50;
            view.tableFooterView = nil;
            
        }
        [view reloadData];
    }
    
}




- (void)changeUI:(UIButton *)btn{
    CGFloat x = (self.selectItem+100 - btn.tag)*85;
    CGFloat px = x < 0 ? -x : x ;
    [UIView animateWithDuration:0.25 animations:^{
        if (x < 0) {
            self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0, 40-2, 33+px, 2);
        }else{
            self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0 - x, 40-2, 33+px, 2);
        }
    } completion:^(BOOL finished) {
        self.selectItem = btn.tag - 100;
        self.supScrView.contentOffset = CGPointMake(self.selectItem*SCREEN_WIDTH, 0);
        [self changeColor];
        [UIView animateWithDuration:0.1 animations:^{
            self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0, 40-2, 33, 2);
        }];
    }];
    
}


- (NSString *)getSelectPage:(BOOL)isAdd isReset:(BOOL)isRestSet{
    int page = 0;
    if (self.selectItem == 0) {
        self.page = isAdd ? ++self.page : self.page;
        self.page = isRestSet ? 1 : self.page;
        page = self.page;
    }else if (self.selectItem == 1){
        self.page1 = isAdd ? ++self.page1 : self.page1;
        self.page1 = isRestSet ? 1 : self.page1;
        page = self.page1;
    }
    return [NSString stringWithFormat:@"%d",page];
}




- (void)changeColor{
    for (int i = 0; i < 2; i++) {
        if (self.scrHeadView.subviews.count >= 2) {
            UIButton *btn = self.scrHeadView.subviews[i];
            [btn setTitleColor:kColor51 forState:UIControlStateNormal];
        }
    }
    UIButton *btn = self.scrHeadView.subviews[self.selectItem];
    [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    UITableView *view = self.supScrView.subviews[self.selectItem];
    
    //    if (!self.dataArray.count) {
    //        [self loadData:YES];
    //    }
    //    if (!self.dataArray1.count) {
    //        [self loadDataLike:YES];
    //    }
    
    if (self.selectItem == 1) {
        [MobClick event:@"operation_reading_records" attributes:@{@"readRecordExposure":@"阅读记录页面的曝光次数"}];
        if (!self.dataArray.count) {
            self.scrHeadView.subviews[2].hidden = YES;
        }else{
            self.scrHeadView.subviews[2].hidden = NO;
        }
    }else{
        if (!self.dataArray1.count) {
            self.scrHeadView.subviews[2].hidden = YES;
        }else{
            self.scrHeadView.subviews[2].hidden = NO;
        }
    }
    
    [self willDismiss:YES];
    [view reloadData];
    
}

- (void)willDismiss:(BOOL)isYES{
    if (isYES) {
        UIButton *btn = self.scrHeadView.subviews[2];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray) {
            model.isSelected = NO;
        }
        for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray1) {
            model.isSelected = NO;
        }
        for (int i = 0; i < 2; i++) {
            UITableView *view = self.supScrView.subviews[i];
            [view setEditing:NO animated:YES];
            view.height = TableHeight;
            if (i == 1) {
//                view.tableFooterView = (self.selectItem == 1 && self.dataArray.count == [self.dataArray.firstObject total].intValue)? self.footView : nil;
            }
        }
        
        self.select = self.select1 = NO;
        self.page = self.page1 = 1;
        [self.operateView removeFromSuperview];
        [self.operateView1 removeFromSuperview];
        [self.operateView.subviews.firstObject setImage:[UIImage imageNamed:@"bookcase_management_check"] forState:UIControlStateNormal];
        [self.operateView1.subviews.firstObject setImage:[UIImage imageNamed:@"bookcase_management_check"] forState:UIControlStateNormal];
        [self.deleteArr removeAllObjects];
        [self.deleteArr1 removeAllObjects];
    }
}


#pragma mark scrDelegte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //左右切换
    if ([scrollView isEqual:self.supScrView] ) {
        [self scrollHeadNavWithScrollView:scrollView];
        return;
    }
    
    self.currentScrView = self.supScrView.subviews[self.selectItem];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.supScrView] ) {
        NSInteger select = self.selectItem;
        self.selectItem = scrollView.contentOffset.x/SCREEN_WIDTH;
        if (select != self.selectItem) {
            [self changeColor];
            
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0 , 40-2, 33, 2);
        }];
    }
}

- (void)scrollHeadNavWithScrollView:(UIScrollView *)scr{
    
    //获取最初偏移量
    CGFloat offsetX = self.selectItem * SCREEN_WIDTH;
    //绝对偏移量
    CGFloat changeX = scr.contentOffset.x - offsetX;
    CGFloat positionChangeX = changeX < 0 ? -changeX : changeX;
    
    //nav移动距离
    CGFloat x = 85.0/SCREEN_WIDTH * changeX;
    CGFloat positionX =  85.0/SCREEN_WIDTH * positionChangeX;
    if (x != 0) {
        [UIView animateWithDuration:0.15 animations:^{
            if (x > 0) {
                
                self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0 , 40-2, 33+positionX, 2);
                
            }else{
                
                self.selectItemView.frame = CGRectMake(85*self.selectItem+(85-33)/2.0 + x, 40-2, 33+positionX, 2);
                
            }
        }];
    }
}





- (void)alertView:(JUDIAN_READ_CustomAlertView *)view didClickAtIndex:(NSInteger)index{
    if (view.tag == 100) {
        if (index == 1) {
            [self cancelLike:self.cancalLikeDic isSingle:NO];
        }
    }else{
        if (index == 1) {
            if (self.selectItem == 0) {
                NSString *str = [self.deleteArr1 componentsJoinedByString:@","];
                if (!str.length) {
                    return;
                }
                NSDictionary *dic = @{@"nids":str};
                self.cancalLikeDic = dic;
                [self cancelLike:dic isSingle:NO];
            }else{
                NSString *str = [self.deleteArr componentsJoinedByString:@","];
                if (!str.length) {
                    return;
                }
                NSDictionary *dic = @{@"nids":str,@"nid":@"0"};
                NSInteger item = self.selectItem;
                [JUDIAN_READ_BookShelfTool deleteReadRecordWithParams:dic completionBlock:^(id result, id error) {
                    if (result) {
                        
                        UITableView *view = self.supScrView.subviews[item];
                        [view setEditing:NO animated:YES];
                        view.height = TableHeight;
                        [self.operateView1 removeFromSuperview];
                        self.select1 = NO;
                        
                        NSArray *arr = [self.dataArray mutableCopy];
                        for (JUDIAN_READ_NovelSummaryModel *model in arr) {
                            if ([self.deleteArr containsObject:model.nid]) {
                                [self.dataArray removeObject:model];
                            }
                        }
                        
                        UIButton *btn1 = self.scrHeadView.subviews[2];
                        if (self.dataArray.count) {
                            [btn1 setTitle:@"编辑" forState:UIControlStateNormal];
                        }
                        
                        [MobClick event:@"operation_reading_records" attributes:@{@"readRecordDeleteCount":[NSString stringWithFormat:@"%ld",self.deleteArr.count]}];
                        [self.deleteArr removeAllObjects];
                        
                        [view reloadData];
                        
                        [MBProgressHUD showMessage:@"移除成功"];
                        [self loadData:YES];
                        
                    }
                }];
            }
        }
    }
    
}

- (void)cancelLike:(NSDictionary *)dic isSingle:(BOOL)isYES{
    if (!isYES) {
        NSInteger item = self.selectItem;
        [JUDIAN_READ_BookShelfTool deleteLikeRecordtWithParams:self.cancalLikeDic completionBlock:^(id result, id error) {
            if (result) {
                [MBProgressHUD showMessage:@"取消收藏成功"];

                if (item == 0) {//喜欢
                    NSArray *arr = [self.dataArray1 mutableCopy];
                    for (JUDIAN_READ_NovelSummaryModel *model in arr) {
                        if ([self.deleteArr1 containsObject:model.nid]) {
                            [self.dataArray1 removeObject:model];
                        }
                    }
                    
                    UITableView *view = self.supScrView.subviews[item];
                    [view setEditing:NO animated:YES];
                    view.height = TableHeight;
                    [self.operateView removeFromSuperview];
                    self.select = NO;
                    
                    UIButton *btn1 = self.scrHeadView.subviews[2];
                    if (self.dataArray1.count) {
                        [btn1 setTitle:@"编辑" forState:UIControlStateNormal];
                    }
                    [GTCountSDK trackCountEvent:@"operation_my_collection" withArgs:@{@"deleteCount":[NSString stringWithFormat:@"%ld",self.deleteArr1.count]}];
                    [MobClick event:@"operation_my_collection" attributes:@{@"deleteCount":[NSString stringWithFormat:@"%ld",self.deleteArr1.count]}];
                    [self.deleteArr1 removeAllObjects];
                    [self loadData:YES];
                }
                
                
                if (item == 1) {//阅读记录
                    NSString *str = self.cancalLikeDic[@"nids"];
                    for (JUDIAN_READ_NovelSummaryModel *model in self.dataArray) {
                        if ([model.nid isEqualToString:str]) {
                            model.is_favorite_book = @"0";
                        }
                    }
                    [MobClick event:@"operation_reading_records" attributes:@{@"CancelCollectCount":@"1"}];
                    [self loadDataLike:YES];
                }
                
                UITableView *view = self.supScrView.subviews[self.selectItem];
                [view reloadData];

            }
            self.isRequesting = NO;
        }];
        
    }else{
        self.cancalLikeDic = dic;
        JUDIAN_READ_CustomAlertView *alert = [JUDIAN_READ_CustomAlertView popAlertViewWithTitle:nil message:@"确定取消收藏吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.delegate = self;
        alert.tag = 100;
    }
    
}




@end
