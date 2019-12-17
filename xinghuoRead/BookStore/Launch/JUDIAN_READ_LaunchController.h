//
//  LaunchController.h
//  Norval
//
//  Created by 胡建波 on 2019/4/16.
//  Copyright © 2019年 com.Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_LaunchController : JUDIAN_READ_BaseViewController

@property (nonatomic, copy) void (^startBlock)(BOOL shared);



@end

NS_ASSUME_NONNULL_END
