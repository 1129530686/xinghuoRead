//
//  JUDIAN_READ_RecommendFictionCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ArticleListModel.h"
#import "JUDIAN_READ_DiscoveryMoreIconCell.h"
#import "JUDIAN_READ_DiscoveryBigIconCell.h"
#import "JUDIAN_READ_DiscoveryLeadIconCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_RecommendFictionCell : UICollectionViewCell
- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model;
@end



@interface JUDIAN_READ_RecommendThreeImageCell : UICollectionViewCell
- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model;
- (NSInteger) getCellHeight:(JUDIAN_READ_ArticleListModel*)model;
@end


@interface JUDIAN_READ_RecommendBigImageCell : UICollectionViewCell
- (void)updateCell:(JUDIAN_READ_ArticleListModel*)model;
- (NSInteger) getCellHeight:(JUDIAN_READ_ArticleListModel*)model;
@end


NS_ASSUME_NONNULL_END
