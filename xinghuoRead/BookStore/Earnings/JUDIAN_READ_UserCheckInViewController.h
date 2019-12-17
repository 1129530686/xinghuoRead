//
//  JUDIAN_READ_UserCheckInViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/19.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserEarningsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserCheckInViewController : UIViewController
+ (void)enterUserCheckInViewController:(UINavigationController*)navigationController viewContoller:(JUDIAN_READ_UserEarningsViewController*)sourceViewController;
@end

NS_ASSUME_NONNULL_END
