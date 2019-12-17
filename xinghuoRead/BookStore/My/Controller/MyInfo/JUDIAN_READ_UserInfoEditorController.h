//
//  JUDIAN_READ_UserInfoEditorController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/3.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_UserBriefViewModel.h"
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_UserInfoEditorController : JUDIAN_READ_BaseViewController
+ (void)enterUserInfoEditor:(UINavigationController*)navigationController title:(NSString*)title placeholder:(NSString*)placeholder userBriefModel:(JUDIAN_READ_UserBriefModel*)userBriefModel;
@end

NS_ASSUME_NONNULL_END
