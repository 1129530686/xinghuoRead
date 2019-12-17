//
//  JUDIAN_READ_NovelChapterCatalogViewController.m
//  xinghuoRead
//
//  Created by judian on 2019/5/7.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelChapterCatalogView.h"
#import "JUDIAN_READ_ChapterTitleCell.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_BuCellAdView.h"
#import "JUDIAN_READ_NovelCatalogInformationView.h"
#import "JUDIAN_READ_VerticalSlider.h"
#import "JUDIAN_READ_HorizontalStyleButton.h"
#import "JUDIAN_READ_Reader_FictionCommandHandler.h"

#define TABLEVIEW_HEIGHT 326
#define FEED_AD_VIEW_HEIGHT 70
#define CATALOG_TIP_HEIGHT 48
#define TABLEVIEW_CELL_HEIGHT 48



@interface JUDIAN_READ_NovelChapterCatalogView ()<
UITableViewDelegate,
UITableViewDataSource,
BUNativeAdsManagerDelegate,
BUVideoAdViewDelegate,
BUNativeAdDelegate>


@property(nonatomic, assign)NSInteger clickIndex;
@property(nonatomic, weak)UITableView* tableView;
@property(nonatomic, copy)NSArray* dataSource;
@property(nonatomic, weak)UIView* container;
@property(nonatomic, weak)JUDIAN_READ_BuCellAdView* adView;
@property(nonatomic, weak)JUDIAN_READ_NovelSummaryModel* model;
@property(nonatomic, weak)UIViewController* viewController;
@property(nonatomic, strong)BUNativeAdsManager* adManager;
@property(nonatomic, weak)JUDIAN_READ_VerticalSlider* slider;
@property(nonatomic, weak)JUDIAN_READ_HorizontalStyleButton* sortButton;
@end

@implementation JUDIAN_READ_NovelChapterCatalogView


- (instancetype)initWithModel:(JUDIAN_READ_NovelSummaryModel*)model controller:(UIViewController*)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.model = model;
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    self.backgroundColor = RGBA(0x00, 0x00, 0x00, 0.4);
    
    [self addContainer];
    [self addTableView];
    [self addAdView];
    [self addTitleView];
    

    NSString* imageName = @"reader_catalog_slider_thumb";
    JUDIAN_READ_VerticalSlider* slider = [[JUDIAN_READ_VerticalSlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _slider = slider;
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_container addSubview:slider];
    
    _slider.minimumTrackTintColor = [UIColor clearColor];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    
    [_slider addTarget:self action:@selector(contentOffsetValueChanged:) forControlEvents:UIControlEventValueChanged];//

    _slider.hidden = YES;
    
    NSString* chapterId = @"1";
    NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:self.model.nid];
    if (dictionary) {
        chapterId = dictionary[@"chapterId"];
    }

    
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getNovelChapterList:self.model.nid block:^(id  _Nonnull parameter) {
        that.dataSource = [parameter copy];
        
        NSInteger index = 0;
        for (index = 0; index < that.dataSource.count; index++) {
            JUDIAN_READ_ChapterTitleModel* model = that.dataSource[index];
            if ([model.chapnum isEqualToString:chapterId]) {
                break;
            }
        }

        that.clickIndex = index;
        [that.tableView reloadData];
        
        [that setNeedsLayout];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (that.dataSource.count <= 0) {
                return;
            }
            
            if (that.dataSource.count <= index) {
                return;
            }
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [that.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:(YES)];
        });

    } failure:^(id  _Nonnull parameter) {
        
    } isCache:YES];
    
    
    [self loadAdsData];

}



- (void)addContainer {
    UIView* container = [[UIView alloc]init];
    container.backgroundColor = [UIColor whiteColor];
    [self addSubview:container];
    _container = container;

    NSInteger height = [self getContainerHeight];
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(height));
        make.bottom.equalTo(that.mas_bottom).offset(height);
    }];
    
}



- (NSInteger)getFeedCellHeight {
    
    BOOL needAd = [JUDIAN_READ_TestHelper needAdView:CHUAN_SHAN_JIA_SWITCH];
    if (needAd) {
        return FEED_AD_VIEW_HEIGHT;
    }
    return 0;
}





- (void)addTableView {
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = 0;
    
    [_container addSubview:tableView];
    
    
    NSInteger bottomOffset = [self getBottomOffset];

    WeakSelf(that);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(TABLEVIEW_HEIGHT));
        make.bottom.equalTo(that.container.mas_bottom).offset(-bottomOffset);
    }];

}



- (NSInteger)getBottomOffset {
    
    NSInteger bottomOffset = 0;
    if (iPhoneX) {
        bottomOffset = 34;
    }
    
    return bottomOffset;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutSlider];
}


- (void)layoutSlider {
   
    WeakSelf(that);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        that.slider.hidden = NO;
        that.slider.frame = CGRectMake(that.frame.size.width - SLIDER_WIDTH, that.tableView.frame.origin.y, SLIDER_WIDTH, TABLEVIEW_HEIGHT);
        [that.slider updateViewFrame];
        
        that.slider.minimumValue = 0;
        that.slider.maximumValue = that.dataSource.count * TABLEVIEW_CELL_HEIGHT - TABLEVIEW_HEIGHT;
        that.slider.value = that.slider.maximumValue;
        that.slider.continuous = YES;
    });
    
    

    
}





