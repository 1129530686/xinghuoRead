//
//  JUDIAN_READ_NovelModel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_ChapterTitleModel.h"
#import "JUDIAN_READ_AppreciateAmountModel.h"
#import "JUDIAN_READ_CacheContentModel.h"
#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_ArticleListModel.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_UserAppreciatedChapterModel.h"

#import "SSZipArchive.h"
#import "JUDIAN_READ_TestHelper.h"


#define COMMAND_CHAPTER_CONTENT @"/appprogram/fiction-chapter/chapter-content"
#define COMMAND_CHAPTER_LIST @"/appprogram/fiction-chapter/chapter-list"
#define COMMAND_FICTION_DOWNLOAD_LINK @"/appprogram/fiction/download-link"
#define COMMAND_APPRECIATE_AVATAR_LIST_V2 @"/appprogram/fiction-reward/v2/reward-list"
#define COMMAND_ADD_USER_READ_CHAPTER @"/appprogram/fiction-chapter/book-reading-add"
#define COMMAND_DOWNLOAD_CHAPTER @"/appprogram/fiction-chapter/download"
#define COMMAND_APPRECIAT_AMOUNT_LIST @"/appprogram/fiction-reward/type-list"
#define COMMAND_APPRECIAT_MONEY @"/appprogram/order/create-reward"
#define COMMAND_APPRECIATE_ORDER_UPDATE @"/appprogram/order/iap-update-reward"
#define COMMAND_GET_APPRECIATED_LIST @"/appprogram/user-reward/person-reward"
#define COMMAND_IS_BOOK_CACHED @"/appprogram/fiction/is-cache"
#define COMMAND_IS_BOOK_IN_COLLECTION @"/appprogram/user-favorite-book/list2"
#define COMMAND_COLLECT_BOOK @"/appprogram/user-favorite-book/add"

#define MAX_CHAPTER_COUNT 100

#define JUDIAN_PARAGRAPH_HEADER_SPACE @"　　"


@interface JUDIAN_READ_NovelManager ()

@property (nonatomic,strong) NSMutableArray  *cacheBookArray;


//@property(nonatomic, strong)NSMutableArray* pageArray;
@end


@implementation JUDIAN_READ_NovelManager


+ (instancetype)shareInstance {
    static JUDIAN_READ_NovelManager* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JUDIAN_READ_NovelManager alloc]init];
    });
    
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self != nil) {
        //_pageArray = [NSMutableArray array];
        //_chapterDictionary = [NSMutableDictionary dictionary];
        _downloadingDictionary = [NSMutableDictionary dictionary];
        //_userReadingModel = [[JUDIAN_READ_UserReadingModel alloc]init];
        
    }
    
    return self;
}






- (BOOL)isFirstChapter {
    return FALSE;
}



- (BOOL)isLastChapter {
    return FALSE;
    
}


- (void)updateReadingModel:(BOOL)isNextChapter {


}





- (void)gotoNextChapter {

}



- (void)gotoPreviousChapter {

}









- (CTFrameRef)getFrameRef:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model {

    if (pageIndex < 0) {
        //NSLog(@"KK::负一");
        return nil;
    }
    
    if (pageIndex >= model.pageArray.count) {
        //NSLog(@"KK::越界");
        return nil;
    }
    
    NSValue* value = model.pageArray[pageIndex];
    NSRange range = [value rangeValue];
    
    NSMutableAttributedString* attributedString = [[JUDIAN_READ_CoreTextManager shareInstance] createAttributedString:model.content];
    CTFrameRef frameRef = [[JUDIAN_READ_CoreTextManager shareInstance] createFrameRef:attributedString range:range page:pageIndex model:model];
    return frameRef;
    
}




- (void)adjustTextStyle:(responseCallback)block {
    

    
}



- (void)clearPage {
   // [_pageArray removeAllObjects];
}


