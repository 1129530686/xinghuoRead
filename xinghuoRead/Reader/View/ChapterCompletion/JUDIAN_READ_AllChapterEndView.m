//
//  JUDIAN_READ_AllChapterEndView.m
//  xinghuoRead
//
//  Created by judian on 2019/5/27.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_AllChapterEndView.h"
#import "JUDIAN_READ_NovelOtherReadingView.h"
#import "JUDIAN_READ_NovelThumbView.h"
#import "JUDIAN_READ_ChapterEndTipCell.h"
#import "JUDIAN_READ_FictionStateCell.h"
#import "JUDIAN_READ_UserRateFictionCell.h"
#import "JUDIAN_READ_UserAppreciateAvatarCell.h"
#import "JUDIAN_READ_UserAppreciateCountCell.h"
#import "JUDIAN_READ_UserFictionRateViewController.h"
#import "JUDIAN_READ_WeChatLoginController.h"
#import "JUDIAN_READ_RecommendFictionCell.h"
#import "JUDIAN_READ_FictionReadingViewController.h"
#import "JUDIAN_READ_FictionNavigationView.h"
#import "JUDIAN_READ_ContentBrowseController.h"

#define NOVEL_COVER_IDENTIFIER @"novelCover"
#define NOVEL_OTHER_READING_IDENTIFIER @"novelRead"
#define NOVEL_CHAPTER_END_IDENTIFIER @"chapterEnd"
#define UserRateFictionCell @"UserRateFictionCell"
#define RecommendFictionCell @"RecommendFictionCell"
#define RecommendThreeImageCell @"RecommendThreeImageCell"
#define RecommendBigImageCell @"RecommendBigImageCell"
#define NoChapterCell @"NoChapterCell"


#define FICTION_APPRECIATE_AVATER_IDENTIFIER @"appreciateAvatarCell"
#define FICTION_APPRECIATE_COUNT_IDENTIFIER @"appreciateCountCell"


@interface JUDIAN_READ_AllChapterEndView ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, copy)NSArray* novelThumbArray;
@property(nonatomic, copy)NSArray* otherNovelArray;
@property(nonatomic, copy)NSArray* feedArray;
@property(nonatomic, copy)NSString* tipText;
@property(nonatomic, strong)JUDIAN_READ_RecommendBigImageCell* recommendBigImageCell;
@property(nonatomic, strong)JUDIAN_READ_RecommendThreeImageCell* threeImageCell;
@property (nonatomic, weak)JUDIAN_READ_FictionNavigationView* topBarView;
@end


@implementation JUDIAN_READ_AllChapterEndView


- (instancetype)initWithName:(NSString*)bookName state:(NSString*)state {
    
    self = [super init];
    if (self) {
        
        _bookName = bookName;
        _fictionState = state;
        
        NSString* stateName = @"下架";
        if ([state isEqualToString:@"1"]) {
            stateName = @"完结";
        }
        else if([state isEqualToString:@"0"]) {
            stateName = @"连载";
        }

        [GTCountSDK trackCountEvent:@"pv_end_reading" withArgs:@{@"completeTpe": stateName}];
        [MobClick event:@"pv_end_reading" attributes:@{@"completeTpe" : stateName}];

        
        [self addNavigationBar];
        [self addCollentionView];
    }
    
    return self;
}



- (void)addNavigationBar {
    CGFloat navigationHeight = [self getNavigationHeight];
    JUDIAN_READ_FictionNavigationView* topBarView = [[JUDIAN_READ_FictionNavigationView alloc]init];
    topBarView.titleLabel.text = _bookName;
    [topBarView setDayStyle];
    topBarView.frame = CGRectMake(0, 0, WIDTH_SCREEN, navigationHeight);
    [self addSubview:topBarView];
    _topBarView = topBarView;
    
    if ([self.fictionState isEqualToString:@"0"] || [self.fictionState isEqualToString:_NO_CHAPTER_CODE_]) {
        [_topBarView hideButton:NO];
    }
    else {
        [_topBarView hideButton:YES];
    }
}



