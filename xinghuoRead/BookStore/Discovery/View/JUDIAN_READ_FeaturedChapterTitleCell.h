//
//  JUDIAN_READ_FeaturedChapterTitleCell.h
//  xinghuoRead
//
//  Created by judian on 2019/8/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_FictionChapterTitleCell.h"
#import "JUDIAN_READ_FeaturedFictionModel.h"

#define FLOAT_WINDOW_HEIGHT 101
#define FeaturedNotification @"featuredNotification"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_FeaturedChapterTitleCell : JUDIAN_READ_FictionChapterTitleCell

@end



@interface JUDIAN_READ_FeaturedNextChapterTipCell : UICollectionViewCell



@end


@interface JUDIAN_READ_FeaturedPageCell : UICollectionViewCell
@property(nonatomic, copy)CompletionBlock block;
@property(nonatomic, weak)UICollectionView* novelCollectionView;
- (UITextView*)getTextView;
- (void)updateText:(NSString*)text row:(NSInteger)row;
- (UICollectionView*)getCollectionView;
- (void)updateHeadState:(BOOL)needRefreshView;
- (void)updateContentPosition :(NSInteger)position;
- (void)updateCellWithModel:(JUDIAN_READ_FeaturedFictionModel*)model;
@end



@interface JUDIAN_READ_FeaturedChapterDescriptionCell : UICollectionViewCell
- (void)updateCellWithModel:(JUDIAN_READ_FeaturedFictionModel*)model;
@end


@interface JUDIAN_READ_FeaturedDescriptionFloatView : UIView
- (void)updateViewWithModel:(JUDIAN_READ_FeaturedFictionModel*)model;
@end


NS_ASSUME_NONNULL_END
