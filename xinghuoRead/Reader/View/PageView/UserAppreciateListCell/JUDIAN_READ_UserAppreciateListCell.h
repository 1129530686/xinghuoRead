//
//  JUDIAN_READ_UserAppreciateListCell.h
//  xinghuoRead
//
//  Created by judian on 2019/5/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserAppreciatedItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAppreciateListCell : UITableViewCell
- (void)setAppreciatedInfoWithMode:(JUDIAN_READ_UserAppreciatedItemModel*)model;
@end

NS_ASSUME_NONNULL_END
