//
//  JUDIAN_READ_FeaturedChapterTitleCell.m
//  xinghuoRead
//
//  Created by judian on 2019/8/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FeaturedChapterTitleCell.h"
#import "JUDIAN_READ_ChapterContentCell.h"
#import "JUDIAN_READ_FeaturedFictionHeaderView.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_NovelManager.h"


@implementation JUDIAN_READ_FeaturedChapterTitleCell

- (NSInteger)getFontSize {
    
    if (iPhone5 || iPhone6) {
        return 15;
    }
    
    if (iPhone6Plus) {
        return 19;
    }
    
    return 17;
}

- (UIColor*)getTextColor {
    return RGB(0x33, 0x33, 0x33);
}

- (UIColor*)getBgColor {
    return [UIColor whiteColor];
}


@end




@implementation JUDIAN_READ_FeaturedNextChapterTipCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = RGB(0x99, 0x99, 0x99);
    tipLabel.text = @"继续阅读下一章 >";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipLabel];

    WeakSelf(that);
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(20);
        make.right.equalTo(that.contentView.mas_right).offset(-20);
        make.height.equalTo(@(12));
        make.centerY.equalTo(that.contentView.mas_centerY);
    }];
}



@end


#define CHAPTER_CONTENT_IDENTIFIER @"ChapterContentCell"
#define FeaturedFictionHeaderView @"FeaturedFictionHeaderView"
#define FeaturedChapterDescriptionCell @"FeaturedChapterDescriptionCell"
#define FeaturedChapterTitleCell @"FeaturedChapterTitleCell"
#define FeaturedNextChapterTipCell @"FeaturedNextChapterTipCell"
#define FeaturedPageCell @"FeaturedPageCell"

#define LEFT_RIGH_EDGE 20



#define TEXT_INFO  @"网络层在一个App中也是一个不可缺少的部分，工程师们在网络层能够发挥的空间也比较大。另外，苹果对网络请求部分已经做了很好的封装，业界的AFNetworking也被广泛使用。其它的ASIHttpRequest，MKNetworkKit啥的其实也都还不错，但前者已经弃坑，后者也在弃坑的边缘。在实际的App开发中，Afnetworking已经成为了事实上各大App的标准配置。网络层在一个App中也是一个不可缺少的部分，工程师们在网络层能够发挥的空间也比较大。另外，苹果对网络请求部分已经做了很好的封装，业界的AFNetworking也被广泛使用。其它的ASIHttpRequest，MKNetworkKit啥的其实也都还不错，但前者已经弃坑，后者也在弃坑的边缘。在实际的App开发中，Afnetworking已经成为了事实上各大App的标准配置。网络层在一个App中也是一个不可缺少的部分，工程师们在网络层能够发挥的空间也比较大。另外，苹果对网络请求部分已经做了很好的封装，业界的AFNetworking也被广泛使用。其它的ASIHttpRequest，MKNetworkKit啥的其实也都还不错，但前者已经弃坑，后者也在弃坑的边缘。在实际的App开发中，Afnetworking已经成为了事实上各大App的标准配置。网络层在一个App中也是一个不可缺少的部分，工程师们在网络层能够发挥的空间也比较大。另外，苹果对网络请求部分已经做了很好的封装，业界的AFNetworking也被广泛使用。其它的ASIHttpRequest，MKNetworkKit啥的其实也都还不错，但前者已经弃坑，后者也在弃坑的边缘。在实际的App开发中，Afnetworking已经成为了事实上各大App的标准配置。网络层在一个App中也是一个不可缺少的部分，工程师们在网络层能够发挥的空间也比较大。另外，苹果对网络请求部分已经做了很好的封装，业界的AFNetworking也被广泛使用。其它的ASIHttpRequest，MKNetworkKit啥的其实也都还不错，但前者已经弃坑，后者也在弃坑的边缘。结束了!???"

@interface JUDIAN_READ_FeaturedPageCell ()<UICollectionViewDelegate,
UICollectionViewDataSource>

