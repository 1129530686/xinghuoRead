//
//  JUDIAN_READ_NovelDescriptionViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_NovelThumbView.h"
#import "JUDIAN_READ_NovelSummaryView.h"
#import "JUDIAN_READ_NovelPrefaceView.h"
#import "JUDIAN_READ_NovelExtraArrowView.h"
#import "JUDIAN_READ_NovelEmptyView.h"
#import "JUDIAN_READ_NovelCatagoryCountView.h"
#import "JUDIAN_READ_NovelOtherReadingView.h"
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_NovelNavigationContainer.h"
#import "JUDIAN_READ_NovelChapterCatalogView.h"
#import "JUDIAN_READ_NovelBottomBar.h"
#import "JUDIAN_READ_VerticalAlignmentLabel.h"
#import "JUDIAN_READ_NovelCopyRightView.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_BuAdCollectionCell.h"
#import "JUDIAN_READ_Account.h"
#import "JUDIAN_READ_NovelSharePanel.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_VipCustomPromptView.h"
#import "JUDIAN_READ_ContentBrowseController.h"
#import "JUDIAN_READ_ChapterTitleModel.h"
#import "NSUserDefaults+JUDIAN_READ_UserDefaults.h"
#import "JUDIAN_READ_DeviceUtils.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_UserLikeNovelCell.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_BookLeaderboardController.h"
#import "JUDIAN_READ_UserContributionBoardController.h"
#import "JUDIAN_READ_UserFictionRateViewController.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_AllChapterEndView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_ChapterContentCell.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_FeaturedChapterTitleCell.h"


#define NOVEL_PREFACE_IDENTIFIER @"novelPreface"
#define NOVEL_COVER_IDENTIFIER @"novelCover"
#define NOVEL_ARROW_IDENTIFIER @"novelArrow"
#define NOVEL_EMPTY_IDENTIFIER @"novelEmpty"
#define NOVEL_CATAGORY_IDENTIFIER @"novelCatagory"
#define NOVEL_FEED_ADVERTISE_IDENTIFIER @"novelFeedAdvertise"
#define NOVEL_OTHER_READING_IDENTIFIER @"novelRead"
#define NOVEL_COPY_RIGHT_IDENTIFIER @"novelCopyRight"
#define UserLikeNovelCell @"UserLikeNovelCell"
#define SegmentChapterContentCell @"SegmentChapterContentCell"
#define FeaturedChapterTitleCell @"FeaturedChapterTitleCell"
#define FeaturedNextChapterTipCell @"FeaturedNextChapterTipCell"

#define SCROLL_DOWN_LIMIT 100
#define BOTTOM_BAR_HEIGHT 50

#define DOWNLOAD_COUNT_DOWN 95
#define GDT_AD_SWITCH 0

@interface JUDIAN_READ_NovelDescriptionViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate,
GDTUnifiedNativeAdDelegate,
GDTUnifiedNativeAdViewDelegate>


@property(nonatomic, strong)JUDIAN_READ_BaseCollectionView* novelCollectionView;
@property(nonatomic, weak)JUDIAN_READ_NovelSummaryView* headView;
@property(nonatomic, strong)JUDIAN_READ_NovelSummaryModel* summaryModel;
@property(nonatomic, weak)JUDIAN_READ_NovelExtraArrowView* arrowCell;
@property(nonatomic, copy)NSArray* novelThumbArray;
@property(nonatomic, copy)NSArray* otherNovelArray;
@property(nonatomic, weak)UILabel* titleLabel;

@property(nonatomic, copy)NSString* bookId;
@property (nonatomic, copy)NSString* bookName;

@property(nonatomic, weak)UIButton* backButton;
@property(nonatomic, weak)UIButton* shareButton;
@property(nonatomic, weak)JUDIAN_READ_NovelNavigationContainer* navigationContainer;
@property(nonatomic, weak)JUDIAN_READ_NovelBottomBar* bottomBar;

@property(nonatomic, strong)BUNativeAdsManager *adManager;
@property(nonatomic, strong)BUNativeAd* buNativeAd;

@property(nonatomic, strong)JUDIAN_READ_NovelChapterCatalogView* catalogView;
@property(nonatomic, strong)JUDIAN_READ_NovelCopyRightView* novelCopyRightCell;

@property(nonatomic, strong)NSTimer* progressTimer;
@property(nonatomic, assign)NSInteger progressTotal;
@property(nonatomic, assign)BOOL isCaching;

@property (nonatomic, strong)GDTUnifiedNativeAd* gdtNativeAd;
@property (nonatomic, strong)GDTUnifiedNativeAdDataObject* gdtAdDataObject;
@property (nonatomic, assign)BOOL hasAds;
@property (nonatomic, assign)BOOL isBookInCollection;
@property (nonatomic, copy)NSString* previousViewName;

@property (nonatomic, weak)JUDIAN_READ_LoadingFictionView* loadingView;
@property (nonatomic, weak)JUDIAN_READ_AllChapterEndView* endView;
@property (nonatomic, strong)JUDIAN_READ_FeaturedChapterTitleCell* titleCell;
@end

@implementation JUDIAN_READ_NovelDescriptionViewController


#pragma mark create viewcontroller
+ (void)enterDescription:(UINavigationController*)sourceViewController bookId:(NSString*)bookId bookName:(NSString*)bookName viewName:(NSString*)viewName {
    JUDIAN_READ_NovelDescriptionViewController* viewController = [[JUDIAN_READ_NovelDescriptionViewController alloc]initWithId:bookId bookName:bookName  viewName:viewName];
    //viewController.bookId = bookId;
    //viewController.previousViewName = viewName;
    [sourceViewController pushViewController:viewController animated:YES];
}


