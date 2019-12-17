//
//  JUDIAN_READ_NovelThumbModel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^thumbBlock)(id model);

@interface JUDIAN_READ_NovelThumbModel : NSObject

/*
 nid    int    书籍ID    58
 bookname    string    书籍名称    神奇人生
 brief    string    简介    无
 author    string    筛选条件参数值    小书生
 update_status    string    更新状态    已完结
 cat_name    string    分类名称    现代言情
 cover
 */
@property(nonatomic, copy)NSString* nid;
@property(nonatomic, copy)NSString* bookname;
@property(nonatomic, copy)NSString* brief;
@property(nonatomic, copy)NSString* author;
@property(nonatomic, copy)NSString* update_status;
@property(nonatomic, copy)NSString* cat_name;
@property(nonatomic, copy)NSString* cover;


+ (void)buildThumbModel:(NSString*)novelId block:(thumbBlock)block;
+ (void)buildAuthorOtherBookModel:(NSString*)novelId block:(thumbBlock)block;

@end

NS_ASSUME_NONNULL_END
