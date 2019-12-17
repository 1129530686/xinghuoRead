//
//  JUDIAN_READ_BookDetailModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookDetailModel : JUDIAN_READ_BaseModel

//书籍搜索列表+推荐搜索书籍
@property (nonatomic,copy) NSString  *nid;
@property (nonatomic,copy) NSString  *bookname;
@property (nonatomic,copy) NSString  *cover;
@property (nonatomic,copy) NSString  *author;
@property (nonatomic,copy) NSString  *cat_name;
@property (nonatomic,copy) NSString  *brief;
@property (nonatomic,copy) NSString  *update_status;
@property (nonatomic,copy) NSString  *words_number;
@property (nonatomic,copy) NSString  *chapter_update;
@property (nonatomic,copy) NSString  *chapters_total;

//v1.1
@property (nonatomic,copy) NSString  *catId;
@property (nonatomic,copy) NSString  *readingNum;
@property (nonatomic,copy) NSString  *favoriteNum;
@property (nonatomic,copy) NSString  *avgScore;
@property (nonatomic,copy) NSString  *praiseNum;
@property (nonatomic,copy) NSString  *channel;



//分享接口
@property (nonatomic,copy) NSString  *name;
@property (nonatomic,copy) NSString  *logo;
@property (nonatomic,copy) NSString  *url;


/*
"list":[
        {
            "nid":128,
            "author":"熊孩子",
            "bookname":"亲爱的律师大人",
            "cover":"http://img.judianbook.com/img/uploads/20180915/15369792767562.jpg",
            "cat_name":"现代言情",
            "brief":"深爱闺蜜男友陆泽承，为了闺蜜之情，单渝薇压抑自己的感情，压抑的心肝脾肺肾都疼了。为了逃避分手的事实，闺蜜出国，四年后",
            "update_status":"已完结",
            "words_number":"104万字",
            "chapter_update":1,
            "chapters_total":377
        },
 */

@end

NS_ASSUME_NONNULL_END