@property(nonatomic, copy)NSAttributedString* chapterContent;
@property(nonatomic, copy)JUDIAN_READ_FeaturedChapterTitleCell* chapterTitleCell;
@property(nonatomic, weak)UITextView* textView;
@property(nonatomic, strong)JUDIAN_READ_FeaturedFictionModel* fictionModel;
@property (nonatomic, assign)BOOL showFloatWindow;
@end

@implementation JUDIAN_READ_FeaturedPageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self addViews:frame];
        _showFloatWindow = FALSE;
        [self addCollectionView];
    }
    
    return self;
}


- (void)addViews:(CGRect)frame {
    
    UITextView* label = [[UITextView alloc] init];
    label.editable = NO;
    _textView = label;
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:30];
    //label.frame = CGRectMake(0, 0, 0, 0);
    //label.text = [NSString stringWithFormat:@"%ld", index];
    label.text = @"";
    label.scrollEnabled = YES;
    [self.contentView addSubview:label];

    WeakSelf(that);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.width.equalTo(that.contentView.mas_width);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom);
    }];
}




- (void)updateText:(NSString*)text row:(NSInteger)row {
    _textView.text = text;
    if (row % 2 == 0) {
        _textView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        _textView.backgroundColor = [UIColor darkGrayColor];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  [_textView setContentOffset:CGPointMake(0, 1)];
    });
}

- (UITextView*)getTextView {
    return _textView;
}


- (UICollectionView*)getCollectionView {
    return self.novelCollectionView;
}



- (void)updateHeadState:(BOOL)needRefreshView {
    if (needRefreshView) {
        WeakSelf(that);
        self.novelCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [that.novelCollectionView.mj_header endRefreshing];
            if (that.block) {
                that.block(@"refresh", nil);
            }
        }];
    }
    else {
        self.novelCollectionView.mj_header = nil;
    }
}




- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionHeadersPinToVisibleBounds = FALSE;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect rect = CGRectZero;
    UICollectionView* novelCollectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    self.novelCollectionView = novelCollectionView;
    self.novelCollectionView.backgroundColor = [UIColor whiteColor];
    self.novelCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);//58 + 8
    self.novelCollectionView.delegate = self;
    self.novelCollectionView.dataSource = self;
    [self.contentView addSubview:novelCollectionView];
    
    [self.novelCollectionView registerClass:[JUDIAN_READ_SegmentChapterContentCell class] forCellWithReuseIdentifier:CHAPTER_CONTENT_IDENTIFIER];
    
    //[self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedFictionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FeaturedFictionHeaderView];
    
    [self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedChapterDescriptionCell class] forCellWithReuseIdentifier:FeaturedChapterDescriptionCell];
    
    [self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedChapterTitleCell class] forCellWithReuseIdentifier:FeaturedChapterTitleCell];
    
    [self.novelCollectionView registerClass:[JUDIAN_READ_FeaturedNextChapterTipCell class] forCellWithReuseIdentifier:FeaturedNextChapterTipCell];
    
    _chapterTitleCell = [[JUDIAN_READ_FeaturedChapterTitleCell alloc]initWithFrame:CGRectZero];
    
    WeakSelf(that);
    [self.novelCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.right.equalTo(that.contentView.mas_right);
        make.top.equalTo(that.contentView.mas_top);
        make.bottom.equalTo(that.contentView.mas_bottom).offset(-Height_TabBar);
    }];


}


- (void)updateCellWithModel:(JUDIAN_READ_FeaturedFictionModel*)model {
    _fictionModel = model;
    _fictionModel.content = [[JUDIAN_READ_NovelManager shareInstance] cleanContent:_fictionModel.content];
    _chapterContent = [[JUDIAN_READ_CoreTextManager shareInstance] createChapterString:_fictionModel.content];//
    [self.novelCollectionView reloadData];
}




