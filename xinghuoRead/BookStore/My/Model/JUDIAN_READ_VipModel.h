//
//  JUDIAN_READ_VipModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/30.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_VipModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *price;
@property (nonatomic,copy) NSString  *original_price;
@property (nonatomic,copy) NSString  *reduced_price;
@property (nonatomic,copy) NSString  *appstroe_pid;

@property (nonatomic,assign)BOOL isSelected;



/*
 {
 "id": 1,
 "title": "黄金会员",
 "price": "0.01",
 "original_price": "18.99",
 "description": "缓存30本书尊贵标识",
 "appstroe_pid": "com.szjudian.zhuishubao01",
 "reduced_price": "18.98"
 },
*/

@end

NS_ASSUME_NONNULL_END
