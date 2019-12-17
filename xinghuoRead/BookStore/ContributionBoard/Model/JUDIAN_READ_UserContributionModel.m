//
//  JUDIAN_READ_UserContributionModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserContributionModel.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_UserContributionModel

+ (void)buildModel:(CompletionBlock)block pageIndex:(NSString*)pageIndex {
    
    if (pageIndex.length <= 0) {
        return;
    }
    
    NSDictionary* dictionary = @{@"page" : pageIndex, @"pageSize" : @"20" };
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/reward/query-contribute-list" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionaryArray = response[@"data"][@"list"];
        NSNumber* totalPage = response[@"data"][@"total_page"];
        NSArray* array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserContributionModel class] json:dictionaryArray];

        if (block) {
            block(array, totalPage);
        }
    }];
}


@end




@implementation JUDIAN_READ_UserContributionMoneyModel


+ (void)buildModel:(CompletionBlock)block pageIndex:(NSString*)pageIndex {
    
    if (pageIndex.length <= 0) {
        return;
    }
    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        uid = @"0";
    }
    
    NSDictionary* dictionary = @{@"uidb":uid, @"page" : pageIndex, @"pageSize" : @"20" };
    [JUDIAN_READ_APIRequest POST:@"/appprogram/reward/query-reward-record" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionaryArray = response[@"data"][@"list"];
        NSNumber* totalPage = response[@"data"][@"total_page"];
        NSArray* array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_UserContributionMoneyModel class] json:dictionaryArray];
        
        if (block) {
            block(array, totalPage);
        }
    }];
    
    
}



@end