#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JUDIAN_READ_FeaturedChapterDescriptionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedChapterDescriptionCell forIndexPath:indexPath];
        [cell updateCellWithModel:_fictionModel];
        return cell;
    }
    
    if (indexPath.row == 1) {
        JUDIAN_READ_FeaturedChapterTitleCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedChapterTitleCell forIndexPath:indexPath];
        [cell setTitleText:_fictionModel.chapter];
        return cell;
    }
    
    if (indexPath.row == 2) {
        JUDIAN_READ_SegmentChapterContentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHAPTER_CONTENT_IDENTIFIER forIndexPath:indexPath];
        NSAttributedString* attributedText = _chapterContent;
        [cell setContent:attributedText nextTip:FALSE];
        return cell;
    }
    
    JUDIAN_READ_FeaturedNextChapterTipCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedNextChapterTipCell forIndexPath:indexPath];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSInteger width = SCREEN_WIDTH;
        CGSize size = {width, 138 + 6};
        return size;
    }
    
    if (indexPath.row == 1) {
        JUDIAN_READ_FeaturedChapterTitleCell* cell = _chapterTitleCell;
        [cell setTitleText:_fictionModel.chapter];
        NSInteger height = [cell getCellHeight:NO];
        return CGSizeMake(SCREEN_WIDTH, height);
    }
    
    if (indexPath.row == 2) {
        CGSize size = CGSizeMake(SCREEN_WIDTH - 2 * LEFT_RIGH_EDGE, MAXFLOAT);
        NSInteger width = SCREEN_WIDTH;
        CGFloat height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:_chapterContent width:size.width lineCount:nil endLine:-1];
        if (height < 10) {
            height = CGRectGetHeight(self.novelCollectionView.frame);
        }
        return CGSizeMake(width, ceil(height));
    }
    
    if (indexPath.row == 3) {
        NSInteger width = SCREEN_WIDTH;
        return CGSizeMake(width, 58);
    }
    
    return CGSizeMake(0, 0);

    
}



//与父视图左右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //return UIEdgeInsetsMake(0, LEFT_RIGH_EDGE, 0, LEFT_RIGH_EDGE);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//单元格左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.01;
}

#if 0
//头部，尾部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0) {
        // return nil;
    }
    
    
    //如果是头部视图
    if (kind == UICollectionElementKindSectionHeader) {
        JUDIAN_READ_FeaturedFictionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FeaturedFictionHeaderView forIndexPath:indexPath];
        return header;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section != 0) {
        //return CGSizeZero;
    }
    
    
    NSInteger width = SCREEN_WIDTH;
    CGSize size = {width, 100};
    return size;
}
#endif

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if (_block) {
            _block(@"reader", _fictionModel);
        }
    }
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"collect sub will::%ld", indexPath.row);
    if (indexPath.row == 0) {
        if (_block) {
            _showFloatWindow = TRUE;
            _block(@"hide", nil);
        }
    }

}



- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"collect sub end::%ld", indexPath.row);
    if (indexPath.row == 0) {
        if (_block) {
            _block(@"show", nil);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yPos = scrollView.contentOffset.y;
    NSIndexPath* indexPath = [_novelCollectionView indexPathForItemAtPoint:CGPointMake(0, yPos)];
    //NSLog(@"collect subview DidScroll   y==%.1f row== %ld", yPos, indexPath.row);
    
    if (_block) {
        _block(@"position", nil);
    }
    
    if (indexPath.row == 0) {
        if (_block) {
            _showFloatWindow = TRUE;
            _block(@"hide", nil);
        }
    }
    else {
        if (_block && !_showFloatWindow) {
            _showFloatWindow = TRUE;
            _block(@"show", _fictionModel);
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //NSLog(@"collect subview Dragging begin=== %.1f", scrollView.contentOffset.y);
    if (_block) {
        _block(@"beginDrag", nil);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"collect subview Dragging end=== %.1f", scrollView.contentOffset.y);
    if (_block) {
        _block(@"endDrag", nil);
    }
}


- (BOOL)getCellVisibility {
    
    for (UICollectionViewCell* element in self.novelCollectionView.visibleCells) {
        if ([element isKindOfClass:[JUDIAN_READ_FeaturedChapterDescriptionCell class]]) {
            return TRUE;
        }
    }
    
    return FALSE;
}



- (void)updateContentPosition :(NSInteger)position {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    if (position == UICollectionViewScrollPositionTop) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.novelCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(position) animated:(NO)];
    });
    
    
}

