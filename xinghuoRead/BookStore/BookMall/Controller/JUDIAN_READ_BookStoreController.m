//
//  MainViewController.m
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//


#import "JUDIAN_READ_BookStoreController.h"
#import "JUDIAN_READ_BannerReusableView.h"
#import "JUDIAN_READ_CollectionHeadReuseView.h"
#import "JUDIAN_READ_NorvalColCell.h"
#import "JUDIAN_READ_SearchController.h"
#import "JUDIAN_READ_TypeCell.h"
#import "JUDIAN_READ_MyController.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_AllCategoryController.h"
#import "JUDIAN_READ_ChildCategoryController.h"
#import "JUDIAN_READ_BannarView.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_BannarWebController.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_BannarModel.h"
#import "JUDIAN_READ_MainViewController.h"
#import "JUDIAN_READ_DiscoveryController.h"
#import "JUDIAN_READ_PlatformController.h"
#import "JUDIAN_READ_BookStoreModel.h"
#import "JUDIAN_READ_ImageLabelColCell.h"
#import "JUDIAN_READ_BookLeaderboardController.h"
#import "JUDIAN_READ_BottomReusableView.h"
#import "JUDIAN_READ_UserLocationManager.h"
//#import "JUDIAN_READ_InterestNorvelColCell.h"



#define headimageHeight   (Height_NavBar + 65) //头部视图的高度
#define headContentHeight   (Height_NavBar + 65 + (SCREEN_WIDTH - 10)/3) //头部视图的高度


@interface JUDIAN_READ_BookStoreController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>

@property (nonatomic,strong) JUDIAN_READ_UserLocationManager *locationManager;

@property (nonatomic,strong) JUDIAN_READ_BannerReusableView  *headContentView;
@property (nonatomic,copy) NSString  *catID;
@property (nonatomic,assign) CGFloat  imageHeight;
@property (nonatomic,assign) BOOL  isFirstLoad;

@property (nonatomic,copy) NSArray  *categoryArr;//顶部
@property (nonatomic,strong) NSArray  *childCategoryArr;//一二页的分类
@property (nonatomic,strong) NSMutableDictionary  *allListDic;//四个小说列表
@property (nonatomic,copy) NSArray  *requestArr;
@property (nonatomic,strong) NSMutableArray  *headTitleArr;

@property (nonatomic,assign) int  page;
@property (nonatomic,assign) int  page1;
@property (nonatomic,assign) int  page2;
@property (nonatomic,assign) int  page3;

@property (nonatomic,strong) UILabel  *refreshNoticeView;


@end

@implementation JUDIAN_READ_BookStoreController

- (instancetype)init{
    if (self = [super init]) {
        [self scrView];
        self.page = self.page1 = 1;
        self.page2 = self.page3 = 0;
        self.isFirstLoad = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAction:) name:@"startAction" object:nil];
        self.selectItem = [[NSUserDefaults getUserDefaults:@"selectItem"] intValue];
        [MBProgressHUD showLoadingForView:self.scrView];
        JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!app.isHaveNet) {
            //[MBProgressHUD hideHUDForView:self.scrView];
        }
        [self getLocation];
        [self loadParentDataFromBottom:NO];

    }
    return self;
}

- (void)getLocation {
    self.locationManager = [[JUDIAN_READ_UserLocationManager alloc] init];
    [self.locationManager startLocationService];
    self.locationManager.simpleLocationBlock = ^(id  _Nullable arg1, id  _Nullable arg2, id  _Nullable arg3) {
        NSString *city = arg2 ? arg2 : @"";
        NSString *area = arg3 ? arg3 : @"";
        [NSUserDefaults saveUserDefaults:@"city" value:city];
        [NSUserDefaults saveUserDefaults:@"area" value:area];
    };
}

