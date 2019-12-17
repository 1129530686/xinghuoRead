//
//  JUDIAN_READ_BookLeaderboardController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/15.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_TitleViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_BookLeaderboardController : JUDIAN_READ_TitleViewController

+ (void)enterLeaderboardController:(UINavigationController*)navigationController editorid:(NSString* _Nullable)editorid channel:(NSString* _Nullable) channel pressName:(NSString*)pressName;

@end

NS_ASSUME_NONNULL_END
