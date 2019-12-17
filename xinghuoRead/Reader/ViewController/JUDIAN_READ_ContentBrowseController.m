//
//  JUDIAN_READ_HomeViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentBrowseController.h"
#import "JUDIAN_READ_ArticlePositiveViewController.h"
#import "JUDIAN_READ_ArticleNegativeViewController.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_PageViewController.h"
#import "JUDIAN_READ_ChapterTitleModel.h"
#import "JUDIAN_READ_SqliteManager.h"
#import "JUDIAN_READ_NovelBrowseHistoryModel.h"
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_FictionEmbeddedAdManager.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_AllChapterEndView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_VipCustomPromptView.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_AppreciateMoneyViewController.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_AppreciatedChapterListViewController.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_HowBrowseFictionView.h"
#import "JUDIAN_READ_CoverViewController.h"

@interface JUDIAN_READ_ContentBrowseController ()<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
UIGestureRecognizerDelegate,
JUDIAN_READ_CoverViewControllerDelegate>

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) BOOL pageAnimationFinished;
@property (nonatomic, assign) BOOL pageTouchFinished;

@property (nonatomic, strong) JUDIAN_READ_PageViewController* pageViewController;
@property (nonatomic, strong) JUDIAN_READ_CoverViewController* coverViewController;
@property (nonatomic, strong) UIView* maskContainer;
@property (nonatomic, strong) UIView* protectionEyeContainer;
@property (nonatomic, strong) JUDIAN_READ_FictionEmbeddedAdManager* bottomAdManager;
@property (nonatomic, strong) JUDIAN_READ_FictionEmbeddedAdManager* middleAdManager;
@property (nonatomic, weak)JUDIAN_READ_AllChapterEndView* endView;
@property (nonatomic, strong) JUDIAN_READ_SettingMenuPanel* menuSettingView;

@property (nonatomic, copy)NSString* bookState;
@property (nonatomic, copy)NSString* wordCount;

@property (nonatomic, copy)NSString* appreciateCount;
@property (nonatomic, copy)NSString* bookAuthor;
@property (nonatomic, copy)NSString* previewViewName;

@property (nonatomic, strong)NSMutableDictionary* fictionDescription;
@property (nonatomic, assign)BOOL isBookInCollection;

@property (nonatomic, strong)NSTimer* progressTimer;
@property (nonatomic, assign)NSInteger progressTotal;

@property (nonatomic, assign)NSTimeInterval lastReadTime;
@property (nonatomic, strong)dispatch_source_t userDurationTimer;
@property (nonatomic, weak) JUDIAN_READ_LoadingFictionView* loadingView;
@property (nonatomic, strong)JUDIAN_READ_ChapterContentModel* currentChapterModel;
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, assign)NSInteger clickPageIndex;
@end

@implementation JUDIAN_READ_ContentBrowseController


+ (void)enterContentBrowseViewController:(UINavigationController*)navigation book:(NSDictionary*)dictionary viewName:(NSString*)viewName {
    
    JUDIAN_READ_ContentBrowseController* viewController = [[JUDIAN_READ_ContentBrowseController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.previewViewName = viewName;
    viewController.fictionDescription = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [navigation pushViewController:viewController animated:YES];
    
}

#pragma mark view

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateViewBgColor];
    
    _lastReadTime = 0;
    _pageTouchFinished = FALSE;
    _clickPageIndex = -1;
    
    [self addProtectionEyeModeView];
    [self showProtectionEyeModeView];

    [self addMaskView];
    [self setMaskViewBackgroundColor];
    
    [self hideStatusView:YES];

    [self createCatalogView];
    
    [self addReaderSettingView];
   
    [self addLoadingView];
    
    [self loadAdData];
    
    [self prepareLoadFiction];
    [self checkBookCollectionState];
    
    [self autoRefreshUserDuration];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self hideStatusView:YES];
    
    [self updateReadingInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleButtonTouch:) name:@"buttonHandler" object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addReaderSettingView {
    
    WeakSelf(that);
    _settingView = [[JUDIAN_READ_PageSettingView alloc]init];
    
    _settingView.block = ^(NSString* cmd) {
        [that hideStatusView:YES];
        if ([cmd isEqualToString:@"collect"]) {
            [that collectBook];
        }
    };
}

- (void)addLoadingView {
    
    JUDIAN_READ_LoadingFictionView* loadingView = [[JUDIAN_READ_LoadingFictionView alloc]initSquareView];
    loadingView.userInteractionEnabled = YES;
    loadingView.frame = self.view.bounds;
    [kKeyWindow addSubview:loadingView];
    loadingView.hidden = YES;
    loadingView.layer.zPosition = LOADING_VIEW_Z_POSITION;
    
    //UIColor* bgColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    loadingView.backgroundColor = RGBA(0x0, 0, 0, 0.4);
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    [loadingView updateImageArray:[style isNightMode]];

    _loadingView = loadingView;

#if 0
    NSInteger bottomOffset = [self getBottomOffset];
    NSInteger topOffset = 0;//[self getContentTopOffset];

    WeakSelf(that);
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        //make.top.equalTo(that.topBarView.mas_bottom);
        make.top.equalTo(@(topOffset));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
#endif
}



- (void)addGuideView {
    
    NSString* key = @"readGuideTipV120";
    NSString* guideTip = [NSUserDefaults getUserDefaults:key];
    if (guideTip) {
        return;
    }
    
    JUDIAN_READ_HowBrowseFictionView* guideView = [[JUDIAN_READ_HowBrowseFictionView alloc]init];
    guideView.layer.zPosition = GUIDE_VIEW_Z_POSITION;
    guideView.frame = self.view.bounds;
    [self.view addSubview:guideView];
    __block JUDIAN_READ_HowBrowseFictionView* thatView = guideView;
    guideView.block = ^(id  _Nullable args) {
        [thatView removeFromSuperview];
        [NSUserDefaults saveUserDefaults:key value:@"1"];
    };
    
}


- (CGFloat)getBottomOffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
    
}


- (void)updateViewBgColor {
    UIColor* bgColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    self.view.backgroundColor = bgColor;
}

