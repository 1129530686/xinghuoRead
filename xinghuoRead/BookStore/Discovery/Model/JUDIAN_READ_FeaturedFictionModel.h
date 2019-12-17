//
//  JUDIAN_READ_FeaturedFictionModel.h
//  xinghuoRead
//
//  Created by judian on 2019/8/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FeaturedFictionModel : NSObject

@property(nonatomic, copy)NSString* author;
@property(nonatomic, copy)NSString* bookname;
@property(nonatomic, copy)NSString* cat_id;
@property(nonatomic, copy)NSString* cat_name;
@property(nonatomic, copy)NSString* chapter;
@property(nonatomic, copy)NSString* content;
@property(nonatomic, copy)NSString* cover;
@property(nonatomic, copy)NSString* favorite_num;
@property(nonatomic, copy)NSString* nid;
@property(nonatomic, copy)NSString* update_status;
@property(nonatomic, copy)NSString* is_favorite;
@property(nonatomic, copy)NSString* first_chapter_id;
@property(nonatomic, copy)NSString* second_chapter_id;

+ (void)buildFeaturedFictionModel:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSString*)type success:(CompletionBlock)block failure:(modelBlock)failureBlock;

- (NSString*)getNovelStateStr;
@end

NS_ASSUME_NONNULL_END