- (void)addCollentionView {
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect rect = CGRectZero;
    self.collectionView = [[JUDIAN_READ_BaseCollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    
    [self.collectionView registerClass:[JUDIAN_READ_NovelThumbView class] forCellWithReuseIdentifier:NOVEL_COVER_IDENTIFIER];
    [self.collectionView registerClass:[JUDIAN_READ_NovelOtherReadingView class] forCellWithReuseIdentifier:NOVEL_OTHER_READING_IDENTIFIER];
    [self.collectionView registerClass:[JUDIAN_READ_UserRateFictionCell class] forCellWithReuseIdentifier:UserRateFictionCell];
   // [self.collectionView registerClass:[JUDIAN_READ_ChapterEndTipCell class] forCellWithReuseIdentifier:NOVEL_CHAPTER_END_IDENTIFIER];
    [self.collectionView registerClass:[JUDIAN_READ_FictionStateCell class] forCellWithReuseIdentifier:NOVEL_CHAPTER_END_IDENTIFIER];
    
    [self.collectionView registerClass:[JUDIAN_READ_UserAppreciateAvatarCell class] forCellWithReuseIdentifier:FICTION_APPRECIATE_AVATER_IDENTIFIER];
    [self.collectionView registerClass:[JUDIAN_READ_UserAppreciateCountCell class] forCellWithReuseIdentifier:FICTION_APPRECIATE_COUNT_IDENTIFIER];
    
    [self.collectionView registerClass:[JUDIAN_READ_RecommendFictionCell class] forCellWithReuseIdentifier:RecommendFictionCell];

    [self.collectionView registerClass:[JUDIAN_READ_RecommendThreeImageCell class] forCellWithReuseIdentifier:RecommendThreeImageCell];
    
    [self.collectionView registerClass:[JUDIAN_READ_NoChapterCell class] forCellWithReuseIdentifier:NoChapterCell];
    [self.collectionView registerClass:[JUDIAN_READ_RecommendBigImageCell class] forCellWithReuseIdentifier:RecommendBigImageCell];
    
    _recommendBigImageCell = [[JUDIAN_READ_RecommendBigImageCell alloc]initWithFrame:CGRectZero];
    _threeImageCell = [[JUDIAN_READ_RecommendThreeImageCell alloc]initWithFrame:CGRectZero];
    
    
    [self addSubview:self.collectionView];
    
    CGFloat navigationHeight = [self getNavigationHeight];
    WeakSelf(that);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(that.mas_top).offset(navigationHeight);
        make.bottom.equalTo(that.mas_bottom);
    }];
    
    
}



- (CGFloat)getNavigationHeight {
    NSInteger navigationHeight = 64;
    if (iPhoneX) {
        navigationHeight = 88;
    }
    return navigationHeight;
}


