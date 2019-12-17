//
//  JUDIAN_READ_DiscoveryTool.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//
#import "JUDIAN_READ_APIRequest.h"
#import "JUDIAN_READ_DiscoveryTool.h"
#import "JUDIAN_READ_ArticleListModel.h"
#import "JUDIAN_READ_ArticleDetailModel.h"
#import "JUDIAN_READ_VersionModel.h"
#import "JUDIAN_READ_TagModel.h"


@implementation JUDIAN_READ_DiscoveryTool
//发现首页
+ (void)getArticleListWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ArticlesListUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_ArticleListModel *model = [JUDIAN_READ_ArticleListModel yy_modelWithJSON:dic];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//发现详情页
+ (void)getArticleDetailWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ArticleDetailUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSDictionary *dic = response[@"data"][@"info"];
            JUDIAN_READ_ArticleDetailModel *model = [JUDIAN_READ_ArticleDetailModel yy_modelWithJSON:dic];
            finishblock([model yy_modelCopy],nil);
        }
    }];
}

//发现标签
+ (void)getArticleTagWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ArticleTagUrl params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSMutableArray *newDic = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *modeDic in dic[@"tags"]) {
                    JUDIAN_READ_TagModel *model = [JUDIAN_READ_TagModel yy_modelWithJSON:modeDic];
                    model.superTitle = dic[@"title"];
                    [arr addObject:model];
                }
                [newDic addObject:arr];
            }
            finishblock([newDic yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//广告开关
+ (void)getAdvertStatusUrlWithParams:(CompletionBlock)finishblock {
    
    NSString* version = GET_VERSION_NUMBER;
    if (version.length <= 0) {
        version = @"";
    }
    
    NSDictionary* parameter = @{@"type":@"ios",
                                @"app_version" : version
                                };
    
    
    [JUDIAN_READ_APIRequest POST:AdvertStatusUrl params:parameter isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
#if _IS_RELEASE_VERSION_ == 1
            [def setObject:response[@"data"][@"info"][@"advertInfo"][@"chuanshanjia"] forKey:CHUAN_SHAN_JIA_SWITCH];
            [def setObject:response[@"data"][@"info"][@"advertInfo"][@"guangdiantong"] forKey:GUANG_DIAN_TONG_SWITCH];
#else
            [def setObject:@"1" forKey:CHUAN_SHAN_JIA_SWITCH];
            [def setObject:@"1" forKey:GUANG_DIAN_TONG_SWITCH];
#endif
            
            NSString* qqGroup = response[@"data"][@"info"][@"qq_group"];
            NSString* qqGroupKey = response[@"data"][@"info"][@"qq_group_key"];
            
            [def setObject:qqGroup forKey:QQ_Group];
            [def setObject:qqGroupKey forKey:QQ_Group_Key];
            
            NSString* weixin = response[@"data"][@"info"][@"wx"];
            if ([weixin isEqual:[NSNull null]]) {
                weixin = @"";
            }
            [def setObject:weixin forKey:WEI_XIN_CUSTOMER];
            
            
            NSNumber* threshold = response[@"data"][@"info"][@"read_duration_threshold"];
            if ([threshold isEqual:[NSNull null]] || threshold.integerValue <= 0) {
                threshold = @(30);
            }
            
            [def setObject:threshold forKey:USER_READ_DURATION];
            
            
            NSNumber* article = response[@"data"][@"info"][@"article"];
            
            NSString* canBorrowMoneyStr = response[@"data"][@"info"][@"borrow_money_url"];
            if ([canBorrowMoneyStr isEqual:[NSNull null]] || canBorrowMoneyStr.length <= 0) {
                canBorrowMoneyStr = @"";
            }
            [def setObject:canBorrowMoneyStr forKey:GET_MONEY_SWITCH];
            
            if (finishblock) {
                finishblock(article, nil);
            }
        }
    }];
    
}

//阅读记录
+ (void)addReadRecorUrlWithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:addRecordUrl params:paraDic isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            finishblock(response,nil);
        }else{
            finishblock(nil,error);
        }
    }];
}



//1.1
// 发现首页
+ (void)getArticleListV1WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ArticlesListUrlV1 params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSLog(@"888=%@",response);
        if (response) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                JUDIAN_READ_ArticleListModel *model = [JUDIAN_READ_ArticleListModel yy_modelWithJSON:dic];
                model.refresh_num = response[@"data"][@"refresh_num"];
                [arr addObject:model];
            }
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];
}

//发现标签
+ (void)getArticleTagV1WithParams:(NSDictionary *)paraDic completionBlock:(CompletionBlock)finishblock{
    [JUDIAN_READ_APIRequest POST:ArticleTagUrlV1 params:paraDic isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        if (response) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_TagModel class] json:response[@"data"][@"list"]];
            finishblock([arr yy_modelCopy],nil);
        }else{
            finishblock(nil,error);
        }
    }];

    
}

@end