//

@end

@interface JUDIAN_READ_FeaturedChapterDescriptionCell ()
@property(nonatomic, weak)UILabel* bookNameLabel;
@property(nonatomic, weak)UILabel* authorLabel;
@property(nonatomic, weak)UIImageView* headImageView;
@property(nonatomic, weak)UILabel* bookTypeLabel;
@property(nonatomic, weak)UILabel* fansCountLabel;
@property(nonatomic, weak)UIImageView* bgImageView;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, weak)UIButton* favoriteButton;
@property(nonatomic, weak)JUDIAN_READ_FeaturedFictionModel* fictionModel;
@property(nonatomic, weak)UIControl* touchControl;
@end


@implementation JUDIAN_READ_FeaturedChapterDescriptionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews:frame];
    }
    return self;
}



- (void)addViews:(CGRect)frame {
    
    UIImageView* bgImageView = [[UIImageView alloc] init];
    _bgImageView = bgImageView;
    bgImageView.image = [UIImage imageNamed:@"featured_fiction_description_tip"];
    [self.contentView addSubview:bgImageView];
    
#if 0
    UIView* container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 7;
    container.layer.shadowOpacity = 1;
    container.layer.shadowColor = RGB(0x65, 0x65, 0x65).CGColor;
    container.layer.shadowRadius = 3;
    //container.layer.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:container];
#else
    UIView* container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:container];
    
    UIImageView* contianerImageView = [[UIImageView alloc] init];
    contianerImageView.image = [UIImage imageNamed:@"fiction_head_corner"];
    [container addSubview:contianerImageView];
    
    
#endif
    
    
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 3;
    headImageView.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    headImageView.layer.borderWidth = 0.5;
    headImageView.layer.masksToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"default_v_image"];
    _headImageView = headImageView;
    [self.contentView addSubview:headImageView];
    
    
    UILabel* bookNameLabel = [[UILabel alloc] init];
    _bookNameLabel = bookNameLabel;
    bookNameLabel.font = [UIFont systemFontOfSize:19 weight:(UIFontWeightMedium)];
    bookNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    bookNameLabel.text = @"";//圣兽帝国
    [self.contentView addSubview:bookNameLabel];
    
    
    UILabel* authorLabel = [[UILabel alloc] init];
    _authorLabel = authorLabel;
    authorLabel.font = [UIFont systemFontOfSize:12];
    authorLabel.textColor = RGB(0x33, 0x33, 0x33);
    authorLabel.text = @"";//
    [self.contentView addSubview:authorLabel];
    
    
    
    UILabel* bookTypeLabel = [[UILabel alloc] init];
    _bookTypeLabel = bookTypeLabel;
    bookTypeLabel.font = [UIFont systemFontOfSize:12];
    bookTypeLabel.textColor = RGB(0x66, 0x66, 0x66);
    bookTypeLabel.text = @"";//风中有种云做的雨
    [self.contentView addSubview:bookTypeLabel];
    
    
    UILabel* fansCountLabel = [[UILabel alloc] init];
    _fansCountLabel = fansCountLabel;
    fansCountLabel.font = [UIFont systemFontOfSize:12];
    fansCountLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    fansCountLabel.text = @"";//
    [self.contentView addSubview:fansCountLabel];
    
    
    UIButton* favoriteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    favoriteButton.layer.cornerRadius = 3;
    _favoriteButton = favoriteButton;
    UIImage* image = [UIImage imageNamed:@"favorite_book_tip"];
    [favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [self.contentView addSubview:favoriteButton];
    [favoriteButton addTarget:self action:@selector(handleButtonTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIControl* touchControl = [[UIControl alloc] init];
    _touchControl = touchControl;
    [touchControl addTarget:self action:@selector(handleButtonTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    [container addSubview:touchControl];
    
    
    WeakSelf(that);
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left);
        make.top.equalTo(that.contentView.mas_top);
        make.right.equalTo(that.contentView.mas_right);
        make.height.equalTo(@(100));
        
    }];
    
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.contentView.mas_left).offset(14);
        make.top.equalTo(that.contentView.mas_top).offset(10);
        make.right.equalTo(that.contentView.mas_right).offset(-14);
        make.height.equalTo(@(134));
    }];
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(10);
        make.centerY.equalTo(container.mas_centerY);
        make.width.equalTo(@(70));
        make.height.equalTo(@(98));
    }];
    
    
    [contianerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left).offset(-8);
        make.right.equalTo(container.mas_right).offset(8);
        make.top.equalTo(container.mas_top);
        make.bottom.equalTo(container.mas_bottom);
    }];
    
    [favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right).offset(-10);
        make.bottom.equalTo(headImageView.mas_bottom).offset(-3);
        make.width.equalTo(@(80));
        make.height.equalTo(@(27));
    }];
    
    
    CGFloat width = [fansCountLabel getTextWidth:12];
    width = ceil(width);
    
    [fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container.mas_right).offset(-10);
        make.height.equalTo(@(12));
        make.top.equalTo(headImageView.mas_top).offset(13);
        make.width.equalTo(@(width));
    }];
    

    [bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(13);
        make.centerY.equalTo(fansCountLabel.mas_centerY);
        make.height.equalTo(@(20));
        make.right.equalTo(fansCountLabel.mas_left).offset(-30);
    }];
    
    
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookNameLabel.mas_left);
        make.height.equalTo(@(12));
        make.top.equalTo(bookNameLabel.mas_bottom).offset(10);
        make.right.equalTo(bookNameLabel.mas_right);
    }];
    
    
    [bookTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookNameLabel.mas_left);
        make.height.equalTo(@(12));
        make.bottom.equalTo(headImageView.mas_bottom).offset(-10);
        make.right.equalTo(bookNameLabel.mas_right);
    }];
    
    [touchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
        make.top.equalTo(container.mas_top);
        make.height.equalTo(container.mas_height);
    }];
    
}


