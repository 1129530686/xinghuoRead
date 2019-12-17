//
//  JUDIAN_READ_NovelBrowseHistoryModel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelBrowseHistoryModel : NSObject
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, copy)NSString* bookName;
@property(nonatomic, copy)NSString* chapterName;
@property(nonatomic, copy)NSString* chapterId;
@property(nonatomic, copy)NSString* pageIndex;
@property(nonatomic, copy)NSString* yPos;
@end

NS_ASSUME_NONNULL_END