- (void)getNovelChapterList:(NSString*)bookId block:(responseCallback)block failure:(responseCallback)failure isCache:(BOOL)isCache {

    if (!bookId) {
        return;
    }
    
    //从本地加载目录
    NSArray* titleArray = [self getNovelChapterListFromFile:bookId];
    if (isCache && titleArray) {
        if (block) {
            block(titleArray);
        }
        return;
    }
    
    //从服务端请求数据
    NSDictionary* dictionary = @{@"id" : bookId};
    [JUDIAN_READ_APIRequest POST:COMMAND_CHAPTER_LIST params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        if (response) {
            NSArray* array = response[@"data"][@"list"];
            NSArray* titleArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_ChapterTitleModel class] json:array];
            if (block) {
                block(titleArray);
            }

        }
        else if(error){
            if (failure) {
                failure(@"0");
            }
        }

    }];
    
}


- (NSArray*)getNovelChapterListFromFile:(NSString*)bookId {
    NSString* bookPath = [self getCatalogFilePath:bookId ext:CATALOG_EXT];
    NSArray* array = [NSArray unarchiveFile:bookPath];;
    return array;
}


- (JUDIAN_READ_CacheContentModel*)getNovelChapterContentFromFile:(NSString*)bookId chapterId:(NSString*)chapterId {
    NSString* chapterPath = [self getChapterFilePath:bookId chapterId:chapterId ext:FICTION_EXT];
    JUDIAN_READ_CacheContentModel* model = [NSKeyedUnarchiver unarchiveObjectWithFile:chapterPath];
    return model;
}



- (BOOL)isExistCatalog:(NSString*)bookId {
    NSString* bookPath = [self getCatalogFilePath:bookId ext:CATALOG_EXT];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:bookPath]) {
        return TRUE;
    }
    
    return FALSE;
}




- (BOOL)isExistChapter:(NSString*)bookId chapterId:(NSInteger)chapterId {
    
    NSString* chapterIdStr = [NSString stringWithFormat:@"%ld", chapterId];
    NSString* chapterPath = [self getChapterFilePath:bookId chapterId:chapterIdStr ext:FICTION_EXT];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:chapterPath]) {
        return TRUE;
    }
    
    return FALSE;
}



- (NSString*)getCatalogFilePath:(NSString*)bookId ext:(NSString*)ext {
    NSString* bookPath = @"";
    bookPath = [NSString stringWithFormat:@"%@/%@", NOVEL_DOWNLOAD_PATH, bookId];
    bookPath = [JUDIAN_READ_APIRequest makePath:bookPath];
    bookPath = [NSString stringWithFormat:@"%@/%@.%@", bookPath, bookId, ext];
    return bookPath;
}



- (NSString*)getFictionDirectory:(NSString*)bookId {
    NSString* bookPath = @"";
    bookPath = [NSString stringWithFormat:@"%@/%@", NOVEL_DOWNLOAD_PATH, bookId];
    bookPath = [JUDIAN_READ_APIRequest makePath:bookPath];
    return bookPath;
}




- (NSString*)getChapterFilePath:(NSString*)bookId chapterId:(NSString*)chapterId ext:(NSString*)ext {
    
    NSString* bookPath = @"";
    bookPath = [NSString stringWithFormat:@"%@/%@", NOVEL_DOWNLOAD_PATH, bookId];
    bookPath = [JUDIAN_READ_APIRequest makePath:bookPath];
    bookPath = [NSString stringWithFormat:@"%@/%@.%@", bookPath, chapterId, ext];
    
    return bookPath;
}




- (void)getNovelUrl:(NSString*)bookId  block:(responseCallback)block {
    
    if (!bookId) {
        return;
    }
    
    NSDictionary* dictionary = @{@"nid" : bookId};
    [JUDIAN_READ_APIRequest POST:COMMAND_FICTION_DOWNLOAD_LINK params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSString* downUrl = response[@"data"][@"down_url"];
        if (block) {
            block(downUrl);
        }
    }];

}



