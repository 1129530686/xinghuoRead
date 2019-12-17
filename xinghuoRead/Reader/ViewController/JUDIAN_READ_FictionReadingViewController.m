//
//  JUDIAN_READ_NovelReadingViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/5/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_ChapterContentCell.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_ChapterTitleModel.h"
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_AdSize250ViewCell.h"
#import "JUDIAN_READ_FictionNavigationView.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_UserAppreciateFictionCell.h"
#import "JUDIAN_READ_UserAppreciateAvatarCell.h"
#import "JUDIAN_READ_UserAppreciateCountCell.h"
#import "JUDIAN_READ_PageTurningCell.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"
#import "JUDIAN_READ_AppreciateMoneyViewController.h"
#import "JUDIAN_READ_FictionChapterTitleCell.h"
#import "JUDIAN_READ_VipCustomPromptView.h"
#import "JUDIAN_READ_NovelDescriptionViewController.h"
#import "JUDIAN_READ_ChapterRefreshStateHeader.h"
#import "JUDIAN_READ_TestHelper.h"
#import "JUDIAN_READ_VipController.h"
#import "JUDIAN_READ_LoadingFictionView.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_AllChapterEndView.h"
#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_HowBrowseFictionView.h"
#import "JUDIAN_READ_MiniAdViewCell.h"
#import "JUDIAN_READ_GdtAdSize250ViewCell.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_AdsManager.h"
#import "JUDIAN_READ_FictionCoverImageCell.h"
#import "JUDIAN_READ_UserEarningsViewController.h"
#import "NSString+JUDIAN_READ_Url.h"

#define FICTION_CHAPTER_TITLE_IDENTIFIER @"chapterTitleCell"
#define FICTION_CONTENT_IDENTIFIER @"fictionCell"
#define FICTION_AD_CELL_IDENTIFIER @"adViewCell"
#define FICTION_GDT_AD_CELL_IDENTIFIER @"gdtAdViewCell"
#define FICTION_APPRECIATE_BUTTON_IDENTIFIER @"appreciateButtonCell"
#define FICTION_APPRECIATE_AVATER_IDENTIFIER @"appreciateAvatarCell"
#define FICTION_APPRECIATE_COUNT_IDENTIFIER @"appreciateCountCell"
#define FICTION_PAGE_TURNING_CELL_IDENTIFIER @"pageTurningCell"
#define FICTION_MINI_FEED_AD_CELL_IDENTIFIER @"miniAdViewCell"
#define FICTION_FICTION_COVER_IMAGE_CELL_IDENTIFIER @"FictionCoverImageCell"

#define READ_CHAPTER_UPPER_LIMIT (10 + 1) //n+1

#define FICTION_AD_VIEW_HEIGHT 273

#define PULL_DOWN_OFFSET_LIMIT 50
#define PULL_UP_OFFSET_LIMIT 30

#define MIN_LINE_COUNT 60

@interface JUDIAN_READ_FictionReadingViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>


@property (nonatomic, strong)UICollectionView* pageCollectionView;

@property (nonatomic, copy)NSString* chapterName;
@property (nonatomic, copy)NSArray* chapterRangeArray;

@property (nonatomic, strong)NSMutableAttributedString* attributedString;
@property (nonatomic, strong)NSString* contentString;

@property (nonatomic, weak)JUDIAN_READ_FictionNavigationView* topBarView;

@property (nonatomic, strong) UIView* maskContainer;
@property (nonatomic, strong) UIView* protectionEyeContainer;
@property (nonatomic, weak) JUDIAN_READ_LoadingFictionView* emptyView;

@property (nonatomic, strong)JUDIAN_READ_FictionChapterTitleCell* chapterTitleCell;

@property (nonatomic, strong)NSMutableDictionary* userReadChapterDictionary;
@property (nonatomic, strong)JUDIAN_READ_ChapterContentModel* currentContentModel;
@property (nonatomic, strong)BURewardedVideoAd* rewardedVideoAd;
@property (nonatomic, copy)NSArray* appreciatedAvatarArray;

@property (nonatomic, strong)NSMutableDictionary* fictionDescription;

@property (nonatomic, strong)NSTimer* progressTimer;
@property (nonatomic, assign)NSInteger progressTotal;

@property (nonatomic, assign)BOOL isScrolling;

@property (nonatomic, strong)JUDIAN_READ_AdsManager* adsManager;

@property (nonatomic, assign)NSInteger lineCount;
@property (nonatomic, copy)NSArray* coverImageArray;

@property (nonatomic, assign)BOOL isBookInCollection;
@property (nonatomic, weak)JUDIAN_READ_AllChapterEndView* endView;
@property (nonatomic, weak)UIButton* favoritesButton;
@property (nonatomic, assign)BOOL isStatisticsDuration;

@property (nonatomic, copy)NSString* previewViewName;
@property (nonatomic, assign)TurningChapterEnum turningPageDirection;
@property (nonatomic, assign)NSInteger appreciatedChapterCount;
@end

@implementation JUDIAN_READ_FictionReadingViewController


