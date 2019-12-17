//
//  JUDIAN_READ_UserDurationRewardModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/18.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserDurationRewardModel : NSObject

@property(nonatomic, copy)NSString* duration;
@property(nonatomic, copy)NSArray* rule;

+ (void)buildModel:(modelBlock)block;

+ (void)receiveGoldCoin:(modelBlock)block duration:(NSString*)duration;

@end


@interface JUDIAN_READ_UserIgnotsModel : NSObject
@property(nonatomic, copy)NSString* min;
@property(nonatomic, copy)NSString* coin;
@property(nonatomic, copy)NSString* isGet;
@end



@interface JUDIAN_READ_UserCheckInDayCountModel : NSObject
+ (void)checkIn:(modelBlock)block;
@end




NS_ASSUME_NONNULL_END
