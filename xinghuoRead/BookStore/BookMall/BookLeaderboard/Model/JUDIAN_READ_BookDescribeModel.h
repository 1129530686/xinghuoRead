//
//  JUDIAN_READ_BookDescribeModel.h
//  xinghuoRead
//
//  Created by judian on 2019/7/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookDescribeModel : NSObject


/*
 
 "id": 0,
 "catId": 11,
 "author": "专业老军医",
 "bookname": "山野小医农",
 "brief": "    居然在无意中获得了神医的魂魄？\r\n\r\n    是治病救人？\r\n\r\n    还是开后宫？ ",
 "cover": "https://wnzsapp.oss-cn-shanghai.aliyuncs.com/uploads/novel/236273532929.jpg?x-oss-process=image/resize,m_mfit,h_256,w_192/format,webp",
 "updateStatus": 0,
 "readingNum": 17,
 "nid": 7875,
 "favoriteNum": 6,
 "avgScore": 7.5,
 "praiseNum": 0,
 "channel": 0,
 "cat_name": "都市"
 
 */
@property(nonatomic, copy)NSNumber* id;
@property(nonatomic, copy)NSNumber* catId;
@property(nonatomic, copy)NSString* author;
@property(nonatomic, copy)NSString* bookname;
@property(nonatomic, copy)NSString* brief;
@property(nonatomic, copy)NSString* cover;
@property(nonatomic, copy)NSNumber* updateStatus;
@property(nonatomic, copy)NSNumber* readingNum;
@property(nonatomic, copy)NSNumber* nid;
@property(nonatomic, copy)NSNumber* favoriteNum;
@property(nonatomic, copy)NSNumber* avgScore;
@property(nonatomic, copy)NSNumber* praiseNum;
@property(nonatomic, copy)NSNumber* channel;
@property(nonatomic, copy)NSString* cat_name;

+ (void)buildUnfinishBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary;
+ (void)buildFinishBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary;
+ (void)buildPressBookDescribeModel:(CompletionBlock)block dicitionary:(NSDictionary*)dictionary;
@end

NS_ASSUME_NONNULL_END