- (void)startAction:(NSNotification *)noti{
    NSString *str = noti.userInfo[@"key"];
    self.selectItem = str.intValue;
    if (self.selectItem == 1) {
        self.isFirstLoad = YES;
        [self loadParentDataFromBottom:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headContentView];
    for (UICollectionView *view in self.scrView.subviews) {
        if ([view isKindOfClass:[UICollectionView class]]) {
            AdjustsScrollViewInsetNever(self,view);
        }
    }
    [self.view addSubview:self.scrView];
    UICollectionView *view = (UICollectionView *)self.scrView.subviews[self.selectItem];
    if ([view isKindOfClass:[UICollectionView class]]) {
        [view reloadData];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];
    UIButton *btn = self.headContentView.btns.firstObject;
    NSString *str = @"head_default_small";
    if ([JUDIAN_READ_Account currentAccount].token) {
        str = @"head_small";
    }
    [btn sd_setImageWithURL:[NSURL URLWithString:[JUDIAN_READ_Account currentAccount].avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:str]];
}



#pragma mark 懒加载
- (UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_NavBar+5, SCREEN_WIDTH, SCREEN_HEIGHT-Height_NavBar-Height_TabBar-5)];
        _scrView.contentSize = CGSizeMake(SCREEN_WIDTH *4,  0);
        _scrView.pagingEnabled = YES;
        _scrView.bounces = NO;
        _scrView.showsHorizontalScrollIndicator = NO;
        _scrView.delegate = self;
        for (NSInteger i = 0; i < 4; i++) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            JUDIAN_READ_BaseCollectionView *collectView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            collectView.delegate = self;
            collectView.dataSource = self;
            collectView.backgroundColor = [UIColor clearColor];
            collectView.showsVerticalScrollIndicator = NO;
            [collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_TypeCell class]) bundle:nil] forCellWithReuseIdentifier:@"JUDIAN_READ_TypeCell"];
            [collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_ImageLabelColCell class]) bundle:nil] forCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell"];
            [collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_NorvalColCell class]) bundle:nil] forCellWithReuseIdentifier:@"JDNorvalCell"];
            [collectView registerNib:[UINib nibWithNibName:@"JUDIAN_READ_CollectionHeadReuseView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReuse"];
            [collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
            [collectView registerClass:[JUDIAN_READ_BannarView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JUDIAN_READ_BannarView"];
            [collectView registerNib:[UINib nibWithNibName:NSStringFromClass([JUDIAN_READ_BottomReusableView class]) bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"JUDIAN_READ_BottomReusableView"];

            WeakSelf(weakself);
            collectView.emptyCallBack = ^(int type){
                [weakself loadParentDataFromBottom:NO];
            };

            collectView.mj_header.backgroundColor = [UIColor clearColor];
           MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
               [weakself getSelectPage:NO isReset:YES];
                [weakself loadParentDataFromBottom:YES];
            }];
            collectView.mj_header = header;
            
            MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                if (i < 2) {
                    [weakself getSelectPage:YES isReset:NO];
                    [weakself loadSomeDataAll:NO];
                }else{
                    [weakself getSelectPage:YES isReset:NO];
                    [weakself loadMoreData];
                }
               
            }];
            collectView.mj_footer = foot;
           
            collectView.frame = CGRectMake((SCREEN_WIDTH*i), 0, SCREEN_WIDTH, SCREEN_HEIGHT-Height_NavBar-Height_TabBar-5);
            [_scrView addSubview:collectView];
            
        }
    }
    return _scrView;
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

    }else if (self.selectItem == 2){
        self.page2 = isAdd ? ++self.page2 : self.page2;
        self.page2 = isRestSet ? 1 : self.page2;
        page = self.page2;

    }else{
        self.page3 = isAdd ? ++self.page3 : self.page3;
        self.page3 = isRestSet ? 1 : self.page3;
        page = self.page3;
    }
    
    return [NSString stringWithFormat:@"%d",page];
}

//四个模块
- (NSMutableDictionary *)allListDic{
    if (!_allListDic) {
        _allListDic = [NSMutableDictionary dictionary];
    }
    return _allListDic;
}


- (NSArray *)childCategoryArr{
    if (!_childCategoryArr) {
        NSDictionary *dic = @{@"name":@"榜单",@"cover":@"book_city_icon_list",@"id":@""};
        NSDictionary *dic1 = @{@"name":@"完结",@"cover":@"book_city_icon_end",@"id":@""};
        NSDictionary *dic2 = @{@"name":@"聚合",@"cover":@"book_city_icon_aggregation",@"id":@""};
        NSDictionary *dic3 = @{@"name":@"分类",@"cover":@"book_city_icon_classification",@"id":@""};
        _childCategoryArr = [NSMutableArray arrayWithObjects:dic,dic1,dic2,dic3, nil];
    }
    return _childCategoryArr;
}

- (NSArray *)requestArr{
    if (!_requestArr) {
        _requestArr = @[@"",@"push",@"like",@"newest",@"faves"];
    }
    return _requestArr;
}
- (NSMutableArray *)headTitleArr{
    if (!_headTitleArr) {
        _headTitleArr = [NSMutableArray arrayWithObjects:@"本周强推",@"猜你喜欢",@"最新上架",@"书友最爱",nil];
    }
    return _headTitleArr;
}





