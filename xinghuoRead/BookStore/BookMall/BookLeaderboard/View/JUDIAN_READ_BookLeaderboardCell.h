//
//  JUDIAN_READ_BookLeaderboardCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_CustomBackgroundViewCell.h"
#import "JUDIAN_READ_BookDescribeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookLeaderboardCell : JUDIAN_READ_CustomBackgroundViewCell
- (void)updateCell:(JUDIAN_READ_BookDescribeModel*)model type:(NSString*)type row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
