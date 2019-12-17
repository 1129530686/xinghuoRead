//
//  JUDIAN_READ_UserEarningsTaskCell.h
//  xinghuoRead
//
//  Created by judian on 2019/6/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserEarningsTaskCell : UITableViewCell
@property(nonatomic, copy)modelBlock block;
@property(nonatomic, weak)UIView* lineView;
- (void)updateTask:(JUDIAN_READ_TaskModel*)model isCheckIn:(BOOL)isCheckIn;
@end



@interface JUDIAN_READ_UserGoldCountCell : UITableViewCell
@property(nonatomic, copy)modelBlock block;
- (void)updateCell;
@end



NS_ASSUME_NONNULL_END
