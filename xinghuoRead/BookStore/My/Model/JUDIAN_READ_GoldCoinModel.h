//
//  JUDIAN_READ_GoldCoinModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_GoldCoinModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *uidb;
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *incomeAmount;
@property (nonatomic,copy) NSString  *createTime;
@property (nonatomic,copy) NSString  *createDate;
@property (nonatomic,copy) NSString  *signDaysDesc;

@property (nonatomic,copy) NSString  *uidBinary;
@property (nonatomic,copy) NSString  *goldCoins;
@property (nonatomic,copy) NSString  *fictionCoins;
@property (nonatomic,copy) NSString  *signinDays;
@property (nonatomic,copy) NSString  *signinDaysMiniprogram;
@property (nonatomic,copy) NSString  *canBeAdd;
@property (nonatomic,copy) NSString  *fictionNum;


/**
 
 "list": [
 {
 "date": "2019年2月",
 "list": [
 {
 "id": 70,
 "uidb": 33604763649,
 "title": "签到奖励",
 "incomeAmount": 30,
 "createTime": "2019-02-15 19:57:28",
 "createDate": "2019-02-15"
 },],
 "info": {
 "id": 1834,
 "uidBinary": 33604763649,
 "goldCoins": 360,
 "fictionCoins": 10,
 "signinDays": 1,
 "signinDaysMiniprogram": 0,
 "canBeAdd": 1,
 "fictionNum": 27
 }
 */


@end

NS_ASSUME_NONNULL_END