- (instancetype)initWithId:(NSString*)bookId bookName:(NSString*)bookName viewName:(NSString*) viewName{
    self = [super init];
    if (self) {
        self.bookId = bookId;
        self.previousViewName = viewName;
        self.bookName = bookName;
        [self initViews];
        
        [self loadSummaryInfo];
    }
    return self;
}



#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


}


-(void)viewWillAppear:(BOOL)animated{
    self.hideBar = YES;
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleButtonTouch:) name:@"buttonHandler" object:nil];
    
    [self updateCacheButtonState];
    [self checkBookCollectionState];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initViews {
    
    _progressTotal = 0;
    _isCaching = FALSE;
    _hasAds = TRUE;
    
    //[self initSummaryModel];
    [self addCollentionView];
    [self addHeadView];
    [self addNavigationView];
    
    [self addBottomBar];

    [self addDetailLoadingView];
}


- (void)addDetailLoadingView {
    
    JUDIAN_READ_LoadingFictionView* loadingView = [[JUDIAN_READ_LoadingFictionView alloc]init];
    [self.view addSubview:loadingView];
    loadingView.hidden = YES;
    
    loadingView.backgroundColor = [UIColor whiteColor];
    [loadingView updateImageArray:NO];
    _loadingView = loadingView;
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    [self getNavigationHeight];
    NSInteger topOffset = [self getNavigationHeight];
    
    WeakSelf(that);
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(@(topOffset));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
    
}



- (void)showLoadingView:(BOOL)isShow {
    if (isShow) {
        _loadingView.hidden = NO;
        [_loadingView playAnimation:YES];
    }
    else {
        _loadingView.hidden = YES;
        [_loadingView playAnimation:FALSE];
    }
}



- (void)loadSummaryInfo {
    [self showLoadingView:YES];
    [_navigationContainer changeBarTransparent:1];
    WeakSelf(that);
    
    [JUDIAN_READ_NovelSummaryModel buildCertainChapterModel:_bookId block:^(id  _Nullable model) {
        
        [that showLoadingView:FALSE];
        [that.navigationContainer changeBarTransparent:0];
        that.summaryModel = model;
        
        BOOL notExistBook = (!that.summaryModel || (that.summaryModel.status.intValue == 0) || (that.summaryModel.status.intValue == 1) || (that.summaryModel.nid.intValue == 0));
        if (notExistBook) {
            [that prepareShowNoChapterView];
            return;
        }
        
        
        if (that.summaryModel.bookname.length <= 0) {
            that.summaryModel = nil;
            [that.novelCollectionView reloadData];
            return;
        }
        
        that.novelThumbArray = that.summaryModel.related_books;
        that.otherNovelArray = that.summaryModel.author_books;
        
        [that.headView setHeadViewWithModel:model];
        [that.navigationContainer setTitle:that.summaryModel.bookname];
        [that.summaryModel computeAttributedTextHeight:CGRectGetWidth(that.view.frame)];
        [that.novelCollectionView reloadData];
        if (that.summaryModel) {
            [that.novelCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:(NO)];
        }

#if 0
        [JUDIAN_READ_NovelManager shareInstance].userReadingModel.bookId = that.summaryModel.nid;
        [JUDIAN_READ_NovelManager shareInstance].userReadingModel.bookName = that.summaryModel.bookname;
        [JUDIAN_READ_NovelManager shareInstance].userReadingModel.chapterCount = that.summaryModel.chapters_total;
#endif

        
        [that updateCacheButtonState];
        
        [that createCatalogView];
        
        
    } failure:^(id  _Nullable args) {
    
        [that showLoadingView:FALSE];
        [that.navigationContainer changeBarTransparent:1];
        that.summaryModel = nil;
        [that.novelCollectionView reloadData];
    }];

#if GDT_AD_SWITCH == 1
    [self initGDTAdData];
#else
    [self loadAdsData];
#endif
    
}



- (void)addHeadView {
    
    CGRect rect = CGRectMake(0, -[self getHeadViewHeight] , CGRectGetWidth(self.view.frame), [self getHeadViewHeight] );
    JUDIAN_READ_NovelSummaryView* summaryView = [[JUDIAN_READ_NovelSummaryView alloc]initWithFrame:rect];
    [self.novelCollectionView addSubview:summaryView];
    _headView = summaryView;
    
}



