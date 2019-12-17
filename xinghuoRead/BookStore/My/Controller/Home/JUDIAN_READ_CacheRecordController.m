//
//  JUDIAN_READ_ReadPreferenceController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/19.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_CacheRecordController.h"
#import "JUDIAN_READ_CacheStoreCell.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_TaskController.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_WeChatLoginController.h"

@interface JUDIAN_READ_CacheRecordController ()<UITextViewDelegate>

@property (nonatomic,strong) JUDIAN_READ_BaseTableView *tableView;
@property (nonatomic,strong) JUDIAN_READ_BaseView  *headView;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,assign) NSInteger  selectRow;
@property (nonatomic,strong) NSTimer  *timer;
@property (nonatomic,assign) BOOL  isLoading;



@end

@implementation JUDIAN_READ_CacheRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GTCountSDK trackCountEvent:@"pv_download_page" withArgs:@{@"myCachePage":@"我的缓存页面曝光"}];
    [MobClick event:@"pv_download_page" attributes:@{@"myCachePage":@"我的缓存页面曝光"}];

    self.title = @"缓存记录";
    [self loadData];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateStatus];
    
    if (self.isLoading) {
        [self startTimer];
    }
    [self.tableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
}

#pragma mark 加载数据
- (void)loadData{
    [JUDIAN_READ_MyTool getCacheRecordWithParams:@{@"page":[NSString stringWithFormat:@"%ld",self.pageSize]} completionBlock:^(id result, id error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (result) {
            //下拉刷新
            if (!self.isPullDown) {
                [self.dataArr removeAllObjects];
            }
            //没有更多
            if([result count] < 20){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.dataArr addObjectsFromArray:result];
            //给进度赋值
            [self updateStatus];
        }
        self.isPullDown = NO;
        [self.tableView reloadData];
        if (self.isLoading) {
            [self startTimer];
        }
    }];
}

- (void)updateStatus{
    //给进度赋值
    NSInteger i = 0;
    NSArray *arr = [[JUDIAN_READ_NovelManager shareInstance] getAllWillDownLoadBooks];
    for (JUDIAN_READ_ReadListModel *model in self.dataArr) {
        for (JUDIAN_READ_ReadListModel *info in arr) {
            if ([info.nid isEqualToString:model.nid]) {
                self.isLoading = YES;
                model.isLoading = YES;
            }
        }
        NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:model.nid];
        NSString *value = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[model.nid];
        if (value) {
            self.selectRow = i;
        }
        i++;
        
        NSInteger chapterCount = model.chapters_num.integerValue;
        if (chapterCount > 0) {
            model.progress = begin * 100 / chapterCount;
        }
        
    }
   
}




#pragma mark 懒加载
- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_Content)];
        _tableView.rowHeight = 55;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.noticeTitle = @"暂无缓存记录";
        _tableView.verticalSpace = -50;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_CacheStoreCell class]) bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_CacheStoreCell"];
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


#pragma mark Tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_CacheStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_CacheStoreCell" forIndexPath:indexPath];
    [cell setDataWithRecordModel:self.dataArr indexPath:indexPath];
    WeakSelf(obj);
    JUDIAN_READ_ReadListModel *model = self.dataArr[indexPath.section];
    cell.downLoadBlock = ^(id cellSelf, id btn) {
        if (model.isLoading) {
            [MBProgressHUD showMessage:@"正在下载中"];
            return;
        }
        if (!model.isLoading) {
            model.isLoading = !model.isLoading;
            [[JUDIAN_READ_NovelManager shareInstance] saveWillDownLoadBook:model];
        }
        [obj.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        //如果有任务在下载，不下载，只修改ui
        int i = 0;
        for (JUDIAN_READ_ReadListModel *info in obj.dataArr) {
            if (info.isLoading) {
                i++;
            }
        }
        
        if (i <= 1) {
            //开始下载
            if (model.isLoading) {
                obj.selectRow = indexPath.section;
                [obj downLoad];
            }
        }
       
    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"缓存记录"}];
    [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"缓存记录"}];
    
    JUDIAN_READ_ReadListModel *info = self.dataArr[indexPath.section];
    [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:@"缓存记录"];
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString isEqualToString:@"two"]) {
        JUDIAN_READ_VipController *vc = [JUDIAN_READ_VipController new];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick  event:pv_app_vip_page attributes:@{@"source":my_cache_page}];
    }else{
        JUDIAN_READ_TaskController *vc = [JUDIAN_READ_TaskController new];
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick  event:pv_task_page attributes:@{@"source":my_cache_page}];
        
    }
    return NO;
}

#pragma mark 下载
- (void)downLoad{
    //调用下载接口，成功之后给model的progress赋值并刷新row
    JUDIAN_READ_ReadListModel *model = self.dataArr[self.selectRow];
    if (model.progress < [model.chapters_num intValue]) {
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        if (app.isHaveNet) {
            model.isLoading = YES;
            
            [self saveFictionSummary:model.nid];
            
            [[JUDIAN_READ_NovelManager shareInstance] downLoadNextBookComplectionBlock:^(id  _Nullable parameter) {
                [self update:parameter];
            }];
        }
    }
    [self startTimer];
}


- (void)saveFictionSummary:(NSString*)bookId {
    
    if (bookId.length <= 0) {
        return;
    }
    
    [JUDIAN_READ_NovelSummaryModel buildSummaryModel:bookId block:^(id  _Nonnull model) {
        [JUDIAN_READ_UserReadingModel saveBookSummary:model];
    } failure:^(id  _Nonnull model) {
        
    }];
}

- (void)update:(id)parameter{
    dispatch_async(dispatch_get_main_queue(), ^{
        JUDIAN_READ_ReadListModel *oldInfo = self.dataArr[self.selectRow];
        
        if ([parameter integerValue] == 1) {
            oldInfo.progress = 100;
            oldInfo.loadFail = NO;
        }else{
            [MBProgressHUD showMessage:@"缓存失败"];
            NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:oldInfo.nid];
            oldInfo.progress = begin*100/oldInfo.chapters_num.integerValue;
            oldInfo.loadFail = YES;
        }
        oldInfo.isLoading = NO;
        
        JUDIAN_READ_ReadListModel *newModel = [[JUDIAN_READ_NovelManager shareInstance] getAllWillDownLoadBooks].firstObject;
        NSInteger i = 0;
        for (JUDIAN_READ_ReadListModel *selModel in self.dataArr) {
            if ([selModel.nid isEqual:newModel.nid]) {
                self.selectRow = i;
                selModel.isLoading = YES;
            }
            i++;
        }
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self startTimer];
        [self.tableView reloadData];
        
    });
}


- (void)startTimer{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_FICTION_DOWNLOAD_INTERVAL_ target:self selector:@selector(down) userInfo:nil repeats:YES];
}

- (void)down{
    JUDIAN_READ_AppDelegate *del = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!del.isHaveNet) {
        [self.timer invalidate];
        self.timer = nil;
        JUDIAN_READ_ReadListModel *model = self.dataArr[self.selectRow];
        NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:model.nid];
        model.progress = begin*100/model.chapters_num.integerValue;
        model.loadFail = YES;
        model.isLoading = NO;
    }else{
        JUDIAN_READ_ReadListModel *model = self.dataArr[self.selectRow];
        if (model.progress >= 90) {
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            model.progress = model.progress > 100 ? 100 : model.progress;
        }else{
            model.progress += 1;
        }
    }
    [self.tableView reloadSection:self.selectRow withRowAnimation:UITableViewRowAnimationNone];
 
    
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