- (void)prepareLoadFiction {
    _bookId = _fictionDescription[@"bookId"];
    _bookName = _fictionDescription[@"bookName"];
    _chapterCount = _fictionDescription[@"chapterCount"];
    
    WeakSelf(that);
    NSString* chapterId = _fictionDescription[@"chapterId"];
    if (!chapterId) {
        chapterId = @"1";
    }
    
   // [self showLoadingView:YES];
    
    BOOL existFiction = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:_bookId chpaterId:chapterId];
    BOOL isExistCatalog = [[JUDIAN_READ_NovelManager shareInstance] isExistCatalog:_bookId];
    if (existFiction && isExistCatalog) {
        
        NSArray* array = [JUDIAN_READ_UserReadingModel getCachedBookSummary:_bookId];
        if (array.count > 0) {
            JUDIAN_READ_NovelSummaryModel* model = array[0];
            _bookState = model.update_status;
            _chapterCount = model.chapters_total;
            _wordCount =  model.words_number;
            _bookAuthor = model.author;
        }
    }

    [self loadFictionContent];
    
    [JUDIAN_READ_NovelSummaryModel buildSummaryModel:_bookId block:^(id  _Nonnull model) {
        JUDIAN_READ_NovelSummaryModel* summaryModel = model;
        
        BOOL notExistBook = (!summaryModel || (summaryModel.status.intValue == 0) || (summaryModel.status.intValue == 1) || (summaryModel.nid.intValue == 0));
        if (notExistBook) {
            //[that showLoadingView:NO];
            [that prepareShowNoChapterView];
            return;
        }
        
        that.bookId = summaryModel.nid;
        that.bookName = summaryModel.bookname;
        that.chapterCount = summaryModel.chapters_total;
        that.bookState = summaryModel.update_status;
        that.wordCount = summaryModel.words_number;
        that.appreciateCount = [NSString stringWithFormat:@"%ld", (long)summaryModel.praise_num.intValue];
        that.bookAuthor = summaryModel.author;
        
    } failure:^(id  _Nonnull model) {
        
    }];
    
    
}



- (void)updateReadingInfo {
    
}




- (void)updateViewStyle {
    [_bottomAdManager setViewStyle];
}

- (void)initFictionContent:(NSInteger)chapterId pageIndex:(NSInteger)pageIndex {
    
    WeakSelf(that);
   // [self showLoadingView:YES];
    
    NSString* indexStr = [NSString stringWithFormat:@"%ld", (long)chapterId];
    [JUDIAN_READ_NovelManager shareInstance].viewController = self;
    [[JUDIAN_READ_NovelManager shareInstance] getFictionChapterContent:indexStr bookId:_bookId block:^(id parameter) {
        //[that showLoadingView:NO];
        BOOL networkError = [that isNetworkError:parameter];
        if (networkError) {
            return;
        }
        
        [that hideTipView];
        
        NSInteger currentPageIndex = pageIndex;
        JUDIAN_READ_ChapterContentModel* model = parameter;
        [[JUDIAN_READ_CoreTextManager shareInstance] pagination:model];
        if (pageIndex >= model.pageArray.count) {
            currentPageIndex = 0;
        }
        
        [that updateCurrentModel:model];
        that.pageIndex = currentPageIndex;
        
        JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        if (style.pageStyle == kStylePageCoverIndex) {
            [that addCoverViewController:currentPageIndex];
        }
        else {
            [that addPageViewController:currentPageIndex];
        }

        [[JUDIAN_READ_NovelManager shareInstance] addUserReadChapter:that.bookId chapterId:model.chapnum];
        
        if (model.chapnum.length > 0) {
            that.middleAdManager.userChapterCountDictionary[model.chapnum] = @"1";
        }
        
        [that addGuideView];
        
    }];
    
}


- (void)loadFictionContent:(NSInteger)chapterId refresh:(BOOL)refresh isCatalog:(BOOL)isCatalog {
    
    if (chapterId < 0) {
        return;
    }
    
    WeakSelf(that);
    NSString* indexStr = [NSString stringWithFormat:@"%ld", (long)chapterId];
    [JUDIAN_READ_NovelManager shareInstance].viewController = self;
    [[JUDIAN_READ_NovelManager shareInstance] getFictionChapterContent:indexStr bookId:_bookId block:^(id parameter) {
        
        BOOL networkError = [self isNetworkError:parameter];
        if (networkError) {
            return;
        }
        
        if (!refresh) {
            return;
        }
        
        [that hideTipView];
        
        JUDIAN_READ_ChapterContentModel* model = parameter;
        [[JUDIAN_READ_CoreTextManager shareInstance] pagination:model];
        [that updateCurrentModel:model];
        
        if (isCatalog) {
            that.pageIndex = 0;
            
            //[that.pageViewController setViewControllers:@[[that viewControllerAtIndex:0 model:model]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            [that updatePageStyle];
            //[that saveBrowseHistory:model];
        }
        
        [[JUDIAN_READ_NovelManager shareInstance]addUserReadChapter:that.bookId chapterId:model.chapnum];
        
        [that saveBrowseHistory:model];
        
        if (model.chapnum.length > 0) {
            that.middleAdManager.userChapterCountDictionary[model.chapnum] = @"1";
        }
        that.middleAdManager.viewController = that;
        [that.middleAdManager showVideoPrompt];
    }];
    
}



- (void)loadFictionContent {
    NSString* chapterId = @"";
    NSString* pageIndex = @"0";
    NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:_bookId];
    
    if (_fictionDescription[@"chapterId"]) {
        chapterId = _fictionDescription[@"chapterId"];
        pageIndex = dictionary ? dictionary[@"pageIndex"] : @"0";
    }
    else if (dictionary) {
        chapterId = dictionary[@"chapterId"];
        pageIndex = dictionary[@"pageIndex"];
    }
    
    if (!pageIndex) {
        pageIndex = @"0";
    }
    
    if (chapterId.length <= 0) {
        chapterId = @"1";
    }
    
    [[JUDIAN_READ_NovelManager shareInstance] deleteLastChapterCache:_bookId chapterId:chapterId];
    
    [self initFictionContent:chapterId.integerValue pageIndex:pageIndex.integerValue];
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL isCache = TRUE;
    if (app.isHaveNet) {
        isCache = FALSE;
    }
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getNovelChapterList:_bookId block:^(id  _Nonnull parameter) {
        that.chapterList = [parameter copy];
        BOOL isExistCatalog = [[JUDIAN_READ_NovelManager shareInstance] isExistCatalog:that.bookId];
        if (!isCache && isExistCatalog) {
            NSString* bookPath = @"";
            bookPath = [ [JUDIAN_READ_NovelManager shareInstance] getCatalogFilePath:that.bookId ext:CATALOG_EXT];
            [that.chapterList archiveFile:bookPath];
        }
        
    } failure:^(id  _Nonnull parameter) {
       // [that showLoadingView:NO];
    } isCache:isCache];
    
}


- (BOOL)isNetworkError:(id)parameter {
    
    if ([parameter isKindOfClass:[NSError class]] && (((NSError*)parameter).code == NSURLErrorNotConnectedToInternet || ((NSError*)parameter).code == NSURLErrorTimedOut)) {
        NSNotification* notification = [[NSNotification alloc]initWithName:@""
                                                                    object:@{@"cmd": @"netError"}
                                                                  userInfo:nil];
        
        [super notificationHandler:notification];
        return TRUE;
    }
    
    return FALSE;
}


- (void)addMaskView {
    _maskContainer = [[UIView alloc]init];
    _maskContainer.frame = self.view.bounds;
    _maskContainer.layer.zPosition = LIGHT_VIEW_Z_POSITION;
    [self.view addSubview:_maskContainer];
}


