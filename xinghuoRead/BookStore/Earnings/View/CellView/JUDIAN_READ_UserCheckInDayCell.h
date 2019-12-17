//
//  JUDIAN_READ_UserCheckInDayCell.h
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserCheckInGoldListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserCheckInDayCell : UITableViewCell
@property(nonatomic, copy)modelBlock block;
@property(nonatomic, copy)NSArray* countArray;
- (void)updateCell:(JUDIAN_READ_UserCheckInGoldListModel*)model;
@end

NS_ASSUME_NONNULL_END
