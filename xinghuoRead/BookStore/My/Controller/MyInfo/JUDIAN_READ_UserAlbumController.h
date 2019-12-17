//
//  JUDIAN_READ_UserAlbumController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/2.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserAlbumController : JUDIAN_READ_BaseViewController
+ (void)enterUserAlbumController:(UINavigationController*)navigationController block:(CompletionBlock)block;
@end

NS_ASSUME_NONNULL_END
