//
//  JUDIAN_READ_CategoryModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/24.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CategoryModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *name;
@property (nonatomic,copy) NSString  *field;
@property (nonatomic,copy) NSString  *value;
@property (nonatomic,copy) NSString  *cover;
@property (nonatomic,copy) NSString  *color;

/**
 {
 "name":"武侠",
 "field":"cat_id",
 "value":"9",
 "cover":"https://img.wannengzhuishu.com/static/img/category_cover.png"
 },

 */


@end

NS_ASSUME_NONNULL_END