+ (void)enterFictionViewController:(UINavigationController*)navigation book:(NSDictionary*)dictionary viewName:(NSString*)viewName {

    JUDIAN_READ_FictionReadingViewController* viewController = [[JUDIAN_READ_FictionReadingViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.fictionDescription = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    viewController.previewViewName = viewName;
    [navigation pushViewController:viewController animated:YES];

}



- (void)viewDidLoad {
    [super viewDidLoad];

    _userReadChapterDictionary = [NSMutableDictionary dictionary];
    _progressTotal = 0;
    _isScrolling = FALSE;
    _lineCount = 0;
    _isBookInCollection = FALSE;
    _isStatisticsDuration = FALSE;
    
    [self addProtectionEyeModeView];
    [self showProtectionEyeModeView];
    
    [self addMaskView];
    [self setMaskViewBackgroundColor];
    
    [self addCollectionView];
    
    [self addEmptyView];
    
    [self addNavigationBar];
    
    [self addFavoritesButton];
    
    _adsManager = [JUDIAN_READ_AdsManager createAdsManager:self collectionView:self.pageCollectionView readChpater:self.userReadChapterDictionary];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.pageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self setViewBackgroundColor];
    
    [self prepareLoadFiction];

    [self createCatalogView];
    
    [self checkBookCollectionState];
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideStatusView:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleButtonTouch:) name:@"buttonHandler" object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    NSString* chapterId = _currentContentModel.chapnum;
    
    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    NSInteger yPos = self.pageCollectionView.contentOffset.y;
    NSString* posStr = [NSString stringWithFormat:@"%ld", yPos];
    if (app.isHaveNet){
        [JUDIAN_READ_UserReadingModel updateReaderPosition:_bookId chapterId:chapterId position:posStr];
    }
    else {
        [JUDIAN_READ_UserReadingModel updateOfflinePosition:_bookId chapterId:chapterId position:posStr];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



- (void)setViewBackgroundColor {
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.view.backgroundColor  = [style getBgColor];
    
    self.pageCollectionView.backgroundColor = [style getBgColor];
    self.view.backgroundColor = [style getBgColor];
    
}


- (void)addNavigationBar {
    CGFloat navigationHeight = [self getNavigationHeight];
    JUDIAN_READ_FictionNavigationView* topBarView = [[JUDIAN_READ_FictionNavigationView alloc]init];
    topBarView.titleLabel.text = _bookName;
    [topBarView setViewStyle];
    topBarView.frame = CGRectMake(0, -navigationHeight, WIDTH_SCREEN, navigationHeight);
    [self.view addSubview:topBarView];
    _topBarView = topBarView;
}


- (void)addFavoritesButton {
    
    UIButton* favoritesButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [favoritesButton addTarget:self action:@selector(handleFavoritesTouch) forControlEvents:(UIControlEventTouchUpInside)];
    _favoritesButton = favoritesButton;
    [favoritesButton setBackgroundImage:[UIImage imageNamed:@"reader_book_favourites"] forState:(UIControlStateNormal)];
    [self.view addSubview:favoritesButton];
    
    NSInteger top = [self getNavigationHeight];
    top += 20;
    
    NSInteger width = 96;
    NSInteger height = 42;
    
    WeakSelf(that);
    [favoritesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(@(top));
        make.right.equalTo(that.view.mas_right).offset(width);
    }];
    
}


- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    NSInteger topOffset = [self getContentTopOffset];
    NSInteger bottomOffset = [self getBottomOffset];
    //CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - bottomOffset);
    CGRect rect = CGRectMake(0, 0, 0, 0);
    self.pageCollectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    self.pageCollectionView.backgroundColor = RGB(0xf9, 0xf9, 0xf9);
    self.pageCollectionView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    self.pageCollectionView.delegate = self;
    self.pageCollectionView.dataSource = self;
    self.pageCollectionView.scrollEnabled = YES;
    self.pageCollectionView.alwaysBounceVertical = YES;
    
    [self.pageCollectionView registerClass:[JUDIAN_READ_FictionChapterTitleCell class] forCellWithReuseIdentifier:FICTION_CHAPTER_TITLE_IDENTIFIER];
    [self.pageCollectionView registerClass:[JUDIAN_READ_ChapterContentCell class] forCellWithReuseIdentifier:FICTION_CONTENT_IDENTIFIER];
    
    [self.pageCollectionView registerClass:[JUDIAN_READ_AdSize250ViewCell class] forCellWithReuseIdentifier:FICTION_AD_CELL_IDENTIFIER];
    [self.pageCollectionView registerClass:[JUDIAN_READ_GdtAdSize250ViewCell class] forCellWithReuseIdentifier:FICTION_GDT_AD_CELL_IDENTIFIER];
    
    [self.pageCollectionView registerClass:[JUDIAN_READ_UserAppreciateFictionCell class] forCellWithReuseIdentifier:FICTION_APPRECIATE_BUTTON_IDENTIFIER];
    [self.pageCollectionView registerClass:[JUDIAN_READ_UserAppreciateAvatarCell class] forCellWithReuseIdentifier:FICTION_APPRECIATE_AVATER_IDENTIFIER];
    [self.pageCollectionView registerClass:[JUDIAN_READ_UserAppreciateCountCell class] forCellWithReuseIdentifier:FICTION_APPRECIATE_COUNT_IDENTIFIER];
    [self.pageCollectionView registerClass:[JUDIAN_READ_PageTurningCell class] forCellWithReuseIdentifier:FICTION_PAGE_TURNING_CELL_IDENTIFIER];
    
    
    [self.pageCollectionView registerClass:[JUDIAN_READ_MiniAdViewCell class] forCellWithReuseIdentifier:FICTION_MINI_FEED_AD_CELL_IDENTIFIER];
    
    [self.pageCollectionView registerClass:[JUDIAN_READ_FictionCoverImageCell class] forCellWithReuseIdentifier:FICTION_FICTION_COVER_IMAGE_CELL_IDENTIFIER];
    
    _chapterTitleCell = [[JUDIAN_READ_FictionChapterTitleCell alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:self.pageCollectionView];
    
    WeakSelf(that);
#if 0
    
    self.pageCollectionView.mj_header = [JUDIAN_READ_ChapterRefreshStateHeader headerWithRefreshingBlock:^{
        [that turnPage:NO];
    }];
    
    
    MJRefreshBackGifFooter *foot = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [that turnPage:YES];
    }];
    //foot.hidden = YES;
    self.pageCollectionView.mj_footer = foot;
    
    [foot setTitle:@"上拉可以加载下一章" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开立即加载下一章" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在加载下一章..." forState:MJRefreshStateRefreshing];
    [foot setTitle:@"已经加载完所有章节" forState:MJRefreshStateNoMoreData];
#endif
    
    [self.pageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.top.equalTo(@(0));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];

}



