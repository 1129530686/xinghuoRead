//
//  JUDIAN_READ_SortNameController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/6/21.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_SortNameController.h"
#import "JUDIAN_READ_MyInfoController.h"
#import "JUDIAN_READ_SortCell.h"
#import "JUDIAN_READ_ShelfTopView.h"
#import "JUDIAN_READ_ReadRankModel.h"
#import "JUDIAN_READ_CircleProgress.h"


#define HeadHeight (257) + Height_StatusBar

@interface JUDIAN_READ_SortNameController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) UIView  *headView;
@property (nonatomic,strong) UIImageView  *backImageView;

@property (nonatomic,strong) UIView  *navView;
@property (nonatomic,strong) JUDIAN_READ_ShelfTopView  *topView;
@property (nonatomic,strong) UILabel  *sortLab;
@property (nonatomic,strong) UILabel  *timeLab;
@property (nonatomic,strong) JUDIAN_READ_ReadRankModel  *info;
@property (nonatomic,strong) JUDIAN_READ_CircleProgress  *circleProgressView;
@property (nonatomic,strong) UILabel  *centerLab;
@property (nonatomic,strong) UIButton  *imgV;
@property (nonatomic,strong) UIView  *lineView;


@end

@implementation JUDIAN_READ_SortNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AdjustsScrollViewInsetNever(self, self.tableView);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


#pragma mark 网络请求
- (void)loadData{
    NSInteger page = self.pageSize;
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.pageSize],@"pageSize":@"20"};
    [JUDIAN_READ_MyTool getReadSortListWithParams:dic completionBlock:^(id result,id error){
        [MBProgressHUD hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (result) {
            self.info = error;
            //下拉刷新
            if (!self.isPullDown) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:result];
            //没有更多
            if([result count] < 20 || page == 5){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self updateInfo];
        }
        self.isPullDown = NO;
        [self.tableView reloadData];
    }];
}

- (void)updateInfo{

    self.circleProgressView.progress = self.info.rankRatio.intValue/100.0;
    self.circleProgressView.alltime = 2.0;
    if ( self.info.rankYesterday.intValue > 100 || ! self.info.rankYesterday || self.info.rankYesterday.intValue <= 0) {
        self.circleProgressView.sortLabStr = @"昨日未上榜";
    }else{
        self.circleProgressView.sortLabStr = [NSString stringWithFormat:@"%@", self.info.rankYesterday];
    }
//    NSString *str =  self.info.rankYesterdayDesc.length &&  self.info.rankYesterdayDesc ? self.info.rankYesterdayDesc : @"";
    NSMutableAttributedString *att = [self changeTimeLabUI:[NSString stringWithFormat:@"昨日阅读时长:%@", self.info.readingDuration] font:kFontSize12];
    self.timeLab.attributedText = att;
}

- (NSMutableAttributedString *)changeTimeLabUI:(NSString *)text font:(UIFont *)font{
    NSCharacterSet *nonDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    NSArray *arr = [text componentsSeparatedByCharactersInSet:nonDigitCharacterSet];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSString *str in arr) {
//        if ([str containsString:@"  "]) {
//            break;
//        }
        NSRange rang = [text rangeOfString:str options:NSBackwardsSearch];
        [att addAttributes:@{NSFontAttributeName:font} range:rang];
    }
    
//    JUDIAN_READ_ReadRankModel *model =  self.info;
//    if (model.rankYesterdayDesc) {
//        NSRange rang1 = [text rangeOfString:model.rankYesterdayDesc];
//        [att addAttributes:@{NSFontAttributeName:kFontSize12,NSForegroundColorAttributeName:KSepColor} range:rang1];
//    }
    return att;
}





#pragma mark 懒加载
- (JUDIAN_READ_CircleProgress *)circleProgressView {
    if (!_circleProgressView) {
        CGRect rect =  CGRectMake((ScreenWidth-167)/2.0, Height_NavBar+10, 167, 167);

        //自定义起始角度
        _circleProgressView = [[JUDIAN_READ_CircleProgress alloc] initWithFrame:rect
                                                        pathBackColor:[UIColor lightGrayColor]
                                                        pathFillColor:[UIColor whiteColor]
                                                           startAngle:135
                                                          strokeWidth:20];
        _circleProgressView.frame = rect;
        _circleProgressView.showPoint = YES;
        _circleProgressView.showProgressText = YES;
        _circleProgressView.reduceValue = 90;
        _circleProgressView.hidden = NO;
        _circleProgressView.strokeWidth = 2;
        _circleProgressView.showDotLine = YES;
        _circleProgressView.progress = 0.0;
        _circleProgressView.sortLabStr = @"昨日未上榜";
    }
    return _circleProgressView;
}

- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 64;
        _tableView.verticalSpace = 50;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_SortCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_SortCell"];
        _tableView.tableHeaderView = self.headView;
        _tableView.noitceImageName = @"default_no_data";
        _tableView.noticeTitle = APP_NO_RECORD_TIP;
        WeakSelf(weakself);
        MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            weakself.isPullDown = YES;
            weakself.pageSize++;
            [weakself loadData];
        }];
        _tableView.emptyCallBack = ^(int type){
            weakself.pageSize = 1;
            [weakself loadData];
        };
        _tableView.mj_footer = foot;
        foot.stateLabel.textColor = kColor153;
        foot.stateLabel.font = kFontSize12;
        [foot setTitle:BOTTOM_LINE_TIP forState:MJRefreshStateNoMoreData];
        [foot setImages:nil forState:MJRefreshStateNoMoreData];
    }
    return _tableView;
}

- (UIView *)headView{
    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeadHeight)];
    
        self.backImageView = [[UIImageView alloc]initWithFrame:_headView.bounds];
        self.backImageView.image = [UIImage imageNamed:@"yesterday_bg"];
        self.backImageView.contentMode = UIViewContentModeScaleToFill;
        [_headView addSubview:self.backImageView];

        [_headView addSubview:self.circleProgressView];

        
        WeakSelf(obj);
        self.topView.touchBlock = ^{
            [GTCountSDK trackCountEvent:@"personal_home_page" withArgs:@{@"cource":@"阅读时长排行榜"}];
            [MobClick event:@"personal_home_page" attributes:@{@"source":@"阅读时长排行榜"}];

            JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
            vc.isSelf = YES;
            vc.uid_b = [JUDIAN_READ_Account currentAccount].uid;
            [obj.navigationController pushViewController:vc animated:YES];
        };
      

        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, HeadHeight-40, SCREEN_WIDTH, 15)];
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        [self.timeLab setText:@" " titleFontSize:17 titleColot:kColorWhite];
         [_headView addSubview:self.timeLab];
    }
    return _headView;
}


- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
        UIButton *imgV = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgV addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV setImage:[UIImage imageNamed:@"nav_return_white"] forState:UIControlStateNormal];
        imgV.frame = CGRectMake(0, Height_StatusBar, 47, Height_NavBar-Height_StatusBar);
        imgV.contentMode = UIViewContentModeCenter;
        self.imgV = imgV;
        [_navView addSubview:imgV];
        
        UILabel *centerLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, Height_StatusBar, 100, Height_NavBar - Height_StatusBar)];
        [centerLab setText:@"昨日排行榜" titleFontSize:17 titleColot:kColorWhite];
        centerLab.textAlignment = NSTextAlignmentCenter;
        self.centerLab = centerLab;
        [_navView addSubview:centerLab];
    }
    return _navView;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_SortCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_SortCell" forIndexPath:indexPath];
    [cell setSortDataWithModel:self.dataArr indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [GTCountSDK trackCountEvent:@"personal_home_page" withArgs:@{@"source":@"阅读时长排行榜"}];
    [MobClick event:@"personal_home_page" attributes:@{@"source":@"阅读时长排行榜"}];

    JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
    JUDIAN_READ_ReadRankModel *info = self.dataArr[indexPath.row];
    vc.uid_b = info.uidb;
    if ([[JUDIAN_READ_Account currentAccount].uid isEqualToString:[info uidb]]) {
        vc.isSelf = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    view.backgroundColor = kBackColor;
    return view;
}

#pragma mark scr代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offy = scrollView.contentOffset.y;
    if (offy <= 0) {
        self.backImageView.origin = CGPointMake(self.backImageView.origin.x, offy);
        self.backImageView.height = HeadHeight  - offy;
        self.backImageView.width = SCREEN_WIDTH  - offy;
        self.navView.backgroundColor = [kColorWhite colorWithAlphaComponent: 0];
        self.centerLab.textColor = kColorWhite;
        [self.imgV setImage:[UIImage imageNamed:@"nav_return_white"] forState:UIControlStateNormal];
        if ([self.navView.subviews containsObject:self.lineView]) {
            [self.lineView removeFromSuperview];
        }
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }else{
        [self.imgV setImage:[UIImage imageNamed:@"reader_left_back_tip"] forState:UIControlStateNormal];
        self.centerLab.textColor = kColor51;
        self.backImageView.origin = CGPointMake(0, 0);
        self.backImageView.height = HeadHeight;
        self.backImageView.width = SCREEN_WIDTH;
        self.navView.backgroundColor = [kColorWhite colorWithAlphaComponent: (1.0*offy)/(HeadHeight - Height_NavBar)];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

        if ((1.0*offy)/(HeadHeight - Height_NavBar) >= 1) {
            if (![self.navView.subviews containsObject:self.lineView]) {
                [self.navView addSubview:self.lineView];
            }
        }else{
            [self.lineView removeFromSuperview];
        }
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navView.height-0.5, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = KSepColor;
    }
    return _lineView;
}


@end