- (JUDIAN_READ_BannerReusableView *)headContentView{
    if (!_headContentView) {
        _headContentView = [[JUDIAN_READ_BannerReusableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, headContentHeight)];
        _headContentView.backgroundColor = kColorWhite;
        WeakSelf(obj);
        _headContentView.touchNavBlock = ^(NSInteger tag, id  _Nonnull catID) {
            UICollectionView *view = obj.scrView.subviews[obj.selectItem];
            [view.mj_header endRefreshing];
            [view.mj_footer endRefreshing];
            if (catID) {
                obj.selectItem = tag-1;
                obj.headContentView.backgroundColor = kColorWhite;
                [NSUserDefaults saveUserDefaults:@"selectItem" value:[NSString stringWithFormat:@"%ld",(long)obj.selectItem]];
                obj.scrView.contentOffset = CGPointMake(obj.selectItem*SCREEN_WIDTH, obj.scrView.contentOffset.y);
                UICollectionView *view1 = obj.scrView.subviews[obj.selectItem];
                [obj scrollViewDidScroll:view1];
                obj.catID = catID[@"value"];
                if (![obj.allListDic objectForKey:[NSString stringWithFormat:@"%ld",(long)obj.selectItem]]) {
                    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
                    if (app.isHaveNet) {
                        [obj loadData:catID isFromBottom:NO];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BadNet" object:obj];
                        return;
                    }
                }
                
                UICollectionView *view = obj.scrView.subviews[obj.selectItem];
                [view reloadData];
                
                if (obj.categoryArr.count > obj.selectItem) {
                    NSDictionary *dic = obj.categoryArr[obj.selectItem];
                    [MobClick event:click_topmenu_bookcity attributes:@{@"type":dic[@"name"]}];
                    [GTCountSDK trackCountEvent:click_topmenu_bookcity withArgs:@{@"type":dic[@"name"]}];
                    
                }
            }else{
                if (tag == 0) {
                    [obj personAction];
                }
                if (tag == 5) {
                    [obj search];
                }
            }
        };
    }
    return _headContentView;
}