- (void)addEmptyView {
    
    JUDIAN_READ_LoadingFictionView* emptyView = [[JUDIAN_READ_LoadingFictionView alloc]init];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    UIColor* bgColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    emptyView.backgroundColor = bgColor;
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    [emptyView updateImageArray:[style isNightMode]];
    
    NSInteger bottomOffset = [self getBottomOffset];
    _emptyView = emptyView;

    NSInteger topOffset = 0;//[self getContentTopOffset];
    
    WeakSelf(that);
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        //make.top.equalTo(that.topBarView.mas_bottom);
        make.top.equalTo(@(topOffset));
        make.bottom.equalTo(that.view.mas_bottom).offset(-bottomOffset);
    }];
}


- (void)addGuideView {

    NSString* key = @"readGuideTip";
    NSString* guideTip = [NSUserDefaults getUserDefaults:key];
    if (guideTip) {
        return;
    }
    
    JUDIAN_READ_HowBrowseFictionView* guideView = [[JUDIAN_READ_HowBrowseFictionView alloc]init];
    guideView.frame = self.view.bounds;
    [self.view addSubview:guideView];
    __block JUDIAN_READ_HowBrowseFictionView* thatView = guideView;
    guideView.block = ^(id  _Nullable args) {
        [thatView removeFromSuperview];
        [NSUserDefaults saveUserDefaults:key value:@"1"];
    };
    
}


- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}


- (NSInteger)getContentTopOffset {
    
    NSInteger topOffset = 0;
    if (iPhoneX) {
        topOffset = 44;
    }
    
    return topOffset;
}


- (CGFloat)getBottomOffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
    
}


- (void)createCatalogView {
    _catalogPanel = [[JUDIAN_READ_ChapterCatalogPanel alloc]initWithViewController:self];
}



- (void)prepareLoadFiction {
    
    _bookId = _fictionDescription[@"bookId"];
    _bookName = _fictionDescription[@"bookName"];
    _chapterCount = _fictionDescription[@"chapterCount"];
    _lastBrowsePosition = _fictionDescription[@"position"];
    
    _topBarView.titleLabel.text = _bookName;
    
    
    WeakSelf(that);
    NSString* chapterId = _fictionDescription[@"chapterId"];
    if (!chapterId) {
        chapterId = @"1";
    }
    
    [self showLoadingView:YES];
    
    BOOL existFiction = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:_bookId chpaterId:chapterId];
    BOOL isExistCatalog = [[JUDIAN_READ_NovelManager shareInstance] isExistCatalog:_bookId];
    if (existFiction && isExistCatalog) {
        
        NSArray* array = [JUDIAN_READ_UserReadingModel getCachedBookSummary:_bookId];
        if (array.count > 0) {
            JUDIAN_READ_NovelSummaryModel* model = array[0];
            that.bookState = model.update_status;
            that.chapterCount = model.chapters_total;
            that.wordCount =  model.words_number;
        }
        
        [that loadFictionContent];
    }
    else {
        
        [self loadFictionContent];
        
        [JUDIAN_READ_NovelSummaryModel buildSummaryModel:_fictionDescription[@"bookId"] block:^(id  _Nonnull model) {
            JUDIAN_READ_NovelSummaryModel* summaryModel = model;

            BOOL notExistBook = (!summaryModel || (summaryModel.status.intValue == 0) || (summaryModel.status.intValue == 1) || (summaryModel.nid.intValue == 0));
            if (notExistBook) {
                [that showLoadingView:NO];
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
    
    
}




- (void)loadFictionContent {
    NSString* chapterId = @"";
    NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:_bookId];
    
    if (_fictionDescription[@"chapterId"]) {
        chapterId = _fictionDescription[@"chapterId"];
    }
    else if (dictionary) {
        chapterId = dictionary[@"chapterId"];
    }
    
    if (chapterId.length <= 0) {
        chapterId = @"1";
    }
    
    [self getFictionChapterContent:chapterId bookId:self.bookId direction:DIRECTION_NONE];

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
        [that showLoadingView:NO];
    } isCache:isCache];
    
    
    
}

#pragma mark 网络异常

- (void)refreshData {
    [self showLoadingView:NO];
    
    BOOL loadContentFail = [self isChapterCountLoad];
    if (loadContentFail) {
        [self prepareLoadFiction];
    }
    else {
        NSString* chapterIndexStr = [self getCurrentChapterIndex];
        [self getFictionChapterContent:chapterIndexStr bookId:_bookId direction:DIRECTION_NONE];
    }

}


- (NSInteger)getTopOffset {
    return [self getNavigationHeight];
}


- (void)notificationHandler:(NSNotification*)obj {
    
    BOOL isExistCatalog = [[JUDIAN_READ_NovelManager shareInstance] isExistCatalog:_bookId];
    if (isExistCatalog) {//整本书已经缓存
        return;
    }
    
    BOOL loadContentFail = [self isChapterCountLoad];
    NSString* chapterIndexStr = [self getCurrentChapterIndex];
    BOOL existFiction = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:_bookId chpaterId:chapterIndexStr];
    [self showLoadingView:NO];
    if (!existFiction || loadContentFail) {//该章节未缓存
        [super notificationHandler:obj];
        self.topBarView.isShow = YES;
        [self showNavigationBar];
    }
    else {
        if (self.attributedString.length <= 0) {
            [self getFictionChapterContent:chapterIndexStr bookId:_bookId direction:DIRECTION_DOWN];
        }
    }

}

- (BOOL)isChapterCountLoad {
    
    BOOL loadContentFail = NO;
    JUDIAN_READ_ChapterContentModel* model = _currentContentModel;
    if (model.prev_chapter.integerValue < 0 || model.next_chapter.integerValue < 0) {
        loadContentFail = YES;
    }
    return loadContentFail;
    
}

