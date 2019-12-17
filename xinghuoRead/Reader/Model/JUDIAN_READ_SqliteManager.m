//
//  JUDIAN_READ_SqliteManager.m
//  xinghuoRead
//
//  Created by judian on 2019/5/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_SqliteManager.h"
#import "FMDatabase.h"



@interface JUDIAN_READ_SqliteManager ()
@property(nonatomic, strong)FMDatabase* dbInstance;
@end



@implementation JUDIAN_READ_SqliteManager


- (void)openDatabase {

    NSString* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString* dbPath = [path stringByAppendingPathComponent:@"JUDIAN_READer.sqlite"];
    BOOL result = FALSE;
    _dbInstance = [FMDatabase databaseWithPath:dbPath];
    if (![_dbInstance open]) {
        [_dbInstance close];
        return;
    }

    NSString *insertCommand = @"CREATE TABLE IF NOT EXISTS t_book(id INTEGER PRIMARY KEY AUTOINCREMENT, book_id  TEXT, book_name TEXT, chapter_count TEXT, reserver_1 TEXT, reserver_2 TEXT);"
    "CREATE TABLE IF NOT EXISTS t_reader_history(id INTEGER PRIMARY KEY AUTOINCREMENT,book_id  TEXT,book_name   TEXT,chapter_name TEXT,chapter_id TEXT, page_index TEXT, y_pos TEXT, reserver_1 TEXT, reserver_2 TEXT);"
    "CREATE TABLE IF NOT EXISTS t_book_summary(id INTEGER PRIMARY KEY AUTOINCREMENT,star TEXT, nid TEXT,bookname TEXT,cover TEXT,update_status  TEXT,words_number TEXT,tag  TEXT,author TEXT,editorid TEXT,brief TEXT,chapter_name TEXT,update_time TEXT,chapters_total TEXT,chapter_update TEXT);"
    "CREATE TABLE IF NOT EXISTS t_reader_offline(id INTEGER PRIMARY KEY AUTOINCREMENT, book_id TEXT, chapter_id  TEXT, y_pos TEXT, reserver_1 TEXT, reserver_2 TEXT);"
    "CREATE TABLE IF NOT EXISTS t_charge_history(id INTEGER PRIMARY KEY AUTOINCREMENT, order_id TEXT, receipt TEXT, charge_type TEXT, reserver_1 TEXT, reserver_2 TEXT,  reserver_3  TEXT);"
    ;
    
    
    result = [_dbInstance executeStatements:insertCommand];

    //INSERT INTO t_book(book_id, book_name,chapter_count) VALUES('0001', '明朝那些事儿', 100)
    //INSERT INTO t_reader_history(book_id, book_name,chapter_name,page_index) VALUES('0001', '明朝那些事儿', '名将是怎样炼成的', 100)
    
}


- (void)closeDatabase {
    [_dbInstance close];
}


- (void)addBook:(JUDIAN_READ_NovelSummaryViewModel*)model {
    
    [self deleteBook:model.bookId];
    
    NSString* sqlCmd = @"INSERT INTO t_book(book_id, book_name,chapter_count) VALUES(?, ?, ?)";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, model.bookId, model.bookName, model.chapterCount];
    if (result) {
        
    }
    else {
    }
}



- (void)deleteBook:(NSString*)bookId {
    NSString* sqlCmd = @"DELETE FROM t_book WHERE book_id = ?";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, bookId];
    if (result) {
        
    }
    else {
    }
}


- (void)addBrowseHistory:(JUDIAN_READ_NovelBrowseHistoryModel*)model {
    NSString* sqlCmd = @"INSERT INTO t_reader_history(book_id, book_name, chapter_name, chapter_id, page_index) VALUES(?, ?, ?, ?, ?)";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, model.bookId, model.bookName, model.chapterName, model.chapterId , model.pageIndex, model.pageIndex];
    if (result) {
    }
    else {
    }
}



- (void)deleteBrowseHistory:(NSString*)bookId {
    NSString* sqlCmd = @"DELETE FROM t_reader_history WHERE book_id = ?";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, bookId];
    if (result) {
        
    }
    else {
    }
}


- (void)deleteBookSummary:(NSString*)nid {
    NSString* sqlCmd = @"DELETE FROM t_book_summary WHERE nid = ?";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, nid];
    if (result) {
            
    }
    else {
    }
}