- (void)personAction{
    [MobClick event:personal_center attributes:@{resource_page:personal_center_bookcity}];
    [GTCountSDK trackCountEvent:personal_center withArgs:@{resource_page:personal_center_bookcity}];
    
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 0.3;
    transition1.type = kCATransitionPush;
    transition1.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition1 forKey:nil];
    JUDIAN_READ_MyController *vc = [JUDIAN_READ_MyController new];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)search{
    
    NSArray* array = self.navigationController.viewControllers;
    for (UIViewController* element in array) {
        if ([element isKindOfClass:[JUDIAN_READ_SearchController class]]) {
            return;
        }
    }
    JUDIAN_READ_SearchController *vc = [[JUDIAN_READ_SearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark 网络请求
/**
    头部item获取
 */
- (void)loadParentDataFromBottom:(BOOL)isYES{
    [JUDIAN_READ_BookMallTool getParentCategoryListWithParams:@{} completionBlock:^(id result, id error) {
        [MBProgressHUD hideHUDForView:self.scrView];
        if (result) {
            self.categoryArr = result;
            self.headContentView.dataArr = result;
            if (self.isFirstLoad) {
                [self.headContentView touchNavsAction:self.headContentView.btns[self.selectItem+1] isTouch:YES];
                self.isFirstLoad = NO;
            }else{
                [self loadData:self.categoryArr[self.selectItem] isFromBottom:isYES];
            }
        }
    }];
}

/**
 "name":"男生",
 "field":"cat_id",
 "value":"17"
 头部点击刷新
 */
- (void)loadData:(NSDictionary *)typeDic isFromBottom:(BOOL)isYES{
    if (!typeDic.count) {
        return;
    }
    self.catID = typeDic[@"value"];
    if (self.selectItem < 2) {
        [self loadFirstDataAll:isYES];
    }else{
        [self loadNewData:isYES];
    }
}

//1、2首次列表
- (void)loadFirstDataAll:(BOOL)loadAll{
    if (!self.catID) {
        return;
    }
    if (self.categoryArr.count > self.selectItem && [self getSelectPage:NO isReset:NO].intValue == 1) {
        [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];
        [MobClick event:@"click_refresh" attributes:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];
        
    }
    NSInteger item = self.selectItem;
    UICollectionView *view = self.scrView.subviews[item];
    if (!view.mj_header.isRefreshing && !loadAll) {
        [MBProgressHUD showLoadingForView:self.scrView];
    }
    NSMutableDictionary *dic = [@{@"cat_id":self.catID,@"type":@"like"} mutableCopy];
    [self setNewValue:dic];
    [JUDIAN_READ_BookMallTool getNewBookOneTwoHomeListWithParams:dic completionBlock:^(id _Nullable result, id _Nullable error) {
        [MBProgressHUD hideHUDForView:self.scrView];
        [view.mj_header endRefreshing];
        [view.mj_footer endRefreshing];
        if (result) {
            if (!view.mj_footer.isRefreshing) {
                [self addNoticeView:result];
            }
            
            [self.allListDic setObject:result forKey:[NSString stringWithFormat:@"%ld", item]];
        }
        [view reloadData];
    }];
 
}

- (void)setNewValue:(NSMutableDictionary *)dic{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *area = [def objectForKey:@"area"];
    NSString *city = [def objectForKey:@"city"];
    if (city.length && city) {
        [dic setObject:city forKey:@"city"];
    }
    if (area.length && area) {
        [dic setObject:area forKey:@"area"];
    }
}



//1，2加载列表
- (void)loadSomeDataAll:(BOOL)loadAll{
    if (!self.catID) {
        return;
    }
    if (self.categoryArr.count > self.selectItem && [self getSelectPage:NO isReset:NO].intValue == 1) {
        [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];
        [MobClick event:@"click_refresh" attributes:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];

    }
    NSMutableDictionary *dic = [@{@"cat_id":self.catID,@"type":@"like",@"pageSize":@"10"} mutableCopy];
    [self setNewValue:dic];
    [dic setObject:[self getSelectPage:NO isReset:NO] forKey:@"page"];
    NSInteger item = self.selectItem;
    [JUDIAN_READ_BookMallTool getBookHomeListWithParams:dic completionBlock:^(id result, id error) {
        UICollectionView *view = self.scrView.subviews[item];
        [view.mj_header endRefreshing];
        [view.mj_footer endRefreshing];
        if (result) {
            NSMutableArray *models = [self.allListDic objectForKey:[NSString stringWithFormat:@"%ld", item]];
            if (models) {
                
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:models];
                [arr addObjectsFromArray:result];
                [self.allListDic setObject:arr forKey:[NSString stringWithFormat:@"%ld", item]];
            }
        }
        [view reloadData];

    }];
}

- (void)addNoticeView:(NSArray *)result{
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



//3.4首次
- (void)loadNewData:(BOOL)isYES{
    if (!self.catID) {
        return;
    }
    NSInteger item = self.selectItem;
    UICollectionView *view = self.scrView.subviews[item];
    if (!view.mj_header.isRefreshing && !isYES) {
        [MBProgressHUD showLoadingForView:self.scrView];
    }
    if (self.categoryArr.count > self.selectItem && [self getSelectPage:NO isReset:NO].intValue == 1) {
        [GTCountSDK trackCountEvent:@"click_refresh" withArgs:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];
        [MobClick event:@"click_refresh" attributes:@{@"page":[NSString stringWithFormat:@"bookMall-%@",self.categoryArr[self.selectItem][@"name"]]}];
    }
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        //[MBProgressHUD hideHUDForView:self.scrView];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.catID forKey:@"cat_id"];
    
    [JUDIAN_READ_BookMallTool getNewBookHomeListWithParams:dic completionBlock:^(id _Nullable result, id _Nullable error) {
        UICollectionView *view = self.scrView.subviews[item];
        [MBProgressHUD hideHUDForView:self.scrView];
        [view.mj_header endRefreshing];
        [view.mj_footer resetNoMoreData];
        if (result && item > 1) {
            if (!view.mj_footer.isRefreshing) {
                [self addNoticeView:result];
            }
            [self.allListDic setObject:result forKey:[NSString stringWithFormat:@"%ld", item]];
        }
        [view reloadData];

    }];
}

//3.4加载列表
- (void)loadMoreData{
    if (!self.catID) {
        return;
    }
    NSInteger item = self.selectItem;
    NSMutableDictionary *dic = [@{@"cat_id":self.catID,@"pageSize":@"20"} mutableCopy];
    [dic setObject:[self getSelectPage:NO isReset:NO] forKey:@"page"];
    [JUDIAN_READ_BookMallTool getNewBookHomePullListWithParams:dic completionBlock:^(id _Nullable result, id _Nullable error) {
        UICollectionView *view = self.scrView.subviews[item];
        [view.mj_footer endRefreshing];
        if (result && item > 1) {
            if ([result count] < 20) {
                [view.mj_footer endRefreshingWithNoMoreData];
            }
            JUDIAN_READ_BookStoreModel *model = [self.allListDic objectForKey:[NSString stringWithFormat:@"%ld", item]];
            if (model) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:model.faves];
                [arr addObjectsFromArray:result];
                model.faves = arr;
                [self.allListDic setObject:model forKey:[NSString stringWithFormat:@"%ld", item]];
            }
        }
        [view reloadData];
    }];
    
}


//3.4切换列表
- (void)loadSomeData:(NSString *)cat all:(BOOL)loadAll{
    if (!self.catID || !cat.length) {
        return;
    }
    NSDictionary *dic = @{@"cat_id":self.catID,@"type":cat};
    NSInteger item = self.selectItem;
    [JUDIAN_READ_BookMallTool getBookHomeListV0WithParams:dic completionBlock:^(id result, id error) {
        UICollectionView *view = self.scrView.subviews[item];
        if (result && item > 1) {
            
            JUDIAN_READ_BookStoreModel *model = [self.allListDic objectForKey:[NSString stringWithFormat:@"%ld", item]];
            if ([cat isEqualToString: @"push"]) {
                model.push = result;
            }else if ([cat isEqualToString:@"like"]){
                model.like = result;
            }else if ([cat isEqualToString:@"newest"]){
                model.newest = result;
            }else{
                model.faves = result;
            }
            [self.allListDic setObject:model forKey:[NSString stringWithFormat:@"%ld", item]];
        }
        [view reloadData];
    }];
}




#pragma mark 获取colView
- (NSString *)getReloadView:(UICollectionView *)colView{
    NSInteger i = self.selectItem;
    if ([colView isEqual:self.scrView.subviews[0]]) {
        i = 0;
    }else if ([colView isEqual:self.scrView.subviews[1]]){
        i = 1;
    }else if ([colView isEqual:self.scrView.subviews[2]]){
        i = 2;
    }else if ([colView isEqual:self.scrView.subviews[3]]){
        i = 3;
    }
    return [NSString stringWithFormat:@"%ld",(long)i];
}



#pragma mark collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self getReloadView:collectionView].intValue < 2) {
        NSArray *arr = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        if (arr.count) {
            return arr.count+1;
        }
//        if(self.childCategoryArr.count){
//            return 1;
//        }
        return 0;
    }else{
        JUDIAN_READ_BookStoreModel *dic = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        if (dic) {
            return 5;
        }
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self getReloadView:collectionView].intValue < 2){
        if (section == 0) {
            return self.childCategoryArr.count;
        }
        NSArray *arr = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        JUDIAN_READ_BookStoreModel *model = arr[section-1];
        return model.books.count;
    }else{
        JUDIAN_READ_BookStoreModel *dic = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        if (section == 0) {
            NSArray *arr = dic.sub_categorys;
            return arr.count ? arr.count + 1 : 0;
        }
        if (section == 1 ) {
            return [dic.push count];
        }
        if (section == 2){
            return [dic.like count];
        }
        if (section == 3) {
            return [dic.newest count];
        }
        if (section == 4) {
            return [dic.faves count];
        }
        return 0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self getReloadView:collectionView].intValue < 2){
        if (indexPath.section == 0) {//类型
            JUDIAN_READ_ImageLabelColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell" forIndexPath:indexPath];
            [cell setTypeDataWithModel:self.childCategoryArr indexPath:indexPath];
            return cell;
        }
        
        NSArray *arr = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        JUDIAN_READ_NorvalColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDNorvalCell" forIndexPath:indexPath];
        
        NSInteger section = indexPath.section - 1;
        if (section < arr.count) {
            JUDIAN_READ_BookStoreModel *model = arr[section];
            [cell setPushDataWithModel:model.books indexPath:indexPath];
        }

        return cell;
        
    }else{
        
        JUDIAN_READ_BookStoreModel *dic = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        
        if (indexPath.section == 0) {//类型
            JUDIAN_READ_TypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_TypeCell" forIndexPath:indexPath];
            [cell setTypeDataWithModel:dic.sub_categorys indexPath:indexPath];
            return cell;

        }
        if (indexPath.section == 1 || indexPath.section == 2) {//强推
            id model = indexPath.section == 1 ? dic.push : dic.like;
            if (indexPath.row != 0) {
                JUDIAN_READ_ImageLabelColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JUDIAN_READ_ImageLabelColCell" forIndexPath:indexPath];
                if (model) {
                    [cell setBookHomeDataWithModel:model indexPath:indexPath];
                }
                return cell;
            }
          
        }
        JUDIAN_READ_NorvalColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JDNorvalCell" forIndexPath:indexPath];
        [cell setv0PushDataWithModel:dic indexPath:indexPath];
        return cell;
        
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //尾部
    if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse" forIndexPath:indexPath];
            view.backgroundColor = kBackColor;
            return view;
        }
       
    }
    WeakSelf(obj);
    if (indexPath.section == 0) {
        JUDIAN_READ_BannarView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JUDIAN_READ_BannarView" forIndexPath:indexPath];
        JUDIAN_READ_BookStoreModel *dic1;
        if ([self getReloadView:collectionView].intValue < 2){
            dic1 = [[self.allListDic valueForKey:[self getReloadView:collectionView]] firstObject];
        }else{
            dic1 = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        }
        if (dic1.store_carousel) {
            [view setBannarArr:[NSMutableArray arrayWithArray:dic1.store_carousel]];
        }
        view.touchBlock = ^(NSInteger index) {
            if (obj.categoryArr.count > obj.selectItem) {

                NSDictionary *dic = obj.categoryArr[obj.selectItem];
                [MobClick event:click_lunbotu_bookcity attributes:@{@"source":dic[@"name"]}];
                [GTCountSDK trackCountEvent:click_lunbotu_bookcity withArgs:@{source_record:dic[@"name"]}];

                JUDIAN_READ_BannarModel *model = dic1.store_carousel[index];
                if ([model nid]) {
                    [MobClick event:pv_app_introduce_page attributes:@{@"source":norval_bannar_page}];
                    [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record:norval_bannar_page}];

                }
                if ([model.type isEqualToString:@"html"]) {
                    JUDIAN_READ_BannarWebController *vc = [JUDIAN_READ_BannarWebController new];
                    vc.url = model.url;
                    [obj.navigationController pushViewController:vc animated:YES];
                }else{
                    if ([model.type isEqualToString:@"picture"]) {
                        return;
                    }
                    [JUDIAN_READ_NovelDescriptionViewController enterDescription:obj.navigationController bookId:model.nid bookName:@"" viewName:norval_bannar_page];
                }

            }

        };
        return view;
    }
    
    //头部其它分区
    JUDIAN_READ_CollectionHeadReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headReuse" forIndexPath:indexPath];
    NSArray *arr = [self.allListDic valueForKey:[self getReloadView:collectionView]];
    if ([self getReloadView:collectionView].intValue < 2){
        [view setHomeDataWithModel:arr indexPath:indexPath];

    }else{
        view.refreshBlock = ^{
            if (indexPath.section == 1) {
                [MobClick event:click_change_refresh attributes:@{source_record:@"本周强推"}];
                [GTCountSDK trackCountEvent:click_change_refresh withArgs:@{source_record:@"本周强推"}];
            }else if (indexPath.section == 2){
                [MobClick event:click_change_refresh attributes:@{source_record:@"猜你喜欢"}];
                [GTCountSDK trackCountEvent:click_change_refresh withArgs:@{source_record:@"猜你喜欢"}];
            }else if (indexPath.section == 3){
                [MobClick event:click_change_refresh attributes:@{source_record:@"最新"}];
                [GTCountSDK trackCountEvent:click_change_refresh withArgs:@{source_record:@"最新"}];
            }else{
                [MobClick event:click_change_refresh attributes:@{source_record:@"书友最爱"}];
                [GTCountSDK trackCountEvent:click_change_refresh withArgs:@{source_record:@"书友最爱"}];
            }
            [obj loadSomeData:self.requestArr[indexPath.section] all:NO];
        };
        [view setV0HomeDataWithModel:self.headTitleArr indexPath:indexPath];
    }
    return view;
}

