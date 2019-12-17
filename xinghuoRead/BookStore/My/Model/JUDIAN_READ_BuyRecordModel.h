//
//  JUDIAN_READ_BuyRecordModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/16.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BuyRecordModel : JUDIAN_READ_BaseModel
@property (nonatomic,strong) NSString  *vip_type_name;
@property (nonatomic,strong) NSString  *vip_type_price;
@property (nonatomic,strong) NSString  *create_time;
@property (nonatomic,strong) NSString  *pay_title;





/**
 
 {
 "vip_type_name": "钻石会员",
 "vip_type_price": "20.12",
 "create_time": "2019-05-06 17:25:01",
 "pay_title": "微信支付"
 },
 
 {
 "id": 1,
 "deviceId": "8664010308302211123",
 "vipType": 4,
 "fictionNum": 0,
 "createTime": "2019-07-16 16:00:27",
 "price": 28800
 },
 
 */


@end

NS_ASSUME_NONNULL_END