- (void)addBookSummary:(JUDIAN_READ_NovelSummaryModel*)model {
    
    if (!model || !model.nid) {
        return;
    }

    [self deleteBookSummary:model.nid];
    
    NSString* sqlCmd = @"INSERT INTO t_book_summary(star, nid, bookname, cover, update_status,words_number,tag,author,editorid,brief,chapter_name,update_time,chapters_total,chapter_update) VALUES(?, ?, ?, ?, ?,?, ?, ?, ?, ?,?, ?, ?, ?)";
    
    BOOL result = [_dbInstance executeUpdate:sqlCmd,
                   model.star, model.nid, model.bookname,
                   model.cover, model.update_status,
                   model.words_number, model.tag,
                   model.author, model.editorid,model.brief,
                   model.chapter_name,model.update_time,
                   model.chapters_total,
                   model.chapter_update];
    
    if (result) {
    }
    else {
        
    }
}




- (NSArray*)getAllBookSummary {
    NSString* sqlCmd = @"SELECT * from t_book_summary";
    NSArray* array = [self getBookSummary:sqlCmd bookId:@""];
    return array;
}


- (NSArray*)getOneBookSummary:(NSString*)bookId {
    NSString* sqlCmd = @"SELECT * from t_book_summary where nid = ?";
    NSArray* array = [self getBookSummary:sqlCmd bookId:bookId];
    return array;
}


- (void)replaceObjectNullWithNil:(JUDIAN_READ_NovelSummaryModel*)model {

    if ([model.star isEqual:[NSNull null]]) {
        model.star = @"";
    }
    
    if ([model.nid isEqual:[NSNull null]]) {
        model.nid  = @"";
    }
    
    if ([model.bookname isEqual:[NSNull null]]) {
        model.bookname = @"";
    }
    
    if ([model.cover isEqual:[NSNull null]]) {
        model.cover   = @"";
    }
    
    if ([model.update_status isEqual:[NSNull null]]) {
        model.update_status   = @"";
    }
    
    
    if ([model.words_number isEqual:[NSNull null]]) {
        model.words_number   = @"";
    }
    
    if ([model.tag isEqual:[NSNull null]]) {
        model.tag = @"";
    }
    
    if ([model.author isEqual:[NSNull null]]) {
        model.author   = @"";
    }
    
    if ([model.editorid isEqual:[NSNull null]]) {
        model.editorid   = @"";
    }
    
    if ([model.brief isEqual:[NSNull null]]) {
        model.brief   = @"";
    }
    
    if ([model.chapter_name isEqual:[NSNull null]]) {
        model.chapter_name   = @"";
    }
    
    if ([model.update_time isEqual:[NSNull null]]) {
        model.update_time   = @"";
    }
    
    if ([model.chapters_total isEqual:[NSNull null]]) {
        model.chapters_total   = @"";
    }
    
    if ([model.chapter_update isEqual:[NSNull null]]) {
        model.chapter_update   = @"";
    }
}


- (NSArray*)getBookSummary:(NSString*)sqlCmd bookId:(NSString*)bookId {
    
    NSDictionary* dictionary = [self getAllBrowseHistory];
    FMResultSet *resultSet = nil;
    
    if (bookId.length > 0) {
        resultSet = [_dbInstance executeQuery:sqlCmd, bookId];
    }
    else {
        resultSet = [_dbInstance executeQuery:sqlCmd];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    
    while ([resultSet next]) {
        
        JUDIAN_READ_NovelSummaryModel* model = [[JUDIAN_READ_NovelSummaryModel alloc]init];
        
        model.star =  [resultSet objectForColumn:@"star"];
        model.nid = [resultSet objectForColumn:@"nid"];
        model.bookname = [resultSet objectForColumn:@"bookname"];
        model.cover = [resultSet objectForColumn:@"cover"];
        model.update_status = [resultSet objectForColumn:@"update_status"];
        model.words_number = [resultSet objectForColumn:@"words_number"];
        model.tag = [resultSet objectForColumn:@"tag"];
        model.author = [resultSet objectForColumn:@"author"];
        model.editorid = [resultSet objectForColumn:@"editorid"];
        model.brief = [resultSet objectForColumn:@"brief"];
        model.chapter_name = [resultSet objectForColumn:@"chapter_name"];
        model.update_time = [resultSet objectForColumn:@"update_time"];
        model.chapters_total = [resultSet objectForColumn:@"chapters_total"];
        model.chapter_update = [resultSet objectForColumn:@"chapter_update"];
        
        [self replaceObjectNullWithNil:model];
        
        NSString* chapterIndex = @"0";
        
        model.read_chapter = @"上次读到第0章";
        model.unread =  [NSString stringWithFormat:@"还有%@章未读", model.chapters_total];
        
        NSString* chapter = dictionary[model.nid];
        if (chapter) {
            NSRange range = [chapter rangeOfString:@"\r"];
            if (range.length > 0) {
                model.chapter_name = [chapter substringToIndex:range.location];
                chapterIndex = [chapter substringFromIndex:range.location + 1];
                
                model.read_chapter = [NSString stringWithFormat:@"上次读到第%@章", chapterIndex];
                NSInteger unreadCount = [model.chapters_total intValue] - [chapterIndex intValue];
                model.unread =  [NSString stringWithFormat:@"还有%ld章未读", unreadCount];
            }
        }
        
        [array addObject:model];
    }
    
    return array;
}






- (BOOL)queryBookWithId:(NSString*)bookId {
    //SELECT book_id,book_name FROM t_book WHERE book_id = '00001'
    NSString* sqlCmd = @"SELECT book_id,book_name FROM t_book WHERE book_id = ?";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd, bookId];
    if ([resultSet next]) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}



