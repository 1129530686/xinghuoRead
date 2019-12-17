//
//  JDCategoryController.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/17.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_DiscoveryController.h"
#import "JUDIAN_READ_DiscoveryLeadIconCell.h"
#import "JUDIAN_READ_DiscoveryMoreIconCell.h"
#import "JUDIAN_READ_DiscoveryBigIconCell.h"
#import "JUDIAN_READ_TagView.h"
#import "JUDIAN_READ_ArticleListModel.h"
#import "JUDIAN_READ_SearchController.h"
#import "JUDIAN_READ_TagModel.h"
#import "JUDIAN_READ_ArticleListModel.h"
#import "JUDIAN_READ_ContentBrowseController.h"
#import "JUDIAN_READ_CustomAlertView.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_RewardSuccessView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_MyController.h"
#import <GTSDK/GeTuiSdk.h>
#import "JUDIAN_READ_UserBriefViewController.h"
#import "JUDIAN_READ_MyInfoController.h"


@interface JUDIAN_READ_DiscoveryController ()

@property (nonatomic,strong) JUDIAN_READ_BaseTableView  *tableView;
@property (nonatomic,strong) NSMutableArray  *dataArr;
@property (nonatomic,strong) JUDIAN_READ_TagView  *tagView;
@property (nonatomic,strong) NSMutableArray  *typeArr;
@property (nonatomic,strong) UIView  *footView;
@property (nonatomic,strong) UIView  *navView;
@property (nonatomic,strong) UIButton  *btn;
@property (nonatomic,strong) UIButton  *rightBtn;
@property (nonatomic,strong) UIView  *backView;

@property (nonatomic,strong) UIImageView  *imageV;
@property (nonatomic,strong) UIButton  *boyImageV;
@property (nonatomic,strong) UIButton  *girlImageV;
@property (nonatomic,assign) int  isSelect;
@property (nonatomic,strong) UIView  *versionView;
@property (nonatomic,strong) UILabel  *textLab;
@property (nonatomic,strong) UILabel  *refreshNoticeView;
@property (nonatomic,assign) CGFloat  VersionHeight;


@end

@implementation JUDIAN_READ_DiscoveryController

- (instancetype)init{
    if (self = [super init]) {
        [MBProgressHUD showLoadingForView:self.tableView];
        [self checkAdverStatus];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if (![def objectForKey:@"hobby"]) {
            self.isSelect = 0;
            [self loadData:YES];
        }else{
            self.isSelect = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hobby"] intValue];
            [self loadData:YES];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
    [self loadUserData];
    [self loadUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tagView removeFromSuperview];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    NSString *str = @"head_default_small";
    if ([JUDIAN_READ_Account currentAccount].token) {
        str = @"head_small";
    }
    [self.btn sd_setImageWithURL:[NSURL URLWithString:[JUDIAN_READ_Account currentAccount].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:str]];
}


#pragma mark 网络请求
- (void)loadData:(BOOL)isFirst{
    NSMutableDictionary *dic = [@{@"type":[NSString stringWithFormat:@"%d",self.isSelect],@"pageSize":@"20"} mutableCopy];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageSize] forKey:@"page"];
    if (isFirst) {
       
        [dic setObject:[NSUserDefaults getUserDefaults:@"time1"] forKey:@"last_time"];
        if ([NSUserDefaults getUserDefaults:@"time2"]) {
            [dic setObject:[NSUserDefaults getUserDefaults:@"time2"] forKey:@"present_time"];
        }
    }
    [self checkNet];
    [JUDIAN_READ_DiscoveryTool getArticleListV1WithParams:dic completionBlock:^(id result,id error){
        [MBProgressHUD hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self checkVersion];
        });
        if (result) {
            if (!self.tableView.mj_footer.isRefreshing) {
                [self addNoticeView:result];
            }
            
            self.tableView.tableFooterView = nil;
            //下拉刷新
            if (!self.isPullDown) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:result];
            //没有更多
//            if([result count] < 20){
//                if (self.dataArr.count > 4) {
//                    self.tableView.tableFooterView = self.footView;
//                }
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
        }
        self.isPullDown = NO;
        [self.tableView reloadData];
    }];
}


