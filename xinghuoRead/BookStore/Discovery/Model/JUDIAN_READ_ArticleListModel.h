//
//  JUDIAN_READ_ArticleListModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ArticleListModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *layout_type;
@property (nonatomic,copy) NSString  *read_number;
@property (nonatomic,copy) NSString  *source;
@property (nonatomic,copy) NSString  *bookname;
@property (nonatomic,copy) NSString  *chapter_id;
@property (nonatomic,copy) NSString  *nid;
@property (nonatomic,copy) NSString  *sort;
@property (nonatomic,copy) NSArray  *img_list;
@property (nonatomic,copy) NSString  *refresh_num;


//1.1推荐书友
@property (nonatomic,copy) NSString  *uidb;



/*
{
    "aid":6,
    "title":"测试文章6",
    "layout_type":1,
    "read_number":0,
    "source":"新浪",
    "img_list":[
                "http://editor-user.oss-cn-beijing.aliyuncs.com/23/46/1191846/154581661094877.jpeg"
                ]
},
 
 */

@end

NS_ASSUME_NONNULL_END
