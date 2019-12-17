//
//  JUDIAN_READ_AllChapterEndView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/27.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ChapterEndTipCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_AllChapterEndView : UIView
@property(nonatomic, copy)NSArray* appreciatedAvatarArray;
@property(nonatomic, copy)touchBlock block;
@property(nonatomic, copy)touchBlock cellBlock;
@property(nonatomic, copy)touchBlock appreciateBlock;
@property(nonatomic, weak)UINavigationController* navigationController;

@property(nonatomic, copy)NSString* wordCount;
@property(nonatomic, copy)NSString* chapterCount;
@property(nonatomic, copy)NSString* bookName;
@property(nonatomic, copy)NSString* bookAuthor;
@property(nonatomic, copy)NSString* bookId;
@property(nonatomic, copy)NSString* fictionState;
@property(nonatomic, copy)NSString* appreciateCount;

- (instancetype)initWithName:(NSString*)bookName state:(NSString*)state;

- (void)reloadData:(NSArray*)array;
- (void)reloadFeedList:(NSArray*)array;
- (void)reloadAvatarList:(NSArray*)array;
- (void)reloadAuthorOtherBookList:(NSArray*)array;
@end

NS_ASSUME_NONNULL_END