- (void)addCollentionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGFloat yPosition = [self getContentYPosition];

    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    WeakSelf(that);
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - bottomOffset);
    self.novelCollectionView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    self.novelCollectionView.backgroundColor = [UIColor whiteColor];
    self.novelCollectionView.contentInset = UIEdgeInsetsMake(yPosition, 0, BOTTOM_BAR_HEIGHT, 0);
    self.novelCollectionView.delegate = self;
    self.novelCollectionView.dataSource = self;
    self.novelCollectionView.scrollEnabled = YES;
    self.novelCollectionView.emptyCallBack = ^(int type) {
        [that loadSummaryInfo];
    };
    
   
    [self.novelCollectionView registerClass:[JUDIAN_READ_UserLikeNovelCell class] forCellWithReuseIdentifier:UserLikeNovelCell];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelPrefaceView class] forCellWithReuseIdentifier:NOVEL_PREFACE_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelThumbView class] forCellWithReuseIdentifier:NOVEL_COVER_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelExtraArrowView class] forCellWithReuseIdentifier:NOVEL_ARROW_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelEmptyView class] forCellWithReuseIdentifier:NOVEL_EMPTY_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelCatagoryCountView class] forCellWithReuseIdentifier:NOVEL_CATAGORY_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelOtherReadingView class] forCellWithReuseIdentifier:NOVEL_OTHER_READING_IDENTIFIER];
    [self.novelCollectionView registerClass:[JUDIAN_READ_NovelCopyRightView class] forCellWithReuseIdentifier:NOVEL_COPY_RIGHT_IDENTIFIER];
    
    [self.novelCollectionView registerClass:[JUDIAN_READ_BuAdCollectionCell class] forCellWithReuseIdentifier:NOVEL_FEED_ADVERTISE_IDENTIFIER];

    [self.novelCollectionView registerClass:[JUDIAN_READ_SegmentChapterContentCell class] forCellWithReuseIdentifier:SegmentChapterContentCell];
    [self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedChapterTitleCell class] forCellWithReuseIdentifier:FeaturedChapterTitleCell];
    
     [self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedNextChapterTipCell class] forCellWithReuseIdentifier:FeaturedNextChapterTipCell];
    
    _titleCell = [[JUDIAN_READ_FeaturedChapterTitleCell alloc] initWithFrame:CGRectZero];
    
    JUDIAN_READ_NovelCopyRightView* copyRightCell = [[JUDIAN_READ_NovelCopyRightView alloc]initWithFrame:CGRectZero];
    _novelCopyRightCell = copyRightCell;
    
    [self.view addSubview:self.novelCollectionView];
}



- (void)addNavigationView {
    
    JUDIAN_READ_NovelNavigationContainer* container = [[JUDIAN_READ_NovelNavigationContainer alloc]init];
    _navigationContainer = container;
    [self.view addSubview:container];
    
    CGFloat height = [self getNavigationHeight];
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(height));
        make.top.equalTo(that.view.mas_top);
    }];
    
    container.navigationBar.block = ^(id  _Nonnull sender) {
        NSString* cmd = sender;
        if ([cmd isEqualToString:@"0"]) {
            [that popViewController];
        }
        else if ([cmd isEqualToString:@"1"]) {
            [that shareNovel];
        }
    };

}




- (void)addBottomBar {
    
    JUDIAN_READ_NovelBottomBar* bottomBar = [[JUDIAN_READ_NovelBottomBar alloc]init];
    _bottomBar = bottomBar;
    [self.view addSubview:bottomBar];
    
    WeakSelf(that);
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(that.view.mas_width);
        make.height.equalTo(@(BOTTOM_BAR_HEIGHT));
        make.left.equalTo(that.view.mas_left);
        make.bottom.equalTo(that.novelCollectionView.mas_bottom);
    }];

    

    
    bottomBar.block = ^(id  _Nonnull sender) {
        [that handleBottomBarTouch:sender];
    };
}


- (void)initSummaryModel {
    _summaryModel = [JUDIAN_READ_NovelSummaryModel buildDefaultSummary];
}


- (void)updateCacheButtonState {
    
    if (!_summaryModel) {
        self.bottomBar.hidden = YES;
        return;
    }
    
    self.bottomBar.hidden = NO;
    
    if([JUDIAN_READ_UserReadingModel getCachedStatus:_summaryModel.nid]){
        [self.bottomBar setCacheText:@"已缓存"];
        [self.bottomBar enableCachedButton:FALSE];
    }
    else {
        [self.bottomBar setCacheText:@"缓存"];
        [self.bottomBar enableCachedButton:TRUE];
    }
    
    NSString* value = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[_summaryModel.nid];
    if (value) {
        //[self.bottomBar setCacheText:@"缓存中"];
        [self.bottomBar enableCachedButton:FALSE];
        [self startCountDownTimer:YES];
    }
}



- (void)handleBottomBarTouch:(NSString*)type {
    
    //
    //[JUDIAN_READ_UserContributionBoardController enterUserContributionBoard:self.navigationController];
    //return;
    
    WeakSelf(that);
    
    if([type isEqualToString:@"1"]) {
        
        if(!_summaryModel || (self.summaryModel.nid.length <= 0) || (self.summaryModel.chapters_total.length <= 0)) {
            return;
        }
           
        NSDictionary* dictionary = @{
                                     @"bookId":self.summaryModel.nid,
                                     @"bookName":self.summaryModel.bookname,
                                     @"chapterCount": self.summaryModel.chapters_total,
                                     @"position" : @""
                                     };
        
        [MobClick event:@"pv_app_reading_page" attributes:@{@"source":@"小说介绍页"}];
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"小说介绍页"}];
#if 0
        [JUDIAN_READ_FictionReadingViewController enterFictionViewController:self.navigationController book:dictionary viewName:@"小说介绍页"];
#else
        [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:self.navigationController book:dictionary viewName:@"小说介绍页"];
#endif

        return;
    }
    
    
    if ([type isEqualToString:@"2"]) {
        [self handleFavoritesTouch];
        return;
    }
    

    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    
    [[JUDIAN_READ_NovelManager shareInstance] getBookCacheState:_summaryModel.nid block:^(id  _Nonnull parameter) {
        NSDictionary* dictionary = parameter;
        [that prepareDownload:dictionary];
    }];
}