- (void)downloadNovel:(NSString*)fileUrl progress:(void (^)(CGFloat progress)) downloadProgressBlock {
    
    [JUDIAN_READ_APIRequest downloadFile:fileUrl path:NOVEL_DOWNLOAD_PATH  progress:^(CGFloat progress) {
        
        if (downloadProgressBlock) {
            downloadProgressBlock(progress);
        }

    }   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
        if (!error) {
            
            NSString *zipPath = [filePath path];
            NSRange range = [zipPath rangeOfString:@"." options:NSBackwardsSearch];
            NSString* unzipPath = [zipPath substringToIndex:range.location];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                //zip文件解压
                [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
                
                //删除zip文件
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:zipPath error:nil];
                
                //[[JUDIAN_READ_NovelManager shareInstance].userReadingModel addBook];
                
#if 0
                //遍历解压后的文件
                NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:unzipPath];
                NSString* file = nil;
                
                while((file=[enumerator nextObject])) {
                    if([[file pathExtension] isEqualToString:@"txt"]) {
                        NSString* content = [NSString stringWithContentsOfFile:[unzipPath stringByAppendingPathComponent:file] encoding:NSUTF8StringEncoding error:nil];
                    }
                }
                
#endif
                
            });
        }
        
    }];
}

#pragma mark loading view
- (void)startLoadingView:(BOOL)show {
    if (!_viewController) {
        return;
    }
    
    [_viewController showLoadingView:show];
}

#pragma mark fiction chapter
- (void)getFictionChapterContent:(NSString*)chapterId bookId:(NSString*)bookId block:(responseCallback) block {
    
    if (!chapterId || !bookId) {
        block(nil);
        return;
    }
    

    //本地有缓存
    JUDIAN_READ_ChapterContentModel* currentChpaterModel = (JUDIAN_READ_ChapterContentModel*)[self getNovelChapterContentFromFile:bookId chapterId:chapterId];
    if (currentChpaterModel && (currentChpaterModel.next_chapter || currentChpaterModel.prev_chapter)) {
        currentChpaterModel.content = [self cleanContent:currentChpaterModel.content];
        block(currentChpaterModel);
        
        [self getOtherChapterContent:currentChpaterModel bookId:bookId block:block];
    }
    else {
        [self startLoadingView:YES];
        [self getCurrentChapterContent:chapterId bookId:bookId block:block];
    }
}



- (void)getCurrentChapterContent:(NSString*)chapterId bookId:(NSString*)bookId block:(responseCallback) block {
    
    if (chapterId.length <= 0) {
        [self startLoadingView:NO];
        return;
    }
    
    //从服务端请求数据
    NSDictionary* dictionary = @{
                                 @"nid" : bookId,
                                 //@"chapnum" : chapterId
                                 @"chapnums" : chapterId
                                 };
    
    WeakSelf(that);
    [JUDIAN_READ_APIRequest POST:COMMAND_CHAPTER_CONTENT params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        [that startLoadingView:NO];
        if (!response) {
            block(error);
            return;
        }
        
        NSDictionary* array = response[@"data"][@"list"];
        NSArray* chapterArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_ChapterContentModel class] json:array];
        if (chapterArray.count <= 0) {
            JUDIAN_READ_CacheContentModel* model = [[JUDIAN_READ_CacheContentModel alloc] init];
            model.content = @"";
            block(model);
            return;
        }
        
        for (JUDIAN_READ_CacheContentModel* element in chapterArray) {
            
            if (element.status.intValue == 1) {
                JUDIAN_READ_CacheContentModel* model = [[JUDIAN_READ_CacheContentModel alloc] init];
                model.content = @"";
                block(model);
                return;
            }
            
            JUDIAN_READ_ChapterContentModel* model = (JUDIAN_READ_ChapterContentModel*)element;
            model.content = [that cleanContent:model.content];
            block(model);

            NSString* chapterPath = [self getChapterFilePath:bookId chapterId:element.chapnum ext:FICTION_EXT];
            [NSKeyedArchiver archiveRootObject:element toFile:chapterPath];
            
            [that getOtherChapterContent:element bookId:bookId block:block];

        }
    }];
    
}