#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6 + 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        if ([self isChapterSerial] || [self isNoChapter]) {
            return 1;
        }
        return 2;
    }
    
    if (section == 1) {
        if (_appreciatedAvatarArray.count > 0) {
            return 2;
        }
        
    }
    
    if (section == 2) {
        return 1;
    }
    
    if (section == 3) {
        return _feedArray.count;
    }
    
    
    if (section == 4) {
        if (_novelThumbArray.count > 0) {
            return 1;
        }
    }
    
    if (section == 5) {
        return _novelThumbArray.count;
    }
    
    
    if (section == 6) {
        if (_otherNovelArray.count > 0) {
            return 1;
        }
    }
    
    if (section == 7) {
        return _otherNovelArray.count;
    }
    
    
   
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {

        if (indexPath.row == 0) {
            
            if ([self isNoChapter]) {
                static NSString *identify = NoChapterCell;
                JUDIAN_READ_NoChapterCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                return cell;
            }

            static NSString *identify = NOVEL_CHAPTER_END_IDENTIFIER;
            JUDIAN_READ_FictionStateCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            [self updateFictionInfo:cell];
            
            return cell;
        }
        else {
            static NSString *identify = UserRateFictionCell;
            JUDIAN_READ_UserRateFictionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            WeakSelf(that);
            cell.block = ^(id  _Nullable args) {
                NSString* cmd = args;
                
                if ([cmd isEqualToString:@"appreciate"]) {
                    if (that.appreciateBlock) {
                        that.appreciateBlock(nil);
                    }
                    return;
                }
                
                if ([cmd isEqualToString:@"rate"]) {
                    
                    NSString* token = [JUDIAN_READ_Account currentAccount].token;
                    if (!token) {
                        JUDIAN_READ_WeChatLoginController *loginVC = [JUDIAN_READ_WeChatLoginController new];
                        [that.navigationController pushViewController:loginVC animated:YES];
                        return;
                    }
                    
                    [GTCountSDK trackCountEvent:@"mark_scores" withArgs:@{@"source":@"小说完结页"}];
                    [MobClick event:@"mark_scores" attributes:@{@"source" : @"小说完结页"}];
                
                    if (!that.appreciateCount) {
                        that.appreciateCount = @"";
                    }
 
                    if (!that.bookName) {
                        that.bookName = @"";
                    }
                
                    if (!that.bookAuthor) {
                        that.bookAuthor = @"";
                    }
                   
                    if (!that.bookId) {
                        that.bookId = @"";
                    }
                    
                    NSDictionary* dictinoary = @{
                      @"appreciateCount" : that.appreciateCount,
                      @"bookName" : that.bookName,
                      @"bookAuthor" : that.bookAuthor,
                      @"bookId" : that.bookId
                      };
                    
                    [JUDIAN_READ_UserFictionRateViewController enterFictionRateViewController:that.navigationController book:dictinoary];
                }
                
            };
            
            return cell;
        }

    }
    
    if (section == 1) {
        
        if (indexPath.row == 0) {
            static NSString *identify = FICTION_APPRECIATE_COUNT_IDENTIFIER;
            JUDIAN_READ_UserAppreciateCountCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            
            NSInteger count = _appreciatedAvatarArray.count;
            if (count > 0) {
                [cell setAppreciateCount:[NSString stringWithFormat:@"%ld", (long)count]];
                [cell setDefaultStyle];
                cell.hidden = NO;
            }
            else {
                [cell setAppreciateCount:@"0"];
                cell.hidden = YES;
            }

            return cell;
        }
        
        if (indexPath.row == 1) {
            static NSString *identify = FICTION_APPRECIATE_AVATER_IDENTIFIER;
            JUDIAN_READ_UserAppreciateAvatarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell setDefaultStyle];
            cell.contentView.backgroundColor = [UIColor whiteColor];
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
    
    if (section == 2) {
        static NSString *identify = NOVEL_OTHER_READING_IDENTIFIER;
        JUDIAN_READ_NovelOtherReadingView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell updateCell:@"推荐阅读"];
        return cell;
    }
    
    
    if (section == 3) {
            JUDIAN_READ_ArticleListModel* model = _feedArray[indexPath.row];
            if (model.layout_type.intValue == 1) {
                static NSString *identify = RecommendFictionCell;
                JUDIAN_READ_RecommendFictionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                if (_feedArray.count > 0) {
                    [cell updateCell:_feedArray[indexPath.row]];
                }
                return cell;
            }
            else if (model.layout_type.intValue == 2) {
                static NSString *identify = RecommendBigImageCell;
                JUDIAN_READ_RecommendBigImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                if (_feedArray.count > 0) {
                    [cell updateCell:_feedArray[indexPath.row]];
                }
                return cell;
            }
            else  {
                static NSString *identify = RecommendThreeImageCell;
                JUDIAN_READ_RecommendThreeImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
                if (_feedArray.count > 0) {
                    [cell updateCell:_feedArray[indexPath.row]];
                }
                return cell;
            }
    }
    
    
    if (section == 4) {
        static NSString *identify = NOVEL_OTHER_READING_IDENTIFIER;
        JUDIAN_READ_NovelOtherReadingView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell updateCell:@"读了这本书的人还在看"];
        return cell;
    }
    
    if (section == 5){
        static NSString *identify = NOVEL_COVER_IDENTIFIER;
        JUDIAN_READ_NovelThumbView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        
        if (_novelThumbArray.count > 0) {
            id model = _novelThumbArray[indexPath.row];
            [cell setThumbWithModel:model];
        }
        
        return cell;
    }

    
    if (section == 6) {
        static NSString *identify = NOVEL_OTHER_READING_IDENTIFIER;
        JUDIAN_READ_NovelOtherReadingView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell updateCell:@"该作者的其他作品"];
        return cell;
    }
    
    if (section == 7){
        static NSString *identify = NOVEL_COVER_IDENTIFIER;
        JUDIAN_READ_NovelThumbView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (_otherNovelArray.count > 0) {
            id model = _otherNovelArray[indexPath.row];
            [cell setThumbWithModel:model];
        }
        
        return cell;
    }
    
    
    
    
    return _recommendBigImageCell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (indexPath.row == 0) {
            
            if ([self isNoChapter]) {
                return  CGSizeMake(SCREEN_WIDTH, 233);
            }
            
            NSInteger offset = 0;
            if ([self isChapterSerial]) {
                offset = 60;
            }
            return  CGSizeMake(SCREEN_WIDTH, 108 + offset);
        }
        else {
            return  CGSizeMake(SCREEN_WIDTH, 20 + 20 + 33);
        }
    }

    if (section == 1) {
        if (indexPath.row == 0) {
            if (_appreciatedAvatarArray.count <= 0) {
                return CGSizeMake(0, 0);
            }
            return CGSizeMake(ScreenWidth, 12);
        }
        
        if (indexPath.row == 1) {
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
            
            return CGSizeMake(ScreenWidth, 26 * row + 3 * (row - 1) + 13);
        }
    }
    
    if (section == 2) {
        return  CGSizeMake(SCREEN_WIDTH, 16);
    }
    
    if (section == 3) {
        CGFloat height = 0;
        if (_feedArray.count > 0) {
            JUDIAN_READ_ArticleListModel* model = _feedArray[indexPath.row];
            if (model.layout_type.intValue == 1) {
                height = 73 + 28;
            }
            else if (model.layout_type.intValue == 2) {
                height = [_recommendBigImageCell getCellHeight:_feedArray[indexPath.row]];
            }
            else {
                //117 + 16 + 14;
                height = [_threeImageCell getCellHeight:_feedArray[indexPath.row]];
            }

        }
        return  CGSizeMake(SCREEN_WIDTH, height);
    }
    
    
    if(section == 4 || section == 6) {
        return  CGSizeMake(SCREEN_WIDTH, 50);
    }
    
    if (section == 5 || section == 7) {
        NSInteger width = (SCREEN_WIDTH - 2 * 14 - 3 * 18) / 4;
        return  CGSizeMake(width, ceil(width * 1.43f + 38));
    }
    
    return CGSizeMake(0, 0);
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 5 || section == 7) {
        return UIEdgeInsetsMake(0, 14, 0, 14);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == 5 || section == 7) {
        return 18;
    }
    
    return 0.01;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        JUDIAN_READ_ArticleListModel* model = _feedArray[indexPath.row];
        
        if (!model.nid || !model.bookname) {
            return;
        }
        
        NSDictionary* dictionary = @{
                                     @"bookId":model.nid,
                                     @"bookName":model.bookname,
                                     @"chapterCount": @"",
                                     @"position" : @""
                                     };
        
        [MobClick event:@"pv_app_reading_page" attributes:@{@"source":@"小说完结页"}];
        [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"source":@"小说完结页"}];
