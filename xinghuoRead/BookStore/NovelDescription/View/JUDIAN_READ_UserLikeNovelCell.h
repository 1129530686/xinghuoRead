//
//  JUDIAN_READ_UserLikeNovelCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/9.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_NovelSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserLikeNovelCell : UICollectionViewCell
@property(nonatomic, copy)modelBlock block;
- (void)updateCell:(JUDIAN_READ_NovelSummaryModel*)model;
@end



@interface JUDIAN_READ_UserCollectNovelView : UIControl
- (void)updateCell:(NSString*)title content:(NSString*)content;
@end





NS_ASSUME_NONNULL_END
