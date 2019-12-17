//
//  HDeviceIdentifier.h
//  HDeviceIdentifier
//
//

#import <Foundation/Foundation.h>

@interface JUDIAN_READ_HDeviceIdentifier : NSObject
/**
 *  同步唯一设备标识 (生成并保存唯一设备标识,如已存在则不进行任何处理)
 *
 *  @return 是否成功
 */
+(BOOL)syncDeviceIdentifier;

/**
 *  返回唯一设备标识
 *
 *  @return 设备标识
 */
+(NSString*)deviceIdentifier;

/**
 *  本应用是第一次安装
 *
 *  @return 是否是第一次安装
 */
+(BOOL)isFirstInstall;

@end
