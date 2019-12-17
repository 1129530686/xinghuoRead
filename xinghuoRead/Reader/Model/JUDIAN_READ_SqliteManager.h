//
//  JUDIAN_READ_SqliteManager.h
//  xinghuoRead
//
//  Created by judian on 2019/5/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_NovelSummaryViewModel.h"
#import "JUDIAN_READ_NovelBrowseHistoryModel.h"

#import "JUDIAN_READ_NovelSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SqliteManager : NSObject

- (void)openDatabase;
- (void)closeDatabase;

- (void)addBook:(JUDIAN_READ_NovelSummaryViewModel*)model;
- (void)addBrowseHistory:(JUDIAN_READ_NovelBrowseHistoryModel*)model;

- (BOOL)queryBookWithId:(NSString*)bookId;
- (NSDictionary*)queryHistoryWithId:(NSString*)bookId;

- (void)updateReaderPosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position;
- (void)saveBrowseHistory:(JUDIAN_READ_NovelBrowseHistoryModel*)model;

- (void)saveOfflineHistory:(NSString*)bookId chapterId:(NSString*)chapterId;
- (NSArray*)getOfflineHistory;
- (void)clearOfflineHistory;
- (void)deleteOfflineHistory:(NSString*)bookId;
- (void)updateReaderOfflinePosition:(NSString*)bookId position:(NSString*)position;
- (NSString*)queryOfflinePosition:(NSString*)bookId;

- (void)addBookSummary:(JUDIAN_READ_NovelSummaryModel*)model;

- (NSArray*)getAllBookSummary;
- (NSArray*)getOneBookSummary:(NSString*)bookId;

//添加充值记录，1为充值，2为赞赏
- (void)addChargeHistory:(NSString*)orderId type:(NSString*)type;

//删除充值记录
- (void)deleteChargeHistory:(NSString*)orderId;

//查询所有充值记录
- (NSArray*)getAllChargeHistory;


- (NSArray*)queryAllCachedBooks;
- (void)clearCachedBooks;

@end

NS_ASSUME_NONNULL_END