- (NSString*)getCurrentChapterIndex {
    if (_bookId.length <= 0) {
        _bookId = _fictionDescription[@"bookId"];
    }
    
    JUDIAN_READ_ChapterContentModel* model = _currentContentModel;
    NSInteger chapterIndex = model.chapnum.integerValue;
    
    if (_turningPageDirection == DIRECTION_UP) {
        chapterIndex = model.prev_chapter.integerValue;
    }
    else if (_turningPageDirection == DIRECTION_DOWN) {
        chapterIndex = model.next_chapter.integerValue;
    }
    
    NSString* chapterIndexStr = [NSString stringWithFormat:@"%d", (int)(chapterIndex)];
    return chapterIndexStr;
}


#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 4;
    }
    
    if (section == 2) {
        return 3;
        //return 0;
    }
    
    if (section == 3) {
        return 3;
    }
    
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        static NSString *identify = FICTION_CHAPTER_TITLE_IDENTIFIER;
        JUDIAN_READ_FictionChapterTitleCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setTitleText:_chapterName];
        return cell;
    }
    
    
    if (section == 1) {
        
        if (row == 0) {
           UICollectionViewCell* cell = [self getCoverCell:0 indexPath:indexPath view:collectionView];
            if (cell) {
                return cell;
            }

           return [self getAdCell:0 indexPath:indexPath view:collectionView];
        }
        
        if (row == 1) {
            static NSString *identify = FICTION_CONTENT_IDENTIFIER;
            JUDIAN_READ_ChapterContentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            if (self.chapterRangeArray.count > 0) {
                NSValue* value = self.chapterRangeArray[0];
                NSRange range = [value rangeValue];
                NSAttributedString* attributedText = [self.attributedString attributedSubstringFromRange:range];
                [cell setContent:attributedText];
            }
            //WeakSelf(that);
            //cell.block = ^(id  _Nullable args) {
            //    that.topBarView.isShow = !that.topBarView.isShow;
            //    [that showNavigationBar];
            //};
            
            return cell;
        }
        
        if (row == 2) {
            UICollectionViewCell* cell = [self getCoverCell:1 indexPath:indexPath view:collectionView];
            if (cell) {
                return cell;
            }
            return [self getAdCell:1 indexPath:indexPath view:collectionView];
        }
        
        if (row == 3) {
            
            static NSString *identify = FICTION_CONTENT_IDENTIFIER;
            JUDIAN_READ_ChapterContentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            if (self.chapterRangeArray.count > 0) {
                NSValue* value = self.chapterRangeArray[1];
                NSRange range = [value rangeValue];
                NSAttributedString* attributedText = [self.attributedString attributedSubstringFromRange:range];
                [cell setContent:attributedText];
            }
            
            //WeakSelf(that);
            //cell.block = ^(id  _Nullable args) {
            //    that.topBarView.isShow = !that.topBarView.isShow;
            //    [that showNavigationBar];
            //};
            return cell;
        }
    }
    
    if (section == 2) {
        
        if (row == 0) {
            static NSString *identify = FICTION_APPRECIATE_BUTTON_IDENTIFIER;
            JUDIAN_READ_UserAppreciateFictionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setViewStyle];
            return cell;
        }

        if (row == 1) {
            static NSString *identify = FICTION_APPRECIATE_COUNT_IDENTIFIER;
            JUDIAN_READ_UserAppreciateCountCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            NSInteger count = _appreciatedChapterCount;
            if (count > 0) {
                [cell setAppreciateCount:[NSString stringWithFormat:@"%ld", count]];
                cell.hidden = NO;
            }
            else {
                [cell setAppreciateCount:@"0"];
                cell.hidden = YES;
            }

            return cell;
        }
        
        if (row == 2) {
            static NSString *identify = FICTION_APPRECIATE_AVATER_IDENTIFIER;
            JUDIAN_READ_UserAppreciateAvatarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setViewStyle];
            [cell reloadAvatar:_appreciatedAvatarArray];
            NSInteger count = _appreciatedAvatarArray.count;
            if (count <= 0) {
                cell.hidden = YES;
            }
            else {
                cell.hidden = NO;
            }
            
            return cell;
        }

    }
    
    
    if (section == 3) {
        if (row == 0) {
            return [self getAdCell:2 indexPath:indexPath view:collectionView];
        }
        
        if (row == 1) {
            static NSString *identify = FICTION_PAGE_TURNING_CELL_IDENTIFIER;
            JUDIAN_READ_PageTurningCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            [cell setViewStyle];
            
            WeakSelf(that);
            cell.block = ^(id  _Nonnull args) {
                NSNumber* cmd = args;
                if ([cmd intValue] == kPageTurningShareCmd) {
                    [that popupShareView];
                }
                else if ([cmd intValue] == kPageTurningForwardCmd) {
                    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
                    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
                    if (!sex) {
                        sex = @"未知";
                    }
                    
                    NSDictionary* dictionary = @{
                                                 @"device" : deviceName,
                                                 @"sex" : sex
                                                 };
                    
                    [MobClick event:@"click_last_chapter" attributes:dictionary];
                    [GTCountSDK trackCountEvent:@"click_last_chapter" withArgs:dictionary];
                    [that turnPage:NO];

                }
                else if ([cmd intValue] == kPageTurningNextCmd) {
                    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
                    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
                    if (!sex) {
                        sex = @"未知";
                    }
                    
                    NSDictionary* dictionary = @{
                                                 @"device" : deviceName,
                                                 @"sex" : sex
                                                 };
                    [MobClick event:@"click_next_chapter" attributes:dictionary];
                    [GTCountSDK trackCountEvent:@"click_next_chapter" withArgs:dictionary];
                    [that turnPage:YES];

                }
                else if ([cmd intValue] == kPageTurningCatalogCmd) {
                    
                    [MobClick event:@"click_setting_reader" attributes:@{@"catalogButton" : @"底部目录按钮"}];
                    [GTCountSDK trackCountEvent:@"click_setting_reader" withArgs:@{@"catalogButton" : @"底部目录按钮"}];
                    
                    NSDictionary* dictionary =  @{
                                                  @"cmd" : @(kCatalogCmd),
                                                  };
                  
                    NSNotification* notification = [[NSNotification alloc]initWithName:@"" object:dictionary userInfo:nil];
                    [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:notification viewController:that];
                }
                else if ([cmd intValue] == kPageTurningSuggestCmd) {
                    
                    NSDictionary* dictionary =  @{
                                                  @"cmd" : @(kUserSugguestCmd),
                                                  };
                    
                    NSNotification* notification = [[NSNotification alloc]initWithName:@"" object:dictionary userInfo:nil];
                    [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:notification viewController:that];
                    
                }
                
                
            };
            
            return cell;
        }
        
        if (row == 2) {
            UICollectionViewCell* cell = [self getCoverCell:2 indexPath:indexPath view:collectionView];
            if (cell) {
                return cell;
            }
            return [self getAdCell:3 indexPath:indexPath view:collectionView];
        }
    }

    return nil;
}