#pragma mark flowLayout代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self getReloadView:collectionView].intValue < 2){

        if (indexPath.section == 0) {
            return CGSizeMake((SCREEN_WIDTH-42)/4, 55);

        }
        NSArray *arr = [self.allListDic valueForKey:[self getReloadView:collectionView]];
        JUDIAN_READ_BookStoreModel *model = arr[indexPath.section-1];
        CGFloat h = indexPath.row == model.books.count - 1 ? 1.35*(SCREEN_WIDTH-30-54)/4 + 10: 1.35*(SCREEN_WIDTH-30-54)/4 + 28;
        return CGSizeMake(SCREEN_WIDTH, h);
        
    }else{
        
        if (indexPath.section == 0) {
            return CGSizeMake((SCREEN_WIDTH-42)/4, 45);
        }
        if (indexPath.section == 1 || indexPath.section == 2) {
            if (indexPath.row != 0) {
                return CGSizeMake((SCREEN_WIDTH-30-54)/4, 1.35*(SCREEN_WIDTH-30-54)/4 + 55);
            }

        }
        
        return CGSizeMake(SCREEN_WIDTH-15, 1.35*(SCREEN_WIDTH-30-54)/4 + 20);        
    }
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if ([self getReloadView:collectionView].intValue < 2){
        if (section == 0) {
            return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-30)/3 + 10);
        }
        
        return CGSizeMake(SCREEN_WIDTH, 56);
    }else{
        if (section == 0) {
            return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-30)/3 + 10);
        }
        return CGSizeMake(SCREEN_WIDTH, 56);
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(13, 15, 10, 15);
    }
    if ([self getReloadView:collectionView].intValue < 2){
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 18;
    }
    return 0;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self getReloadView:collectionView].intValue >= 2){
        if (indexPath.section == 0) {//分区为1
            JUDIAN_READ_BookStoreModel *dic1 = [self.allListDic valueForKey:[self getReloadView:collectionView]];
            NSArray *arr = dic1.sub_categorys;
            if (indexPath.row >= arr.count) {
                JUDIAN_READ_AllCategoryController *vc = [JUDIAN_READ_AllCategoryController new];
                vc.section = self.selectItem;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                JUDIAN_READ_ChildCategoryController *vc = [JUDIAN_READ_ChildCategoryController new];
                vc.isPublish = self.selectItem == 2 ? YES : NO;
                vc.category = arr[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
            NSString *sex = [self getReloadView:collectionView].intValue == 0 ? @"publish" : @"terror";
            NSString *Str = [NSString stringWithFormat:@"click_bookcity_subtype_%@",sex];
            [GTCountSDK trackCountEvent:Str withArgs:@{@"location":[NSString stringWithFormat:@"分类位置%ld",(long)indexPath.row+1]}];
            [MobClick event:Str attributes:@{@"location":[NSString stringWithFormat:@"分类位置%ld",(long)indexPath.row+1]}];
        }
        else {
            [self enterNovelDescriptionViewControllerV0:indexPath];
        }
        return;
    }

    
    if (indexPath.section == 0) {//分区为1
        NSString *sex = [self getReloadView:collectionView].intValue == 0 ? @"boy" : @"girl";
        NSString *Str = [NSString stringWithFormat:@"click_bookcity_subtype_%@",sex];
        [GTCountSDK trackCountEvent:Str withArgs:@{@"location":self.childCategoryArr[indexPath.row][@"name"]}];
        [GTCountSDK trackCountEvent:@"click_bookcity_subtype" withArgs:@{@"type":self.childCategoryArr[indexPath.row][@"name"]}];
        [MobClick event:Str attributes:@{@"location":self.childCategoryArr[indexPath.row][@"name"]}];
        [MobClick event:@"click_bookcity_subtype" attributes:@{@"type":self.childCategoryArr[indexPath.row][@"name"]}];

        if (indexPath.row == 3) {
            JUDIAN_READ_AllCategoryController *vc = [JUDIAN_READ_AllCategoryController new];
            vc.section = self.selectItem;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            JUDIAN_READ_PlatformController *vc = [JUDIAN_READ_PlatformController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JUDIAN_READ_BookLeaderboardController enterLeaderboardController:self.navigationController editorid:[NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1)] channel:[NSString stringWithFormat:@"%ld",(self.selectItem + 1)] pressName:@""];
        }
    }
    else {
        [self enterNovelDescriptionViewController:indexPath];
    }
    

    [self addClickEvent:indexPath];
}



