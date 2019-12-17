//
//  JUDIAN_READ_UserCheckInGoldListModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserCheckInGoldListModel.h"
#import "JUDIAN_READ_APIRequest.h"

@implementation JUDIAN_READ_UserCheckInGoldListModel

+ (void)buildModel:(modelBlock)block {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/signin" params:@{} isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionary = response[@"data"];
        JUDIAN_READ_UserCheckInGoldListModel* model = [JUDIAN_READ_UserCheckInGoldListModel yy_modelWithJSON:dictionary];
        if (block) {
            block(model);
        }
    }];
}



+ (void)buildVersionModel:(modelBlock)block {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/version-coin" params:@{} isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* goldCount = response[@"data"][@"info"][@"gold"];
        if (block) {
            block(goldCount);
        }
    }];
}






+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"reward_rule" : JUDIAN_READ_UserCheckInDayModel.class};
}

@end



@implementation JUDIAN_READ_UserCheckInDayModel

@end