- (UICollectionViewCell*)getCoverCell:(NSInteger)index indexPath:(NSIndexPath*)indexPath view:(UICollectionView*) collectionView {
#if 0
    if([self isCoverImage:index]) {
        static NSString *identify = FICTION_FICTION_COVER_IMAGE_CELL_IDENTIFIER;
        JUDIAN_READ_FictionCoverImageCell* coverCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [coverCell updateImage:self.coverImageArray[index]];
        return coverCell;
    }
#endif
    return nil;
}


- (UICollectionViewCell*)getAdCell:(NSInteger)adIndex indexPath:(NSIndexPath*)indexPath view:(UICollectionView*) collectionView{

    JUDIAN_READ_AdSize250ViewCell* cell = nil;
    
#if _GDT_AD_STATE_ == 1
    if (adIndex == 2) {
     
        static NSString *identify = FICTION_MINI_FEED_AD_CELL_IDENTIFIER;
        JUDIAN_READ_MiniAdViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setViewStyle];
        
        [_adsManager buildBuAdsDataWithMiniView:cell index:0];

        return cell;
    }
    else if (adIndex == 3) {
        
        static NSString *identify = FICTION_AD_CELL_IDENTIFIER;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setViewStyle];
    
        [_adsManager buildBuAdsDataWithBigView:cell index:1];
    }
    else {
        static NSString *identify = FICTION_GDT_AD_CELL_IDENTIFIER;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setViewStyle];
        
        [_adsManager buildGdtAdsData:(JUDIAN_READ_GdtAdSize250ViewCell*)cell index:adIndex];
        
        if (adIndex == 1 && ![self isMiddleAd]) {
            cell.hidden = YES;
        }
    }
#else
    
    if (adIndex == 2) {
        
        static NSString *identify = FICTION_MINI_FEED_AD_CELL_IDENTIFIER;
        JUDIAN_READ_MiniAdViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setViewStyle];
        
        BOOL showAdView = [self canLoadAds];
        if (showAdView && (adIndex < _adsDataArray.count)) {
            BUNativeAd* nativeAd = _adsDataArray[adIndex];
            [self buildMiniAdView:nativeAd cell:cell];
            cell.hidden = NO;
        }
        else {
            cell.hidden = YES;
        }
        
        return cell;
    }
    else {
        
        static NSString *identify = FICTION_AD_CELL_IDENTIFIER;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell setViewStyle];
        
        BOOL showAdView = [self canLoadAds];
        if (showAdView && (adIndex < _adsDataArray.count)) {
            BUNativeAd* nativeAd = _adsDataArray[adIndex];
            [self buildAdView:nativeAd cell:cell];
            cell.hidden = NO;
        }
        else {
            cell.hidden = YES;
        }
    }

#endif
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        JUDIAN_READ_FictionChapterTitleCell* cell = _chapterTitleCell;
        [cell setTitleText:_chapterName];
        BOOL gdtAdvertise = [_adsManager canLoadGdtAds];
        BOOL coverImage =  [self isCoverImage:0];
        BOOL showCell = (gdtAdvertise || coverImage);
        NSInteger height = [cell getCellHeight:showCell];
        return CGSizeMake(CGRectGetWidth(self.view.frame), height);
    }
    
    
    if (indexPath.section == 1) {

        if (self.chapterRangeArray.count <= 0) {
            return CGSizeZero;
        }
        
        NSInteger row = indexPath.row;
        if (row == 0) {
            return [self getAdSize:YES indexPath:indexPath];
        }
        
        if (row == 1) {
            CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * CONTENT_VIEW_SIDE_EDGE, MAXFLOAT);
            NSValue* value = self.chapterRangeArray[0];
            NSRange range = [value rangeValue];
            NSAttributedString* attributedText = [self.attributedString attributedSubstringFromRange:range];
            CGFloat height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:attributedText width:size.width lineCount:nil endLine:-1];
            return CGSizeMake(CGRectGetWidth(self.view.frame), ceil(height));
        }
        
        if (row == 2) {
            
            if ([self isCoverImage:1] || [self isMiddleAd]) {
                return [self getAdSize:YES indexPath:indexPath];
            }
            else {
                return CGSizeZero;
            }
        }
        
        if (row == 3) {
            CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * CONTENT_VIEW_SIDE_EDGE, MAXFLOAT);
            NSValue* value = self.chapterRangeArray[1];
            NSRange range = [value rangeValue];
            if (range.length <= 0) {
                return CGSizeZero;
            }
            NSAttributedString* attributedText = [self.attributedString attributedSubstringFromRange:range];
            CGFloat height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:attributedText width:size.width lineCount:nil endLine:-1];
            return CGSizeMake(CGRectGetWidth(self.view.frame), ceil(height));
        }
        
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            return CGSizeMake(CGRectGetWidth(self.view.frame), 88 + 10);
        }
        
        if (indexPath.row == 1) {
            if (_appreciatedAvatarArray.count <= 0) {
                return CGSizeMake(0, 0);
            }
            
            return CGSizeMake(CGRectGetWidth(self.view.frame), 12 + 20);
        }
        
        if (indexPath.row == 2) {
            
            NSInteger count = _appreciatedAvatarArray.count;
            if (count <= 0) {
                return CGSizeMake(0, 0);
            }
            if (count > 24) {
                count = 24;
            }
            
            NSInteger row = count / 8;
            NSInteger surplus = count % 8;
            if (surplus > 0) {
                row += 1;
            }

            return CGSizeMake(CGRectGetWidth(self.view.frame), 26 * row + 3 * (row - 1) + 13);
        }
        
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            BOOL needAd = [_adsManager canLoadBuAds];
            if (needAd) {
                return CGSizeMake(CGRectGetWidth(self.view.frame), 70 + 22);
            }
            return CGSizeMake(CGRectGetWidth(self.view.frame), 0.01);
        }
        
        if (indexPath.row == 1) {
            return CGSizeMake(CGRectGetWidth(self.view.frame), 134 + 10);
        }
        
        if (indexPath.row == 2) {
            return [self getAdSize:NO indexPath:indexPath];
        }
        
    }
    
    return CGSizeZero;

}



