//
//  JUDIAN_READ_BookMallTool.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BookMallTool.h"
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_ReadListModel.h"
#import "JUDIAN_READ_BannarModel.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_CategoryModel.h"
#import "JUDIAN_READ_FastSearchModel.h"
#import "JUDIAN_READ_BookStoreModel.h"

@implementation JUDIAN_READ_BookMallTool

+ (NSDictionary *)setParaDic:(NSDictionary *)dic pageCount:(NSInteger)page{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    if (dic.count) {
        [paras setDictionary:dic];
    }
    return paras;
}

//书城首页列表
+(void)getBookHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookHomeList params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookStoreModel class] json:response[@"data"][@"list"]];
            JUDIAN_READ_BookStoreModel *model = arr.firstObject;
            if (model) {
                model.pages = response[@"data"][@"pages"];
            }
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

+(void)getBookHomeListV0WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookHomeListV0 params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"][@"books"]) {
                JUDIAN_READ_ReadListModel *model = [JUDIAN_READ_ReadListModel yy_modelWithJSON:dic];
                model.title = response[@"data"][@"list"][@"title"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//父级分类
+ (void)getParentCategoryListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ParentCategory params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//书城首页分类
+(void)getCategoryWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookHomeCategory params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_CategoryModel *model = [JUDIAN_READ_CategoryModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//书城轮播图
+(void)getBannarListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BannarImageUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_BannarModel *model = [JUDIAN_READ_BannarModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//推荐书籍
+(void)getHotBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:HotSearchBookUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_ReadListModel *model = [JUDIAN_READ_ReadListModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//搜索结果
+(void)getSearchBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:SearchResultUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_BookDetailModel *model = [JUDIAN_READ_BookDetailModel yy_modelWithJSON:dic];
                model.bookname = [model.bookname stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//搜索提示
+(void)getFastSearchBookListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:FastSearchResultUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_FastSearchModel *model = [JUDIAN_READ_FastSearchModel yy_modelWithJSON:dic];
//                model.title = [model.title stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}


//分类筛选条件获取，
+(void)getSelectConditionWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:CategoryConditionUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSMutableArray *newArr = [NSMutableArray array];
            for (NSMutableArray *arr in response[@"data"][@"list"]) {
                NSArray *arr1 = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_CategoryModel class] json:arr];
                [newArr addObjectsFromArray:arr1];
            }
            finishblock([newArr yy_modelCopy],nil);
        }
    }];
}

//分类筛选条件下书籍获取
+ (void)getSelectConditionBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ConditionBookUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookDetailModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//分享
+(void)shareBookWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:shareUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            JUDIAN_READ_BookDetailModel *model = [JUDIAN_READ_BookDetailModel yy_modelWithJSON:response[@"data"][@"info"]];
            NSString* url = model.cover;
            NSRange range = [url rangeOfString:@"?" options:(NSBackwardsSearch)];
            if (range.length > 0) {
                model.cover = [url substringToIndex:range.location];
            }
            
            finishblock([model yy_modelCopy],nil);
        }
    }];
}

//内容商列表
+(void)getContentCompanyWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ContentCompanyUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            finishblock([response[@"data"][@"list"] yy_modelCopy],nil);
        }
    }];

}


//v1.2 书城
+(void)getNewBookHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookNewList params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            JUDIAN_READ_BookStoreModel *model = [JUDIAN_READ_BookStoreModel yy_modelWithJSON:response[@"data"][@"info"]];
            finishblock([model yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}


//v1.2 书城加载
+(void)getNewBookHomePullListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookPullList params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookDetailModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }
    }];
}

//v1.2 书城 1、2
+(void)getNewBookOneTwoHomeListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:BookOneTowNewList params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response[@"data"]) {
            JUDIAN_READ_BookStoreModel *model = [JUDIAN_READ_BookStoreModel yy_modelWithJSON:response[@"data"][@"info"]];
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookStoreModel class] json:response[@"data"][@"info"][@"recommend_lists"]];
            JUDIAN_READ_BookStoreModel *model1 = arr.firstObject;
            model1.store_carousel = model.store_carousel;
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

@end
