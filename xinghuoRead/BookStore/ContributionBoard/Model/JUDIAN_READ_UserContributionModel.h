//
//  JUDIAN_READ_UserContributionModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserContributionModel : NSObject

@property(nonatomic, copy)NSString* avatar;
@property(nonatomic, copy)NSString* nickname;
@property(nonatomic, copy)NSString* rankId;
@property(nonatomic, copy)NSNumber* totalMoney;
@property(nonatomic, copy)NSString* uidb;

+ (void)buildModel:(CompletionBlock)block pageIndex:(NSString*)pageIndex;
@end




@interface JUDIAN_READ_UserContributionMoneyModel : NSObject

@property(nonatomic, copy)NSString* id;
@property(nonatomic, copy)NSString* uidb;
@property(nonatomic, copy)NSString* amount;
@property(nonatomic, copy)NSString* nid;
@property(nonatomic, copy)NSString* chapnum;
@property(nonatomic, copy)NSString* payType;
@property(nonatomic, copy)NSString* createTime;
@property(nonatomic, copy)NSString* rewardType;
@property(nonatomic, copy)NSString* contributeMoney;
@property(nonatomic, copy)NSString* rankId;


+ (void)buildModel:(CompletionBlock)block pageIndex:(NSString*)pageIndex;

@end



NS_ASSUME_NONNULL_END
