//
//  JUDIAN_READ_SignListModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SignListModel : JUDIAN_READ_BaseModel
@property (nonatomic,copy)NSMutableArray *days;
@property (nonatomic,copy)NSString *signin_days;
@property (nonatomic,copy)NSMutableArray *reward_rule;

@end


/**
 {
 "status":true,
 "data":{
 "days":[
 "23",
 "24"
 ],
 "signin_days":"2",
 "reward_rule":[
 "1.每次签到奖励30金币",
 "2.连续签到7天额外奖励50金币",
 "3.连续签到15天额外奖励200金币",
 "4.连续签到一个月额外奖励500金币",
 "5.每个自然月为一个周期"
 ]
 }
 }
 
 */
NS_ASSUME_NONNULL_END
