//
//  JUDIAN_READ_ChapterIndexModel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_NovelBrowseHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserReadingModel : NSObject

+ (void)updateReaderPosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position;
+ (void)saveBrowseHistoryWithModel:(JUDIAN_READ_NovelBrowseHistoryModel*)historyModel;
+ (void)addBook:(NSString*)bookId bookName:(NSString*)bookName chapterCount:(NSString*)chapterCount;

+ (NSDictionary*)getChapterId:(NSString*)bookId;

+ (void)saveBookSummary:(JUDIAN_READ_NovelSummaryModel*)model;

+ (NSArray*)getBookSummary;

+ (void)updateOfflinePosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position;
+ (void)addOfflineHistory:(NSString*)bookId chapterId:(NSString*)chapterId;
+ (NSArray*)getOfflineHistory;
+ (void)clearOfflineHistory;
+ (NSString*)getOfflinePosition:(NSString*)bookId;
+ (NSArray*)getCachedBookSummary:(NSString*)bookId;
+ (NSString*)getOfflineChapterIndex:(NSString*)bookId;


+ (void)addChargeHistory:(NSString*)orderId type:(NSString*)type;
+ (void)deleteChargeHistory:(NSString*)orderId;
+ (NSArray*)getAllChargeHistory;

+ (NSArray*)queryAllCachedBooks;
+ (void)clearCachedBooks;

+ (BOOL)getCachedStatus:(NSString*)bookId;


@end

NS_ASSUME_NONNULL_END