- (void)getOtherChapterContent:(JUDIAN_READ_CacheContentModel*)model bookId:(NSString*)bookId block:(responseCallback) block  {
    
    NSString* chpaters = @"";
    chpaters = [self getChapterIds:model bookId:bookId];
    
    if (chpaters.length <= 0) {
        return;
    }
    
    //从服务端请求数据
    NSDictionary* dictionary = @{
                                 @"nid" : bookId,
                                 //@"chapnum" : chapterId
                                 @"chapnums" : chpaters
                                 };
    
    [JUDIAN_READ_APIRequest POST:COMMAND_CHAPTER_CONTENT params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        if (!response) {
            return;
        }
        
        NSDictionary* array = response[@"data"][@"list"];
        NSArray* chapterArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_ChapterContentModel class] json:array];
        if (chapterArray.count <= 0) {
            JUDIAN_READ_CacheContentModel* model = [[JUDIAN_READ_CacheContentModel alloc] init];
            model.content = @"";
            block(model);
            return;
        }
        
        for (JUDIAN_READ_CacheContentModel* element in chapterArray) {
            
            if (element.status.intValue == 1) {
                JUDIAN_READ_CacheContentModel* model = [[JUDIAN_READ_CacheContentModel alloc] init];
                model.content = @"";
                block(model);
                return;
            }

            NSString* chapterPath = [self getChapterFilePath:bookId chapterId:element.chapnum ext:FICTION_EXT];
            [NSKeyedArchiver archiveRootObject:element toFile:chapterPath];
        }
    }];

}


- (NSString*)getChapterIds:(JUDIAN_READ_CacheContentModel*)model bookId:(NSString*)bookId {
    
    BOOL existedChapter = FALSE;
    
    NSString* chapterIds = @"";
    NSInteger previousChapterId = model.prev_chapter.integerValue;
    NSInteger nextChapterId = model.next_chapter.integerValue;
    
    if (previousChapterId > 0) {
        existedChapter = [self isExistChapter:bookId chapterId:previousChapterId];
        if (!existedChapter) {
            NSString* chapterStr = [NSString stringWithFormat:@"%ld", (long)previousChapterId];
            chapterIds = [chapterIds stringByAppendingString:chapterStr];
            chapterIds = [chapterIds stringByAppendingString:@","];
        }
    }
    
    if (nextChapterId > 0) {
        existedChapter = [self isExistChapter:bookId chapterId:nextChapterId];
        if (!existedChapter) {
            NSString* chapterStr = [NSString stringWithFormat:@"%ld", (long)nextChapterId];
            chapterIds = [chapterIds stringByAppendingString:chapterStr];
            chapterIds = [chapterIds stringByAppendingString:@","];
        }
    }
    
    if (chapterIds.length > 0) {
        chapterIds = [chapterIds substringToIndex:chapterIds.length - 1];
    }
    
    
    return chapterIds;
}






- (NSString*)cleanContent:(NSString*)content {
    
    if (!content || content.length <= 0) {
        return @"";
    }
    
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* spaceStr = @"\n";
    spaceStr = [spaceStr stringByAppendingString:JUDIAN_PARAGRAPH_HEADER_SPACE];
    
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    content = [JUDIAN_PARAGRAPH_HEADER_SPACE stringByAppendingString:content];
    content = [content stringByReplacingRegex:@"\\s*\\n+\\s*" options:(NSRegularExpressionCaseInsensitive) withString:spaceStr];
    
    return content;
}