- (void)loadUserData{
    if ([JUDIAN_READ_Account currentAccount].token.length) {
        [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
            if (result) {
                [self.btn sd_setImageWithURL:[NSURL URLWithString:[JUDIAN_READ_Account currentAccount].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_small"]];
            }
        }];
    }
}

- (void)addNoticeView:(NSArray *)result{
    if (!self.refreshNoticeView.window) {
        [self.view insertSubview:self.refreshNoticeView belowSubview:self.navView];
    }
    JUDIAN_READ_ArticleListModel *info = result.firstObject;
    self.refreshNoticeView.text = [NSString stringWithFormat:@"为您推荐%@条更新",info.refresh_num];
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.origin = CGPointMake(0, Height_NavBar+33);
        self.refreshNoticeView.frame = CGRectMake(0, Height_NavBar, SCREEN_WIDTH, 33);
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.origin = CGPointMake(0, Height_NavBar);
                self.refreshNoticeView.origin = CGPointMake(0, Height_NavBar-33);
            }completion:^(BOOL finished) {
                self.refreshNoticeView.frame = CGRectMake(SCREEN_WIDTH/2.0, Height_NavBar, 0, 33);
            }];
           
        });
    }];
}

- (void)loadTag:(NSInteger)needLoadData{
    [self checkNet];
    [JUDIAN_READ_DiscoveryTool getArticleTagV1WithParams:@{} completionBlock:^(id result, id error) {
        if (result) {
            self.typeArr = result;
            self.tagView.dataArr = self.typeArr;
            if (needLoadData) {
                [self loadData:NO];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.tableView];
        }
    }];
}


- (void)checkNet{
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        //[MBProgressHUD hideHUDForView:self.tableView];
    }

    WeakSelf(that);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:that.tableView];
    });
}

- (void)checkAdverStatus{    
    [JUDIAN_READ_DiscoveryTool getAdvertStatusUrlWithParams:^(id result, id error) {
        
    }];
}

- (void)getUserInfo{
    if ([JUDIAN_READ_Account currentAccount].token) {
        [JUDIAN_READ_MyTool getUserInfoWithParams:@{} completionBlock:^(id result, id error) {
        }];
    }
}

#pragma tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JUDIAN_READ_ArticleListModel *model = self.dataArr[indexPath.row];
    if (model.sort.integerValue == 1) {
        JUDIAN_READ_DiscoveryMoreIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_DiscoveryMoreIconCell" forIndexPath:indexPath];
        [cell setMoreDataWithModel:self.dataArr indexPath:indexPath];
        return cell;
    }
