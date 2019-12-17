//
//  JUDIAN_READ_TaskModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/5.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TaskModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSNumber* count;
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *image;
@property (nonatomic,copy) NSString  *type;
@property (nonatomic,copy) NSString  *url;
@property (nonatomic,copy) NSString  *coins;
@property (nonatomic,copy) NSString  *signDays;


/**
 "list": [
 {
 "title": "看广告领取福利",
 "image": "http://static-all.nhbook.com/api.wannengzhuishu.com/static/advert/welfare_list_watch.png",
 "description": "看4个小广告就能免1小时广告啦",
 "type": "advert",
 "url": ""
 }
 
 */

@end

NS_ASSUME_NONNULL_END
