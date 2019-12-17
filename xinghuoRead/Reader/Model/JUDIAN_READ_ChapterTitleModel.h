//
//  JUDIAN_READ_ChapterTitleModel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/23.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterTitleModel : NSObject<NSCoding>
//{"chapter_id":974,"title":"\u7b2c1\u7ae0 \u9003\u5a5a","chapnum":1}
@property(nonatomic, copy)NSString* chapter_id;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* chapnum;

@end

NS_ASSUME_NONNULL_END