- (void)handleFavoritesTouch {
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {
            
            that.isBookInCollection = YES;
            [that.bottomBar updateFavouriteName:@"已收藏"];
            
            [MBProgressHUD showSuccess:@"收藏成功"];
            
            if (that.previousViewName.length <= 0) {
                that.previousViewName = @"";
            }
            
            NSDictionary* dictionary = @{
                                         @"source" : that.previousViewName
                                         };
            
            [MobClick event:@"collection_source_bydetails" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"collection_source_bydetails" withArgs:dictionary];
        }
    }];
}


- (void)checkBookCollectionState {
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] isBookInCollection:_bookId block:^(id  _Nullable parameter) {
        if ([parameter isEqual:[NSNull null]]) {
            that.isBookInCollection = FALSE;
            [that.bottomBar updateFavouriteName:@"收藏"];
        }
        else {
            NSString* count = parameter;
            that.isBookInCollection = ([count intValue] > 0) ? TRUE : FALSE;
            if (that.isBookInCollection) {
                [that.bottomBar updateFavouriteName:@"已收藏"];
            }
            else {
                [that.bottomBar updateFavouriteName:@"收藏"];
            }
        }
        
    }];
}


- (void)prepareDownload:(NSDictionary*)dictionary {
    
    if (!dictionary) {
        return;
    }
    NSNumber* goldCoinCount = dictionary[@"golds_total_num"];
    NSNumber* fictionPrize = dictionary[@"need_golds_num"];
    
    NSNumber* cacheNumber = dictionary[@"cache"];
    //NSNumber* fictionNumber = dictionary[@"fiction_num"];
    NSNumber* overloadNumber = dictionary[@"overload_cache"];
    NSString* tip = @"今日已缓存上限";
    
    WeakSelf(that);
    if (goldCoinCount.intValue < fictionPrize.intValue) {
        NSString* count = [NSString stringWithFormat:@"%d", fictionPrize.intValue];
        [JUDIAN_READ_VipCustomPromptView createNoFeePromptView:self.view goldCoin:count  block:^(id  _Nonnull args) {
            [JUDIAN_READ_UserEarningsViewController entryEarningsViewController:that.navigationController];
        }];
        return;
    }
    
    
    if ([cacheNumber intValue] == 1) {

        if ([overloadNumber intValue] <= 0) {
            [MBProgressHUD showMessage:tip];
            return;
        }

        if ([self.bottomBar isButtonEnable]) {
            [self.bottomBar enableCachedButton:FALSE];
            [self beginDownloadFiction];
        }
            
        [self updateCacheButtonState];
        return;
    }
   
    //if ([fictionNumber intValue] > 0) {}
    if ([overloadNumber intValue] <= 0) {
        [MBProgressHUD showMessage:tip];
    }
    else {
        [self.bottomBar enableCachedButton:FALSE];
        [self beginDownloadFiction];
    }
    
}




- (void)beginDownloadFiction {
    
    NSString* type = [JUDIAN_READ_Account currentAccount].vip_type;
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!type) {
        type = @"";
    }
    
    if (!sex) {
        sex = @"";
    }
    
    NSDictionary* dictionary = @{@"source" : @"小说简介页",
                                 @"vip_type" : type,
                                 @"sex" : sex
                                 };
    [MobClick event:click_cache attributes:dictionary];
    [GTCountSDK trackCountEvent:click_cache withArgs:dictionary];

    [JUDIAN_READ_UserReadingModel saveBookSummary:_summaryModel];
    
    [self startCountDownTimer:FALSE];
    
    WeakSelf(that);
    NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:_summaryModel.nid];
    if (begin < [_summaryModel.chapters_total intValue]) {
        NSString* beginStr = [NSString stringWithFormat:@"%ld", (long)(begin)];
        
        [[JUDIAN_READ_NovelManager shareInstance] serializeFictionFromServer:_summaryModel.nid bookName:_summaryModel.bookname begin:beginStr size:_summaryModel.chapters_total block:^(id  _Nonnull parameter) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [that.progressTimer invalidate];
                that.progressTimer = nil;
                [that.bottomBar setCacheText:@"已缓存"];
            });
        }];
    }
    else {
        
    }
    
}



- (void)startCountDownTimer:(BOOL)isCaching {
    
    if (self.progressTimer) {
        return;
    }
    
    _progressTotal = 0;
    _isCaching = isCaching;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:_FICTION_DOWNLOAD_INTERVAL_ target:self selector:@selector(increaseTick) userInfo:nil repeats:YES];
}


- (void)increaseTick {
    _progressTotal++;
    NSString* tip = [NSString stringWithFormat:@"已缓存%ld", (long)_progressTotal];
    tip = [tip stringByAppendingString:@"%"];
    [self.bottomBar setCacheText:tip];

    if (_isCaching) {
        
        if (_progressTotal >= DOWNLOAD_COUNT_DOWN) {
            _progressTotal = DOWNLOAD_COUNT_DOWN;
        }
        
        NSString* value = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[_summaryModel.nid];
        if (!value) {
            [self updateCacheButtonState];
            [self.progressTimer invalidate];
            self.progressTimer = nil;
        }
    }
    else {
        
        if (_progressTotal >= DOWNLOAD_COUNT_DOWN) {
            [self.progressTimer invalidate];
            self.progressTimer = nil;
        }
        
    }

}



- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)shareNovel {
    
    if (!_summaryModel) {
        return;
    }
    
    JUDIAN_READ_SettingMenuPanel* settingView = [[JUDIAN_READ_SettingMenuPanel alloc]initShareView:self.bookId];
    //_settingView = settingView;
    settingView.fromView = @"小说简介页";
    settingView.frame = self.view.bounds;
    settingView.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
    [settingView addToKeyWindow:self.view];
    [settingView showView];
    //[settingView setViewStyle];
    
}



