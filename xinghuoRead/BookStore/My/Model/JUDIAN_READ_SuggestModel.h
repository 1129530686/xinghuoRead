//
//  JUDIAN_READ_SuggestModel.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/9/23.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_SuggestModel : JUDIAN_READ_BaseModel

@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *content;
@property (nonatomic,copy) NSString  *create_time;
@property (nonatomic,copy) NSString  *answer_content;
@property (nonatomic,copy) NSString  *answer_time;



@end

NS_ASSUME_NONNULL_END
