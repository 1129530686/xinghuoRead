//
//  JUDIAN_READ_UserDurationRewardModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/18.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserDurationRewardModel.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_UserDurationRewardModel


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"rule" : JUDIAN_READ_UserIgnotsModel.class};
}


+ (void)buildModel:(modelBlock)block {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/duration-coin-list" params:@{} isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionary = response[@"data"][@"info"];
        JUDIAN_READ_UserDurationRewardModel* model = [JUDIAN_READ_UserDurationRewardModel yy_modelWithJSON:dictionary];
        if (block) {
            block(model);
        }
    }];
}



+ (void)receiveGoldCoin:(modelBlock)block duration:(NSString*)duration {
    
    if (duration.length <= 0) {
        return;
    }
    
    NSDictionary* dictionary = @{@"duration" : duration};
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/duration-coins" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* goldCount = response[@"data"][@"info"][@"gold_coin"];
        NSString* count = @"";
        if (goldCount.intValue > 0) {
            count = [NSString stringWithFormat:@"%ld", goldCount.integerValue];
        }
        
        if (block) {
            block(count);
        }
    }];
    
    
}

@end



@implementation JUDIAN_READ_UserIgnotsModel


@end




@implementation JUDIAN_READ_UserCheckInDayCountModel

+ (void)checkIn:(modelBlock)block {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/user/signin-action" params:@{} isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSNumber* goldCount = response[@"data"][@"info"][@"gold"];
        NSString* count = @"";
        if (goldCount.intValue > 0) {
            count = [NSString stringWithFormat:@"%ld", (long)goldCount.intValue];
        }
        if (block) {
            block(count);
        }
    }];
    
}


@end




