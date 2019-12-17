//
//  JUDIAN_READ_UserCheckInGoldListModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface JUDIAN_READ_UserCheckInDayModel : NSObject
@property(nonatomic, copy)NSString* day;
@property(nonatomic, copy)NSString* coin;
@end


@interface JUDIAN_READ_UserCheckInGoldListModel : NSObject

/*
 "gold_coin":30,
 "signin_days":3,
 "first_signin":false,
 "reward_rule"
 
 
  {"day":"1","coin":10},
 */
@property(nonatomic, copy)NSString* gold_coin;
@property(nonatomic, copy)NSString* signin_days;
@property(nonatomic, copy)NSString* first_signin;
@property(nonatomic, copy)NSArray* reward_rule;
@property(nonatomic, copy)NSNumber* today_signin;

+ (void)buildModel:(modelBlock)block;
+ (void)buildVersionModel:(modelBlock)block;

@end

NS_ASSUME_NONNULL_END
