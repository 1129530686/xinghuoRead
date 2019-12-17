//
//  JUDIAN_READ_PromotionUserCountActivity.m
//  xinghuoRead
//
//  Created by judian on 2019/7/12.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_PromotionUserCountActivity.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_PromotionMessageModel


@end



@implementation JUDIAN_READ_PromotionUserCountActivity


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"message" : [JUDIAN_READ_PromotionMessageModel class]};
}


+ (void)buildActivityModel:(modelBlock)block {
    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    if (uid.length <= 0) {
        return;
    }
    
    NSDictionary* dictionary = @{@"uidb" : uid};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/share/invitationFriend" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        //NSNumber* status = response[@"status"];
        NSDictionary* dictionary = response[@"data"][@"info"];
        JUDIAN_READ_PromotionUserCountActivity* model = [JUDIAN_READ_PromotionUserCountActivity yy_modelWithJSON:dictionary];
        if (block) {
            block(model);
        }
    }];

}


@end
