//
//  JUDIAN_READ_ChapterModel.h
//  xinghuoRead
//
//  Created by judian on 2019/4/23.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_CacheContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterContentModel : JUDIAN_READ_CacheContentModel

@property(nonatomic, copy)NSString* words_number;
@property(nonatomic, copy)NSString* nid;

//@property(nonatomic, copy)NSString* title;
//@property(nonatomic, copy)NSString* chapnum;
//@property(nonatomic, copy)NSString* content;

@property(nonatomic, copy)NSString* chapter_id;

@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, copy)NSArray* advertiseArray;

@end

NS_ASSUME_NONNULL_END