//    if (model.nid.intValue == -1000) {
//        JUDIAN_READ_DiscoveryBigIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_DiscoveryBigIconCell" forIndexPath:indexPath];
//        [cell setBigDataWithModel:self.dataArr indexPath:indexPath];
//        return cell;
//    }
    
    if (model.layout_type.integerValue == 1) {
        JUDIAN_READ_DiscoveryLeadIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_DiscoveryLeadIconCell" forIndexPath:indexPath];
        [cell setDiscoveryDataWithModel:self.dataArr indexPath:indexPath];
        return cell;
    }
    if (model.layout_type.integerValue == 3) {
        JUDIAN_READ_DiscoveryMoreIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_DiscoveryMoreIconCell" forIndexPath:indexPath];
        [cell setMoreDataWithModel:self.dataArr indexPath:indexPath];
        return cell;
    }
    JUDIAN_READ_DiscoveryBigIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JUDIAN_READ_DiscoveryBigIconCell" forIndexPath:indexPath];
    [cell setBigDataWithModel:self.dataArr indexPath:indexPath];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"信息流"}];
    [MobClick event:@"click_infor_flow" attributes:@{@"pageFlow":@"信息流"}];

    JUDIAN_READ_ArticleListModel *model = self.dataArr[indexPath.row];
    if (!model.aid) {
        return;
    }
    NSDictionary *paras = @{@"aid":model.aid};
    model.read_number = [NSString stringWithFormat:@"%ld",(long)(model.read_number.intValue+1)];
    [JUDIAN_READ_DiscoveryTool addReadRecorUrlWithParams:paras completionBlock:^(id result, id error) {
        
    }];
    

    if (model.nid.intValue == -1000) {
        [GTCountSDK trackCountEvent:@"personal_home_page" withArgs:@{@"fromExpose":@"信息流推荐书友"}];
        [MobClick event:@"personal_home_page" attributes:@{@"fromExpose":@"信息流推荐书友"}];
        JUDIAN_READ_MyInfoController *vc = [JUDIAN_READ_MyInfoController new];
        vc.uid_b = model.aid;
        if ([[JUDIAN_READ_Account currentAccount].uid isEqualToString:model.aid]) {
            vc.isSelf = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    NSString *type = one_small_picture;
    if (model.layout_type.integerValue == 1) {
        type = one_small_picture;
    }else if (model.layout_type.intValue == 2){
        type = one_big_picture;
    }else{
        type = three_picture;
    }
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"";
    }
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    if (!deviceName) {
        deviceName = @"";
    }
    NSDictionary* dic = @{type_record : type,
                          @"device" : deviceName,
                          @"sex" : sex,
                          };
    [MobClick event:click_infor_flow attributes:dic];
    
    [GTCountSDK trackCountEvent:click_infor_flow withArgs:@{type_record:type}];

    if (model.sort.intValue == 1) {
        [GTCountSDK trackCountEvent:click_infor_flow withArgs:@{@"mode":[NSString stringWithFormat:@"第%ld条置顶的信息流",(long)indexPath.row]}];
        [MobClick event:click_infor_flow attributes:@{@"mode":[NSString stringWithFormat:@"第%ld条置顶的信息流",(long)indexPath.row]}];

    }else{
        [GTCountSDK trackCountEvent:click_infor_flow withArgs:@{@"mode":@"非置顶的信息流"}];
        [MobClick event:click_infor_flow attributes:@{@"mode":@"非置顶的信息流"}];

    }
    
    if (!model.nid || !model.bookname) {
        return;
    }
    
    
    
    
    NSDictionary* dictionary = @{
                                 @"bookId":model.nid,
                                 @"bookName":model.bookname,
                                 @"chapterCount": @"",
                                 @"position" : @""
                                 };
    
#if 1
    [MobClick event:@"pv_app_reading_page" attributes:@{@"accessSource":@"信息流"}];
    [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"accessSource":@"信息流"}];
    
    [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:self.navigationController book:dictionary viewName:@"信息流"];
#else
    [MobClick event:@"pv_app_reading_page" attributes:@{@"accessSource":@"信息流"}];
    [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"accessSource":@"信息流"}];
    [JUDIAN_READ_FictionReadingViewController enterFictionViewController:self.navigationController book:dictionary viewName:@"信息流"];
    //[JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:model.aid];
    
#endif

}

#pragma mark 懒加载
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
        _navView.backgroundColor = kColorWhite;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, Height_StatusBar+5, 33, 33);
        [btn doBorderWidth:0.5 color:KSepColor cornerRadius:33/2.0];
        [btn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];
        self.btn = btn;
        btn.contentMode = UIViewContentModeScaleToFill;
        [_navView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
#if _IS_RELEASE_VERSION_ == 1
        [lab setText:@"今日推荐" titleFontSize:17 titleColot:kColor51];
#else
        [lab setText:@"今日推荐--测试版" titleFontSize:17 titleColot:kColor51];
#endif
        
        [_navView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(btn);
        }];
        

        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_under"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_under"] forState:UIControlStateHighlighted];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH-45-15, Height_StatusBar+5, 45, 33);
        [rightBtn addTarget:self action:@selector(selectCategory) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:rightBtn];
        NSString *text = self.isSelect == 1 ? @"男频" : @"女频";
        if (self.isSelect == 0) {
            text = @"全部";
        }
        [rightBtn setText:text titleFontSize:14 titleColot:kColor51];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        self.rightBtn = rightBtn;

        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_NavBar-0.5, SCREEN_WIDTH, 0.5)];
        sepView.backgroundColor = kBackColor;
        [_navView addSubview:sepView];
    }
    return _navView;
}

