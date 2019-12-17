//
//  JUDIAN_READ_ArticlePositiveView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ArticlePositiveViewController.h"
#import "JUDIAN_READ_ContentView.h"
#import "JUDIAN_READ_BuImageAdView.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_NovelManager.h"

@interface JUDIAN_READ_ArticlePositiveViewController ()
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, strong)JUDIAN_READ_BuImageAdView* adView;
@property(nonatomic, copy)NSMutableArray* appreciatedAvatarArray;
@property(nonatomic, weak)JUDIAN_READ_PlainAppreciateView* appreciateView;
@property(nonatomic, weak)JUDIAN_READ_FictionEmbeddedAdManager* adManager;
@property(nonatomic, copy)NSString* bookId;
@end


@implementation JUDIAN_READ_ArticlePositiveViewController


- (instancetype)initWith:(NSInteger)pageIndex adManager:(JUDIAN_READ_FictionEmbeddedAdManager*)adManager model:(JUDIAN_READ_ChapterContentModel*)model bookId:(NSString*)bookId {

    self = [super init];
    if(self != nil) {
        _adManager = adManager;
        _pageIndex = pageIndex;
        _model = model;
        _bookId = bookId;
        _appreciatedAvatarArray = [NSMutableArray array];
        [self addChapterTitleView];
        [self addContentView];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.view.backgroundColor = [style getBgColor];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 70 - BOTTOM_OFFSET);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_appreciateView) {
        [self getAppreciateAvatarList];
    }
    
}

- (NSInteger)getPageIndex {
    return _pageIndex;
}

- (void)setPageIndex:(NSInteger)index {
    _pageIndex = index;
}

- (void)dealloc {
    //NSLog(@"dealloc===%@===", NSStringFromClass([self class]));
    
}

- (void)addAdView:(UIView*)parentView {

    JUDIAN_READ_ChapterContentModel* model = _model;
    NSValue* value = model.adViewFrameArray[_pageIndex];
    CGRect rect = [value CGRectValue];
    
    [_adManager addMiddleAdView:self container:parentView frame:rect];

#if 0
    if (rect.size.width > 0) {
        _adView = [[JUDIAN_READ_BuImageAdView alloc]init];
        _adView.frame = CGRectMake(0, CONTENT_VIEW_FRAME.size.height - rect.origin.y - rect.size.height, CONTENT_VIEW_FRAME.size.width, rect.size.height );
        [parentView addSubview:_adView];
    }
#endif
}


- (void)addChapterTitleView {
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = RGB(0xac, 0x86, 0x62);
    
    //JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    //style.textSize;
    NSInteger fontSize = 12;
    
    titleLabel.font = [UIFont fontWithName:FONT_ALIBABA_PUHUITI_REGULAR size:fontSize];
    [self.view addSubview:titleLabel];
    
    titleLabel.text = _model.title;
    titleLabel.numberOfLines = 0;
    
    WeakSelf(that);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left).offset(19);
        make.top.equalTo(that.view.mas_top).offset(TOP_OFFSET);
        make.height.equalTo(@(37));//57
        make.right.equalTo(that.view.mas_right).offset(-14);
    }];
    
    titleLabel.hidden = NO;
    if (_pageIndex < _model.pageArray.count) {
        NSValue* value = _model.pageArray[_pageIndex];
        NSRange range = [value rangeValue];
        if (range.length <= 0) {
            titleLabel.hidden = YES;
        }
    }
}


- (void)addContentView {
    
    JUDIAN_READ_ContentView* contentView = [[JUDIAN_READ_ContentView alloc]initWith:_pageIndex model:_model];
    _contentView = contentView;
    
    CGRect contentViewFrame = [[JUDIAN_READ_CoreTextManager shareInstance] getContentViewFrame];
    contentView.frame = contentViewFrame;
    contentView.backgroundColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    
    [self.view addSubview:contentView];
    [self addSystemTimeView:contentView];
    
    
    CGRect rect = [[JUDIAN_READ_CoreTextManager shareInstance] getAdViewRect:_pageIndex model:_model];
    if(rect.size.width > 0) {
        [self addAdView:contentView];
        //[self loadAdsData];
    }
    else if (rect.size.width == -1) {
        NSInteger yPos = (rect.origin.y);
        [self addAppricateViewAtBottom:contentView topOffset:yPos];
        [self getAppreciateAvatarList];
    }
    else if (rect.size.width == -2) {
        [self addAppricateViewAtTop:contentView];
        [self getAppreciateAvatarList];
    }
    
}


- (void)addAppricateViewAtTop:(UIView*)container {
    
    JUDIAN_READ_PlainAppreciateView* appreciateView = [[JUDIAN_READ_PlainAppreciateView alloc] init];
    _appreciateView = appreciateView;
    [container addSubview:appreciateView];
    
    [appreciateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(PAGE_APPRECIATE_VIEW_HEIGH));
        make.top.equalTo(container.mas_top).offset(-20);
    }];
}



- (void)addAppricateViewAtBottom:(UIView*)container topOffset:(NSInteger)topOffset {
    
    JUDIAN_READ_PlainAppreciateView* appreciateView = [[JUDIAN_READ_PlainAppreciateView alloc] init];
    _appreciateView = appreciateView;
    [container addSubview:appreciateView];
    
    [appreciateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.right.equalTo(container.mas_right);
        make.height.equalTo(@(PAGE_APPRECIATE_VIEW_HEIGH));
        make.top.equalTo(container.mas_top).offset(topOffset);
    }];
}


- (void)addSystemTimeView:(UIView*)container {
    
    CGFloat readRate = (_model.chapnum.floatValue / (CGFloat)_model.totalChap.integerValue);
    NSString* pageInfoStr = [NSString stringWithFormat:@"%ld/%ld", (_pageIndex), _model.pageArray.count - 1];
    //NSString* rateStr = [NSString stringWithFormat:@"%.2f%%", (readRate * 100)];
    //JUDIAN_READ_SystemTimeView* timeView = [[JUDIAN_READ_SystemTimeView alloc] initWithPageInfo:rateStr];
    JUDIAN_READ_SystemTimeView* timeView = [[JUDIAN_READ_SystemTimeView alloc] initWithPageInfo:pageInfoStr];
    [self.view addSubview:timeView];
    
    WeakSelf(that);
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.view.mas_left);
        make.right.equalTo(that.view.mas_right);
        make.height.equalTo(@(11));
        make.bottom.equalTo(that.view.mas_bottom).offset(-3);
    }];
}






#pragma mark 获取赞赏人数

- (void)getAppreciateAvatarList {
    
    NSString* chapterId = _model.chapnum;
    NSString* bookId = _bookId;
    if (!bookId || !chapterId) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"id":bookId,
                                 @"chapnum": chapterId,
                                 @"page":@"1",
                                 //@"pageSize":@"1000000"
        
                                 };
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance]getUserAppreciateAvatarList:dictionary block:^(NSArray* array, NSNumber* total) {
        
        //[that.appreciatedAvatarArray addObjectsFromArray:array];
        NSString* totalStr = [NSString stringWithFormat:@"%ld", (long)total.integerValue];
        [that.appreciateView updateAvatarList:array total:totalStr];
    } needTotalPage:FALSE];
    
}


@end
