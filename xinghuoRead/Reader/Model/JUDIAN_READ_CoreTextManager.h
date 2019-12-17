//
//  JUDIAN_READ_CoreTextManager.h
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JUDIAN_READ_ChapterContentModel.h"
#import "JUDIAN_READ_NovelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CoreTextManager : NSObject

+ (instancetype)shareInstance;

- (NSMutableAttributedString*)createAttributedString:(NSString*)text;
- (NSInteger)computeAttributedTextHeight:(NSAttributedString*)attributedString width:(CGFloat)width lineCount: (NSInteger* _Nullable)lineCount endLine:(NSInteger)endLine;
- (CTFrameRef)getChapterFrameRef:(NSAttributedString*)attributedString frame:(CGRect)frame;

- (NSArray*)splitContent:(NSAttributedString*)attributedString frame:(CGRect)frame;
- (NSMutableAttributedString*)createChapterString:(NSString*)text;

- (CTFrameRef)createFrameRef:(NSMutableAttributedString*)attributedString range:(NSRange)range page:(NSInteger)index model:(JUDIAN_READ_ChapterContentModel*)model;
- (void)pagination:(JUDIAN_READ_ChapterContentModel*)model;
- (CGRect)getAdViewRect:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model;
- (BOOL)isWrapText:(NSInteger)index;
- (CGRect)getContentViewFrame;
- (CGRect)getFrameOutOfAd;

@end

NS_ASSUME_NONNULL_END
