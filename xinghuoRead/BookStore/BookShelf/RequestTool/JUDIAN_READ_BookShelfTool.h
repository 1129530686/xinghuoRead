//
//  JUDIAN_READ_BookShelfTool.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ReadListUrl @"/appprogram/user/book-reading"
#define DeleteReadRecordUrl @"/appprogram/user/book-reading-remove"
#define ReadTimeUrl @"/appprogram/user-read/duration-info"

#define DeleteLikeRecordUrl @"/appprogram/user-favorite-book/delete"
#define addLikeUrl @"/appprogram/user-favorite-book/add"
#define likeListUrl @"/appprogram/user/user-favorite-book"


@interface JUDIAN_READ_BookShelfTool : NSObject
//阅读列表
+(void)getReadListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//删除阅读记录
+ (void)deleteReadRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//阅读时长
+ (void)getReadTimeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//收藏删除
+(void)deleteLikeRecordtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//收藏添加
+(void)addLikeRecordtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//收藏列表
+(void)LikeRecordListtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;



@end

NS_ASSUME_NONNULL_END