#if 0
        [JUDIAN_READ_FictionReadingViewController enterFictionViewController:self.navigationController book:dictionary viewName:@"完结页的推荐信息流"];
#else
        [JUDIAN_READ_ContentBrowseController enterContentBrowseViewController:self.navigationController book:dictionary viewName:@"完结页的推荐信息流"];
#endif
        if (!model.aid) {
            return;
        }
        
        NSDictionary *paras = @{@"aid":model.aid};
        model.read_number = [NSString stringWithFormat:@"%ld",(long)(model.read_number.intValue+1)];
        [JUDIAN_READ_DiscoveryTool addReadRecorUrlWithParams:paras completionBlock:^(id result, id error) {
            
        }];
        
        return;
    }
    
    if (indexPath.section == 5) {
        
        if (_novelThumbArray.count <= 0) {
            return;
        }
        
        if (_cellBlock) {
            
            [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"阅读器里结束页面"}];
            [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"阅读器里结束页面"}];
            
            JUDIAN_READ_NovelThumbModel* model = _novelThumbArray[indexPath.row];
            _cellBlock(model);
        }
        
    }
    
    
    if (indexPath.section == 7) {
        
        if (_otherNovelArray.count <= 0) {
            return;
        }
        
        if (_cellBlock) {
            
            [GTCountSDK trackCountEvent:@"pv_app_introduce_page" withArgs:@{@"source" : @"阅读器里结束页面"}];
            [MobClick event:@"pv_app_introduce_page" attributes:@{@"source" : @"阅读器里结束页面"}];
            
            JUDIAN_READ_NovelThumbModel* model = _otherNovelArray[indexPath.row];
            _cellBlock(model);
        }
        
    }
    
}


- (BOOL)isChapterSerial {
    if ([_fictionState isEqualToString:@"0"]) {
        return TRUE;
    }
    return FALSE;
}


- (BOOL)isNoChapter {
    if ([_fictionState isEqualToString:_NO_CHAPTER_CODE_]) {
        return TRUE;
    }
    return FALSE;
}



- (void)reloadData:(NSArray*)array{
    _novelThumbArray = array;
    //_tipText = tip;
    [self.collectionView reloadData];
}



- (void)reloadFeedList:(NSArray*)array {
    _feedArray = array;
    [self.collectionView reloadData];
}


- (void)reloadAvatarList:(NSArray*)array {
    _appreciatedAvatarArray = array;
    [self.collectionView reloadData];
}

- (void)reloadAuthorOtherBookList:(NSArray*)array {
    _otherNovelArray = array;
    [self.collectionView reloadData];
}


- (void)updateFictionInfo:(JUDIAN_READ_FictionStateCell*)cell {
    
    NSString* chapterCount = @"";
    NSString* updateInfo = @"";
    NSString* slogan = @"";
    NSString* stateText = @"";
    
    if ([self isChapterSerial]) {
        stateText = @"未完待续";
        chapterCount = @"您已看到最新章节，作者正在努力创作中…";
        updateInfo = @"连载小说，每天更新1-5章";
        slogan = @"精彩后续，稍后或明天再来~";
    }
    else {
        stateText = @"已完结";//[NSString stringWithFormat:@"《%@》已完结", _bookName];
        chapterCount = [NSString stringWithFormat:@"共有%@章节，%@", _chapterCount, _wordCount];
        updateInfo = @"感谢你的陪伴";
        slogan = @"免费看小说，认准追书宝";
    }
    
    [cell updateFictionInfo:stateText count:chapterCount updateInfo:updateInfo slogan:slogan];
    
}



@end