- (CGSize)getAdSize:(BOOL)isGdtAds indexPath:(NSIndexPath*)indexPath {
    
    NSInteger index = 0;
    if (indexPath.section == 1 && indexPath.row == 0) {
        index = 0;
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        index = 1;
    }
    else if (indexPath.section == 3 && indexPath.row == 2) {
        index = 2;
    }
    
    NSInteger imageHeight = ceil((DESCRIPTION_WIDTH) * 0.5625);
    if ([self isCoverImage:index]) {
        NSInteger cellHeight = (34 + imageHeight + 34) + 42;
        return CGSizeMake(CGRectGetWidth(self.view.frame), cellHeight);
    }
    
    BOOL needAd = FALSE;
    if (isGdtAds) {
        needAd = [_adsManager canLoadGdtAds];
    }
    else {
        needAd = [_adsManager canLoadBuAds];
    }
    
    if (needAd) {
        NSInteger height = 0;
        NSInteger lineCount = 0;
        NSInteger cellHeight = (34 + imageHeight + 34) + 42;
        
        [_adsManager computeAdDscriptionHeight:index width:DESCRIPTION_WIDTH height:&height lineCount:&lineCount];
        if (lineCount > 1) {
            cellHeight = (20 + height + imageHeight + 34) + 42;
        }

        return CGSizeMake(CGRectGetWidth(self.view.frame), cellHeight);
    }
    else {
        return CGSizeMake(CGRectGetWidth(self.view.frame), 0.01);
    }
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1 || indexPath.row == 3) {
            self.topBarView.isShow = !self.topBarView.isShow;
            [self showNavigationBar];
        }
    }
}


- (BOOL)isMiddleAd {
    if (_lineCount > MIN_LINE_COUNT) {
        return TRUE;
    }
    return FALSE;
}


- (BOOL)isCoverImage:(NSInteger)index {
#if 0
    NSString* chapterId = [JUDIAN_READ_NovelManager shareInstance].userReadingModel.current_chapter;
    if((index < self.coverImageArray.count) && [chapterId isEqualToString:@"1"]){
        return TRUE;
    }
#endif
    return FALSE;
}



#pragma mark 翻页，分享事件处理
- (void)turnPage:(BOOL)isNext {

    NSInteger chapterIndex = 0;
    
    if (isNext) {
        chapterIndex = [_currentContentModel.next_chapter integerValue];

        if (chapterIndex < 0) {
            
            [self.pageCollectionView.mj_header endRefreshing];
            [self.pageCollectionView.mj_footer endRefreshing];
            
            [self prepareShowChapterEndView];
            return;
        }
        
        self.pageCollectionView.mj_header.hidden = YES;
        NSString* chapterIndexStr = [NSString stringWithFormat:@"%d", (int)(chapterIndex)];
        [self getFictionChapterContent:chapterIndexStr bookId:_bookId direction:DIRECTION_DOWN];
        
    }
    else {
        chapterIndex = [_currentContentModel.prev_chapter integerValue];
        if (chapterIndex < 0) {
            
            [self.pageCollectionView.mj_header endRefreshing];
            [self.pageCollectionView.mj_footer endRefreshing];
            
            [MBProgressHUD showSuccess:@"已经是第一章"];
            return;
        }

        self.pageCollectionView.mj_footer.hidden = YES;
        NSString* chapterIndexStr = [NSString stringWithFormat:@"%d", (int)(chapterIndex)];
        [self getFictionChapterContent:chapterIndexStr bookId:_bookId direction:DIRECTION_UP];
    
    }
    
}



- (void)popupShareView {

    JUDIAN_READ_SettingMenuPanel* settingView = [[JUDIAN_READ_SettingMenuPanel alloc]initShareView:self.bookId];
    _settingView = settingView;
    settingView.fromView = @"章节底部分享";
    settingView.frame = self.view.bounds;
    settingView.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
    [settingView addToKeyWindow:self.view];
    [settingView showView];
    [settingView setViewStyle];
    
}



- (void)sumUserReadChapter:(NSString*)chapterId {
    
    NSNumber* number = self.userReadChapterDictionary[chapterId];
    if (!number) {
        self.userReadChapterDictionary[chapterId] = @(1);
    }
    else {
        self.userReadChapterDictionary[chapterId] = @(number.intValue + 1);
    }
    
    BOOL needAd = [_adsManager canLoadBuAds];
    if (needAd && self.userReadChapterDictionary.count == READ_CHAPTER_UPPER_LIMIT) {
        [_adsManager initRewardViedoAd];
    }
    
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
    
#if 0
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(kDayLightCmd)}];
    
    if ([self.bookState isEqualToString:@"0"]) {
        [_topBarView hideButton:NO];
    }
    else {
        [_topBarView hideButton:YES];
    }
    
    self.topBarView.isShow = TRUE;
    [self showNavigationBar];
