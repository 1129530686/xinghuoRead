//
//  JUDIAN_READ_DiscoveryTool.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ArticlesListUrl @"/appprogram/articles/article-list"
#define ArticleDetailUrl @"/appprogram/articles/article-detail"
#define ArticleTagUrl @"/appprogram/articles-tag/list"
#define AdvertStatusUrl @"/appprogram/V2/config"
#define addRecordUrl @"/appprogram/articles/read-record"

#define ArticlesListUrlV1  @"/appprogram/articles/V2/article-list"
#define ArticleTagUrlV1  @"/appprogram/articles-tag/V2/list"


@interface JUDIAN_READ_DiscoveryTool : NSObject

// 发现首页
+ (void)getArticleListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;
//发现详情页
+ (void)getArticleDetailWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;
//发现标签
+ (void)getArticleTagWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;
//广告开关
+ (void)getAdvertStatusUrlWithParams:(CompletionBlock)finishblock;
//阅读记录
+ (void)addReadRecorUrlWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;


//1.1
// 发现首页
+ (void)getArticleListV1WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//发现标签
+ (void)getArticleTagV1WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;


@end

NS_ASSUME_NONNULL_END