- (CGFloat)getContentYPosition {
    CGFloat height = [self getNavigationHeight];
    return [self getHeadViewHeight] - height;
}


- (CGFloat)getNavigationHeight {
    CGFloat height = 0;
    if (iPhoneX) {
        height = 88;
    }
    else {
        height = 64;
    }
    return height;
}


- (NSInteger)getHeadViewHeight {
    
    if (iPhoneX) {
        return 280;
    }
    
    return 250;
}


- (NSInteger)getMaxYOffset {
   return -([self getHeadViewHeight] + SCROLL_DOWN_LIMIT);
}



- (void)dealloc {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}


#pragma mark collectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (!_summaryModel) {
        return 0;
    }

    if (section == 0) {
        return 11;
    }
    
    if (section == 1) {
        if (_novelThumbArray.count > 0) {
            return 1;
        }

        return 0;
    }
    
    if (section == 2) {
        return _novelThumbArray.count;
    }
    
    if (section == 3) {
        if (_otherNovelArray.count > 0) {
            return 1;
        }
        
        return 0;
    }
    

    if (section == 4) {
        return _otherNovelArray.count;
    }
    

    if (section == 5) {
        return 1;
    }
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if(section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {

            WeakSelf(that);
            static NSString *identify = UserLikeNovelCell;
            JUDIAN_READ_UserLikeNovelCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            cell.block = ^(id  _Nullable args) {
                [that entryRateViewController];
            };
            [cell updateCell:_summaryModel];
            return cell;
        }
        else if (row == 1) {
            static NSString *identify = NOVEL_PREFACE_IDENTIFIER;
            JUDIAN_READ_NovelPrefaceView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setPrefaceModel:_summaryModel];
            return cell;
        }
        else if(row == 2){
            static NSString *identify = NOVEL_ARROW_IDENTIFIER;
            JUDIAN_READ_NovelExtraArrowView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
#if 0
            if(_summaryModel.arrowState == NOVEL_BRIEF_ARROW_NONE) {
                cell.hidden = YES;
            }
            else {
                cell.hidden = NO;
            }
#else
            cell.hidden = YES;
#endif
            _arrowCell = cell;
            return cell;
        }
        else if(row == 3){

            //static NSString *identify = NOVEL_EMPTY_IDENTIFIER;
           // JUDIAN_READ_NovelEmptyView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
           // return cell;
            static NSString *identify = NOVEL_CATAGORY_IDENTIFIER;
            JUDIAN_READ_NovelCatagoryCountView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setEditorWithModel:_summaryModel];
            return cell;

        }
        else if(row == 4){
            static NSString *identify = NOVEL_CATAGORY_IDENTIFIER;
            JUDIAN_READ_NovelCatagoryCountView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setChapterWithModel:_summaryModel];
            return cell;
        }
        else if (row == 5) {
            static NSString *identify = NOVEL_EMPTY_IDENTIFIER;
            JUDIAN_READ_NovelEmptyView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            return cell;
        }
        else if (row == 6) {
            JUDIAN_READ_FeaturedChapterTitleCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedChapterTitleCell forIndexPath:indexPath];
            NSString* name = _summaryModel.first_chapter_title;
            [cell setTitleText:name];
            return cell;
        }
        else if (row == 7) {
            JUDIAN_READ_SegmentChapterContentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentChapterContentCell forIndexPath:indexPath];
            BOOL nextRender = [_summaryModel canGoNextRender];
            [cell setContent:_summaryModel.attributedFirstChapterContent nextTip:nextRender];
            WeakSelf(that);
            cell.nextRenderBlock = ^(id  _Nullable args) {
                [that.summaryModel goNextRenderStep];
                [that.novelCollectionView reloadData];
            };
            return cell;
        }
        else if (row == 8) {
            JUDIAN_READ_FeaturedNextChapterTipCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedNextChapterTipCell forIndexPath:indexPath];
            if ([_summaryModel canGoNextRender]) {
                cell.hidden = YES;
            }
            else {
                cell.hidden = NO;
            }
            return cell;
        }
        else if (row == 9) {
            static NSString *identify = NOVEL_EMPTY_IDENTIFIER;
            JUDIAN_READ_NovelEmptyView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            return cell;
        }
        else if (row == 10) {
            static NSString *identify = NOVEL_FEED_ADVERTISE_IDENTIFIER;
            JUDIAN_READ_BuAdCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            cell.bottomLineView.hidden = NO;
            
#if GDT_AD_SWITCH == 1
            if (_gdtNativeAd && _gdtAdDataObject) {
                [cell addPlaceholderView];
                cell.unifiedNativeAdView.delegate = self;
                cell.unifiedNativeAdView.viewController = self;
                [cell buildGdtView:_gdtAdDataObject];
                
                [cell.unifiedNativeAdView registerDataObject:_gdtAdDataObject clickableViews:@[cell.unifiedNativeAdView]];
                
            }
#else
            if (_buNativeAd) {
                [_buNativeAd unregisterView];
                _buNativeAd.rootViewController = self;
                _buNativeAd.delegate = self;
                [_buNativeAd registerContainer:cell withClickableViews:@[cell]];
                [cell buildView:_buNativeAd];
            }
#endif

            BOOL needAd = [self canLoadAds];
            if (needAd) {
                cell.hidden = NO;
            }
            else {
                cell.hidden = YES;
            }
            
            return cell;
        }
    }
    else if (section == 1) {
        static NSString *identify = NOVEL_OTHER_READING_IDENTIFIER;
        JUDIAN_READ_NovelOtherReadingView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell updateCell:@"读了这本书的人还在看"];
        return cell;
    }
    else if (section == 2){
        static NSString *identify = NOVEL_COVER_IDENTIFIER;
        JUDIAN_READ_NovelThumbView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        if (_novelThumbArray.count > 0) {
            id model = _novelThumbArray[indexPath.row];
            [cell setThumbWithModel:model];
        }
        
        return cell;
    }
    else if (section == 3) {
        static NSString *identify = NOVEL_OTHER_READING_IDENTIFIER;
        JUDIAN_READ_NovelOtherReadingView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell updateCell:@"该作者的其他作品"];
        return cell;
    }
    else if (section == 4){
        static NSString *identify = NOVEL_COVER_IDENTIFIER;
        JUDIAN_READ_NovelThumbView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        if (_otherNovelArray.count > 0) {
            id model = _otherNovelArray[indexPath.row];
            [cell setThumbWithModel:model];
        }
        
        return cell;
    }
    else if(section == 5) {
        static NSString *identify = NOVEL_COPY_RIGHT_IDENTIFIER;
        JUDIAN_READ_NovelCopyRightView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        return cell;
    }
    
    return nil;

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            return  CGSizeMake(CGRectGetWidth(self.view.frame), 67);
        }
        else if (row == 1) {
            return  CGSizeMake(CGRectGetWidth(self.view.frame), [_summaryModel getCellHeight]);
        }
        else if(row == 2) {
#if 0
            if(_summaryModel.arrowState == NOVEL_BRIEF_ARROW_NONE) {
               return  CGSizeMake(CGRectGetWidth(self.view.frame), 0);
            }
            else {
                return  CGSizeMake(CGRectGetWidth(self.view.frame), 20);
            }
#else
            return  CGSizeMake(CGRectGetWidth(self.view.frame), 0);
#endif
        }
        else if(row == 3){
            return  CGSizeMake(CGRectGetWidth(self.view.frame), 47);
        }
        else if(row ==4){
            return  CGSizeMake(CGRectGetWidth(self.view.frame), 47);
        }
        else if(row == 5){
            return CGSizeMake(CGRectGetWidth(self.view.frame), 10);
        }
        else if(row == 6) {
            NSInteger width = CGRectGetWidth(self.view.frame);
            CGFloat height = [_titleCell getCellHeight:NO];
            if (height < 58) {
                height = 58;
            }
            return CGSizeMake(width, ceil(height));
        }
        else if(row == 7) {
            NSInteger width = CGRectGetWidth(self.view.frame);
            CGFloat height = [_summaryModel getNextPartContentHeight];
            return CGSizeMake(width, ceil(height));
        }
        
        else if(row == 8) {
            CGFloat heigth = 58;
            if ([_summaryModel canGoNextRender]) {
                heigth = 0.01;
            }
            NSInteger width = CGRectGetWidth(self.view.frame);
            return CGSizeMake(width, heigth);
        }
        else if(row == 9){
            return CGSizeMake(CGRectGetWidth(self.view.frame), 10);
        }
        else if(row == 10) {
            BOOL needAd = [self canLoadAds];
            if (needAd) {
                return CGSizeMake(CGRectGetWidth(self.view.frame), 70);
            }
            else {
                //return CGSizeZero;
                return CGSizeMake(CGRectGetWidth(self.view.frame), 0);
            }
        }
        else if(row == 7) {
            return CGSizeMake(CGRectGetWidth(self.view.frame), 10);
        }
    }
   
    if(section == 1) {
        return  CGSizeMake(CGRectGetWidth(self.view.frame), 50);
    }
    
    if (section == 2) {
        NSInteger width = (SCREEN_WIDTH - 2 * 14 - 3 * 18) / 4;
        return  CGSizeMake(width, ceil(width * 1.43f + 38));
    }
    
    
    if(section == 3) {
        return  CGSizeMake(CGRectGetWidth(self.view.frame), 50);
    }
    
    if (section == 4) {
        NSInteger width = (SCREEN_WIDTH - 2 * 14 - 3 * 18) / 4;
        return  CGSizeMake(width, ceil(width * 1.43f + 38));
    }
    
    if (section == 5) {
        CGFloat height = [_novelCopyRightCell getCellHeight:CGRectGetWidth(self.view.frame)];
        return  CGSizeMake(CGRectGetWidth(self.view.frame), height);
    }
    
    return CGSizeMake(0, 0);
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (section == 1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }

    if (section == 2) {
        return UIEdgeInsetsMake(0, 14, 0, 14);
    }
    
    
    if (section == 3) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    if (section == 4) {
        return UIEdgeInsetsMake(0, 14, 0, 14);
    }
    
    
    if (section == 5) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == 2) {
        return 26;
    }
    
    if (section == 4) {
        return 26;
    }
    
    return 0.01;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 5) {
        //[JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页banner广告"];
        //[self.gdtNativeAd clickAd:self.gdtAdData];
        return;
    }
    
    
    if (indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)) {
        [_arrowCell updateArrow:_summaryModel];
        [self.novelCollectionView reloadData];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        
        [GTCountSDK trackCountEvent:@"pv_content_provider_details" withArgs:@{@"source":@"小说简介页"}];
        [MobClick event:@"pv_content_provider_details" attributes:@{@"source" : @"小说简介页"}];
        
        NSNumber* editorId = _summaryModel.publisher_id;
        NSString* editorStr = [NSString stringWithFormat:@"%ld", (long)editorId.intValue];
        NSString* pressName = _summaryModel.editorid;
        [JUDIAN_READ_BookLeaderboardController enterLeaderboardController:self.navigationController editorid:editorStr  channel:nil pressName:pressName];
        return;
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 4) {
        [self createCatalogView];
        [self.view addSubview:_catalogView];
        [_catalogView showView];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 8) {
        if ([_summaryModel canGoNextRender]) {
            return;
        }
       
        if (!_summaryModel.nid
            || !_summaryModel.bookname
            || !_summaryModel.second_chapter_id
            || !_summaryModel.chapters_total) {
            return;
        }
        
        NSDictionary* dictionary = @{
                                     @"bookId" : _summaryModel.nid,
                                     @"bookName" : _summaryModel.bookname,
                                     @"chapterId": _summaryModel.second_chapter_id,
                                     @"chapterCount" : _summaryModel.chapters_total,
                                     @"position" : @""
                                     };
            
        [MobClick event:@"pv_app_reading_page" attributes:@{@"source":@"小说介绍页"}];
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"小说介绍页"}];
#if 0
        [JUDIAN_READ_FictionReadingViewController enterFictionViewController:self.navigationController book:dictionary viewName:@"小说介绍页"];