- (void)addProtectionEyeModeView {
    
    NSInteger realFilter = 30;
    NSInteger r = (NSInteger) (200 - (realFilter / 80.f) * 190);
    NSInteger g = (NSInteger) (180 - (realFilter / 80.f) * 170);
    NSInteger b = (NSInteger) (60 - realFilter / 80.f * 60);
    UIColor* color = RGBA(r, g, b, 0.3);
    
    _protectionEyeContainer = [[UIView alloc]init];
    _protectionEyeContainer.frame = self.view.bounds;
    _protectionEyeContainer.backgroundColor = color;
    _protectionEyeContainer.layer.zPosition = EYE_VIEW_Z_POSITION;
    
    [self.view addSubview:_protectionEyeContainer];
    
    _protectionEyeContainer.hidden = YES;
}



- (void)showProtectionEyeModeView {
    
    if ([JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.eyeMode) {
        _protectionEyeContainer.hidden = NO;
    }
    else {
        _protectionEyeContainer.hidden = YES;
    }
}



- (void)setMaskViewBackgroundColor {
    _maskContainer.backgroundColor = RGBA(0x0, 0x0, 0x0, 1 - [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.brightness);
}

- (void)hideStatusView:(BOOL)hidden {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    
}


- (void)addMoreMenuView {
    
    JUDIAN_READ_SettingMenuPanel* moreMenuPanel = [[JUDIAN_READ_SettingMenuPanel alloc]initWithId:self.bookId];
    _moreMenuPanel = moreMenuPanel;
    
    moreMenuPanel.fromView = @"阅读器更多设置";
    moreMenuPanel.frame = self.view.bounds;
    moreMenuPanel.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
    [moreMenuPanel addToKeyWindow:self.view];
    [moreMenuPanel showView];
    [moreMenuPanel setViewStyle];
    
}



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}



- (void)addPageViewController:(NSInteger)pageIndex {
 
    if (_pageViewController) {
        return;
    }
    

    NSInteger transitionStyle = 0;
    NSInteger pageStyleIndex = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel.pageStyle;
    NSInteger navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
    
    if (pageStyleIndex == kStylePageCurlIndex) {
        transitionStyle = UIPageViewControllerTransitionStylePageCurl;
        self.pageAnimationFinished = YES;
        navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
    }
    else {
        transitionStyle = UIPageViewControllerTransitionStyleScroll;
        self.pageAnimationFinished = YES;
        
        if (pageStyleIndex == kStylePageScrollIndex) {
            navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        }
        else if (pageStyleIndex == kStylePageVerticalIndex) {
            navigationOrientation = UIPageViewControllerNavigationOrientationVertical;
        }
        
    }

    //UIPageViewControllerOptionSpineLocationKey
    JUDIAN_READ_PageViewController *pageViewController = [[JUDIAN_READ_PageViewController alloc] initWithTransitionStyle:transitionStyle                                  navigationOrientation:navigationOrientation
                                                options:nil];
    
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    JUDIAN_READ_ArticlePositiveViewController* viewController = (JUDIAN_READ_ArticlePositiveViewController*)[self viewControllerAtIndex:pageIndex model:model];
    [viewController setPageIndex:pageIndex];
    
    [pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    if (pageStyleIndex == kStylePageCurlIndex) {
        pageViewController.doubleSided = YES;
    }
    else {
        pageViewController.doubleSided = NO;
    }
    
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    [self addGuesture:pageViewController.view];
    WeakSelf(that);
    pageViewController.block = ^(id  _Nullable args) {
        [that popupSettingView];
    };
    _pageViewController = pageViewController;
}


- (void)createCatalogView {
    _catalogPanel = [[JUDIAN_READ_ChapterCatalogPanel alloc]initWithViewController:self];
}



- (UIViewController *)viewControllerAtIndex:(NSUInteger)index model:(JUDIAN_READ_ChapterContentModel*)model{
    JUDIAN_READ_ArticlePositiveViewController *childViewController = [[JUDIAN_READ_ArticlePositiveViewController alloc]initWith:index adManager:_middleAdManager model:model bookId:_bookId];
    return childViewController;
}



- (void) updatePageViewController {
    
    [self updateViewBgColor];
    
    UIColor* bgColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    _loadingView.backgroundColor = bgColor;
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    [_loadingView updateImageArray:[style isNightMode]];
    
    NSInteger pageIndex = _pageIndex;
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    
    [self loadFictionContent:model.chapnum.integerValue refresh:YES isCatalog:FALSE];
    
    model = _currentChapterModel;
    if (pageIndex >= model.pageArray.count) {
        pageIndex = 0;//model.pageArray.count - 1;
    }
    _pageIndex = pageIndex;
    if (style.pageStyle == kStylePageCoverIndex) {
        [self addCoverViewController:pageIndex];
    }
    else {
        [self addPageViewController:pageIndex];
        [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:pageIndex model:model]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }

    [_settingView setViewStyle];
    [_bottomAdManager updateViewStyle];
    
    if (self.view.subviews.count >= 2) {
        NSInteger index = self.view.subviews.count - 1;
        NSInteger preIndex = self.view.subviews.count - 2;
        [self.view exchangeSubviewAtIndex:index withSubviewAtIndex:preIndex];
    }
    
}



- (void) updatePageStyle {

    [_pageViewController removeFromParentViewController];
    [_pageViewController.view removeFromSuperview];
    _pageViewController = nil;
    
    [_coverViewController.view removeFromSuperview];
    [_coverViewController removeFromParentViewController];
    _coverViewController = nil;
    
    [self updatePageViewController];
}



- (void)enterFictionDescriptionViewController {
    
    BOOL existViewController = FALSE;
    NSArray* array = self.navigationController.viewControllers;
    for (UIViewController* element in array) {
        if ([element isKindOfClass:[JUDIAN_READ_NovelDescriptionViewController class]]) {
            existViewController = TRUE;
            break;
        }
    }
    
    if (existViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:self.navigationController bookId:self.bookId bookName:self.bookName viewName:@"阅读器完结页面"];
    }
}


#pragma mark 翻页代理
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController* resultViewController = nil;
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    
    if (style.pageStyle == kStylePageCurlIndex) {
        resultViewController = [self buildCurlViewController:pageViewController viewControllerBeforeViewController:viewController];
        return resultViewController;
    }
    
    if (style.pageStyle == kStylePageVerticalIndex) {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerBeforeViewController:viewController];
        return resultViewController;
    }
    
    if (_pageTouchFinished) {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerAfterViewController:viewController];
    }
    else {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerBeforeViewController:viewController];
    }

    return resultViewController;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController* resultViewController = nil;
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    
    if (style.pageStyle == kStylePageCurlIndex) {
        resultViewController = [self buildCurlViewController:pageViewController viewControllerAfterViewController:viewController];
        return resultViewController;
    }
    
    if (style.pageStyle == kStylePageVerticalIndex) {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerAfterViewController:viewController];
        return resultViewController;
    }
    
    
    if (_pageTouchFinished) {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerBeforeViewController:viewController];
    }
    else {
        resultViewController = [self buildScrollViewController:pageViewController viewControllerAfterViewController:viewController];
    }

    return resultViewController;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    self.pageAnimationFinished = NO;
    
    for (JUDIAN_READ_ArticlePositiveViewController* vc in pendingViewControllers) {
        _clickPageIndex = [vc getPageIndex];
        break;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.pageAnimationFinished = finished;
    _pageTouchFinished = FALSE;

    [self updateOperationTime];
    
    if (!completed) {
        for (JUDIAN_READ_ArticlePositiveViewController* vc in previousViewControllers) {
            _clickPageIndex = [vc getPageIndex];
            break;
        }
    }

}