- (void)deleteLastChapterCache:(NSString*)bookId chapterId:(NSString*)chapterId {

    if (bookId.length <= 0 || chapterId.length <= 0) {
        return;
    }
    
    JUDIAN_READ_ChapterContentModel* currentChpaterModel = (JUDIAN_READ_ChapterContentModel*)[self getNovelChapterContentFromFile:bookId chapterId:chapterId];
    
    if (!currentChpaterModel) {
        return;
    }
    
    if (currentChpaterModel.next_chapter.intValue < 0) {
        NSString* chapterPath = [self getChapterFilePath:bookId chapterId:chapterId ext:FICTION_EXT];
        [JUDIAN_READ_TestHelper deleteCachePath:chapterPath];
    }

#if 0
    NSInteger lastIndex = array.count - 1;
    if (lastIndex < 0) {
        return;
    }
    
    if (bookId.length <= 0) {
        return;
    }
    
    NSInteger high = lastIndex;
    
    while (high >= 0) {
        JUDIAN_READ_ChapterTitleModel* model = array[high];
        JUDIAN_READ_ChapterContentModel* currentChpaterModel = (JUDIAN_READ_ChapterContentModel*)[self getNovelChapterContentFromFile:bookId chapterId:model.chapnum];
        
        if (lastIndex - high >= 150) {
            break;
        }
        
        if ((currentChpaterModel.next_chapter.intValue < 0)) {
            
            if (high != lastIndex) {//最后一章,连载书籍目录有更新，则删除最后一章的缓存文件
                NSString* chapterPath = [self getChapterFilePath:bookId chapterId:model.chapnum ext:FICTION_EXT];
                [JUDIAN_READ_TestHelper deleteCachePath:chapterPath];
            }

            break;
        }
        
        high--;
    }
#endif

}



- (void)getUserAppreciateAvatarList:(NSDictionary*)dictionary block:(CompletionBlock)block needTotalPage:(BOOL)needTotalPage {
    
    if (!dictionary) {
        return;
    }
    
    [JUDIAN_READ_APIRequest POST:COMMAND_APPRECIATE_AVATAR_LIST_V2 params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (!response) {
            block(nil, @(0));
            return;
        }
        NSArray* array = response[@"data"][@"list"];
        array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserAppreciatedChapterModel class] json:array];
        NSNumber* total = response[@"data"][@"total"];
        if (needTotalPage) {
            total = response[@"data"][@"total_page"];
        }
        
        block(array, total);
    }];
    
}


- (void)addUserReadChapter:(NSString*)bookId chapterId:(NSString*)chapterId {
    
    if (!chapterId || !chapterId) {
        return;
    }
    
    NSDictionary* dictionary = @{
      @"nid" : bookId,
      @"chapnum" : chapterId
      };

    [JUDIAN_READ_APIRequest POST:COMMAND_ADD_USER_READ_CHAPTER params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {

    }];
    
}




- (void)getAppreciateMoneyAmountList:(responseCallback)block {
    
    NSDictionary* dictionary = @{
                                 @"type" : @"ios"
                                 };
    
    [JUDIAN_READ_APIRequest POST:COMMAND_APPRECIAT_AMOUNT_LIST params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (block) {
            NSDictionary* array = response[@"data"][@"list"];
            NSArray* amountArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_AppreciateAmountModel class] json:array];
            block(amountArray);
        }
    }];
}





- (void)appreciateChapter:(NSDictionary*)dictionary block:(responseCallback)block {
    
    [JUDIAN_READ_APIRequest POST:COMMAND_APPRECIAT_MONEY params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (block) {
            if (response) {
                block(response[@"data"][@"info"]);
            }
            else {
                block(nil);
            }
        }
    }];
}





- (void)updteAppreciateStatus:(NSDictionary*)dictionary block:(responseCallback)block {
    
    [JUDIAN_READ_APIRequest POST:COMMAND_APPRECIATE_ORDER_UPDATE params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (block) {
            if (error) {
                block(@"0");
            }
            else {
                block(@"1");
            }
        }
    }];
}



