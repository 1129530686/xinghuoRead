//
//  JUDIAN_READ_BookDescribeModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BookDescribeModel.h"
#import "JUDIAN_READ_APIRequest.h"



@implementation JUDIAN_READ_BookDescribeModel


+ (void)buildUnfinishBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary {
    
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/query-ranking-list" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionaryArray = response[@"data"][@"list"];
        NSArray* array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookDescribeModel class] json:dictionaryArray];
        NSNumber* totalPage = response[@"data"][@"total_page"];
        if (block) {
            block(array, totalPage);
        }

    }];
    
}


+ (void)buildFinishBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/query-end-Book" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionaryArray = response[@"data"][@"list"];
        NSNumber* totalPage = response[@"data"][@"total_page"];
        NSArray* array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookDescribeModel class] json:dictionaryArray];
        
        if (block) {
            block(array, totalPage);
        }
    }];
    
}



+ (void)buildPressBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary {
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/query-editor-book" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionaryArray = response[@"data"][@"list"];
        
        NSArray* array = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_BookDescribeModel class] json:dictionaryArray];
        NSNumber* totalPage = response[@"data"][@"total_page"];
        if (block) {
            block(array, totalPage);
        }
        
    }];
    
}



@end
