//
//  JUDIAN_READ_UserAppreciatedItemModel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAppreciatedItemModel : NSObject

/*
 
 "bookname": "独家总裁",
 "chapter_title": "第1章 被女友抛弃",
 "amount": "666.00",
 "create_time": "2019-05-13 14:09:30",
 "pay_type": "微信支付"
 */
@property(nonatomic, copy)NSString* bookname;
@property(nonatomic, copy)NSString* chapter_title;
@property(nonatomic, copy)NSString* amount;
@property(nonatomic, copy)NSString* create_time;
@property(nonatomic, copy)NSString* pay_type;

@end

NS_ASSUME_NONNULL_END
