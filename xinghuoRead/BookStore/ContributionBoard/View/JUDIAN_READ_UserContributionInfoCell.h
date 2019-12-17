//
//  JUDIAN_READ_UserContributionInfoCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserContributionModel.h"
#import "JUDIAN_READ_UserAppreciatedChapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserContributionInfoCell : UITableViewCell
- (void)updateUserContribution:(JUDIAN_READ_UserContributionModel*)model row:(NSInteger)row;
- (void)updateChapterContribution:(JUDIAN_READ_UserAppreciatedChapterModel*)model;
@end


@interface JUDIAN_READ_UserRoundCornerImageView : UIImageView

@end


NS_ASSUME_NONNULL_END