- (UIViewController*)buildCurlViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (!self.pageAnimationFinished) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[JUDIAN_READ_ArticlePositiveViewController class]]) {
        
        JUDIAN_READ_ArticlePositiveViewController* currentViewController = (JUDIAN_READ_ArticlePositiveViewController*)viewController;
        NSInteger index = [currentViewController getPageIndex];
        JUDIAN_READ_ChapterContentModel* model = currentViewController.model;
        
        if ([self isFictionHeader:index model:model]) {
            [MBProgressHUD showSuccess:APP_FIRST_PAGE_TIP];
            return nil;
        }
        
        --index;
        
        if (index < 0) {
            [self loadFictionContent:model.prev_chapter.integerValue refresh:TRUE isCatalog:FALSE];
            model = _currentChapterModel;
            index = [self getPageSize:model] - 1;
            
            [self recordUserPageAction:@"翻到上一章"];
        }
        else {
            [self loadFictionContent:model.prev_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        }
        
        _pageIndex = index;
        JUDIAN_READ_ArticleNegativeViewController *backViewController = [[JUDIAN_READ_ArticleNegativeViewController alloc]init];
        
        UIViewController* previousViewController = [self viewControllerAtIndex:index model:model];
        [backViewController updateBgImage:previousViewController];
        return backViewController;
    }
    
    JUDIAN_READ_ArticlePositiveViewController* currentViewController = [(id)viewController positiveViewController];
    NSUInteger index = [currentViewController getPageIndex];
    JUDIAN_READ_ChapterContentModel* model = currentViewController.model;
    _pageIndex = index;

    //[self saveBrowseHistory:model];
    return [self viewControllerAtIndex:index model:model];
    
}



- (UIViewController *)buildCurlViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (!self.pageAnimationFinished) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[JUDIAN_READ_ArticlePositiveViewController class]]) {
       JUDIAN_READ_ArticlePositiveViewController* positiveViewController = (JUDIAN_READ_ArticlePositiveViewController *)viewController;
        
        NSInteger index = [positiveViewController getPageIndex];
        JUDIAN_READ_ChapterContentModel* model = positiveViewController.model;
        
        if ([self isFictionTail:index model:model]) {//小说最后一章的最后一页
            [self saveCurrentModel];
            [self prepareShowChapterEndView];
            return nil;
        }

        [self loadFictionContent:model.next_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        JUDIAN_READ_ArticleNegativeViewController *backViewController = [[JUDIAN_READ_ArticleNegativeViewController alloc]init];
        [backViewController updateBgImage:(id)viewController];
        return backViewController;
    }
    
    NSUInteger index = [[(id)viewController positiveViewController] getPageIndex];
    JUDIAN_READ_ChapterContentModel* model = [(id)viewController positiveViewController].model;
    if (index >= ([self getPageSize:model] - 1)) {
        [self loadFictionContent:model.next_chapter.integerValue refresh:TRUE isCatalog:FALSE];
        model = _currentChapterModel;
        index = 0;
        [self recordUserPageAction:@"翻到下一章"];
    }
    else {
        ++index;
    }
    
    _pageIndex = index;
    //[self saveBrowseHistory:model];
    return [self viewControllerAtIndex:index model:model];
    
}


- (UIViewController*)buildScrollViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (!self.pageAnimationFinished) {
        return nil;
    }
    
    [self updateOperationTime];
    
    JUDIAN_READ_ArticlePositiveViewController* positiveViewController = (JUDIAN_READ_ArticlePositiveViewController*)viewController;
    NSInteger index = [positiveViewController getPageIndex];
    JUDIAN_READ_ChapterContentModel* model = positiveViewController.model;
    
    if ([self isFictionHeader:index model:model]) {
        [MBProgressHUD showSuccess:APP_FIRST_PAGE_TIP];
        return nil;
    }
    
    --index;
    if (index < 0) {
        [self loadFictionContent:model.prev_chapter.integerValue refresh:TRUE isCatalog:FALSE];
        model = _currentChapterModel;
        index = [self getPageSize:model] - 1;
    }
    else {
        [self loadFictionContent:model.prev_chapter.integerValue refresh:FALSE isCatalog:FALSE];
    }
    
    //NSLog(@"KK::before===%ld chapter==%@",index, (model.chapnum));
    _pageIndex = index;

    UIViewController* previousViewController =[self viewControllerAtIndex:index model:model];
    return previousViewController;
}



- (UIViewController *)buildScrollViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    if (!self.pageAnimationFinished) {
        return nil;
    }
    
    [self updateOperationTime];
    
    JUDIAN_READ_ArticlePositiveViewController* positiveViewController = (JUDIAN_READ_ArticlePositiveViewController*)viewController;
    NSInteger index = [positiveViewController getPageIndex];
    
    ++index;
    JUDIAN_READ_ChapterContentModel* model = positiveViewController.model;
    if (index >= [self getPageSize:model]) {
        [self loadFictionContent:model.next_chapter.integerValue refresh:TRUE isCatalog:FALSE];
        index = 0;
        model = _currentChapterModel;
    }
    else {
        [self loadFictionContent:model.next_chapter.integerValue refresh:FALSE isCatalog:FALSE];
    }
    
    //NSLog(@"KK::after===%ld chapter==%@",index, (model.chapnum));
    _pageIndex = index;
    
    UIViewController* nextViewController =[self viewControllerAtIndex:index model:model];
    return nextViewController;
}


- (void)updateCurrentModel:(JUDIAN_READ_ChapterContentModel*)model{
    _currentChapterModel = model;
    [_settingView updateBookInfo:_bookName chapterName:model.title];    
}

- (BOOL)isFictionHeader:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model {
    if(model.prev_chapter.integerValue < 0 && pageIndex <= 0) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)isFictionTail:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model {
    NSInteger lastPage = ([self getPageSize:model] - 1);
    if((pageIndex >= lastPage) && (model.next_chapter.integerValue < 0)) {
        return TRUE;
    }
    return FALSE;
}


- (NSInteger)getPageSize:(JUDIAN_READ_ChapterContentModel*) model {
    //JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    return model.pageArray.count;
}

- (void)updateOperationTime {
    NSDate *datenow = [NSDate date];
    _lastReadTime = [datenow timeIntervalSince1970];
}


#pragma mark 处理cover

