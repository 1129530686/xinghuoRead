//
//  JUDIAN_READ_FastSearchModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/25.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FastSearchModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *kname;
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *ktype;


/**

 {
 "kname":"作者",
 "title":"牧云风",
 "ktype":"author"
 },
 
 */


@end

NS_ASSUME_NONNULL_END
