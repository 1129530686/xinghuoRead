//
//  JUDIAN_READ_ChapterIndexModel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserReadingModel.h"
#import "JUDIAN_READ_SqliteManager.h"
#import "JUDIAN_READ_NovelManager.h"


@implementation JUDIAN_READ_UserReadingModel


+ (void)saveBrowseHistoryWithModel:(JUDIAN_READ_NovelBrowseHistoryModel*)historyModel {

    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager saveBrowseHistory:historyModel];
    [manager closeDatabase];
}

+ (void)updateReaderPosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager updateReaderPosition:bookId chapterId:chapterId position:position];
    [manager closeDatabase];
}




+ (NSDictionary*)getChapterId:(NSString*)bookId {
    
    if (!bookId) {
        return nil;
    }
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSDictionary* dictionary = [manager queryHistoryWithId:bookId];
    [manager closeDatabase];
    return dictionary;
}




+ (void)addBook:(NSString*)bookId bookName:(NSString*)bookName chapterCount:(NSString*)chapterCount {

    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    
    JUDIAN_READ_NovelSummaryViewModel* model = [[JUDIAN_READ_NovelSummaryViewModel alloc]init];
    model.bookName = bookName;
    model.bookId = bookId;
    model.chapterCount = chapterCount;
    [manager addBook:model];
    [manager closeDatabase];
    
}



+ (void)addOfflineHistory:(NSString*)bookId chapterId:(NSString*)chapterId {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager deleteOfflineHistory:bookId];
    [manager saveOfflineHistory:bookId chapterId:chapterId];
    [manager closeDatabase];
}



+ (NSArray*)getOfflineHistory {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSArray* array = [manager getOfflineHistory];
    [manager closeDatabase];
    
    return array;
}


+ (NSString*)getOfflineChapterIndex:(NSString*)bookId {
    NSArray* array = [self getOfflineHistory];
    for (NSDictionary* element in array) {
        NSString* existBookId = element[@"bookId"];
        NSString* chapterId = element[@"chapterId"];
        
        if ([existBookId isEqual:[NSNull null]] || [chapterId isEqual:[NSNull null]] ) {
            return @"";
        }
        
        if ([existBookId isEqualToString:bookId]) {
            return chapterId;
        }
    }
    return @"";
}




+ (NSString*)getOfflinePosition:(NSString*)bookId {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSString* yPosition = [manager queryOfflinePosition:bookId];
    [manager closeDatabase];
    return yPosition;
}




+ (void)clearOfflineHistory {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager clearOfflineHistory];
    [manager closeDatabase];
    
}



+ (void)updateOfflinePosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager updateReaderOfflinePosition:bookId position:position];
    [manager closeDatabase];
}



+ (BOOL)getCachedStatus:(NSString*)bookId {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    BOOL isCached = [manager queryBookWithId:bookId];
    
    if (isCached) {
        isCached = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:bookId chpaterId:_DOWN_FICTION_FLAG_];
    }
    
    [manager closeDatabase];

    return isCached;
}



+ (NSArray*)getCachedBookSummary:(NSString*)bookId {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSArray* array = [manager getOneBookSummary:bookId];
    [manager closeDatabase];
    
    return array;
}




+ (void)saveBookSummary:(JUDIAN_READ_NovelSummaryModel*)model {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager addBookSummary:model];
    [manager closeDatabase];
}




+ (NSArray*)getBookSummary {
    
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSArray* array = [manager getAllBookSummary];
    [manager closeDatabase];
    
    return array;
}



+ (void)addChargeHistory:(NSString*)orderId type:(NSString*)type {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager addChargeHistory:orderId type:type];
    [manager closeDatabase];
}


+ (void)deleteChargeHistory:(NSString*)orderId {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager deleteChargeHistory:orderId];
    [manager closeDatabase];
}



+ (NSArray*)getAllChargeHistory {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSArray* array = [manager getAllChargeHistory];
    [manager closeDatabase];
    return array;
}




+ (NSArray*)queryAllCachedBooks {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    NSArray* array = [manager queryAllCachedBooks];
    [manager closeDatabase];
    return array;
}



+ (void)clearCachedBooks {
    JUDIAN_READ_SqliteManager* manager = [[JUDIAN_READ_SqliteManager alloc]init];
    [manager openDatabase];
    [manager clearCachedBooks];
    [manager closeDatabase];
}



@end
