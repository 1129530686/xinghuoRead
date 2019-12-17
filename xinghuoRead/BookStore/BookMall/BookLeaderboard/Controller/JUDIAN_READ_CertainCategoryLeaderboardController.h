//
//  JUDIAN_READ_CertainCategoryLeaderboardController.h
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUDIAN_READ_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_CertainCategoryLeaderboardController : JUDIAN_READ_BaseViewController
@property(nonatomic, assign)NSString* editorId;
@property(nonatomic, assign)BOOL isComplete;
@property(nonatomic, assign)BOOL isPress;
@property(nonatomic, assign)NSString* channelName;
@property(nonatomic, assign)NSString* filterType;
@property(nonatomic, assign)NSString* sortType;
@property(nonatomic, weak)UIViewController* viewController;
@end

NS_ASSUME_NONNULL_END