- (void)addCoverViewController:(NSInteger)pageIndex {
    
    if (_coverViewController) {
        return;
    }
    
    JUDIAN_READ_CoverViewController *coverVC = [[JUDIAN_READ_CoverViewController alloc] init];
    coverVC.delegate = self;
    _coverViewController = coverVC;
    [self.view addSubview:coverVC.view];
    [self addChildViewController:coverVC];
    
    _pageIndex = pageIndex;
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    JUDIAN_READ_ArticlePositiveViewController* viewController = (JUDIAN_READ_ArticlePositiveViewController*)[self viewControllerAtIndex:pageIndex model:model];
    [viewController setPageIndex:pageIndex];
    [coverVC setController:viewController];
    
}


- (void)showSettingMenuView {
    [self popupSettingView];
}

- (void)coverController:(JUDIAN_READ_CoverViewController *)coverController currentController:(UIViewController *)currentController finish:(BOOL)isFinish {
    if (!isFinish) { // 切换失败
        
    }
}

// 上一个控制器
- (UIViewController *)coverController:(JUDIAN_READ_CoverViewController *)coverController aboveController:(UIViewController *)currentController {
    
    JUDIAN_READ_ArticlePositiveViewController* positiveViewController = (JUDIAN_READ_ArticlePositiveViewController*)currentController;
    JUDIAN_READ_ChapterContentModel* model = positiveViewController.model;
    NSInteger index = [positiveViewController getPageIndex];

    if ([self isFictionHeader:index model:model]) {
        [MBProgressHUD showSuccess:APP_FIRST_PAGE_TIP];
        return nil;
    }
    
    --index;
    if (index < 0) {
        [self loadFictionContent:model.prev_chapter.integerValue refresh:TRUE isCatalog:FALSE];
        model = _currentChapterModel;
        index = [self getPageSize:model] - 1;
    }
    else {
        [self loadFictionContent:model.prev_chapter.integerValue refresh:FALSE isCatalog:FALSE];
    }
    
    //NSLog(@"KK::before===%ld chapter==%@",index, (model.chapnum));
    _pageIndex = index;
    
    JUDIAN_READ_ArticlePositiveViewController* previousViewController = (JUDIAN_READ_ArticlePositiveViewController*)[self viewControllerAtIndex:index model:model];
    previousViewController.model = model;
    return previousViewController;
}

// 下一个控制器
- (UIViewController *)coverController:(JUDIAN_READ_CoverViewController *)coverController belowController:(UIViewController *)currentController {
    
    JUDIAN_READ_ArticlePositiveViewController* positiveViewController = (JUDIAN_READ_ArticlePositiveViewController*)currentController;
    JUDIAN_READ_ChapterContentModel* model = positiveViewController.model;
    NSInteger index = [positiveViewController getPageIndex];
    
    if ([self isFictionTail:index model:model]) {//小说最后一章的最后一页
        [self saveCurrentModel];
        [self prepareShowChapterEndView];
        return nil;
    }
    
    ++index;
    if (index >= [self getPageSize:model]) {
        [self loadFictionContent:model.next_chapter.integerValue refresh:TRUE isCatalog:FALSE];
        index = 0;
        model = _currentChapterModel;
    }
    else {
        [self loadFictionContent:model.next_chapter.integerValue refresh:FALSE isCatalog:FALSE];
    }
    
    //NSLog(@"KK::after===%ld chapter==%@",index, (model.chapnum));
    _pageIndex = index;
    
    JUDIAN_READ_ArticlePositiveViewController* nextViewController = (JUDIAN_READ_ArticlePositiveViewController*)[self viewControllerAtIndex:index model:model];
    nextViewController.model = model;
    return nextViewController;
}


#pragma mark 自定义手势操作

- (void)addGuesture:(UIView*)view {
 
    UITapGestureRecognizer* guestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuesture:)];
    guestureRecognizer.delegate = self;
    [view addGestureRecognizer:guestureRecognizer];
    
}


- (void)handleTapGuesture:(UITapGestureRecognizer *)sender {
    
    CGFloat leftWidth = 0.32f * WIDTH_SCREEN;
    CGFloat rightWidth = 0.68f * WIDTH_SCREEN;
    
    CGPoint touchPoint = [sender locationInView:self.view];
    
    if(touchPoint.x > leftWidth && touchPoint.x < rightWidth) {
        [self showSettingMenuView];
        return;
    }
    

    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    if (style.pageStyle == kStylePageCurlIndex) {
        [self handlePageCurlStyleTap:touchPoint leftWidth:leftWidth rightWidth:rightWidth];
        return;
    }
    
    if (style.pageStyle == kStylePageScrollIndex) {
        [self handlePageScrollStyleTap:touchPoint leftWidth:leftWidth rightWidth:rightWidth];
    }
    
}