- (void)personAction{
    [MobClick event:personal_center attributes:@{resource_page:personal_center_find}];
    [MobClick event:click_infor_flow attributes:@{@"pageFlow":@"个人中心"}];
    [GTCountSDK trackCountEvent:personal_center withArgs:@{resource_page:personal_center_find}];
    [GTCountSDK trackCountEvent:@"click_infor_flow" withArgs:@{@"pageFlow":@"个人中心"}];


    CATransition *transition1 = [CATransition animation];
    transition1.duration = 0.3;
    transition1.type = kCATransitionPush;
    transition1.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition1 forKey:nil];
    JUDIAN_READ_MyController *vc = [JUDIAN_READ_MyController new];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)selectCategory{
    if (self.tagView.window) {
        [self.rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_under"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_under"] forState:UIControlStateHighlighted];
        [self.tagView removeFromSuperview];
    }else{
        [self.rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_on"] forState:UIControlStateHighlighted];
        [self.rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_on"] forState:UIControlStateNormal];
        [MobClick event:click_tag_find attributes:@{click_tag_label:click_tag_label}];
        [kKeyWindow addSubview:self.tagView];
        [self loadTag:NO];
    }
    [GTCountSDK trackCountEvent:@"click_tag_find" withArgs:@{@"discoveryLabel":@"点击次数"}];
    [MobClick event:@"click_tag_find" attributes:@{@"discoveryLabel":@"点击次数"}];

}



- (JUDIAN_READ_BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[JUDIAN_READ_BaseTableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_NavBar - Height_TabBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_DiscoveryLeadIconCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_DiscoveryLeadIconCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_DiscoveryMoreIconCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_DiscoveryMoreIconCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_DiscoveryBigIconCell" bundle:nil] forCellReuseIdentifier:@"JUDIAN_READ_DiscoveryBigIconCell"];
        
        WeakSelf(weakself);
        _tableView.emptyCallBack = ^(int type){
            weakself.pageSize = 1;
            [weakself loadData:NO];
        };
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isPullDown = NO;
            weakself.pageSize = 1;
            [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":@"信息流"}];
            [MobClick event:@"click_refresh" attributes:@{@"page":@"信息流"}];

            [weakself loadData:NO];
        }];
        
        MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            weakself.isPullDown = YES;
            weakself.pageSize++;
            [weakself loadData:NO];
        }];
        _tableView.mj_footer = foot;
        foot.stateLabel.textColor = kColor153;
        foot.stateLabel.font = kFontSize12;
        [foot setTitle:@"" forState:MJRefreshStateNoMoreData];
        [foot setImages:nil forState:MJRefreshStateNoMoreData];
        
    }
    return _tableView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [lab setText:BOTTOM_LINE_TIP titleFontSize:12 titleColot:kColor153];
        lab.textAlignment = NSTextAlignmentCenter;
        [_footView addSubview:lab];
    }
    return _footView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UILabel *)refreshNoticeView{
    if (!_refreshNoticeView) {
        _refreshNoticeView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, 0, 33)];
        _refreshNoticeView.backgroundColor = RGBA(255, 216, 226, 1);
        _refreshNoticeView.textAlignment = NSTextAlignmentCenter;
        [_refreshNoticeView setText:@"" titleFontSize:14 titleColot:kThemeColor];
    }
    return _refreshNoticeView;
}

