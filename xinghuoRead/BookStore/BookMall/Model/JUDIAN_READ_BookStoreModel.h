//
//  JUDIAN_READ_BookStoreModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/7/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookStoreModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *pages;
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,strong) NSArray  *books;


//v1.2版本 3,4
@property (nonatomic,copy) NSArray  *store_carousel;
@property (nonatomic,copy) NSArray  *sub_categorys;
@property (nonatomic,copy) NSArray  *push;
@property (nonatomic,copy) NSArray  *like;
@property (nonatomic,copy) NSArray  *newest;
@property (nonatomic,copy) NSMutableArray  *faves;





/**
 "list": [{
 "title": "该小区的人都在看",
 "book": [{
 "nid": 7603,
 "bookname": "最强竹鼠养殖场",
 "brief": "刘芒回乡创业养殖竹鼠，经历一场鼠疫，无意间获得神农诀传承，开启出仙泉异能，拥有绝世养殖天赋，养殖的牲畜体内含有精华物质可以延年益寿。含有仙泉的竹鼠汤治愈了侄女夭夭的疾病，步步开启发家致富的渠道。",
 "author": "枫子",
 "update_status": 0,
 "cat_name": "都市",
 "cover": "https://img.wannengzhuishu.com/uploads/novel/170792058881.jpg?x-oss-process=image/resize,m_mfit,h_256,w_192"
 },
 
 */

@end

NS_ASSUME_NONNULL_END
