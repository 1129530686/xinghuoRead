//
//  JUDIAN_READ_UserSubAreaViewController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserSubAreaViewController : JUDIAN_READ_BaseViewController
+ (void)enterSubAreaViewController:(UINavigationController*)navigationController title:(NSString*)title data:(NSArray*)array nextCascade:(BOOL)nextCascade;
@end

NS_ASSUME_NONNULL_END
