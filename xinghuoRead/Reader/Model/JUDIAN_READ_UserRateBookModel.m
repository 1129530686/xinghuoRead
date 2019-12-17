//
//  JUDIAN_READ_UserRateBookModel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/30.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserRateBookModel.h"
#import "JUDIAN_READ_APIRequest.h"

@implementation JUDIAN_READ_UserRateBookModel

+ (void)buildRateModel:(modelBlock)block bookId:(NSString*)bookId {
    
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    NSString* currentBook = bookId;
    
    if (uid.length <= 0) {
        uid = @"";
    }
    
    if (currentBook.length <= 0) {
        currentBook = @"";
    }

    NSDictionary* dictionary = @{
                                 @"uid_b" : uid,
                                 @"nid" : bookId
                                 };
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/query-last-evascore" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        NSDictionary* dictionary = response[@"data"][@"info"];
        JUDIAN_READ_UserRateBookModel* model = [JUDIAN_READ_UserRateBookModel yy_modelWithJSON:dictionary];
        if (block) {
            block(model);
        }
    }];
    
    
}


@end
