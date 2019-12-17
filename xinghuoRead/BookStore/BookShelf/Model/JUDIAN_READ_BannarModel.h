//
//  JUDIAN_READ_BannarModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BannarModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *picture;
@property (nonatomic,copy) NSString  *type;
@property (nonatomic,copy) NSString  *url;
@property (nonatomic,copy) NSString  *nid;




/**
 {
 "picture": "https://img.wannengzhuishu.com/static/advert/a3.jpg?x-oss-process=image/resize,m_mfit,h_320,w_1000",
 "type": "html",
 "url": "http://www.baidu.com",
 "nid": 0
 }
 
 */
@end

NS_ASSUME_NONNULL_END