- (void)downloadChapter:(NSString*)bookId begin:(NSString*)begin size:(NSString*)size block:(responseCallback)block failure:(responseCallback) failure {
    
    if (!bookId || !size || !begin) {
        return;
    }
    
    NSDictionary* dictionary = @{
        @"nid" : bookId,
        @"chapnum" : begin,
        @"size" : size
    };
    

    [JUDIAN_READ_APIRequest POST:COMMAND_DOWNLOAD_CHAPTER params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        if (response) {
            
            NSArray* array = response[@"data"][@"list"];
            NSArray* contentArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_CacheContentModel class] json:array];
            
            for (JUDIAN_READ_CacheContentModel* model in contentArray) {
                NSString* chapterPath = [self getChapterFilePath:bookId chapterId:model.chapnum ext:FICTION_EXT];
                [NSKeyedArchiver archiveRootObject:model toFile:chapterPath];
            }
        
            if (block) {
                block(@(contentArray.count));
            }
            
        }
        else if(failure) {
            failure(@"");
        }
        
    }];
}


#pragma mark 小说章节序列化
- (void)serializeFictionFromServer:(NSString*)bookId bookName:(NSString*)bookName begin:(NSString*)begin size:(NSString*)size block:(responseCallback)block {

    [self.downloadingDictionary setObject:@"1" forKey:bookId];
    
    WeakSelf(that);
    [[JUDIAN_READ_NovelManager shareInstance] getNovelChapterList:bookId block:^(id  _Nonnull parameter) {
    
        [that saveCacheFlag:bookId];
        
        NSArray* chapterList = parameter;
        NSString* bookPath = @"";
        bookPath = [ [JUDIAN_READ_NovelManager shareInstance] getCatalogFilePath:bookId ext:CATALOG_EXT];
        [chapterList archiveFile:bookPath];
    
        NSInteger undoneChapterCount = [size intValue] - [begin intValue];
        
        NSInteger batchCount = undoneChapterCount / MAX_CHAPTER_COUNT;
        NSInteger surpuls = undoneChapterCount % MAX_CHAPTER_COUNT;
        
        if (surpuls > 0) {
            batchCount++;
        }
        
        __block NSInteger finishChapter = 0;
        NSString* sizeStr = [NSString stringWithFormat:@"%ld", (NSInteger)MAX_CHAPTER_COUNT];
        dispatch_queue_t concurrent_queue = dispatch_queue_create("serializeFictionQueue", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(concurrent_queue, ^{

            dispatch_semaphore_t signal;
            signal = dispatch_semaphore_create(0);
            __block BOOL responseFailure = FALSE;
            for (NSInteger m = 1; m <= batchCount; m++) {

                NSInteger start = (m - 1) * MAX_CHAPTER_COUNT + 1 + [begin intValue];
                NSString* startStr = [NSString stringWithFormat:@"%ld", (NSInteger)start];
                
                [[JUDIAN_READ_NovelManager shareInstance] downloadChapter:bookId begin:startStr size:sizeStr block:^(id  _Nonnull parameter) {

                    NSNumber* number = parameter;
                    finishChapter += [number intValue];
                    responseFailure = FALSE;
                    
                    dispatch_semaphore_signal(signal);
                    
                } failure:^(id  _Nonnull parameter) {
                    responseFailure = YES;
                    
                    dispatch_semaphore_signal(signal);
                }];

                dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);

                if (responseFailure) {
                    break;
                }
            }
            
            NSString* tip = @"缓存失败";
            NSString* result = @"0";
            if ((finishChapter + [begin intValue]) >= [size intValue]) {
                result = @"1";
                tip = @"缓存成功";
            }

            NSString* type = [JUDIAN_READ_Account currentAccount].vip_type;
            NSString* sex = [JUDIAN_READ_Account currentAccount].sex;
            if (!type) {
                type = @"";
            }
            
            if (!sex) {
                sex = @"";
            }
            
            NSDictionary* dictionary = @{@"state" : tip,
                                         @"vip_type" : type,
                                         @"sex" : sex
                                         };
            [MobClick event:click_cache attributes:dictionary];
            [GTCountSDK trackCountEvent:click_cache withArgs:dictionary];
            
            if (block) {
                if ([result isEqualToString:@"1"]) {
                    [JUDIAN_READ_UserReadingModel addBook:bookId bookName:bookName chapterCount:size];
                }
                
                [that.downloadingDictionary removeObjectForKey:bookId];
                block(result);
            }
        
        } );

    } failure:^(id  _Nonnull parameter) {
        [that.downloadingDictionary removeObjectForKey:bookId];
        block(@"0");
    } isCache:NO];

}