- (void)updateCellWithModel:(JUDIAN_READ_FeaturedFictionModel*)model {
    
    _bookId = model.nid;
    _fictionModel = model;
    
    if ([model.is_favorite integerValue] > 0) {
        [self updateButtonState:YES];
    }
    else {
        [self updateButtonState:NO];
    }
    
    
    NSInteger tenThousand = 10000.0f;
    NSInteger count = model.favorite_num.integerValue;
    NSString* countTip = @"";
    if (count > tenThousand) {
        countTip = [NSString stringWithFormat:@"%.1fW人气", model.favorite_num.floatValue / tenThousand];
    }
    else {
        countTip = [NSString stringWithFormat:@"%@人气", model.favorite_num];
    }
    
    _bookNameLabel.text = model.bookname;
    _authorLabel.text = model.author;
    _bookTypeLabel.text = [NSString stringWithFormat:@"%@ | %@", model.cat_name, [model getNovelStateStr]];
    _fansCountLabel.text = countTip;
    
    NSURL* imageUrl = [NSURL URLWithString:model.cover];
    UIImage* defaultImage = [UIImage imageNamed:@"default_v_image"];
    WeakSelf(that);
    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        that.bgImageView.image = [image imageByBlurLight];
    }];
    
    
    CGFloat width = [_fansCountLabel getTextWidth:12];
    width = ceil(width);

    [_fansCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
}



- (void)handleButtonTouch:(id)sender {
    
    if (sender == _touchControl && _fictionModel) {
        [[NSNotificationCenter defaultCenter]postNotificationName:FeaturedNotification object:@{@"model":_fictionModel}];
        return;
    }
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {
            that.fictionModel.is_favorite = @"1";
            [that updateButtonState:YES];
            
            NSDictionary* dictionary = @{
                                         @"source" : @"精选"
                                         };
            
            [MobClick event:@"collection_source_bydetails" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"collection_source_bydetails" withArgs:dictionary];
        }
    }];
    
}



