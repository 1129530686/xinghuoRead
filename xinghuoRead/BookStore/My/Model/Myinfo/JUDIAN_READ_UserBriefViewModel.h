//
//  JUDIAN_READ_UserBriefViewModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/1.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserBriefViewModel : NSObject
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* content;
@end




@interface JUDIAN_READ_UserBriefModel : NSObject

@property(nonatomic, copy)NSString* encryShow;
@property(nonatomic, copy)NSString* uidb;
@property(nonatomic, copy)NSString* nickname;
@property(nonatomic, copy)NSString* age;
@property(nonatomic, copy)NSString* constellation;
@property(nonatomic, copy)NSString* wxNo;
@property(nonatomic, copy)NSString* area;
@property(nonatomic, copy)NSString* profession;
@property(nonatomic, copy)NSString* birthday;
@property(nonatomic, copy)NSString* personProfile;
@property(nonatomic, copy)NSString* readDuration;
@property(nonatomic, copy)NSString* rankDesc;
@property(nonatomic, copy)NSString* headImg;
@property(nonatomic, copy)NSNumber* sex;
@property(nonatomic, copy)NSString* deliveryAddr;
@property(nonatomic, copy)NSString* province;
@property(nonatomic, copy)NSString* city;

+ (void)buildModel:(modelBlock)block;
- (void)saveUserBriefModel:(modelBlock)block viewController:(UIViewController*)viewController isFirst:(BOOL)isFirst;
- (NSString*)getSexName;
- (void)updateSex:(NSString*)name;
@end



@interface JUDIAN_READ_UserDeliveryAddressModel : NSObject
#if 0
"id": 1,
"privince": "广东省",
"city": "深圳",
"area": "宝安",
"uid_b": 110101001,
"user_name": "隔壁老王-update2",
"phone_no": "13798452743",
"detailed_addr": "宝安区坪洲地铁1001---update2",
"default_addr": 1
#endif

@property(nonatomic, copy)NSNumber* id;
@property(nonatomic, copy)NSString* privince;
@property(nonatomic, copy)NSString* city;
@property(nonatomic, copy)NSString* area;
@property(nonatomic, copy)NSString* uid_b;
@property(nonatomic, copy)NSString* user_name;
@property(nonatomic, copy)NSString* phone_no;
@property(nonatomic, copy)NSNumber* default_addr;
@property(nonatomic, copy)NSString* detailed_addr;

+ (void)buildDeliveryAddressModel:(modelBlock)block;
- (void)saveDeliveryAddress:(modelBlock)block isAdd:(BOOL)isAdd;
- (void)deleteAddress:(modelBlock)block;

@end





NS_ASSUME_NONNULL_END
