//
//  JUDIAN_READ_NovelModel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_UserReadingModel.h"
#import "NSArray+JUDIAN_READ_KeyedArchiver.h"
#import "JUDIAN_READ_CacheContentModel.h"
#import "JUDIAN_READ_ContentBrowseController.h"

#define CATALOG_EXT @"catalog"
#define FICTION_EXT @"dat"


NS_ASSUME_NONNULL_BEGIN

typedef void(^responseCallback)(_Nullable id parameter);


@interface JUDIAN_READ_NovelManager : NSObject

+ (instancetype)shareInstance;

//@property(nonatomic, strong)JUDIAN_READ_UserReadingModel* userReadingModel;
//@property(nonatomic, strong)NSMutableDictionary* chapterDictionary;
@property (nonatomic, copy)NSString* userRemark;
@property(nonatomic, strong)NSMutableDictionary* downloadingDictionary;
@property(nonatomic, weak)JUDIAN_READ_ContentBrowseController* viewController;

- (void)updateReadingModel:(BOOL)isNextChapter;


- (CTFrameRef)getFrameRef:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model;
- (void)adjustTextStyle:(responseCallback)block;


- (void)getNovelChapterList:(NSString*)bookId block:(responseCallback)block failure:(responseCallback)failure isCache:(BOOL)isCache;
- (NSArray*)getNovelChapterListFromFile:(NSString*)bookId;

- (void)getNovelUrl:(NSString*)bookId  block:(responseCallback)block;
- (void)downloadNovel:(NSString*)fileUrl progress:(void (^)(CGFloat progress)) downloadProgressBlock;


- (BOOL)isFirstChapter;
- (BOOL)isLastChapter;

- (void)gotoNextChapter;
- (void)gotoPreviousChapter;


- (void)getFictionChapterContent:(NSString*)chapterId bookId:(NSString*)bookId block:(responseCallback) block;
- (void)getUserAppreciateAvatarList:(NSDictionary*)dictionary block:(CompletionBlock)block needTotalPage:(BOOL)needTotalPage;
- (void)addUserReadChapter:(NSString*)bookId chapterId:(NSString*)chapterId;

- (void)getAppreciateMoneyAmountList:(responseCallback)block;
- (void)appreciateChapter:(NSDictionary*)dictionary block:(responseCallback)block;
- (void)updteAppreciateStatus:(NSDictionary*)dictionary block:(responseCallback)block;

- (NSString*)getCatalogFilePath:(NSString*)bookId ext:(NSString*)ext;
- (JUDIAN_READ_CacheContentModel*)getNovelChapterContentFromFile:(NSString*)bookId chapterId:(NSString*)chapterId;

- (void)downloadChapter:(NSString*)bookId begin:(NSString*)begin size:(NSString*)size block:(responseCallback)block failure:(responseCallback) failure;
- (void)serializeFictionFromServer:(NSString*)bookId bookName:(NSString*)bookName begin:(NSString*)begin size:(NSString*)size block:(responseCallback)block;

- (NSString*)getSavedChapterRateInDocument:(NSString*)bookId totalChapter:(NSInteger)totalChapter;
- (NSInteger)travelFictionDirectory:(NSString*)bookId;

- (void)getFictionAppreciateList:(NSString*)pageIndexStr block:(responseCallback)block;
- (BOOL)isFictionInDocument:(NSString*)bookId chpaterId:(NSString*)chapterId;

- (void)deleteLastChapterCache:(NSString*)bookId chapterId:(NSString*)chapterId;
- (void)getBookCacheState:(NSString*)bookId block:(responseCallback)block;

- (void)isBookInCollection:(NSString*)bookId block:(responseCallback)block;
- (void)collectBook:(NSString*)bookId block:(responseCallback)block;
- (BOOL)isExistCatalog:(NSString*)bookId;

//将书籍添加到准备下载队列
- (void)saveWillDownLoadBook:(id)book;

//获取所有等待下载书籍
- (NSArray *)getAllWillDownLoadBooks;

//循环下载
- (void)downLoadNextBookComplectionBlock:(responseCallback)finishBlock;
- (void)updateUserReadDuration:(NSString*)bookId chapterId:(NSString*)chapterId duration:(NSString*)duration block:(responseCallback)block;

- (void)loadRecommendFeedData:(NSString*)bookId block:(responseCallback)block;

- (NSString*)getFictionDirectory:(NSString*)bookId;
- (NSString*)cleanContent:(NSString*)content;
@end

NS_ASSUME_NONNULL_END