- (JUDIAN_READ_TagView *)tagView{
    if (!_tagView) {
        _tagView = [[JUDIAN_READ_TagView alloc]initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_NavBar)];
        WeakSelf(obj);
        _tagView.refreshBlock = ^(id result, id count) {
            [obj.rightBtn setImage:[UIImage imageNamed:@"found_nav_arrow_under"] forState:UIControlStateNormal];
            if ([count intValue] == obj.isSelect) {
                return;
            }
            obj.pageSize = 1;
            [obj.rightBtn setTitle:result forState:UIControlStateNormal];
            [NSUserDefaults saveUserDefaults:@"hobby" value:count];
            obj.isSelect = [count intValue];
            [JUDIAN_READ_MyTool userPreferenceParams:@{@"type" : [NSString stringWithFormat:@"%d",obj.isSelect]} completionBlock:^(id result, id error) {
            }];
            [obj loadData:NO];
            [GTCountSDK trackCountEvent:@"click_tag_find" withArgs:@{@"selectType":@"result"}];
            [MobClick event:@"click_tag_find" attributes:@{@"selectType":@"result"}];

        };
        
    }
    return _tagView;
}

- (void)checkVersion{
    NSMutableDictionary *dic = [@{@"type":@"ios",@"versionNo":GET_VERSION_NUMBER} mutableCopy];
    if ([JUDIAN_READ_Account currentAccount].token) {
        [dic setObject:[JUDIAN_READ_Account currentAccount].token forKey:@"token"];
    }
    [JUDIAN_READ_MyTool getVersionWithParams:dic completionBlock:^(id result, id error) {
        if (result) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSString *version = [def objectForKey:@"version"];
            if (![result[@"version"] isEqualToString:version]) {
                [def setObject:result[@"version"] forKey:@"version"];
                [def setObject:@"isYes" forKey:@"isFirstLoad"];
                [def synchronize];
            }
            //版本不一致，且是第一次加载
            if ([JUDIAN_READ_TestHelper needUpdate] && [[def objectForKey:@"isFirstLoad"] isEqualToString:@"isYes"]) {
                NSString *str = result[@"content"];
                if ([str containsString:@"\\n"]) {
                    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                }
                self.VersionHeight =  [str heightForFont:kFontSize14 width:SCREEN_WIDTH-30];
                [kKeyWindow addSubview:self.versionView];
            
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
                NSDictionary *dic = @{NSFontAttributeName:kFontSize14,NSParagraphStyleAttributeName:paraStyle,NSForegroundColorAttributeName:kColor100};
                NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:str attributes:dic];
                paraStyle.lineSpacing = 3;
                self.textLab.attributedText = attributeStr;
            }
            
        }
    }];
}

- (UIView *)versionView{
    if (!_versionView) {
        _versionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _versionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        CGFloat width = SCREEN_WIDTH-120;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(60, (SCREEN_HEIGHT-width)/2.0, width, 200+self.VersionHeight+20)];
        view.backgroundColor = kColorWhite;
        [view doBorderWidth:0 color:nil cornerRadius:7];
        view.clipsToBounds = NO;

        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -6, width, 185/2.0)];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.image = [UIImage imageNamed:@"new_version_bg"];
        [view addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 185/2.0 + 10, width-30, self.VersionHeight+25)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.numberOfLines = 0;
        self.textLab = lab;
        [view addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 220+self.VersionHeight-80, width-30, 40);
        [btn addTarget:self action:@selector(updateVersion:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"members_button_pay"] forState:UIControlStateHighlighted];
        [btn setText:@"优先体验" titleFontSize:16 titleColot:kColorWhite];
        [btn doBorderWidth:0 color:nil cornerRadius:20];
        [view addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(15, 220+self.VersionHeight-40, width-30, 40);
        btn1.tag = 999;
        [btn1 addTarget:self action:@selector(updateVersion:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setText:@"以后再说" titleFontSize:14 titleColot:kColor153];
        [view addSubview:btn1];

        [_versionView addSubview:view];
        
    }
    return _versionView;
}