#endif
    
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
#if 0
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(kDayLightCmd)}];
    
    [_topBarView hideButton:NO];
    
    self.topBarView.isShow = TRUE;
    [self showNavigationBar];
#endif
    
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



- (void)refreshPageContent:(JUDIAN_READ_ChapterContentModel* )contentModel{
    
    if (contentModel == nil) {
        return;
    }
    
    contentModel.title = [contentModel.title removeAllWhitespace];
    self.currentContentModel = contentModel;
    
    if (!_isStatisticsDuration) {
        _isStatisticsDuration = TRUE;
    }
    

    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isHaveNet){
        
        JUDIAN_READ_NovelBrowseHistoryModel* historyModel = [[JUDIAN_READ_NovelBrowseHistoryModel alloc] init];
        historyModel.bookId = _bookId;
        historyModel.bookName = _bookName;
        historyModel.chapterName = _currentContentModel.title;
        historyModel.chapterId = _currentContentModel.chapnum;
        historyModel.pageIndex = @"0";
        
        [JUDIAN_READ_UserReadingModel saveBrowseHistoryWithModel:historyModel];
    }
    else {
        [JUDIAN_READ_UserReadingModel addOfflineHistory:_bookId chapterId:contentModel.chapnum];
    }
    
    
    [[JUDIAN_READ_NovelManager shareInstance]addUserReadChapter:self.bookId chapterId:contentModel.chapnum];
    
    [self sumUserReadChapter:contentModel.chapnum];
    
    self.contentString = contentModel.content;
    self.attributedString = [[JUDIAN_READ_CoreTextManager shareInstance] createAttributedString:self.contentString];
    
    NSInteger lineCount = 0;
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * CONTENT_VIEW_SIDE_EDGE, MAXFLOAT);
    CGFloat height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:self.attributedString width:size.width lineCount:&lineCount endLine:-1];
    
    _lineCount = lineCount;
    
    CGRect frame = CGRectMake(0, 0, size.width, ceil(height / 2));
    
    self.chapterRangeArray = [[JUDIAN_READ_CoreTextManager shareInstance] splitContent:self.attributedString frame:frame];
    self.chapterName = contentModel.title;
    
    [self.pageCollectionView reloadData];
}



- (void)getFictionChapterContent:(NSString*)chapterId bookId:(NSString*)bookId direction:(NSInteger)direction {
    
    _turningPageDirection = direction;
    
    [self showLoadingView:YES];
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getFictionChapterContent:chapterId bookId:bookId block:^(id parameter) {
        
        if (!parameter) {
            [that showLoadingView:NO];
            return;
        }
        
        [that hideTipView];
        
        JUDIAN_READ_ChapterContentModel* contentModel = parameter;
        
        if (contentModel.content.length <= 0) {//书籍下架
            [that showLoadingView:NO];
            [that prepareShowNoChapterView];
            return;
        }
        
        [that refreshPageContent:contentModel];
        
        [that getAppreciateAvatarList];
    
        [that.adsManager loadAdData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (direction == DIRECTION_DOWN) {
                [that.pageCollectionView scrollToTopAnimated:FALSE];
                that.pageCollectionView.mj_header.hidden = FALSE;
            }
            else if(direction == DIRECTION_UP) {
                if(that.pageCollectionView.contentSize.height > that.pageCollectionView.frame.size.height) {
                    [that.pageCollectionView scrollToBottomAnimated:FALSE];
                    that.pageCollectionView.mj_footer.hidden = FALSE;
                }
            }
            else {
                BOOL isLastPosition = (that.lastBrowsePosition != (id)[NSNull null]);
                if (isLastPosition && that.lastBrowsePosition.length > 0) {
                    [that.pageCollectionView setContentOffset:CGPointMake(0, [that.lastBrowsePosition intValue])];
                    that.lastBrowsePosition = @"";
                }
            }
            
            [that.pageCollectionView.mj_header endRefreshing];
            [that.pageCollectionView.mj_footer endRefreshing];
            
            [that showLoadingView:NO];
        
            [that addGuideView];
        });
        
    }];
    
    
}




- (void)showLoadingView:(BOOL)isShow {
    
    if (isShow) {
        _emptyView.hidden = NO;
        [_emptyView playAnimation:YES];
    }
    else {
        self.emptyView.hidden = YES;
        [_emptyView playAnimation:FALSE];
    }

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


- (void)getAppreciateAvatarList {
    
    NSString* chapterId = _currentContentModel.chapnum;
    
    if (!_bookId || !chapterId) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"id":_bookId,
                                 @"chapnum": chapterId,
                                 @"page":@"1",
                                 //@"pageSize":@"1000000"
                                 };
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance]getUserAppreciateAvatarList:dictionary block:^(NSArray* array, NSNumber* total) {
        that.appreciatedChapterCount = total.integerValue;
        that.appreciatedAvatarArray = array;
        [that.pageCollectionView reloadData];
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



#pragma mark 设置菜单处理
- (void)updatePageViewController {

    [self setViewBackgroundColor];
    
    UIColor* bgColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    _emptyView.backgroundColor = bgColor;
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    [_emptyView updateImageArray:[style isNightMode]];
    
    [_topBarView setViewStyle];
    
    self.attributedString = [[JUDIAN_READ_CoreTextManager shareInstance] createAttributedString:self.contentString];
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 2 * CONTENT_VIEW_SIDE_EDGE, MAXFLOAT);
    CGFloat height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:self.attributedString width:size.width lineCount:nil endLine:-1];
    CGRect frame = CGRectMake(0, 0, size.width, ceil(height / 2));
    
    self.chapterRangeArray = [[JUDIAN_READ_CoreTextManager shareInstance] splitContent:self.attributedString frame:frame];
    [self.pageCollectionView reloadData];
    
}


