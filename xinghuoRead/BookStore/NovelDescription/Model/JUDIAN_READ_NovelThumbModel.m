//
//  JUDIAN_READ_NovelThumbModel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_APIRequest.h"


@implementation JUDIAN_READ_NovelThumbModel

+ (void)buildThumbModel:(NSString*)novelId block:(thumbBlock)block {
    
    if (!novelId) {
        return;
    }
    
    NSDictionary* dictionary = @{@"id" : novelId};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/book-related" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {

        NSArray* array = response[@"data"][@"list"];
        if (dictionary) {
            NSArray* resultArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_NovelThumbModel class] json:array];
            
            for (JUDIAN_READ_NovelThumbModel* model in resultArray) {
                if ([model.nid isKindOfClass:[NSNumber class]]) {
                    model.nid = [NSString stringWithFormat:@"%ld", model.nid.integerValue];
                }
            }
            
            if (block) {
                block(resultArray);
            }
        }
    }];
    
    
}



+ (void)buildAuthorOtherBookModel:(NSString*)novelId block:(thumbBlock)block {
    
    if (!novelId) {
        return;
    }
    
    NSDictionary* dictionary = @{@"id" : novelId};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/thesame-author-books" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        NSArray* array = response[@"data"][@"list"];
        if (dictionary) {
            NSArray* resultArray = [NSArray yy_modelArrayWithClass:[JUDIAN_READ_NovelThumbModel class] json:array];
            
            for (JUDIAN_READ_NovelThumbModel* model in resultArray) {
                if ([model.nid isKindOfClass:[NSNumber class]]) {
                    model.nid = [NSString stringWithFormat:@"%ld", model.nid.integerValue];
                }
            }
            
            if (block) {
                block(resultArray);
            }
        }
    }];
    
    
}




@end
