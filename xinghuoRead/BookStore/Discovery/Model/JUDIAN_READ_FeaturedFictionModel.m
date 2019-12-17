//
//  JUDIAN_READ_FeaturedFictionModel.m
//  xinghuoRead
//
//  Created by judian on 2019/8/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FeaturedFictionModel.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_FeaturedFictionModel

+ (void)buildFeaturedFictionModel:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSString*)type success:(CompletionBlock)block failure:(modelBlock)failureBlock {
    
    NSString* lastTime = [NSUserDefaults getUserDefaults:@"time1"];
    if (!lastTime) {
        lastTime = @"";
    }
    
    NSString* presentTime = [NSUserDefaults getUserDefaults:@"time2"];
    if (!presentTime) {
        presentTime = @"";
    }
    
    NSString* indexStr = @"1";
    if (pageIndex > 0) {
        indexStr = [NSString stringWithFormat:@"%ld", pageIndex];
    }
    
    NSString* sizeStr = @"1";
    if (pageSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%ld", pageSize];
    }
    
    NSString* fictionType = type;
    if (fictionType.length <= 0) {
        fictionType = @"0";
    }
    
    NSDictionary* dictionary = @{@"type" : fictionType,
                                 @"page" : indexStr,
                                 @"pageSize" : sizeStr,
                                 @"last_time" : lastTime,
                                 @"present_time" : presentTime
                                 };
    [JUDIAN_READ_APIRequest POST:@"/appprogram/articles/chosen-fiction" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        if (response) {
            NSNumber* total = response[@"data"][@"total"];
            NSArray* dictionaryArray = response[@"data"][@"list"];
            NSArray* modelArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_FeaturedFictionModel class] json:dictionaryArray];
            if (block) {
                block(modelArray, total);
            }
        }
        else if (failureBlock) {
            failureBlock(@"error");
        }
    }];
    
}



- (NSString*)getNovelStateStr {
    
    //0（连载中） 1（已完结） 2（弃更）
    if ([self.update_status isEqualToString:@"0"]) {
        return @"连载";
    }
    else if ([self.update_status isEqualToString:@"1"]) {
        return @"完结";
    }
    else if ([self.update_status isEqualToString:@"2"]) {
        return @"弃更";
    }
    
    return @"";
}


@end