- (NSArray*)queryAllCachedBooks {
    //SELECT book_id,book_name FROM t_book WHERE book_id = '00001'
    NSMutableArray* array = [NSMutableArray array];
    NSString* sqlCmd = @"SELECT book_id,book_name FROM t_book ";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd];
    while ([resultSet next]) {
       NSString* bookId = [resultSet objectForColumn:@"book_id"];
        if ([bookId isEqual:[NSNull null]] || bookId.length <= 0) {
            continue;
        }
        [array addObject:bookId];
    }

    return array;
}


- (void)clearCachedBooks {
    NSString* sqlCmd = @"DELETE FROM t_book";
    BOOL result = [_dbInstance executeUpdate:sqlCmd];
    if (result) {
        
    }
    else {
    }
}



- (NSDictionary*)queryHistoryWithId:(NSString*)bookId {
    //SELECT book_id,book_name,chapter_name,page_index FROM t_reader_history where book_id = '00001'
    
    NSDictionary* dictionary = nil;
    
    NSString* sqlCmd = @"SELECT book_id,book_name,chapter_name,chapter_id, y_pos,page_index FROM t_reader_history where book_id = ?";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd, bookId];
    
    if ([resultSet next]) {

        NSString* bookId = [resultSet objectForColumn:@"book_id"];
        NSString* bookName = [resultSet objectForColumn:@"book_name"];
        NSString* chapterName = [resultSet objectForColumn:@"chapter_name"];
        NSString* pageIndex = [resultSet objectForColumn:@"page_index"];
        NSString* chapterId = [resultSet objectForColumn:@"chapter_id"];
        NSString* yPos = [resultSet objectForColumn:@"y_pos"];

        if ([chapterId isEqual:[NSNull null]]) {
            chapterId = @"";
        }
        
        if ([chapterName isEqual:[NSNull null]]) {
            chapterName = @"";
        }
        
        if ([yPos isEqual:[NSNull null]]) {
            yPos = @"";
        }
        
        dictionary = @{
          @"bookId": (bookId ? bookId : @""),
          @"bookName": (bookName ? bookName : @""),
          @"chapterName": (chapterName ? chapterName : @""),
          @"pageIndex": (pageIndex ? pageIndex : @""),
          @"chapterId": (chapterId ? chapterId : @""),
          @"position" : (yPos ? yPos : @"0")
          };

    }
 
    return dictionary;
}


- (void)updateHistory:(NSString*)bookId chapterName:(NSString*)chapterName chapterId:(NSString*)chapterId  pageIndex:(NSString*)pageIndex {
    
    NSString* sqlCmd = [NSString stringWithFormat:@"UPDATE t_reader_history SET page_index = '%@', chapter_name = '%@', chapter_id = '%@' WHERE book_id = '%@'",pageIndex, chapterName, chapterId, bookId];
    
    BOOL result = [_dbInstance executeUpdate:sqlCmd];
    
    if (result) {
        
    }
    else {
        
    }
}




- (void)updateReaderPosition:(NSString*)bookId chapterId:(NSString*)chapterId position:(NSString*)position {
    
    NSString* sqlCmd = [NSString stringWithFormat:@"UPDATE t_reader_history SET y_pos = '%@' WHERE book_id = '%@' and chapter_id = '%@'", position, bookId, chapterId];
    BOOL result = [_dbInstance executeUpdate:sqlCmd];
    if (result) {
        
    }
    else {
        
    }
}




- (void)saveBrowseHistory:(JUDIAN_READ_NovelBrowseHistoryModel*)model {
    [self deleteBrowseHistory:model.bookId];
    [self addBrowseHistory:model];
}


#pragma mark 离线记录
- (void)deleteOfflineHistory:(NSString*)bookId {
    
    if (!bookId) {
        return;
    }
    
    NSString* sqlCmd = @"DELETE FROM t_reader_offline WHERE book_id = ?";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, bookId];
    if (result) {
        
    }
    else {
    }
    
}





