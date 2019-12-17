//
//  JUDIAN_READ_ChapterContentCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_FictionTextContainer.h"


typedef void(^touchBlock)(_Nullable id args);

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ChapterContentCell : UICollectionViewCell
@property(nonatomic, strong) JUDIAN_READ_FictionTextContainer* textView;
@property(nonatomic, copy)touchBlock block;
- (void)setContent:(NSAttributedString*)attributedText;
@end


@interface JUDIAN_READ_SegmentChapterContentCell : JUDIAN_READ_ChapterContentCell
@property(nonatomic, copy)touchBlock nextRenderBlock;
- (void)setContent:(NSAttributedString*)attributedText nextTip:(BOOL)nextTip;
@end


NS_ASSUME_NONNULL_END
