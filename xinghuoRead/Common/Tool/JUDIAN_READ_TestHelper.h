//
//  TestHelper.h
//
//  Created by apple on 18/8/7.
//  Copyright (c) 2018年 Hu. All rights reserved.
//

/**
 *
 * 验证类
 *
 */

#import <Foundation/Foundation.h>

@interface JUDIAN_READ_TestHelper : NSObject

+ (BOOL)isMobileNumber:(NSString *)mobileNum;//手机验证方法

+ (BOOL)isValidateEmail:(NSString *)email;//邮箱验证方法

+ (BOOL)isValidPassword:(NSString *)password;//密码验证

+ (BOOL)isValidateIdentityCard:(NSString *)identityString;//身份证验证

+ (NSString *)getIdentityCardSex:(NSString *)numberStr; //从身份证上获取性别

+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;

+ (NSString *)getIdentityCardAge:(NSString *)numberStr;  //从身份证上获取年龄 18位身份证

+ (BOOL)isValidateAccount:(NSString *)account;//账号验证

+ (NSDictionary *)JSONSTringToNSDictionary:(NSString *)JSONString;//字符串JSON解析

+ (NSString *)JSONDictionaryToString:(NSDictionary *)JSONDictionary;

+ (BOOL)isValidMoney:(NSString *)identityString accuracy:(NSInteger)count;//数字以及小数验证

//获取日期，month给一个数,正数是以后n个月，负数是前n个月；
- (NSString *)getDateFromFormatter:(NSString *)formatter withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

//判断是否含有非法字符 yes 有  no没有 (字母和汉字组成)
+ (BOOL)checkUserName:(NSString *)content;

//判断是否包含表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//判断是否是纯数字
+ (BOOL)isOnlyNumber:(NSString *)inputString;

+(NSString *)getLastDate;

+(NSString *)getCurrentDate;

+(NSString *)getWeekAgoDate;

+(NSString *)getMontnAgoDate;

+(NSString *)getSeasonAgoDate;

+(NSString *)getYearAgoDate;

+(NSString *)changeDateToString:(NSDate *)date formatter:(NSString *)formatter;

+ (NSString *)dateChangeUTC:(NSDate *)date;

+ (NSString *)UTCchangeDate:(NSString *)utc withFormat:(NSString *)format;

+ (NSString *)TENUTCchangeDate:(NSString *)utc withFormat:(NSString *)format;

+(NSString *)getAgeByBirthday:(NSString *)birthday;
+(NSString *)getTodayString;

+ (void)deleteCachePath:(NSString*)path;

+ (BOOL)needAdView:(NSString*)type;

+ (void)showSystemSettingAlert:(NSString*)message viewController:(UIViewController*)viewController;

+ (void)updateFictionCache;

+ (NSString*)getQrCode;

+ (BOOL)joinQQGroup;

+ (BOOL)needUpdate;

@end
