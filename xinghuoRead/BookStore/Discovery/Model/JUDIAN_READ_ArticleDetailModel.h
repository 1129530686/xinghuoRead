//
//  JUDIAN_READ_ArticleDetailModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ArticleDetailModel : JUDIAN_READ_BaseModel
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *source;
@property (nonatomic,copy) NSString  *date;
@property (nonatomic,copy) NSString  *like_number;
@property (nonatomic,copy) NSString  *read_number;
@property (nonatomic,copy) NSString  *continue_reading;
@property (nonatomic,copy) NSString  *next_chapter;
@property (nonatomic,copy) NSString  *nid;
@property (nonatomic,copy) NSString  *allow_like;
@property (nonatomic,copy) NSString  *next_chapnum;
@property (nonatomic,copy) NSString  *author;
@property (nonatomic,copy) NSString  *bookname;
@property (nonatomic,copy) NSString  *allow_bookshelf;
@property (nonatomic,copy) NSString  *cur_chapter;


/*
"title":"测试文章3",
"source":"新浪",
"date":"2018-12-26",
"like_number":0,
"read_number":"0",
"continue_reading":1,
"next_chapter":17218,
"nid":0,
"allow_like":0,
"next_chapnum":0,
"author":"",
"bookname":"",
"allow_bookshelf":0,
"cur_chapter":17217,
*/

@end

NS_ASSUME_NONNULL_END
