//
//  JUDIAN_READ_BookMallTool.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BookHomeList @"/appprogram/fiction/v2/book-screen-recommend"
#define BookHomeListV0 @"/appprogram/fiction/book-screen-recommend"
#define ParentCategory @"/appprogram/fiction-category/screen-parent"
#define BannarImageUrl @"/appprogram/fiction/book-mall-carousel"
#define BookHomeCategory @"/appprogram/fiction-category/sub-category"
#define HotSearchBookUrl @"/appprogram/fiction/recommend-books"
#define SearchResultUrl @"/appprogram/fiction/book-search"
#define FastSearchResultUrl @"/appprogram/fiction-search/quick-search"
#define CategoryConditionUrl @"/appprogram/fiction-category/screen-sub"
#define ConditionBookUrl @"/appprogram/fiction/book-list"
#define shareUrl @"/appprogram/fiction/book-share"
#define ContentCompanyUrl @"/appprogram/fiction/query-content-company"

//v 1.2
#define BookOneTowNewList @"/appprogram/fiction/book-channel-store"
#define BookNewList @"/appprogram/fiction/book-channel"
#define BookPullList @"/appprogram/fiction/v2/book-recommend-pull-up"

@interface JUDIAN_READ_BookMallTool : NSObject
//书城首页列表1.1
+(void)getBookHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//书城首页列表1.0
+(void)getBookHomeListV0WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//书城父级分类（导航栏）
+(void)getParentCategoryListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//书城轮播图
+(void)getBannarListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//书城首页分类
+(void)getCategoryWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//推荐书籍
+(void)getHotBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//搜索结果
+(void)getSearchBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//搜索提示
+(void)getFastSearchBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//分类筛选条件获取，
+(void)getSelectConditionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//分类筛选条件下书籍获取
+(void)getSelectConditionBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//分享
+(void)shareBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//内容商列表
+(void)getContentCompanyWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//v1.2 书城
+(void)getNewBookOneTwoHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//v1.2 书城
+(void)getNewBookHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;

//v1.2 上拉加载
+(void)getNewBookHomePullListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock;


@end

NS_ASSUME_NONNULL_END
