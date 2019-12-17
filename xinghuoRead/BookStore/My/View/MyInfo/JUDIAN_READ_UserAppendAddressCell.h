//
//  JUDIAN_READ_UserAppendAddressCell.h
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserBriefViewModel.h"
#import "JUDIAN_READ_CustomBackgroundViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAppendAddressCell : JUDIAN_READ_CustomBackgroundViewCell

@end



@interface JUDIAN_READ_UserEditedAddressCell : JUDIAN_READ_CustomBackgroundViewCell

- (void)updateCell:(JUDIAN_READ_UserDeliveryAddressModel*)model;

@end



NS_ASSUME_NONNULL_END
