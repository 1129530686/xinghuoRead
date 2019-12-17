//
//  JUDIAN_READ_UserShippingAddressEditorController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/4.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserBriefViewModel.h"
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserShippingAddressEditorController : JUDIAN_READ_BaseViewController
+ (void)enterShippingAddresssEditor:(UINavigationController*)navigationController model:(JUDIAN_READ_UserDeliveryAddressModel* _Nullable)model block:(_Nullable modelBlock)block;
@end

NS_ASSUME_NONNULL_END