- (void)updateButtonState:(BOOL)isCollected {
    
    if (isCollected) {
        UIImage* image = [UIImage imageNamed:@"favorited_book_tip"];
        [_favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
        _favoriteButton.userInteractionEnabled = NO;
    }
    else {
        UIImage* image = [UIImage imageNamed:@"favorite_book_tip"];
        [_favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
        _favoriteButton.userInteractionEnabled = YES;
    }
}



@end


@interface JUDIAN_READ_FeaturedDescriptionFloatView ()
@property(nonatomic, weak)UILabel* bookNameLabel;
@property(nonatomic, weak)UIImageView* headImageView;
@property(nonatomic, weak)UILabel* bookTypeLabel;
@property(nonatomic, weak)UILabel* fansCountLabel;
@property(nonatomic, copy)NSString *bookId;
@property(nonatomic, weak)UIButton* favoriteButton;
@property(nonatomic, weak)JUDIAN_READ_FeaturedFictionModel* fictionModel;
@property(nonatomic, weak)UIControl* touchControl;
@end



@implementation JUDIAN_READ_FeaturedDescriptionFloatView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self addViews];
    }
    
    return self;
}




- (void)addViews {
    
    UIView* container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];
    [self addSubview:container];
    
    UIImageView* shadowImageView = [[UIImageView alloc] init];
    shadowImageView.image = [UIImage imageNamed:@"fiction_head_square"];
    [container addSubview:shadowImageView];
    
    UIImageView* headImageView = [[UIImageView alloc] init];
    _headImageView = headImageView;
    headImageView.layer.cornerRadius = 2;
    headImageView.layer.borderWidth = 0.5;
    headImageView.layer.borderColor = RGB(0xee, 0xee, 0xee).CGColor;
    headImageView.layer.masksToBounds = YES;
    
    headImageView.image = [UIImage imageNamed:@"default_v_image"];
    [self addSubview:headImageView];
    
    
    UILabel* bookNameLabel = [[UILabel alloc] init];
    _bookNameLabel = bookNameLabel;
    bookNameLabel.font = [UIFont systemFontOfSize:19 weight:(UIFontWeightMedium)];
    bookNameLabel.textColor = RGB(0x33, 0x33, 0x33);
    bookNameLabel.text = @"";
    [self addSubview:bookNameLabel];
    
    
    UILabel* bookTypeLabel = [[UILabel alloc] init];
    _bookTypeLabel = bookTypeLabel;
    bookTypeLabel.font = [UIFont systemFontOfSize:12];
    bookTypeLabel.textColor = RGB(0x66, 0x66, 0x66);
    bookTypeLabel.text = @"";
    [self addSubview:bookTypeLabel];
    
    
    UILabel* fansCountLabel = [[UILabel alloc] init];
    _fansCountLabel = fansCountLabel;
    fansCountLabel.font = [UIFont systemFontOfSize:12];
    fansCountLabel.textColor = READER_SETTING_PANEL_BUTTON_CLICKED_COLOR;
    fansCountLabel.text = @"";
    [self addSubview:fansCountLabel];
    
    
    UIButton* favoriteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage* image = [UIImage imageNamed:@"favorite_book_tip"];
    [favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [favoriteButton addTarget:self action:@selector(handleButtonTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    _favoriteButton = favoriteButton;
    [self addSubview:favoriteButton];
    
    UIControl* touchControl = [[UIControl alloc] init];
    _touchControl = touchControl;
    [touchControl addTarget:self action:@selector(handleButtonTouch:) forControlEvents:(UIControlEventTouchUpInside)];
    [container addSubview:touchControl];
    
    WeakSelf(that);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.top.equalTo(that.mas_top);
        make.width.equalTo(that.mas_width);
        make.height.equalTo(that.mas_height);
    }];
    
    
    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.top.equalTo(container.mas_top);
        make.width.equalTo(container.mas_width);
        make.height.equalTo(container.mas_height);
    }];
    
    
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(20);
        make.centerY.equalTo(that.mas_centerY).offset(-8);
        make.width.equalTo(@(48));
        make.height.equalTo(@(68));
    }];
    
    
    
    [favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-20);
        make.bottom.equalTo(headImageView.mas_bottom).offset(-3);
        make.width.equalTo(@(80));
        make.height.equalTo(@(27));
    }];
    
    
    CGFloat width = [fansCountLabel getTextWidth:12];
    width = ceil(width);
    
    [fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-20);
        make.height.equalTo(@(12));
        make.bottom.equalTo(favoriteButton.mas_top).offset(-13);
        make.width.equalTo(@(width));
    }];
    
    
    CGFloat height = 87;
    CGFloat topOffset = (height - 49) / 2;
    
    [bookNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(13);
        make.top.equalTo(that.mas_top).offset(topOffset);
        make.height.equalTo(@(20));
        make.right.equalTo(fansCountLabel.mas_left).offset(-30);
    }];
    
    
    [bookTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bookNameLabel.mas_left);
        make.height.equalTo(@(12));
        make.top.equalTo(bookNameLabel.mas_bottom).offset(17);
        make.right.equalTo(bookNameLabel.mas_right);
    }];
    
    [touchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container.mas_left);
        make.width.equalTo(container.mas_width).multipliedBy(0.5);
        make.top.equalTo(container.mas_top);
        make.height.equalTo(container.mas_height);
    }];
}