- (void)showNavigationBar {
    
    WeakSelf(that);

    [UIView animateWithDuration:0.3 animations:^{
        if (that.topBarView.isShow) {
            that.topBarView.transform = CGAffineTransformMakeTranslation(0, [that getNavigationHeight]);
        }
        else {
            that.topBarView.transform = CGAffineTransformMakeTranslation(0, -[that getNavigationHeight]);
        }
        
        if (!that.isBookInCollection) {
            NSInteger width = 81;
            if (that.topBarView.isShow) {
                that.favoritesButton.transform = CGAffineTransformMakeTranslation(-width, 0);
            }
            else {
                that.favoritesButton.transform = CGAffineTransformMakeTranslation(width, 0);
            }
        }
        
        [that hideStatusView:!that.topBarView.isShow];
    }];
}


- (void)addSettingView {

    JUDIAN_READ_SettingMenuPanel* settingView = [[JUDIAN_READ_SettingMenuPanel alloc]initWithId:self.bookId];
    _settingView = settingView;
    settingView.fromView = @"阅读器更多设置";
    settingView.frame = self.view.bounds;
    settingView.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.3);
    [settingView addToKeyWindow:self.view];
    [settingView showView];
    [settingView setViewStyle];
    
}





- (void)addMaskView {
    _maskContainer = [[UIView alloc]init];
    _maskContainer.frame = self.view.bounds;
    _maskContainer.layer.zPosition = EYE_VIEW_Z_POSITION;
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
    _protectionEyeContainer.layer.zPosition = NSIntegerMax - 100;
    
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


#pragma mark 赞赏 viewcontroller

- (void)prepareEnterAppreciateMoneyViewController {
    NSString* chapterId = _currentContentModel.chapnum;
    [self enterAppreciateMoneyViewController:chapterId];
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



#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


#pragma mark notification

- (void)handleButtonTouch:(NSNotification*)obj {
    
    WeakSelf(that);
    NSNumber* cmd = obj.object[@"cmd"];
    
    if (([cmd intValue] == kBackCmd) && _endView && !_endView.hidden) {
        if ([_endView.fictionState isEqualToString:_NO_CHAPTER_CODE_]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [_endView removeFromSuperview];
        }
        
        return;
    }
    

    if (([cmd intValue] == kBackCmd) && !_isBookInCollection) {
        [JUDIAN_READ_VipCustomPromptView createCollectionPromptView:self.view block:^(id  _Nonnull args) {
            [that collectBook];
            [that.navigationController popViewControllerAnimated:YES];
        } cancel:^(id  _Nonnull args) {
            NSDictionary* dictionary = @{
                                         @"source" : @"阅读器"
                                         };
            [MobClick event:@"cancle_collection_reader" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"cancle_collection_reader" withArgs:dictionary];
            [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:obj viewController:that];
        }];
        
        return;
    }
    
    if ([cmd intValue] == kCatalogCmd) {
        [MobClick event:@"click_setting_reader" attributes:@{@"topCatalogButton" : @"顶部目录按钮"}];
        [GTCountSDK trackCountEvent:@"click_setting_reader" withArgs:@{@"topCatalogButton" : @"顶部目录按钮"}];
    }
    
    [JUDIAN_READ_Reader_FictionCommandHandler handleCommand:obj viewController:self];

}

#pragma mark 书籍收藏

- (void)checkBookCollectionState {
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] isBookInCollection:_bookId block:^(id  _Nullable parameter) {
        if ([parameter isEqual:[NSNull null]]) {
            that.isBookInCollection = FALSE;
        }
        else {
            NSString* count = parameter;
            that.isBookInCollection = ([count intValue] > 0) ? TRUE : FALSE;
        }

    }];
}



- (void)handleFavoritesTouch {
    
    self.topBarView.isShow = FALSE;
    [self showNavigationBar];

    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {
            
            that.isBookInCollection = YES;
            [MBProgressHUD showSuccess:@"收藏成功"];

            NSDictionary* dictionary = @{
                                         @"收藏按钮位置" : @"阅读器菜单"
                                         };
            [MobClick event:@"add_collection" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"add_collection" withArgs:dictionary];
            
        }
    }];
}


- (void)collectBook {
    
    NSString* viewName = _previewViewName;
    if (viewName.length <= 0) {
        viewName = @"阅读器退出";
    }
    
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {
            NSDictionary* dictionary = @{
                                         @"source" : viewName
                                         };
            [MobClick event:@"collection_source_byreader" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"collection_source_byreader" withArgs:dictionary];
        }
    }];
}



#pragma mark 滚动条代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.topBarView.isShow) {
        self.topBarView.isShow = FALSE;
        [self showNavigationBar];
    }
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    NSString* deviceName = [JUDIAN_READ_DeviceUtils getDeviceName];
    NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
    if (!sex) {
        sex = @"未知";
    }
    

    NSInteger endPosition = scrollView.contentSize.height - scrollView.frame.size.height;

    if ((scrollView.contentOffset.y < 0) && abs((int)(scrollView.contentOffset.y)) > PULL_DOWN_OFFSET_LIMIT) {
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"sex" : sex,
                                     @"type" : @"滑动上一章翻页",
                                     };
        [MobClick event:@"click_sliding_page_turning" attributes:dictionary];
        [GTCountSDK trackCountEvent:@"click_sliding_page_turning" withArgs:dictionary];
        [self turnPage:NO];
        
    }
    else if((scrollView.contentOffset.y - endPosition) > PULL_UP_OFFSET_LIMIT) {
        NSDictionary* dictionary = @{
                                     @"device" : deviceName,
                                     @"sex" : sex,
                                     @"type" : @"滑动下一章翻页",
                                     };
        [MobClick event:@"click_sliding_page_turning" attributes:dictionary];
        [GTCountSDK trackCountEvent:@"click_sliding_page_turning" withArgs:dictionary];
        [self turnPage:YES];
        
    }
}


#pragma mark dealloc
- (void)dealloc {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

@end
