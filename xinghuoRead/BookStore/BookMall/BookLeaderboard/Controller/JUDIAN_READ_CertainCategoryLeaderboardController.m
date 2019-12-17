//
//  JUDIAN_READ_CertainCategoryLeaderboardController.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CertainCategoryLeaderboardController.h"
#import "JUDIAN_READ_BookLeaderboardCell.h"
#import "JUDIAN_READ_BookDescribeModel.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_UserCheckInEmptyCell.h"
#import "JUDIAN_READ_BaseTableView.h"

#define BookLeaderboardCell @"BookLeaderboardCell"
#define UserCheckInEmptyCell @"UserCheckInEmptyCell"

@interface JUDIAN_READ_CertainCategoryLeaderboardController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, strong)NSMutableArray* dataArray;
@end

@implementation JUDIAN_READ_CertainCategoryLeaderboardController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    _dataArray = [NSMutableArray array];
    [self addTableView];
    
    [MBProgressHUD showLoadingForView:self.view];
    [self loadBookList];
}


- (void)addTableView {
    JUDIAN_READ_BaseTableView* tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WeakSelf(that);
    tableView.emptyCallBack = ^(int type) {
        [that loadBookList];
    };
    [self.view addSubview:tableView];
    
    [tableView registerClass:[JUDIAN_READ_BookLeaderboardCell class] forCellReuseIdentifier:BookLeaderboardCell];
    [tableView registerClass:[JUDIAN_READ_UserCheckInEmptyCell class] forCellReuseIdentifier:UserCheckInEmptyCell];
    
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(that.view.mas_top);
        make.bottom.equalTo(that.view.mas_bottom);
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
    }];
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        that.pageIndex = 1;
        [that.dataArray removeAllObjects];
        [that loadBookList];
        
    }];
    
    tableView.mj_header = header;

    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        that.pageIndex++;
        [that loadBookList];
    }];
    
    tableView.mj_footer = foot;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 14;
    }
    
    if (indexPath.section == 1) {
        //self.iconheight.constant = 1.35*(SCREEN_WIDTH-30-54)/4;
        //self.iconWidth.constant = (SCREEN_WIDTH-30-54)/4;
        CGFloat width = (SCREEN_WIDTH - 84) / 4.0f;
        CGFloat height = 1.35 * ceil(width) + 2 * 14;
        
        return height;
    }

    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_dataArray.count > 0) {
            return 1;
        }
        return 0;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        JUDIAN_READ_UserCheckInEmptyCell* cell = [tableView dequeueReusableCellWithIdentifier:UserCheckInEmptyCell];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    if (indexPath.section == 1) {
        JUDIAN_READ_BookLeaderboardCell* cell = [tableView dequeueReusableCellWithIdentifier:BookLeaderboardCell];
        if (_dataArray.count > 0) {
            [cell updateCell:_dataArray[indexPath.row] type:_sortType row:indexPath.row];
        }
        return cell;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.row >= _dataArray.count) {
        return;
    }
    
    JUDIAN_READ_NovelThumbModel* model = _dataArray[indexPath.row];
    
    NSString* name = self.title;
    if (name.length <= 0) {
        name = @"";
    }

    [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : name}];
    [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : name}];
    
    NSString* bookId = [NSString stringWithFormat:@"%ld", model.nid.integerValue];
    [JUDIAN_READ_NovelDescriptionViewController enterDescription:_viewController.navigationController bookId:bookId bookName:model.bookname viewName:name];
    
}


#pragma mark 加载数据
- (void)loadBookList {
    
    NSDictionary* dictionary = nil;
    NSString* pageStr = [NSString stringWithFormat:@"%ld", (long)_pageIndex];
    
    WeakSelf(that);
    
    if (_isPress) {
        
        dictionary = @{
          @"editorid" : _editorId,
          @"type" : _filterType,
          @"page" : pageStr,
          @"pageSize" : @"20"
          };
        
        [JUDIAN_READ_BookDescribeModel buildPressBookDescribeModel:^(NSArray*  _Nullable array, NSNumber*  _Nullable totalPage) {
            
            [MBProgressHUD hideHUDForView:that.view];
            
            [that.tableView.mj_header endRefreshing];
            [that.tableView.mj_footer endRefreshing];
            
            if (totalPage.intValue <= 1) {
                that.tableView.mj_footer.hidden = YES;
            }
            else {
                that.tableView.mj_footer.hidden = NO;
            }
            
            if (totalPage.intValue <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
                });
                return;
            }
            
            if (that.pageIndex > totalPage.intValue) {
                [that.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            [that.dataArray addObjectsFromArray:array];
            [that.tableView reloadData];
        } dicitionary:dictionary];
        
        return;
    }
 

     
    if (_isComplete) {
        
        dictionary = @{
                       @"channel" : _channelName,
                       @"type" : _filterType,
                       @"page" : pageStr,
                       @"pageSize" : @"20"
                       };
        
        [JUDIAN_READ_BookDescribeModel buildFinishBookDescribeModel:^(NSArray*  _Nullable array, NSNumber*  _Nullable totalPage) {
            
            [MBProgressHUD hideHUDForView:that.view];
            
            [that.tableView.mj_header endRefreshing];
            [that.tableView.mj_footer endRefreshing];
            
            if (totalPage.intValue <= 1) {
                that.tableView.mj_footer.hidden = YES;
            }
            else {
                that.tableView.mj_footer.hidden = NO;
            }
            
            if (totalPage.intValue <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
                });
                return;
            }
            
            if (that.pageIndex > totalPage.intValue) {
                [that.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            
            [that.dataArray addObjectsFromArray:array];
            [that.tableView reloadData];
        } dicitionary:dictionary];
        return;
    }
  
    
    dictionary = @{
                   @"channel" : _channelName,
                   @"rankingType" : _filterType,
                   @"page" : pageStr,
                   @"pageSize" : @"20"
                   };
    [JUDIAN_READ_BookDescribeModel buildUnfinishBookDescribeModel:^(NSArray*  _Nullable array, NSNumber*  _Nullable totalPage) {
        
        [MBProgressHUD hideHUDForView:that.view];
        
        [that.tableView.mj_header endRefreshing];
        [that.tableView.mj_footer endRefreshing];
        
        if (totalPage.intValue <= 1) {
            that.tableView.mj_footer.hidden = YES;
        }
        else {
            that.tableView.mj_footer.hidden = NO;
        }
        
        if (totalPage.intValue <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoNewData" object:nil];
            });
            return;
        }
        
        if (that.pageIndex > totalPage.intValue) {
            [that.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        [that.dataArray addObjectsFromArray:array];
        [that.tableView reloadData];
    } dicitionary:dictionary];
    
}



@end