- (void)updateViewWithModel:(JUDIAN_READ_FeaturedFictionModel*)model {
    
    if (!model) {
        return;
    }
    _fictionModel = model;
    if ([model.is_favorite integerValue] > 0) {
        [self updateButtonState:YES];
    }
    else {
        [self updateButtonState:NO];
    }
    
    _bookId = model.nid;
    
    NSInteger tenThousand = 10000.0f;
    NSInteger count = model.favorite_num.integerValue;
    NSString* countTip = @"";
    if (count > tenThousand) {
        countTip = [NSString stringWithFormat:@"%.1fW人气", model.favorite_num.floatValue / tenThousand];
    }
    else {
        countTip = [NSString stringWithFormat:@"%@人气", model.favorite_num];
    }
    
    _bookNameLabel.text = model.bookname;
    _bookTypeLabel.text = model.author;//[NSString stringWithFormat:@"%@ | %@", model.cat_name, [model getNovelStateStr]];
    _fansCountLabel.text = countTip;
    
    NSURL* imageUrl = [NSURL URLWithString:model.cover];
    UIImage* defaultImage = [UIImage imageNamed:@"default_v_image"];

    [_headImageView sd_setImageWithURL:imageUrl placeholderImage:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    
    CGFloat width = [_fansCountLabel getTextWidth:12];
    width = ceil(width);
    
    [_fansCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
}

- (void)handleButtonTouch:(id)sender {
    
    if (sender == _touchControl && _fictionModel) {
        [[NSNotificationCenter defaultCenter]postNotificationName:FeaturedNotification object:@{@"model":_fictionModel}];
        return;
    }
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] collectBook:_bookId block:^(id  _Nullable parameter) {
        if (parameter) {
            that.fictionModel.is_favorite = @"1";
            [that updateButtonState:YES];
            
            NSDictionary* dictionary = @{
                                         @"source" : @"精选"
                                         };
            
            [MobClick event:@"collection_source_bydetails" attributes:dictionary];
            [GTCountSDK trackCountEvent:@"collection_source_bydetails" withArgs:dictionary];
        }
    }];
    
}



- (void)updateButtonState:(BOOL)isCollected {
    
    if (isCollected) {
        UIImage* image = [UIImage imageNamed:@"favorited_book_tip"];
        [_favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
        _favoriteButton.userInteractionEnabled = NO;
    }
    else {
        UIImage* image = [UIImage imageNamed:@"favorite_book_tip"];
        [_favoriteButton setBackgroundImage:image forState:(UIControlStateNormal)];
        _favoriteButton.userInteractionEnabled = YES;
    }
}


@end