- (void)addClickEvent:(NSIndexPath*)indexPath {
    
    if (indexPath.section == 0) {
        NSString *str;
        NSString *str1;
        if (self.selectItem == 0) {
            str = click_bookcity_subtype_boy;
        }else if (self.selectItem == 1){
            str = click_bookcity_subtype_girl;
        }else if (self.selectItem == 3){
            str = @"click_bookcity_subtype_terror";
        }else{
            str = click_bookcity_subtype_publish;
        }
        
        if (indexPath.row == 0) {
            str1 = position_one;
        }else if (indexPath.row == 1){
            str1 = position_Two;
        }else if (indexPath.row ==2){
            str1 = position_Three;
        }else{
            str1 = position_More;
        }
        [MobClick event:str attributes:@{@"position":str1}];
    }
}



- (void)enterNovelDescriptionViewController:(NSIndexPath*)indexPath {
    [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"书城列表"}];
    [GTCountSDK trackCountEvent:pv_app_introduce_page withArgs:@{source_record:@"书城列表"}];

    NSArray *arr = [self.allListDic valueForKey:[NSString stringWithFormat:@"%ld",self.selectItem]];
    JUDIAN_READ_BookStoreModel *model = arr[indexPath.section-1];
    JUDIAN_READ_ReadListModel *info = model.books[indexPath.row];
    [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:@"书城列表"];
    
}

