//
//  JUDIAN_READ_ReadRankModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/3.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ReadRankModel : JUDIAN_READ_BaseModel
//阅读排名
@property (nonatomic,copy) NSString  *nickname;
@property (nonatomic,copy) NSString  *uidb;
@property (nonatomic,copy) NSString  *headImg;
@property (nonatomic,copy) NSString  *rankYesterday;
@property (nonatomic,copy) NSString  *rankYesterdayDesc;
@property (nonatomic,copy) NSString  *readingDuration;
@property (nonatomic,copy) NSString  *rewardGolds;
@property (nonatomic,copy) NSNumber  *rankRatio;



//用户个人主页
@property (nonatomic,copy) NSString  *age;
@property (nonatomic,copy) NSString  *constellation;
@property (nonatomic,copy) NSString  *wxNo;
@property (nonatomic,copy) NSString  *area;
@property (nonatomic,copy) NSString  *profession;
@property (nonatomic,copy) NSString  *birthday;
@property (nonatomic,copy) NSString  *personProfile;
@property (nonatomic,copy) NSString  *readDuration;
@property (nonatomic,copy) NSString  *rankDesc;
@property (nonatomic,copy) NSString  *sex;
@property (nonatomic,copy) NSString  *encryShow;
@property (nonatomic,copy) NSString  *province;
@property (nonatomic,copy) NSString  *city;



@end

/**
 "list": [
 {
 "username": "zs1074",
 "uidb": 92727672834,
 "headImg": "http://zlltest2019.oss-cn-shenzhen.aliyuncs.com/data/upload/92727672834?Expires=1877399879&OSSAccessKeyId=LTAIbqUohHqEpsJL&Signature=Ff%2Bnut%2BhOgOkiAXLrvuxQI4T6ng%3D",
 "rankYesterday": 1,
 "rankYesterdayDesc": "超过81.0%的用户"
 },
 ]
 
 "info": {
 "username": "zs1074",
 "uidb": 92727672834,
 "headImg": "http://zlltest2019.oss-cn-shenzhen.aliyuncs.com/data/upload/92727672834?Expires=1877399879&OSSAccessKeyId=LTAIbqUohHqEpsJL&Signature=Ff%2Bnut%2BhOgOkiAXLrvuxQI4T6ng%3D",
 "rankYesterday": 1,
 "rankYesterdayDesc": "超过81.0%的用户"
 }
 
 */

NS_ASSUME_NONNULL_END