#else
        [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:self.navigationController book:dictionary viewName:@"小说介绍页"];
#endif
        return;
    }
    
    
    if (indexPath.section == 2) {
        if (_novelThumbArray.count <= 0) {
            return;
        }
        JUDIAN_READ_NovelThumbModel* model = _novelThumbArray[indexPath.row];
        [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"小说简介页面的关联推荐"}];
        [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"小说简介页面的关联推荐"}];
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:model.nid bookName:model.bookname viewName:@"小说简介页面的关联推荐"];
    }

    if (indexPath.section == 4) {
        if (_otherNovelArray.count <= 0) {
            return;
        }
        JUDIAN_READ_NovelThumbModel* model = _otherNovelArray[indexPath.row];
        
        [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"小说简介页面的可能感兴趣的推荐"}];
        [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"小说简介页面的可能感兴趣的推荐"}];
        
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:model.nid bookName:model.bookname viewName:@"小说简介页面的可能感兴趣的推荐"];
    }
    
    
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)createCatalogView {

    if (_catalogView) {
        return;
    }
    
    WeakSelf(that);
    _catalogView = [[JUDIAN_READ_NovelChapterCatalogView alloc]initWithModel:_summaryModel controller:self];
    _catalogView.block = ^(id  _Nullable args) {
            JUDIAN_READ_ChapterTitleModel* model = args;

        [that saveBrowseHistory:model.title chpaterId:model.chapnum];
        NSDictionary* dictionary = @{
                                         @"bookId" : that.summaryModel.nid,
                                         @"bookName" : that.summaryModel.bookname,
                                         @"chapterId": model.chapnum,
                                         @"chapterCount" : that.summaryModel.chapters_total,
                                         @"position" : @""
                                         };
            [MobClick event:@"pv_app_reading_page" attributes:@{@"source":@"小说介绍页"}];
            [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"小说介绍页"}];
#if 0
        [JUDIAN_READ_FictionReadingViewController enterFictionViewController:that.navigationController book:dictionary viewName:@"小说介绍页"];
#else
        [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:that.navigationController book:dictionary viewName:@"小说介绍页"];
#endif
    };
    
    _catalogView.frame = self.view.bounds;
    
}



