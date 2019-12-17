//
//  JUDIAN_READ_ReadListModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ReadListModel : JUDIAN_READ_BaseModel
//分类首页
@property (nonatomic,copy) NSString  *nid;
@property (nonatomic,copy) NSString  *bookname;
@property (nonatomic,copy) NSString  *cover;
@property (nonatomic,copy) NSString  *read_chapter;
@property (nonatomic,copy) NSString  *latest_chapter;
@property (nonatomic,copy) NSString  *chapter_update;
@property (nonatomic,copy) NSString  *author;
@property (nonatomic,copy) NSString  *chapter_id;
@property (nonatomic,copy) NSString  *chapnum;

//书城首页
@property (nonatomic,copy) NSString  *title; //分类的名字
@property (nonatomic,copy) NSString  *cat_name;
@property (nonatomic,copy) NSString  *brief;
@property (nonatomic,copy) NSString  *update_status;
@property (nonatomic,copy) NSString  *readingNum;


//书架
@property (nonatomic,strong) NSString  *is_favorite_book;
@property (nonatomic,copy) NSString  *total;
@property (nonatomic,copy) NSString  *unread;

//缓存记录
@property (nonatomic,copy) NSString  *update_time;
@property (nonatomic,copy) NSString  *chapters_num;
@property (nonatomic,assign) NSInteger  isLoading;
@property (nonatomic,assign) NSInteger  progress;
@property (nonatomic,assign) BOOL  loadFail;



/**
 
 {
 "nid":85,
 "bookname":"都市美女如云",
 "cover":"http://img.judianbook.com/img/uploads/20115369808327492.jpg",
 "read_chapter":"上次读到第3章",
 "latest_chapter":"12月21日更新到638章",
 "chapter_update":0,
 "author":"六根不净",
 "chapter_id":34443,
 "chapnum":1
 },
 
 
 {
 "nid":6187,
 "author":"西山凌风",
 "bookname":"逍遥武医",
 "cover":"https://wnzsapp.oss-cn-shanghai.aliyuncs.com/uploads/novel/139385110529.jpg?x-oss-process=image/resize,m_mfit,h_256,w_192",
 "cat_name":"都市",
 "brief":"我，本是一个一无所有的穷小子，却在偶然的机会，得到玄道传承，从此建立中华武社，炎黄医院，玄理大学......
 为的，只是一个目标，弘扬中华古术！"
 },

 */
@end

NS_ASSUME_NONNULL_END
