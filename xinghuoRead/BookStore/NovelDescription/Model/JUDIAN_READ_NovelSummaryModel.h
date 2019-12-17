//
//  JUDIAN_READ_NovelSummaryModel.h
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NOVEL_BRIEF_ARROW_NONE = 0x10,
    NOVEL_BRIEF_ARROW_DOWN,
    NOVEL_BRIEF_ARROW_UP,
} NovelBriefArrowEnum;


typedef void(^summaryBlock)(id model);

@interface JUDIAN_READ_NovelSummaryModel : NSObject

/*
"star":4,
"nid":3,
"bookname":"绝品盲技师",
"cover":"http://img.judianbook.com/img/uploads/20180804/153331533212820%E7.jpg",
"update_status":"连载中",
"words_number":"92万字",
"tag":"",
"author":"老白干",
"editorid":"据点内容中心",
"brief":"一次意外竟然让我恢复了视力，从此美女金钱通通到我怀里来！",
"chapter_name":"第477章：以身相许",
"update_time":"2018-12-15 18:36",
"chapters_total":494,
"chapter_update":0
 
 "": 5.0,
 "evaluate_users": 0,
 "": 9,
 "": 0
 
*/
@property(nonatomic, copy)NSString* star;
@property(nonatomic, copy)NSString* nid;
@property(nonatomic, copy)NSString* bookname;
@property(nonatomic, copy)NSString* cover;
@property(nonatomic, copy)NSString* update_status;
@property(nonatomic, copy)NSString* words_number;
@property(nonatomic, copy)NSString* tag;
@property(nonatomic, copy)NSString* author;
@property(nonatomic, copy)NSString* editorid;
@property(nonatomic, copy)NSString* brief;
@property(nonatomic, copy)NSString* chapter_name;
@property(nonatomic, copy)NSString* update_time;
@property(nonatomic, copy)NSString* chapters_total;
@property(nonatomic, copy)NSString* chapter_update;
@property(nonatomic, copy)NSNumber* publisher_id;
@property (nonatomic,copy) NSString  *unread; //@"还有4000章未读"
@property (nonatomic,copy) NSString  *read_chapter; //@“上次读到第20章”
@property (nonatomic,copy) NSString  *total;//书架专用，不需要理会
@property (nonatomic,assign) BOOL  isSelected;
@property (nonatomic,copy) NSString *is_favorite_book;

@property (nonatomic, copy)NSNumber* praise_num;
@property (nonatomic, copy)NSNumber* reading_num;
@property (nonatomic, copy)NSNumber* attention_num;
@property (nonatomic, copy)NSNumber* fensi_num;
@property (nonatomic, copy)NSNumber* evaluate_score;
@property (nonatomic, copy)NSNumber* status;

@property (nonatomic, copy)NSArray* related_books;
@property (nonatomic, copy)NSArray* author_books;
@property (nonatomic,copy) NSString *second_chapter_id;
@property (nonatomic,copy) NSString *first_chapter_content;
@property (nonatomic,copy) NSString *first_chapter_title;
@property (nonatomic,copy) NSString *is_collect;
@property (nonatomic,copy) NSString *chapnum;

@property(nonatomic, assign)NSInteger lineCount;

@property(nonatomic, assign)NovelBriefArrowEnum arrowState;
@property(nonatomic, strong)NSMutableAttributedString* attributedString;
@property(nonatomic, strong)NSMutableAttributedString* attributedFirstChapterContent;


+ (void)buildSummaryModel:(NSString*)novelId block:(summaryBlock)block failure:(summaryBlock)failureBlock;
+ (JUDIAN_READ_NovelSummaryModel*)buildDefaultSummary;
+ (void)buildCertainChapterModel:(NSString*)novelId block:(modelBlock)block failure:(modelBlock)failureBlock;
+ (void)buildExpecialBookModel:(modelBlock)block;

- (void)computeAttributedTextHeight:(CGFloat)width;
- (CGFloat)getCellHeight;
- (NSString*)getNovelStateStr;

- (NSInteger)getMaxLineCount;

- (CTFrameRef)getTextFrameRef:(CGRect)frame;
- (void)goNextRenderStep;
- (CGFloat)getNextPartContentHeight;
- (BOOL)canGoNextRender;

@end

NS_ASSUME_NONNULL_END