- (void)saveBrowseHistory:(NSString*)chapterName chpaterId:(NSString*)chapterId {
    
    JUDIAN_READ_NovelBrowseHistoryModel* historyModel = [[JUDIAN_READ_NovelBrowseHistoryModel alloc] init];
    historyModel.bookId = _summaryModel.nid;
    historyModel.bookName = _summaryModel.bookname;
    historyModel.chapterName = chapterName;
    historyModel.chapterId = chapterId;
    historyModel.pageIndex = @"0";

    [JUDIAN_READ_UserReadingModel saveBrowseHistoryWithModel:historyModel];
}



#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_loadingView.hidden) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat yPosition = -[self getContentYPosition];
    CGFloat gapHeight = fabs(yPosition) - [self getNavigationHeight];
    
    if (offsetY >= -[self getNavigationHeight]) {
        [_navigationContainer changeBarTransparent:1];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else if(offsetY <= yPosition) {
        [_navigationContainer changeBarTransparent:0];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    else {
        CGFloat alpha = ((offsetY) - yPosition) / gapHeight;
        [_navigationContainer changeBarTransparent:alpha];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }

    //下拉时候超过这个位置，就不能再下拉
    if(offsetY < [self getMaxYOffset]) {
        [scrollView setContentOffset:CGPointMake(0, [self getMaxYOffset])];
    }
    
    //下拉位置大于视图高度，就修改视图高度
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -[self getHeadViewHeight] ) {
        _headView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }

}


#pragma mark 广点通

- (void)initGDTAdData {
    
    self.gdtNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:GDT_AD_APP_ID placementId:GDT_BOOK_INTRODUCTION_AD_ID];
    self.gdtNativeAd.maxVideoDuration = 5; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    self.gdtNativeAd.delegate = self;
    [self.gdtNativeAd loadAdWithAdCount:1];
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"介绍页banner广告"];
}

- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error {
    if (unifiedNativeAdDataObjects) {
        _hasAds = TRUE;
        [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"介绍页banner广告"];
        _gdtAdDataObject = unifiedNativeAdDataObjects[0];
        [_novelCollectionView reloadData];
    }
    else if(error) {
        _hasAds = FALSE;
        [self.novelCollectionView reloadData];
    }
}


-(void)nativeAdFailToLoad:(NSError *)error {

}


- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页banner广告"];
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"介绍页banner广告"];
}



#pragma mark 穿山甲广告

- (void)loadAdsData {

    BUNativeAdsManager *adManager = [[BUNativeAdsManager alloc]init];
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = CHUAN_SHAN_JIA_FEED_ID;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionTop;
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot.isSupportDeepLink = YES;
    adManager.adslot = slot;
    adManager.delegate = self;
    self.adManager = adManager;
    
    [adManager loadAdDataWithCount:1];
    
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"介绍页banner广告"];
}


- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
   
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"介绍页banner广告"];
    _hasAds = TRUE;
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BUNativeAd *model = obj;
        [that setAdModel:model];
    }];
    
    [self.novelCollectionView reloadData];
}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    _hasAds = FALSE;
    [self.novelCollectionView reloadData];
}


- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"介绍页banner广告"];
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页banner广告"];
}


- (void)setAdModel:(BUNativeAd*)nativeAd {
    _buNativeAd = nativeAd;
    [self.novelCollectionView reloadData];
}

#pragma mark 广告判断
- (BOOL)canLoadAds {
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    return _hasAds && showAdView;
}


#pragma mark 进入评分
- (void)entryRateViewController {

    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    
    NSString* appreciateCount = @"";
    
    if (![_summaryModel.update_status isEqualToString:@"1"]) {
        return;
    }
    
    [GTCountSDK trackCountEvent:@"mark_scores" withArgs:@{@"source":@"小说简介页"}];
    [MobClick event:@"mark_scores" attributes:@{@"source" : @"小说简介页"}];

    if (appreciateCount.length <= 0) {
        appreciateCount = @"";
    }
    
    NSString* bookName = @"";
    if (_summaryModel.bookname.length > 0) {
        bookName = _summaryModel.bookname;
    }
    
    NSString* bookAuthor = @"";
    if (_summaryModel.author.length > 0) {
        bookAuthor = _summaryModel.author;
    }
    
    NSString* bookId = @"";
    if (_summaryModel.nid.length > 0) {
        bookId = _summaryModel.nid;
    }
    
    NSDictionary* dictinoary = @{
                                 @"appreciateCount" : appreciateCount,
                                 @"bookName" : bookName,
                                 @"bookAuthor" : bookAuthor,
                                 @"bookId" : bookId
                                 };
    
    
     
    [JUDIAN_READ_UserFictionRateViewController enterFictionRateViewController:self.navigationController book:dictinoary];
    
}



#pragma mark 书籍下架处理
- (void)showNoChapterView {
    [_endView removeFromSuperview];
    
    JUDIAN_READ_AllChapterEndView* endView = [[JUDIAN_READ_AllChapterEndView alloc]initWithName:self.bookName state:_NO_CHAPTER_CODE_];
    endView.navigationController = self.navigationController;
    [self.view addSubview:endView];
    _endView = endView;
    
    CGFloat navigationHeight = 0;//[self getNavigationHeight];
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    endView.frame = CGRectMake(0, navigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - bottomOffset - navigationHeight);
    
    //0（连载中） 1（已完结） 2（弃更）
    endView.fictionState = _NO_CHAPTER_CODE_;
    endView.bookName = self.bookName;
    endView.wordCount = @"";
    endView.chapterCount = @"";
    endView.appreciateCount = @"";
    endView.bookAuthor = @"";
    endView.bookId = @"";
    
    WeakSelf(that);
    endView.block = ^(id  _Nullable args) {
        NSString* cmd = args;
        if ([cmd isEqualToString:@"share"]) {
           // [that popupShareView];
        }
        else {

           // [that enterBookStoreViewController];
        }
        
    };
    
    endView.cellBlock = ^(id  _Nullable args) {
        JUDIAN_READ_NovelThumbModel* model = args;
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:that.navigationController bookId:model.nid bookName:model.bookname viewName:@"阅读器完结页面"];
    };
    
    
    endView.appreciateBlock = ^(id  _Nullable args) {
       // [that enterAppreciateMoneyViewController:@"0"];
    };
    
}




- (void)prepareShowNoChapterView {
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        [MBProgressHUD showMessage:@"网络连接异常"];
        return;
    }
    
    [self showNoChapterView];
    
    WeakSelf(that);
    [JUDIAN_READ_NovelThumbModel buildThumbModel:_bookId block:^(id  _Nonnull model) {
        [that.endView reloadData:model];
    }];
    
    
    [[JUDIAN_READ_NovelManager shareInstance] loadRecommendFeedData:_bookId block:^(id  _Nullable parameter) {
        [that.endView reloadFeedList:parameter];
    }];
    
}


- (void)handleButtonTouch:(NSNotification*)obj {
    NSNumber* cmd = obj.object[@"cmd"];
    if (_endView && !_endView.hidden) {
        if ([cmd intValue] == kBackCmd) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self enterBookStoreViewController];
        }
    }
}



- (void)enterBookStoreViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UITabBarController *vc = (UITabBarController*)kKeyWindow.rootViewController;
    vc.selectedIndex = 2;
}

@end
