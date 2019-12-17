//
//  JUDIAN_READ_TagModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/30.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_TagModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *tag_id;
@property (nonatomic,copy) NSString  *superTitle;

@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *is_checkd;
@property (nonatomic,copy) NSString  *type;


/**

 "list":[
 {
 "title":"男生",
 "tags":[
 {
 "tag_id":1,
 "title":"惊悚",
 "is_checkd":1
 },
 {
 "tag_id":2,
 "title":"冒险",
 "is_checkd":1
 },

 
 */


@end

NS_ASSUME_NONNULL_END
