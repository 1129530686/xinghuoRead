//
//  JUDIAN_READ_ArticleNegativeView.h
//  xinghuoRead
//
//  Created by judian on 2019/4/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_ArticlePositiveViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_ArticleNegativeViewController : UIViewController

@property (strong, nonatomic) JUDIAN_READ_ArticlePositiveViewController *positiveViewController;

- (void)updateBgImage:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