- (void)saveCacheFlag:(NSString*)bookId {
    NSString* chapterPath = [self getChapterFilePath:bookId chapterId:_DOWN_FICTION_FLAG_ ext:FICTION_EXT];
    JUDIAN_READ_CacheContentModel* model = [[JUDIAN_READ_CacheContentModel alloc] init];
    [NSKeyedArchiver archiveRootObject:model toFile:chapterPath];
}




- (void)downLoadNextBookComplectionBlock:(responseCallback)finishBlock{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    
   
    dispatch_source_set_event_handler(timer, ^{
        
        if (self.cacheBookArray.count <= 0) {
            dispatch_cancel(timer);
            timer = nil;
            return;
        }
        
        JUDIAN_READ_ReadListModel *model = self.cacheBookArray[0];
        NSString *isDownloading = [JUDIAN_READ_NovelManager shareInstance].downloadingDictionary[model.nid];
        if (!isDownloading) {
            NSInteger begin = [[JUDIAN_READ_NovelManager shareInstance] travelFictionDirectory:model.nid];
            [self serializeFictionFromServer:model.nid bookName:model.bookname begin:[NSString stringWithFormat:@"%ld", (long)begin] size:model.chapters_num block:^(id  _Nullable parameter) {
                
                NSString* result = parameter;
                if ([result isEqualToString:@"0"]) {
                    return;
                }
                
                if (self.cacheBookArray.count > 0) {
                    [self.cacheBookArray removeObjectAtIndex:0];
                }
                
                if (finishBlock) {
                    finishBlock(parameter);
                }
                
            }];
        }
    });
    
    dispatch_resume(timer);

}




- (BOOL)isFictionInDocument:(NSString*)bookId chpaterId:(NSString*)chapterId {

    JUDIAN_READ_ChapterContentModel* model = (JUDIAN_READ_ChapterContentModel*)[self getNovelChapterContentFromFile:bookId chapterId:chapterId];
    
    if (model) {
        return TRUE;
    }
    
    return FALSE;
}


#pragma mark 遍历已经序列化的文件
- (NSInteger)travelFictionDirectory:(NSString*)bookId {

    if (!bookId) {
        return 0;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* bookPath = [self getFictionDirectory:bookId];

    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:bookPath];
    NSString* file = nil;
    
    NSMutableArray* fileArray = [NSMutableArray array];
    
    while((file = [enumerator nextObject])) {

        if([[file pathExtension] isEqualToString:FICTION_EXT]) {
            
            NSInteger length = file.length - FICTION_EXT.length - 1;
            NSString* fileIndex = [file substringToIndex:length];
   
            [fileArray addObject:fileIndex];
        }
    }
    
    NSArray* resultArray = [fileArray sortedArrayUsingFunction:compareFileName context:nil];
    if (resultArray.count > 0) {
        return resultArray.count;
    }
    else {
        return 0;
    }

}


- (NSString*)getSavedChapterRateInDocument:(NSString*)bookId totalChapter:(NSInteger)totalChapter {
    
    NSInteger count = [self travelFictionDirectory:bookId];
    CGFloat floatRate = (CGFloat)(count) / (CGFloat)totalChapter;
    NSInteger rate = floatRate * 100;
    
    if (rate <= 0) {
        return @"缓存";
    }
    
    if (count >= totalChapter) {
        return @"已缓存";
    }

    NSString* rateStr = [NSString stringWithFormat:@"已缓存%ld", (long)rate];
    rateStr = [rateStr stringByAppendingString:@"%"];
    return rateStr;
}