- (void)addAdView {
    
    JUDIAN_READ_BuCellAdView* adView = [[JUDIAN_READ_BuCellAdView alloc] init];
    _adView = adView;
    [adView setDefaultStyle];
    
    [_container addSubview:adView];
    
    NSInteger adHeight = [self getFeedCellHeight];
    if (adHeight > 0) {
        _adView.hidden = NO;
    }
    else {
        _adView.hidden = YES;
    }
    
    
    WeakSelf(that);
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(adHeight));
        make.bottom.equalTo(that.tableView.mas_top);
    }];
}


- (void)addTitleView {
    JUDIAN_READ_NovelCatalogInformationView* titleView = [[JUDIAN_READ_NovelCatalogInformationView alloc]init];
    [_container addSubview:titleView];
    
    [titleView setTextWithModel:_model];
    
    WeakSelf(that);
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.container.mas_left);
        make.right.equalTo(that.container.mas_right);
        make.height.equalTo(@(CATALOG_TIP_HEIGHT));
        make.bottom.equalTo(that.adView.mas_top);
    }];
    
    
    titleView.block = ^(id  _Nullable args) {
        [that sortChapterList:args];
    };
}



- (NSInteger)getContainerHeight {
    NSInteger bottomOffset = [self getBottomOffset];
    NSInteger feedAdHeight = [self getFeedCellHeight];
    return TABLEVIEW_HEIGHT + feedAdHeight + CATALOG_TIP_HEIGHT + bottomOffset;
}



- (void)showView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, -[that getContainerHeight]);
    }completion:^(BOOL finished) {
        
    }];
}




- (void)hideView {
    
    WeakSelf(that);
    [UIView animateWithDuration:0.3 animations:^{
        that.container.transform = CGAffineTransformMakeTranslation(0, [that getContainerHeight]);
    }completion:^(BOOL finished) {
        [that removeFromSuperview];
    }];
}



- (void)sortChapterList:(NSString*) sortType {

    NSString* chapterId = @"1";
    NSDictionary* dictionary = [JUDIAN_READ_UserReadingModel getChapterId:self.model.nid];
    if (dictionary) {
        chapterId = dictionary[@"chapterId"];
    }
    
    NSInteger type = [sortType intValue];
    _dataSource = [_dataSource sortedArrayUsingFunction:compareChapter context:&type];
        
    NSInteger index = 0;
    for (index = 0; index < _dataSource.count; index++) {
        JUDIAN_READ_ChapterTitleModel* model = _dataSource[index];
        if ([model.chapnum isEqualToString:chapterId]) {
            break;
        }
    }
    
    self.clickIndex = index;
    [self.tableView reloadData];
    
    WeakSelf(that);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (that.dataSource.count <= 0) {
            return;
        }

        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [that.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:(YES)];
    });
}




NSInteger compareChapter(JUDIAN_READ_ChapterTitleModel* num1, JUDIAN_READ_ChapterTitleModel* num2, void *context) {
    
    int v1 = [num1.chapnum intValue];
    int v2 = [num2.chapnum intValue];
    
    NSInteger* type = (NSInteger*)context;
    
    if (*type == 1) {
        
        if (v1 > v2) {
            return NSOrderedAscending;
        } else if (v1 < v2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }
    else {
        if (v1 < v2) {
            return NSOrderedAscending;
        } else if (v1 > v2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }
    
    
}






- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLEVIEW_CELL_HEIGHT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"chapterTitleCell";
    JUDIAN_READ_ChapterTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JUDIAN_READ_ChapterTitleCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == _clickIndex) {
        cell.isClicked = TRUE;
    }
    else {
        cell.isClicked = FALSE;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataSource.count > 0) {
        [cell setTitleWithModel:_dataSource[indexPath.row]];
    }
    
    [cell setDefaultStyle];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSource.count <= 0) {
        return;
    }
    
    _clickIndex = indexPath.row;
    JUDIAN_READ_ChapterTitleModel* model = _dataSource[indexPath.row];
    if (_block) {
        _block(model);
    }

    //[tableView reloadData];
    [self hideView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _slider.value = _slider.maximumValue - scrollView.contentOffset.y;
}



- (void)contentOffsetValueChanged:(UISlider*)sender {
    
    CGFloat y = (_slider.maximumValue - sender.value);
    [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, y)];
    
}

#pragma mark 穿山甲广告

- (void)loadAdsData {
    
    BUNativeAdsManager *adManager = [[BUNativeAdsManager alloc]init];
    self.adManager = adManager;
    
    BUAdSlot *slot = [[BUAdSlot alloc] init];
    slot.ID = CHUAN_SHAN_JIA_FEED_ID;
    slot.AdType = BUAdSlotAdTypeFeed;
    slot.position = BUAdSlotPositionTop;
    slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed228_150];
    slot.isSupportDeepLink = YES;
    adManager.adslot = slot;
    adManager.delegate = self;
    [adManager loadAdDataWithCount:1];
     [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_request" source:@"介绍页目录列表banner广告"];
}


- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_request" source:@"介绍页目录列表banner广告"];
    WeakSelf(that);
    [nativeAdDataArray enumerateObjectsUsingBlock:^(BUNativeAd * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BUNativeAd *model = obj;
        [that setAdModel:model];
    }];
}



- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}




- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_success_show" source:@"介绍页目录列表banner广告"];
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    [JUDIAN_READ_Reader_FictionCommandHandler addSingleAdEvent:@"ad_click" source:@"介绍页目录列表banner广告"];
}










- (void)setAdModel:(BUNativeAd *)model {
    
    [self.adView buildView:model];
    
    [model unregisterView];
    model.rootViewController = self.viewController;
    model.delegate = self;
    [model registerContainer:self.adView withClickableViews:@[self.adView]];
    
}






@end