- (void)enterNovelDescriptionViewControllerV0:(NSIndexPath*)indexPath {
    
    [MobClick event:pv_app_introduce_page attributes:@{@"source":norval_bannar_page}];
    
    JUDIAN_READ_BookStoreModel *dic = [self.allListDic valueForKey:[NSString stringWithFormat:@"%ld",self.selectItem]];
    NSInteger section = indexPath.section;
    
    JUDIAN_READ_ReadListModel *info = nil;
    
    if (section == 1) {
        NSArray* array = dic.push;
        info = array[indexPath.row];
    }
    else if (section == 2) {
        NSArray* array = dic.like;
        info = array[indexPath.row];
    }
    else if (section == 3 ) {
        NSArray* array = dic.newest;
        info = array[indexPath.row];
    }
    else if (section == 4 ) {
        NSArray* array = dic.faves;
        info = array[indexPath.row];
    }
    
    [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:info.nid bookName:info.bookname viewName:@"书城列表"];

}


#pragma mark 处理联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //获取滚动视图y值的偏移量
    //内层分页视图的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if ([scrollView isEqual:self.scrView]) {
        [self scrollHeadNavWithScrollView:scrollView];
        return;
    }
    
    [self changeOffset:yOffset];
}

- (void)changeOffset:(CGFloat)yOffset{
    UICollectionView *view = self.scrView.subviews[self.selectItem];
    
    if (yOffset > 0) {
        self.headContentView.navSepView.hidden = NO;
        CGRect rect = CGRectMake(0, 0, self.headContentView.width, self.headContentView.backView.height);
        CGRect rect1 = CGRectMake(0, 0, self.headContentView.width, self.headContentView.height);
        
        if (yOffset < 65) {
            rect.size.height = headimageHeight - yOffset + 5;
        }else{
            rect.size.height = Height_NavBar+5;
        }
        if (yOffset < 65+115) {
            rect1.size.height =  headContentHeight - yOffset + 5;
        }else{
            rect1.size.height = Height_NavBar+5;
        }
        self.headContentView.backView.frame = rect;
        self.headContentView.frame = rect1;
    }else {
        self.headContentView.navSepView.hidden = YES;
        view.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(0, 0, self.headContentView.width, self.headContentView.backView.height);
        CGRect rect1 = CGRectMake(0, 0, self.headContentView.width, self.headContentView.height);
        rect.size.height = headimageHeight - yOffset;
        rect1.size.height =  headContentHeight - yOffset;
        self.headContentView.backView.frame = rect;
        self.headContentView.imageView.frame = rect;
        self.headContentView.frame = rect1;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual: self.scrView]) {

        int index = ceilf((scrollView.contentOffset.x / SCREEN_WIDTH));
        UICollectionView *view1 = self.scrView.subviews[index];
        [self changeOffset:view1.contentOffset.y];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual: self.scrView]) {
        self.selectItem = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.headContentView touchNavsAction:self.headContentView.btns[self.selectItem+1] isTouch:NO];
        if (self.selectItem == (scrollView.contentOffset.x / SCREEN_WIDTH)) {
            return;
        }
       
    }
   
}

#pragma mark 滚动collection
- (void)scrollHeadNavWithScrollView:(UIScrollView *)scr{

    //获取最初偏移量
    CGFloat offsetX = self.selectItem * SCREEN_WIDTH;
    //绝对偏移量
    CGFloat changeX = scr.contentOffset.x - offsetX;
    CGFloat positionChangeX = changeX < 0 ? -changeX : changeX;

    //nav移动距离
    CGFloat x = 51.0/SCREEN_WIDTH * changeX;
    CGFloat positionX =  51.0/SCREEN_WIDTH * positionChangeX;
    if (x != 0) {
        [UIView animateWithDuration:0.05  animations:^{
            CGFloat x1 = (SCREEN_WIDTH - 33*2 - 15*2 - 36*4)/5 + 36;
            if (x > 0) {
                self.headContentView.sepView.frame = CGRectMake(26+(x1)*(self.selectItem+1), 32, 17+positionX, 3);
            }else{
                self.headContentView.sepView.frame = CGRectMake(26+(x1)*(self.selectItem+1)+x, 32, 17+positionX, 3);
            }
        }];
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
