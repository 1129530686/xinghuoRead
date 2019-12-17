//
//  JUDIAN_READ_GoldCoinListModel.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/3.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_GoldCoinListModel.h"
#import "JUDIAN_READ_GoldCoinModel.h"


@implementation JUDIAN_READ_GoldCoinListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list" : [JUDIAN_READ_GoldCoinModel class]};
}

@end
