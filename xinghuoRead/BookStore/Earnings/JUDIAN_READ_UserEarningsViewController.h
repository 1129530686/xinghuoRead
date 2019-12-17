//
//  JUDIAN_READ_UserEarningsViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/6/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserEarningsViewController : JUDIAN_READ_BaseViewController
+ (void)entryEarningsViewController:(UINavigationController*)navigationController;
- (void)loadRewardVedio:(UIViewController*)viewController;
- (void)showNotificationSettingView;
@end

NS_ASSUME_NONNULL_END