- (void)handlePageCurlStyleTap:(CGPoint)touchPoint leftWidth:(CGFloat)leftWidth rightWidth:(CGFloat)rightWidth {

    WeakSelf(that);
    if (_pageTouchFinished) {
        return;
    }
    
    _pageTouchFinished = TRUE;
    
    [self updateOperationTime];
    
    if (touchPoint.x < leftWidth) {
        NSInteger pageIndex = _pageIndex;
        pageIndex--;
        
        if (pageIndex < 0) {
            
            JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
            if (model.prev_chapter.integerValue < 0) {
                _pageTouchFinished = FALSE;
                [MBProgressHUD showSuccess:APP_FIRST_PAGE_TIP];
                return;
            }
            
            [self loadFictionContent:model.prev_chapter.integerValue refresh:YES isCatalog:FALSE];
            model = _currentChapterModel;
            pageIndex = model.pageArray.count - 1;
            
            [self recordUserPageAction:@"翻到上一章"];
        }
        else {
            JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
            [self loadFictionContent:model.prev_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        }
        
        JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
        _pageIndex = pageIndex;
        JUDIAN_READ_ArticleNegativeViewController *backViewController = [[JUDIAN_READ_ArticleNegativeViewController alloc]init];
        UIViewController* previousViewController = [self viewControllerAtIndex:pageIndex model:model];
        [backViewController updateBgImage:previousViewController];
        
        
        UIViewController* viewController =  [self viewControllerAtIndex:pageIndex model:model];
        [_pageViewController setViewControllers:@[viewController, backViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            that.pageTouchFinished = !finished;
        }];
        
        //[self saveBrowseHistory:model];
        
        return;
    }
    
    if (touchPoint.x > rightWidth) {
        
        NSInteger pageIndex = _pageIndex;
        pageIndex++;
        JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
        if (pageIndex >= [self getPageSize:model]) {
            if (model.next_chapter.integerValue < 0) {
                _pageTouchFinished = FALSE;
                [self saveCurrentModel];
                [self prepareShowChapterEndView];
                return;
            }
            
            [self loadFictionContent:model.next_chapter.integerValue refresh:TRUE isCatalog:FALSE];
            pageIndex = 0;
            
            [self recordUserPageAction:@"翻到下一章"];
        }
        else {
            JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
            [self loadFictionContent:model.next_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        }
        
        _pageIndex = pageIndex;
        model = _currentChapterModel;
        UIViewController* viewController =  [self viewControllerAtIndex:pageIndex model:model];
        JUDIAN_READ_ArticleNegativeViewController *backViewController = [[JUDIAN_READ_ArticleNegativeViewController alloc]init];
        [backViewController updateBgImage:(id)viewController];
        
        [_pageViewController setViewControllers:@[viewController, backViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            that.pageTouchFinished = !finished;
        }];
        
        //[self saveBrowseHistory:model];
        
        return;
    }
    
}


- (void)handlePageScrollStyleTap:(CGPoint)touchPoint leftWidth:(CGFloat)leftWidth rightWidth:(CGFloat)rightWidth {
    
    WeakSelf(that);
    if (_pageTouchFinished) {
        return;
    }
    
    [self updateOperationTime];
    
    _pageTouchFinished = TRUE;
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    
    NSInteger pageIndex = 0;
    pageIndex = _pageIndex;
    
    if (_clickPageIndex >= 0) {
        pageIndex = _clickPageIndex;
        _clickPageIndex = -1;
    }

    if (touchPoint.x < leftWidth) {
        pageIndex--;
        if (pageIndex < 0) {
            if (model.prev_chapter.integerValue < 0) {
                _pageTouchFinished = FALSE;
                [MBProgressHUD showSuccess:APP_FIRST_PAGE_TIP];
                return;
            }
            
            [self loadFictionContent:model.prev_chapter.integerValue refresh:YES isCatalog:FALSE];
            model = _currentChapterModel;
            pageIndex = model.pageArray.count - 1;
            
            [self recordUserPageAction:@"翻到上一章"];
        }
        else {
            [self loadFictionContent:model.prev_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        }

        _pageIndex = pageIndex;

        UIViewController* viewController =  [self viewControllerAtIndex:pageIndex model:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            that.pageViewController.view.userInteractionEnabled = NO;
            [that.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                that.pageTouchFinished = !finished;
                that.pageViewController.view.userInteractionEnabled = YES;
            }];
        });

        return;
    }
    

    if (touchPoint.x > rightWidth) {
        pageIndex++;
        if (pageIndex >= [self getPageSize:model]) {
            if (model.next_chapter.integerValue < 0) {
                _pageTouchFinished = FALSE;
                [self saveCurrentModel];
                [self prepareShowChapterEndView];
                return;
            }
            
            [self loadFictionContent:model.next_chapter.integerValue refresh:TRUE isCatalog:FALSE];
            pageIndex = 0;
            model = _currentChapterModel;
            [self recordUserPageAction:@"翻到下一章"];
        }
        else {
            [self loadFictionContent:model.next_chapter.integerValue refresh:FALSE isCatalog:FALSE];
        }

        _pageIndex = pageIndex;
        UIViewController* viewController = [self viewControllerAtIndex:pageIndex model:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            that.pageViewController.view.userInteractionEnabled = NO;
            [that.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                that.pageTouchFinished = !finished;
                that.pageViewController.view.userInteractionEnabled = YES;
            }];
        });
        return;
    }
    
}




- (void)saveCurrentModel {
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    [self saveBrowseHistory:model];
}



- (void)saveBrowseHistory:(JUDIAN_READ_ChapterContentModel*)model {

    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet){
       [JUDIAN_READ_UserReadingModel addOfflineHistory:_bookId chapterId:model.chapnum];
    }

    JUDIAN_READ_NovelBrowseHistoryModel* historyModel = [[JUDIAN_READ_NovelBrowseHistoryModel alloc]init];
    historyModel.bookId = _bookId;
    historyModel.bookName = _bookName;
    historyModel.chapterName = _currentChapterModel.title;
    historyModel.chapterId = _currentChapterModel.chapnum;
    historyModel.pageIndex = [NSString stringWithFormat:@"%ld", _pageIndex];
    
    
    [JUDIAN_READ_UserReadingModel saveBrowseHistoryWithModel:historyModel];
}




- (void)popupSettingView {
    
    [_settingView addToKeyWindow:self.view];// kKeyWindow
    [_settingView setTitleText:_bookName];
    [_settingView showBarView];
    
    [self hideStatusView:NO];
}


#pragma mark notification

- (void)handleButtonTouch:(NSNotification*)obj {
    
    WeakSelf(that);
    NSNumber* cmd = obj.object[@"cmd"];
    
    if (([cmd intValue] == kBackCmd) && _endView && !_endView.hidden) {
       
        [self updateReadingInfo];
        
        [self saveCurrentModel];
        if ([_endView.fictionState isEqualToString:_NO_CHAPTER_CODE_]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [_endView removeFromSuperview];
        }
        
        return;
    }
    
    
    if (([cmd intValue] == kBackCmd) && !_isBookInCollection) {
        [self saveCurrentModel];
        [JUDIAN_READ_VipCustomPromptView createCollectionPromptView:self.view block:^(id  _Nonnull args) {
            [that collectBook];
            [that.navigationController popViewControllerAnimated:YES];
        } cancel:^(id  _Nonnull args) {
            NSDictionary* dictionary = @{
                                         @"source" : @"阅读器"
                                         };
            [MobClick event:@"cancle_collection_reader" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"cancle_collection_reader" withArgs:dictionary];
            [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:obj viewController:that type:0];
        }];
        
        return;
    }
    
    if ([cmd intValue] == kCatalogCmd) {
        [MobClick event:@"click_setting_reader" attributes:@{@"topCatalogButton" : @"顶部目录按钮"}];
        [GTCountSDK trackCountEvent:@"click_setting_reader" withArgs:@{@"topCatalogButton" : @"顶部目录按钮"}];
    }
    
    if ([cmd intValue] == kBackCmd) {
        [self saveCurrentModel];
    }
    
    [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:obj viewController:self type:0];
    
}



- (void)enterAppreciatedUserList {
    [JUDIAN_READ_AppreciatedChapterListViewController enterUserListViewController:self.navigationController bookId:_bookId chapterId:_currentChapterModel.chapnum];
}



- (void)prepareShowChapterEndView {
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        [MBProgressHUD showMessage:@"已是最后一页了"];
        return;
    }
    
    if((self.bookState.length <= 0)
       || (self.bookId.length <= 0)
       || (self.bookName.length <= 0)
       || (self.bookAuthor.length <= 0)) {
        return;
    }
    
    //self.pageCollectionView.hidden = YES;
    [self showChapterEndView];
    
    WeakSelf(that);
    [JUDIAN_READ_NovelThumbModel buildThumbModel:_bookId block:^(id  _Nonnull model) {
        [that.endView reloadData:model];
    }];
    
    
    [[JUDIAN_READ_NovelManager shareInstance] loadRecommendFeedData:_bookId block:^(id  _Nullable parameter) {
        [that.endView reloadFeedList:parameter];
    }];
    
    [JUDIAN_READ_NovelThumbModel buildAuthorOtherBookModel:_bookId block:^(id  _Nonnull parameter) {
        [that.endView reloadAuthorOtherBookList:parameter];
    }];
    
    
    [self getAppreciteBookAvatarList];
    
}



