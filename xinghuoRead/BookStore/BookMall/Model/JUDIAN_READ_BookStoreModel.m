//
//  JUDIAN_READ_BookStoreModel.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BookStoreModel.h"
#import "JUDIAN_READ_BookDetailModel.h"
#import "JUDIAN_READ_CategoryModel.h"
#import "JUDIAN_READ_BannarModel.h"

@implementation JUDIAN_READ_BookStoreModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"store_carousel": [JUDIAN_READ_BannarModel class],
             @"sub_categorys": [JUDIAN_READ_CategoryModel class],
             @"push": [JUDIAN_READ_BookDetailModel class],
             @"like": [JUDIAN_READ_BookDetailModel class],
             @"newest": [JUDIAN_READ_BookDetailModel class],
             @"faves": [JUDIAN_READ_BookDetailModel class],
             @"books": [JUDIAN_READ_BookDetailModel class],
        };
}

@end
