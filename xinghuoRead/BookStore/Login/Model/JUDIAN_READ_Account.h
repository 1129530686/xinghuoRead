//
//  JUDIAN_READ_Account.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_Account : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *token;
@property (nonatomic,copy) NSString  *nickname;
@property (nonatomic,copy) NSString  *sex;
@property (nonatomic,copy) NSString  *province;
@property (nonatomic,copy) NSString  *city;
@property (nonatomic,copy) NSString  *country;
@property (nonatomic,copy) NSString  *avatar;
@property (nonatomic,copy) NSString  *status;
@property (nonatomic,copy) NSString  *vip_type;
@property (nonatomic,copy) NSString  *vip_status;
@property (nonatomic,copy) NSString  *uid;
@property (nonatomic,copy) NSString  *bind_mobile;
@property (nonatomic,copy) NSString  *bind_wechat;
@property (nonatomic,copy) NSString  *mobile;
@property (nonatomic,copy) NSString  *wechat_nickname;
@property (nonatomic,copy) NSString  *fiction_num;
@property (nonatomic,copy) NSString  *openid;
@property (nonatomic,copy) NSString  *totalCoins;
@property (nonatomic,copy) NSString  *todayCoins;
@property (nonatomic,copy) NSString  *todayReadRank;
@property (nonatomic,copy) NSString  *start_time;
@property (nonatomic,copy) NSString  *end_time;
@property (nonatomic,copy) NSString  *showInviteCode;
@property (nonatomic,copy) NSString  *allow_signin;
@property (nonatomic,copy) NSString  *oldVip;
@property (nonatomic,copy) NSString  *rewardFlag;


//用户偏好
@property (nonatomic,copy) NSString  *hobby;



+ (JUDIAN_READ_Account *)currentAccount;
/**
 *  保存系统Account
 *
 */
+ (void)saveCurrentAccount:(JUDIAN_READ_Account *)account;



/**
 "data":{
 "info":{
 "nickname":"陈",
 "sex":"女",
 "province":"",
 "city":"",
 "country":"",
 "avatar":"https://thirdwx.qlogo.cn/mmopen/vi_32/bQOhtHPwiaVmBEQNA3w/132",
 "status":1,
 "uid":838860801,
 "vip_type": 0,
 "vip_status":3,
 "bind_mobile":1,
 "bind_wechat":0,
 "mobile":"186****6387",
 "wechat_nickname":"一叶",
 "fiction_num":0
 }
 */

+ (void)deleteCurrentAccount;

@end

NS_ASSUME_NONNULL_END