- (void)showChapterEndView {
    
    [_endView removeFromSuperview];
    
    JUDIAN_READ_AllChapterEndView* endView = [[JUDIAN_READ_AllChapterEndView alloc]initWithName:self.bookName state:self.bookState];
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
    endView.fictionState = self.bookState;
    endView.bookName = self.bookName;
    endView.wordCount = self.wordCount;
    endView.chapterCount = self.chapterCount;
    endView.appreciateCount = self.appreciateCount;
    endView.bookAuthor = self.bookAuthor;
    endView.bookId = self.bookId;
    
    WeakSelf(that);
    endView.block = ^(id  _Nullable args) {
        NSString* cmd = args;
        if ([cmd isEqualToString:@"share"]) {
            [that popupShareView];
        }
        else {
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(kBackCmd)}];
            [that enterBookStoreViewController];
        }
        
    };
    
    endView.cellBlock = ^(id  _Nullable args) {
        JUDIAN_READ_NovelThumbModel* model = args;
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:that.navigationController bookId:model.nid bookName:model.bookname viewName:@"阅读器完结页面"];
    };
    
    
    endView.appreciateBlock = ^(id  _Nullable args) {
        [that enterAppreciateMoneyViewController:@"0"];
    };
    
    [self getAppreciteBookAvatarList];
}




- (void)prepareShowNoChapterView {
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        [MBProgressHUD showMessage:@"网络连接异常"];
        return;
    }
    
    //self.pageCollectionView.hidden = YES;
    [self showNoChapterView];
    
    WeakSelf(that);
    [JUDIAN_READ_NovelThumbModel buildThumbModel:_bookId block:^(id  _Nonnull model) {
        [that.endView reloadData:model];
    }];
    
    
    [[JUDIAN_READ_NovelManager shareInstance] loadRecommendFeedData:_bookId block:^(id  _Nullable parameter) {
        [that.endView reloadFeedList:parameter];
    }];
    
    
    [JUDIAN_READ_NovelThumbModel buildAuthorOtherBookModel:_bookId block:^(id  _Nonnull parameter) {
        [that.endView reloadAuthorOtherBookList:parameter];
    }];
    
}


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
    endView.wordCount = self.wordCount;
    endView.chapterCount = self.chapterCount;
    endView.appreciateCount = self.appreciateCount;
    endView.bookAuthor = self.bookAuthor;
    endView.bookId = self.bookId;
    
    WeakSelf(that);
    endView.block = ^(id  _Nullable args) {
        NSString* cmd = args;
        if ([cmd isEqualToString:@"share"]) {
            [that popupShareView];
        }
        else {
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(kBackCmd)}];
            [that enterBookStoreViewController];
        }
        
    };
    
    endView.cellBlock = ^(id  _Nullable args) {
        JUDIAN_READ_NovelThumbModel* model = args;
        [JUDIAN_READ_NovelDescriptionViewController enterDescription:that.navigationController bookId:model.nid bookName:model.bookname viewName:@"阅读器完结页面"];
    };
    
    
    endView.appreciateBlock = ^(id  _Nullable args) {
        [that enterAppreciateMoneyViewController:@"0"];
    };
    
}




- (void)enterBookStoreViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UITabBarController *vc = (UITabBarController*)kKeyWindow.rootViewController;
    vc.selectedIndex = 2;
}




#pragma mark 书籍收藏
- (void)collectBook {
    
    NSString* viewName = _previewViewName;
    if (viewName.length <= 0) {
        viewName = @"阅读器退出";
    }
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {

            [MBProgressHUD showSuccess:@"收藏成功"];
            
            that.isBookInCollection = YES;
            [that showFavouriteButton:that.isBookInCollection];
                        
            NSDictionary* dictionary = @{
                                         @"source" : viewName
                                         };
            [MobClick event:@"collection_source_byreader" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"collection_source_byreader" withArgs:dictionary];
        }
    }];
}



- (void)checkBookCollectionState {
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] isBookInCollection:_bookId block:^(id  _Nullable parameter) {
        if ([parameter isEqual:[NSNull null]]) {
            that.isBookInCollection = FALSE;
            [that showFavouriteButton:that.isBookInCollection];
        }
        else {
            NSString* count = parameter;
            that.isBookInCollection = ([count intValue] > 0) ? TRUE : FALSE;
            [that showFavouriteButton:that.isBookInCollection];
        }
        
    }];
}


- (void)showFavouriteButton:(BOOL)hidden {

    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        that.settingView.favoritesButton.hidden = hidden;
    });

}


#pragma mark 用户赞赏
- (void)prepareEnterAppreciateMoneyViewController {
    NSString* chapterId = _currentChapterModel.chapnum;
    [self enterAppreciateMoneyViewController:chapterId];
}

- (void)getAppreciteBookAvatarList {
    
    WeakSelf(that);
    if (_bookId.length > 0) {
        NSDictionary* dictionary = @{
                                     @"id":_bookId,
                                     @"chapnum": @"0",
                                     @"page":@"1",
                                     //@"pageSize":@"1000000"
                                     };
        
        [[JUDIAN_READ_NovelManager shareInstance]getUserAppreciateAvatarList:dictionary block:^(NSArray* array, NSNumber* total) {
            [that.endView reloadAvatarList:array];
        } needTotalPage:FALSE];
    }
    
}


- (void)enterAppreciateMoneyViewController:(NSString*)chapterId {
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        [MBProgressHUD showError:APP_NO_NETWORK_TIP toView:self.view];
        return;
    }
    
    
    WeakSelf(that);
    [JUDIAN_READ_AppreciateMoneyViewController enterAppreciateMoneyViewController:self.navigationController bookId:_bookId chapterId:chapterId source:@"阅读器的章节赞赏" block:^(id  _Nullable args) {
        
        if ([chapterId isEqualToString:@"0"]) {
            [that getAppreciteBookAvatarList];
        }
        else {
            [that getAppreciateAvatarList];
        }
    }];
}


- (void)getAppreciateAvatarList {
    
    NSString* chapterId = _currentChapterModel.chapnum;
    
    if (!_bookId || !chapterId) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"id":_bookId,
                                 @"chapnum": chapterId,
                                 @"page":@"1",
                                 //@"pageSize":@"1000000"
                                 };
    //WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance]getUserAppreciateAvatarList:dictionary block:^(NSArray* array, NSNumber* total) {
        //that.appreciatedChapterCount = total.integerValue;
        //that.appreciatedAvatarArray = array;
        //[that.pageCollectionView reloadData];
    } needTotalPage:FALSE];
    
}

#pragma mark 下载小说

- (void)saveFictionSummary {
    [JUDIAN_READ_NovelSummaryModel buildSummaryModel:_bookId block:^(id  _Nonnull model) {
        [JUDIAN_READ_UserReadingModel saveBookSummary:model];
    } failure:^(id  _Nonnull model) {
        
    }];
}

