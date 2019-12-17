//
//  JUDIAN_READ_DeviceUtils.h
//  xinghuoRead
//
//  Created by judian on 2019/5/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUDIAN_READ_DeviceUtils : NSObject
+ (BOOL)isIphoneX;
+ (NSString *)getDeviceName;
+ (NSInteger)getBatteryLevel;
@end

NS_ASSUME_NONNULL_END
