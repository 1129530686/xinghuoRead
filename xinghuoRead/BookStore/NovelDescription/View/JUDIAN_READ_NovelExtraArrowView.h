//
//  JUDIAN_READ_NovelExtraArrowView.h
//  xinghuoRead
//
//  Created by judian on 2019/5/5.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_NovelSummaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_NovelExtraArrowView : UICollectionViewCell
- (void)updateArrow:(JUDIAN_READ_NovelSummaryModel*)model;
@end

NS_ASSUME_NONNULL_END
