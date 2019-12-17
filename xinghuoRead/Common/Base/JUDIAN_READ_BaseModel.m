//
//  BaseTableViewCell.m
//
//  Created by hu on 16/6/1.
//  Copyright © 2016年. All rights reserved.
//
#import "JUDIAN_READ_BaseModel.h"

@implementation JUDIAN_READ_BaseModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"ID": @"id"};
}


@end
