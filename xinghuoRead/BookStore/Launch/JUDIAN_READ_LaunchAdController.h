//
//  JUDIAN_READ_LaunchAdController.h
//  xinghuoRead
//
//  Created by 胡建波 on 2019/5/10.
//  Copyright © 2019年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTSplashAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LaunchAdController : UIViewController<GDTSplashAdDelegate>
@property (nonatomic,copy) VoidBlock  launchBlock;
@end

NS_ASSUME_NONNULL_END