- (void)prepareDownload {
    
    [self.catalogPanel removeSelf];
    
    NSString* token = [JUDIAN_READ_Account currentAccount].token;
    if (!token) {
        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getBookCacheState:_bookId block:^(id  _Nonnull parameter) {
        NSDictionary* dictionary = parameter;
        [that prepareDownload:dictionary];
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
        NSString* count = [NSString stringWithFormat:@"%d", (fictionPrize.intValue)];//- goldCoinCount.intValue
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
        [self beginDownloadFiction];
        return;
    }
    
    //if ([fictionNumber intValue] > 0) {}
    if ([overloadNumber intValue] <= 0) {
        [MBProgressHUD showMessage:tip];
    }
    else {
        [self beginDownloadFiction];
    }
    
}



- (void)beginDownloadFiction {
    
    [MBProgressHUD showSuccess:@"开始缓存"];
    
    NSString* type = [JUDIAN_READ_Account currentAccount].vip_type;
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!type) {
        type = @"";
    }
    
    if (!sex) {
        sex = @"未知";
    }
    
    NSDictionary* dictionary = @{@"source" : @"小说阅读器",
                                 @"vip_type" : type,
                                 @"sex" : sex
                                 };
    [MobClick event:click_cache attributes:dictionary];
    [GTCountSDK trackCountEvent:click_cache withArgs:dictionary];
    
    [self saveFictionSummary];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTick) userInfo:nil repeats:YES];
    
    WeakSelf(that);
    NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:_bookId];
    if (begin < [_chapterCount intValue]) {
        NSString* beginStr = [NSString stringWithFormat:@"%ld", (begin)];
        
        [[JUDIAN_READ_NovelManager shareInstance] serializeFictionFromServer:_bookId bookName:_bookName begin:beginStr size:_chapterCount block:^(id  _Nonnull parameter) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [that.progressTimer invalidate];
                that.progressTimer = nil;
                [that.catalogPanel.titleItem updateProgress:@"已缓存"];
            });
        }];
    }
    else {
        
    }
    
}


- (void)increaseTick {
    _progressTotal++;
    NSString* tip = [NSString stringWithFormat:@"%ld", _progressTotal];
    tip = [tip stringByAppendingString:@"%"];
    [self.catalogPanel.titleItem updateProgress:tip];
    if (_progressTotal >= 60) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    
}




#pragma mark 分享
- (void)popupShareView {
    
    JUDIAN_READ_SettingMenuPanel* settingView = [[JUDIAN_READ_SettingMenuPanel alloc]initShareView:self.bookId];
    _menuSettingView = settingView;
    _menuSettingView.fromView = @"章节底部分享";
    _menuSettingView.frame = self.view.bounds;
    _menuSettingView.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
    [_menuSettingView addToKeyWindow:self.view];
    [_menuSettingView showView];
    [_menuSettingView setViewStyle];
    
}


#pragma mark 统计时长
- (void)autoRefreshUserDuration {

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSNumber *defaultDuration = [def objectForKey:USER_READ_DURATION];
    
    NSInteger duration = defaultDuration.integerValue;
    NSString* durationStr = [NSString stringWithFormat:@"%ld", (long)duration];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _userDurationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_userDurationTimer, DISPATCH_TIME_NOW, duration * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    WeakSelf(that);
    dispatch_source_set_event_handler(_userDurationTimer, ^{
        
        NSDate *datenow = [NSDate date];
        NSTimeInterval currentTime = [datenow timeIntervalSince1970];
        if ((currentTime - that.lastReadTime) > (duration + 10)) {
            return;
        }
        
        NSString* chapterId = that.currentChapterModel.chapnum;
        NSString* bookId = that.bookId;
        
        [[JUDIAN_READ_NovelManager shareInstance] updateUserReadDuration:bookId chapterId:chapterId duration:durationStr block:^(id  _Nullable parameter) {
            
        }];
        
    });
    dispatch_resume(_userDurationTimer);
    
}


- (void)loadAdData {
    
    _bottomAdManager = [JUDIAN_READ_FictionEmbeddedAdManager createEmbeddedAdManager:FICTION_BOTTOM_AD];
    [_bottomAdManager addBottomAdView:self];
    
    _middleAdManager = [JUDIAN_READ_FictionEmbeddedAdManager createEmbeddedAdManager:FICTION_EMBEDDED_AD];
    

    [_bottomAdManager initGDTBottomAdData];
    [_middleAdManager initGDTMiddleAdData:self];
    
}

#pragma mark 进度加载

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


#pragma mark 网络异常

- (void)refreshData {
    [self showLoadingView:NO];
    
    BOOL loadContentFail = [self isChapterCountLoad];
    if (loadContentFail) {
        [self prepareLoadFiction];
    }
    else {
        NSInteger chapterIndex = [self getCurrentChapterIndex];
        [self loadFictionContent:chapterIndex refresh:YES isCatalog:NO];
    }
    
}

- (NSInteger)getCurrentChapterIndex {
    if (_bookId.length <= 0) {
        _bookId = _fictionDescription[@"bookId"];
    }
    
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    NSInteger chapterIndex = model.chapnum.integerValue;
    return chapterIndex;
}

- (BOOL)isChapterCountLoad {
    
    BOOL loadContentFail = NO;
    JUDIAN_READ_ChapterContentModel* model = _currentChapterModel;
    if (model.prev_chapter.integerValue < 0 || model.next_chapter.integerValue < 0) {
        loadContentFail = YES;
    }
    return loadContentFail;
    
}




- (void)notificationHandler:(NSNotification*)obj {
    
    BOOL isExistCatalog = [[JUDIAN_READ_NovelManager shareInstance] isExistCatalog:_bookId];
    if (isExistCatalog) {//整本书已经缓存
        return;
    }
    
    BOOL loadContentFail = [self isChapterCountLoad];
    NSInteger chapterIndex = [self getCurrentChapterIndex];
    NSString* chapterIndexStr = [NSString stringWithFormat:@"%ld", chapterIndex];
    BOOL existFiction = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:_bookId chpaterId:chapterIndexStr];
    [self showLoadingView:NO];
    if (!existFiction || loadContentFail) {//该章节未缓存
        [super notificationHandler:obj];
        //self.topBarView.isShow = YES;
        //[self showNavigationBar];
    }

}

- (void)popupWhenNetworkError {
    [self saveCurrentModel];
}

#pragma mark 埋点
- (void)recordUserPageAction:(NSString*)actionName {
    
    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"未知";
    }
    
    NSDictionary* dictionary = @{
                                 @"device" : deviceName,
                                 @"sex" : sex,
                                 @"type" : actionName,
                                 };
    [MobClick event:@"click_sliding_page_turning" attributes:dictionary];
    [GTCountSDK trackCountEvent:@"click_sliding_page_turning" withArgs:dictionary];
}


#pragma mark dealloc
- (void)dealloc {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
    dispatch_cancel(_userDurationTimer);
    _userDurationTimer = nil;
    
}


@end
