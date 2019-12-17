//
//  JUDIAN_READ_ContributionBoardTop3Cell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserContributionModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ContributionBoardTop3Cell : UITableViewCell
@property(nonatomic, copy)modelBlock block;
- (void)updateCell:(NSArray*)array;
@end


@interface JUDIAN_READ_UserContributionMoneyView : UIControl
- (void)updateUserContribution:(JUDIAN_READ_UserContributionModel*)model;
- (void)updateHead:(CGSize)size level:(NSString*)level;
- (void)updateDefaultUser:(NSString*)imageNmae;
@end





NS_ASSUME_NONNULL_END