- (void)saveOfflineHistory:(NSString*)bookId chapterId:(NSString*)chapterId {
    
    if (!bookId || !chapterId) {
        return;
    }
    
    NSString* sqlCmd = @"INSERT INTO t_reader_offline(book_id, chapter_id) VALUES(?, ?)";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, bookId, chapterId];
    if (result) {
    }
    else {
    }
    
}



- (void)updateReaderOfflinePosition:(NSString*)bookId position:(NSString*)position {
    
    NSString* sqlCmd = [NSString stringWithFormat:@"UPDATE t_reader_offline SET y_pos = '%@' WHERE book_id = '%@'", position, bookId];
    BOOL result = [_dbInstance executeUpdate:sqlCmd];
    if (result) {
        
    }
    else {
        
    }
}



- (NSString*)queryOfflinePosition:(NSString*)bookId {

    NSString* sqlCmd = @"SELECT y_pos FROM t_reader_offline where book_id = ?";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd, bookId];
    NSString* yPos = @"0";
    if ([resultSet next]) {
        yPos = [resultSet objectForColumn:@"y_pos"];
        if ([yPos isKindOfClass:[NSNull class]] || yPos.length <= 0) {
            yPos = @"0";
        }
    }
    
    return yPos;
}




- (NSArray*)getOfflineHistory {

    NSMutableArray* array = [NSMutableArray array];
    NSString* sqlCmd = @"SELECT book_id, chapter_id, y_pos FROM t_reader_offline";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd];
    while ([resultSet next]) {
        NSString* bookId = [resultSet objectForColumn:@"book_id"];
        NSString* chapterId = [resultSet objectForColumn:@"chapter_id"];
        if (bookId && chapterId) {
            NSDictionary* dictionary = @{
              @"bookId" : bookId,
              @"chapterId" : chapterId
              };
            [array addObject:dictionary];
        }

    }
    
    return array;
}



- (void)clearOfflineHistory {
    
    NSString* sqlCmd = @"DELETE FROM t_reader_offline";
    BOOL result = [_dbInstance executeUpdate:sqlCmd];
    if (result) {
        
    }
    else {
    }
    
}




- (NSDictionary*)getAllBrowseHistory {
  
    NSString* sqlCmd = @"SELECT book_id,book_name,chapter_name,chapter_id,page_index FROM t_reader_history";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    while ([resultSet next]) {
        NSString* bookId = [resultSet objectForColumn:@"book_id"];
        NSString* chapterName = [resultSet objectForColumn:@"chapter_name"];
        NSString* chapterId = [resultSet objectForColumn:@"chapter_id"];
        NSString* chapter = [NSString stringWithFormat:@"%@\r%@", chapterName, chapterId];
        [dictionary setObject:chapter forKey:bookId];
    }
    return dictionary;
}





- (void)addChargeHistory:(NSString*)orderId type:(NSString*)type {
    //t_charge_history(id INTEGER PRIMARY KEY AUTOINCREMENT, order_id TEXT, receipt TEXT, reserver_1 TEXT, reserver_2 TEXT,  reserver_3  TEXT)
    NSString* sqlCmd = @"INSERT INTO t_charge_history(order_id, receipt, charge_type, reserver_1, reserver_2, reserver_3) VALUES(?, ?, ?, ?, ?, ?)";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, orderId, @"", type, @"", @"", @""];
    if (result) {
    }
    else {
    }
    
}


- (void)deleteChargeHistory:(NSString*)orderId {
    
    NSString* sqlCmd = @"DELETE FROM t_charge_history WHERE order_id = ?";
    BOOL result = [_dbInstance executeUpdate:sqlCmd, orderId];
    if (result) {
        
    }
    else {
    }
    
}



- (NSArray*)getAllChargeHistory {
    
    NSMutableArray* array = [NSMutableArray array];
    NSString* sqlCmd = @"SELECT order_id, charge_type FROM t_charge_history";
    FMResultSet *resultSet = [_dbInstance executeQuery:sqlCmd];
    while ([resultSet next]) {
        NSString* orderId = [resultSet objectForColumn:@"order_id"];
        NSString* chargeType = [resultSet objectForColumn:@"charge_type"];
        
        if (!orderId) {
            orderId = @"";
        }
        
        if (!chargeType) {
            chargeType = @"";
        }
        
        NSDictionary* dictionary = @{
          @"orderId" : orderId,
          @"chargeType" : chargeType
          };

        [array addObject:dictionary];
    }
    
    return array;
}

@end
