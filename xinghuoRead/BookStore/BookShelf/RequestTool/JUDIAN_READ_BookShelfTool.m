//
//  JUDIAN_READ_BookShelfTool.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BookShelfTool.h"
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_NovelSummaryModel.h"

@implementation JUDIAN_READ_BookShelfTool


+(void)getReadListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    
    [JUDIAN_READ_APIRequest POST:ReadListUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_NovelSummaryModel *model = [JUDIAN_READ_NovelSummaryModel yy_modelWithJSON:dic];
                model.total = response[@"data"][@"total"];
                [arr addObject:model];
                [GTCountSDK trackCountEvent:@"pv_app_reading_page" withArgs:@{@"readRecordCount":model.total}];
                [MobClick event:@"pv_app_reading_page" attributes:@{@"readRecordCount":model.total}];
            }
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//删除阅读记录
+ (void)deleteReadRecordWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:DeleteReadRecordUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"删除成功",nil);
        }
    }];
}

//阅读时长
+ (void)getReadTimeWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ReadTimeUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            finishblock([dic yy_modelCopy],nil);
        }
    }];
}



//收藏删除
+ (void)deleteLikeRecordtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:DeleteLikeRecordUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"删除成功",nil);
        }
    }];
    
}

//收藏添加
+ (void)addLikeRecordtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:addLikeUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(@"收藏成功",nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//收藏列表
+ (void)LikeRecordListtWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:likeListUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_NovelSummaryModel *model = [JUDIAN_READ_NovelSummaryModel yy_modelWithJSON:dic];
                model.total = response[@"data"][@"total"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}



@end