NSInteger compareFileName(NSString* nameStr1, NSString* nameStr2, void *context) {
    
    int v1 = [nameStr1 intValue];
    int v2 = [nameStr2 intValue];

    if (v1 > v2) {
        return NSOrderedAscending;
    } else if (v1 < v2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
    
}



#pragma mark 用户赞赏记录
- (void)getFictionAppreciateList:(NSString*)pageIndexStr block:(responseCallback)block {
    
    if (!pageIndexStr) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"page" : pageIndexStr,
                                 @"pageSize" : @"20"
                                 };
    
    [JUDIAN_READ_APIRequest POST:COMMAND_GET_APPRECIATED_LIST params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (block) {
            block(response[@"data"]);
        }
    }];
    
}




- (void)getBookCacheState:(NSString*)bookId block:(responseCallback)block {
    
    if (!bookId) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"nid" : bookId
                                 };
    
    [JUDIAN_READ_APIRequest POST:COMMAND_IS_BOOK_CACHED params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionary = response[@"data"][@"info"];
        //NSString* cache = dictionary[@"cache"];
        if (block) {
            block(dictionary);
        }
    }];
    
}

#pragma mark 书籍收藏
- (void)isBookInCollection:(NSString*)bookId block:(responseCallback)block {
    
    if (!bookId) {
        return;
    }
   
    NSDictionary* dictionary = @{
                                 @"page" : @"1",
                                 @"nid" : bookId
                                 };
    
    [JUDIAN_READ_APIRequest POST:COMMAND_IS_BOOK_IN_COLLECTION params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        NSString* count = response[@"data"][@"total"];
        if (block) {
            block(count);
        }
    }];
    
}



- (void)collectBook:(NSString*)bookId block:(responseCallback)block {
    
    if (!bookId) {
        return;
    }
    
    NSDictionary* dictionary = nil;    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length > 0) {
        dictionary = @{
                       @"nid" : bookId,
                       @"uid_b" : uid
                       };
    }
    else {
        dictionary = @{
                       @"nid" : bookId
                       };
    }

    [JUDIAN_READ_APIRequest POST:COMMAND_COLLECT_BOOK params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (block) {
            block(response);
        }
    }];
    
}



#pragma mark 将书籍添加到准备下载队列
- (void)saveWillDownLoadBook:(id)book{
    if (book) {
        [self.cacheBookArray addObject:book];
    }
}

#pragma mark 获取所有等待下载书籍
- (NSArray *)getAllWillDownLoadBooks{
    return [self.cacheBookArray yy_modelCopy];
}


- (NSMutableArray *)cacheBookArray{
    if (!_cacheBookArray) {
        _cacheBookArray = [NSMutableArray array];
    }
    return _cacheBookArray;
}


#pragma mark 获取相关推荐书籍
- (void)loadRecommendFeedData:(NSString*)bookId block:(responseCallback)block {
    
    if (bookId.length <= 0) {
        return;
    }
    
    NSDictionary* dictionary = @{
                                 @"id" : bookId
                                 };
    
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/articles/fiction-end-list" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSArray* array = response[@"data"][@"list"];
        if (block) {
            array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_ArticleListModel class] json:array];
            block(array);
        }
    }];
    
}

#pragma mark 上传阅读时长
- (void)updateUserReadDuration:(NSString*)bookId chapterId:(NSString*)chapterId duration:(NSString*)duration block:(responseCallback)block {
    
    if (bookId.length <= 0) {
        return;
    }
    
    if (chapterId.length <= 0) {
        return;
    }
    
    if (duration.length <= 0) {
        return;
    }
    
    
    NSDictionary* dictionary = @{
                                 @"nid" : bookId,
                                 @"chapnum" : chapterId,
                                 @"duration" : duration
                                 };
    
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user-read/duration-report" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* obj = response[@"data"][@"info"];
        if (block) {
            block(obj);
        }
    }];
    
}


@end