- (void)updateVersion:(UIButton *)btn{
    [self.versionView removeFromSuperview];
    if (btn.tag == 999) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isFirstLoad"];
    }else{
        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",@"1462710009"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}




- (void)loadUI{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"hobby"]) {
        return;
    }
    [def setObject:@"0" forKey:@"hobby"];
    [def synchronize];
    self.isSelect = 0;
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.backView = backView;
    [kKeyWindow addSubview:backView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(60, (SCREEN_HEIGHT-SCREEN_WIDTH+120)/2, SCREEN_WIDTH-120, SCREEN_WIDTH-130)];
    view.backgroundColor = kColorWhite;
    [view doBorderWidth:0 color:nil cornerRadius:7];
    [backView addSubview:view];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, 84)];
    [lab setText:@"选择性别，进入小说专区" titleFontSize:19 titleColot:kColor51];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(touchBoy) forControlEvents:UIControlEventTouchUpInside];
    NSString *imgN = iPhone6Plus ? @"bounced_gender_boy2" : @"bounced_gender_boy";
    CGFloat h = iPhone6Plus ? 150 : 110;
    [btn1 setImage:[UIImage imageNamed:imgN] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:imgN] forState:UIControlStateHighlighted];
    self.boyImageV = btn1;
    btn1.frame = CGRectMake((view.width - 230-30)/2.0, 84, 115, h);
    btn1.contentMode = UIViewContentModeTop;
    [btn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *imgN1 = iPhone6Plus ? @"bounced_gender_girl2" : @"bounced_gender_girl";
    [btn2 addTarget:self action:@selector(touchGirl) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:imgN1] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:imgN1] forState:UIControlStateHighlighted];
    self.girlImageV = btn2;
    btn2.frame = CGRectMake((view.width - 230-30)/2.0 + 115 + 30, 84, 115, h);
    [btn2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    btn2.contentMode = UIViewContentModeTop;
    [view addSubview:btn2];
    
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake((SCREEN_WIDTH-33)/2, CGRectGetMaxY(view.frame) + 27, 33, 33);
    [delBtn setImage:[UIImage imageNamed:@"close_prompt_button"] forState:UIControlStateNormal];
    [delBtn setImage:[UIImage imageNamed:@"close_prompt_button"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:delBtn];
    
}


- (void)touchBoy{
    self.isSelect = 1;
    [MobClick event:click_interest attributes:@{@"gender":@"男频"}];
    [GTCountSDK trackCountEvent:click_interest withArgs:@{@"gender":@"男频"}];

    [self startAction];
}

- (void)touchGirl{
    self.isSelect = 2;
    [GTCountSDK trackCountEvent:click_interest withArgs:@{@"gender":@"女频"}];
    [MobClick event:click_interest attributes:@{@"gender":@"女频"}];
    [self startAction];
}


#pragma mark 开始
- (void)startAction{
    [self.backView removeFromSuperview];
    NSInteger i = self.isSelect == 2 ? 1 : 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startAction" object:nil userInfo:@{@"key":@(i)}];
    NSString *sex = self.isSelect == 1 ? @"男频" : @"女频";
    if (self.isSelect == 0) {
        sex = @"全部";
    }
    [NSUserDefaults saveUserDefaults:@"hobby" value:[NSString stringWithFormat:@"%d",self.isSelect]];
    [self.rightBtn setTitle:sex forState:UIControlStateNormal];
    
    if (self.isSelect == NO) {
        return;
    }
    [JUDIAN_READ_MyTool userPreferenceParams:@{@"type" : [NSString stringWithFormat:@"%d",self.isSelect]} completionBlock:^(id result, id error) {
        [self loadTag:YES];
    }];
    
    NSString *version = GET_VERSION_NUMBER;
    NSString *tagName = [NSString stringWithFormat:@"%@,%@,iphone",sex,version];
    NSArray *tagNames = [tagName componentsSeparatedByString:@","];
    [GeTuiSdk setTags:tagNames];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
