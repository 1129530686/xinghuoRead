//
//  TestHelper.m
//  YYHealth
//
//  Created by apple on 18/8/7.
//  Copyright (c) 2015年 Hu. All rights reserved.
//

#import "JUDIAN_READ_TestHelper.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "JUDIAN_READ_AppDelegate.h"
#import "JUDIAN_READ_UserReadingModel.h"
#import "JUDIAN_READ_NovelManager.h"

@import AVFoundation;

#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

@interface JUDIAN_READ_TestHelper()
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateComponents *adcomps;
@end

@implementation JUDIAN_READ_TestHelper

+ (NSDictionary *)JSONSTringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    return responseJSON;
}

+ (NSString *)JSONDictionaryToString:(NSDictionary *)JSONDictionary {
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSONDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    return JSONString;
}

/**
 *
 *  身份证验证
 *
 */
+ (BOOL)isValidateIdentityCard:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *// //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
        
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"] && ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    } else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    } return YES;
    
}

/**
 *
 *  手机验证 YES正确 NO错误
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    //NSString * MOBILE = @"^1[3|4|5|7|8][0-9]\\d{8}$";
//    NSString *MOBILE = @"^(\\d+-)?(\\d{4}-?\\d{7}|\\d{3}-?\\d{8}|^\\d{7,8})(-\\d+)?$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)) {
//        return YES;
//    }
//    else {
//        return NO;
//    }
//
    
    //手机的格式校验1开头，数字，11位
    if (mobileNum.length == 11) {
        if([[mobileNum substringToIndex:1] isEqualToString:@"1"]){
            mobileNum = [mobileNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            if(mobileNum.length == 0)
                return YES;
        }
    }
    return NO;
}



/**
    从身份证上获取年龄 18位身份证
 */

+ (NSString *)getIdentityCardAge:(NSString *)numberStr {
    
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self birthdayStrFromIdentityCard:numberStr]];
  
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
 
    int age = trunc(dateDiff/(60*60*24))/365;
    return [NSString stringWithFormat:@"%d",-age];
}


+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr {
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

/**
 *  从身份证上获取性别
 */

+ (NSString *)getIdentityCardSex:(NSString *)numberStr {
    NSString *sex = @"";
    //获取18位 二代身份证  性别
    if (numberStr.length==18) {
        int sexInt=[[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
        if(sexInt%2!=0) {
            sex = @"1"; //男孩
        } else {
            sex = @"0"; //女孩
        }
    }
    //  获取15位 一代身份证  性别

    if (numberStr.length==15){
        int sexInt=[[numberStr substringWithRange:NSMakeRange(14,1)] intValue];
        if(sexInt%2!=0) {
            sex = @"1"; //男孩
        } else {
            sex = @"0"; //女孩
        }
    }
    return sex;
}




/**
 *
 *  邮箱验证
 *
 */
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *
 *  密码验证
 *
 */
+ (BOOL)isValidPassword:(NSString *)password {
    BOOL result = false;
    if ([password length] >= 8 && [password length] <= 16){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}

/**
 *
 *  账号用户名验证
 *

 */
+ (BOOL)isValidateAccount:(NSString *)account {
    NSString *userName = @"^[A-Za-z][A-Za-z0-9_]{5,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userName];
    return [userNamePredicate evaluateWithObject:account];

}


+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }

    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }

    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tipStr];
        [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [alertView bk_addButtonWithTitle:@"设置" handler:nil];
        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
            if (index == 1) {
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        }];
        [alertView show];
    }else{
        kTipAlert(@"%@", tipStr);
    }
}

//判断是否是纯数字
+ (BOOL)isOnlyNumber:(NSString *)inputString{
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

/**
 *  判断是否含有非法字符 yes 合法  no非法 (字母和汉字组成)
 */
+ (BOOL)checkUserName:(NSString *)content{
    NSString *str = @"^[A-Za-z\\u4e00-\u9fa5·s]{1,30}+$";//@"[\u4E00-\u9FA5\uf900-\ufa2d·s]{2,30}";//
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
        if ([emailTest evaluateWithObject:content]) {
            return YES;
        }
        return NO;
}

//是否为小数or正数 正整数或保留两位小数
+ (BOOL)isValidMoney:(NSString *)identityString accuracy:(NSInteger)count{
    NSString *str = count ? [NSString stringWithFormat:@"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,%ld})?$",count]:[NSString stringWithFormat:@"^(0|[1-9][0-9]*)$"];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if ([test evaluateWithObject:identityString]) {
        return YES;
    }
    return NO;
}



+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

+ (NSString *)dateChangeUTC:(NSDate *)date{
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    timeSp = [NSString stringWithFormat:@"%lld", [timeSp longLongValue] * 1000]; // *1000 是精确到毫秒，不乘就是精确到秒
    return timeSp;
}

+ (NSString *)UTCchangeDate:(NSString *)utc withFormat:(NSString *)format{
    NSTimeInterval time = [utc doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:format];
    NSString *staartstr = [dateformatter stringFromDate:date];
    return staartstr;
}
+ (NSString *)TENUTCchangeDate:(NSString *)utc withFormat:(NSString *)format{
    NSTimeInterval time = [utc doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:format];
    NSString *staartstr = [dateformatter stringFromDate:date];
    return staartstr;
}

#pragma mark 昨天时间
+(NSString *)getLastDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //一天的秒数
    NSTimeInterval time = 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *weekDate =  [dateFormatter stringFromDate:lastWeek];
    return weekDate;
}

#pragma mark 当前时间
+(NSString *)getCurrentDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currenDate =  [dateFormatter stringFromDate:date];
    return currenDate;
}


+(NSString *)getTodayString {
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currenDate =  [dateFormatter stringFromDate:date];
    return currenDate;
}


#pragma mark 一周前
+(NSString *)getWeekAgoDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //一周的秒数
    NSTimeInterval time = 7 * 24 * 60 * 60;
    //下周就把"-"去掉
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *weekDate =  [dateFormatter stringFromDate:lastWeek];
    return weekDate;
}

#pragma mark 一月前
+(NSString *)getMontnAgoDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //一月的秒数
    NSTimeInterval time = 30 * 24 * 60 * 60;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *weekDate =  [dateFormatter stringFromDate:lastWeek];
    return weekDate;
}

#pragma mark 一季前
+(NSString *)getSeasonAgoDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //一季的秒数
    NSTimeInterval time = 30 * 24 * 60 * 60 * 3;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *weekDate =  [dateFormatter stringFromDate:lastWeek];
    return weekDate;
}

#pragma mark 一年前
+(NSString *)getYearAgoDate{
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //一年的秒数
    NSTimeInterval time = 24 * 60 * 60 * 365;
    NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
    NSString *weekDate =  [dateFormatter stringFromDate:lastWeek];
    return weekDate;
}

//日期转字符串
+ (NSString *)changeDateToString:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}


//根据出生日期获取年龄
+(NSString *)getAgeByBirthday:(NSString *)birthday{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
    //年龄未满月可以显示多少天，未满周岁的显示多少个月。
    if ([date month] < 1 && [date year] < 1 ) {
        return [NSString stringWithFormat:@"%ld天",(long)([date day]+1)];
    }else if ([date year] < 1 ){
        return [NSString stringWithFormat:@"%ld月",(long)([date month])];
    }
    return [NSString stringWithFormat:@"%ld岁",(long)([date year])];
}


//获取日期，month给一个数,正数是以后n个月，负数是前n个月；
- (NSString *)getDateFromFormatter:(NSString *)formatter withYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    NSDate * date = [NSDate date];
    
    NSDateComponents *comps = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    [self.adcomps setYear:year];
    
    [self.adcomps setMonth:month];
    
    [self.adcomps setDay:day];
    
    NSDate *newdate = [self.calendar dateByAddingComponents:self.adcomps toDate:date options:0];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatter];
    
    NSString *lastDate =  [dateFormatter stringFromDate:newdate];
    
    return lastDate;
}

-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
    }
    return _calendar;
}

-(NSDateComponents *)adcomps{
    if (!_adcomps) {
        _adcomps = [[NSDateComponents alloc] init];
    }
    return _adcomps;
}


+ (void)deleteCachePath:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}


+ (void)updateFictionCache {
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        BOOL canClearCache = FALSE;
        
        NSArray* bookArray = [JUDIAN_READ_UserReadingModel queryAllCachedBooks];
        for (NSString* bookId in bookArray) {
            BOOL isNewCached = [[JUDIAN_READ_NovelManager shareInstance] isFictionInDocument:bookId chpaterId:_DOWN_FICTION_FLAG_];
            if (!isNewCached) {
                canClearCache = TRUE;
                NSString* bookPath = [[JUDIAN_READ_NovelManager shareInstance] getFictionDirectory:bookId];
                [JUDIAN_READ_TestHelper deleteCachePath:bookPath];
            }
        }
        
        if (canClearCache) {
            [JUDIAN_READ_UserReadingModel clearCachedBooks];
        }
        
    });

}



+ (BOOL)needAdView:(NSString*)type {
    BOOL needAd = FALSE;

    JUDIAN_READ_AppDelegate *app = (JUDIAN_READ_AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!app.isHaveNet) {
        return needAd;
    }
    
    NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:type];
    if (status.integerValue == 1) {
        needAd = TRUE;
    }
    
    if ([type isEqualToString:GET_MONEY_SWITCH]) {
        if (status.length) {
            needAd = true;
        }else{
            needAd = false;
        }
    }

    return needAd;
}


+ (void)showSystemSettingAlert:(NSString*)message viewController:(UIViewController*)viewController {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:confirm];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

+ (NSString*)getQrCode {
    NSString* uid = [JUDIAN_READ_Account currentAccount].uid;
    NSString* qrCode = @"";
    if (uid.length > 0) {
        qrCode = [NSString stringWithFormat:@"%@/authorize.html?uid=%@", API_HOST_NAME, uid];
    }
    
    return qrCode;
}



+ (BOOL)joinQQGroup {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *group = [def objectForKey:QQ_Group];
    NSString *group1 = [def objectForKey:QQ_Group_Key];
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", group,group1];
    NSURL *url = [NSURL URLWithString:urlStr];
    BOOL result = FALSE;
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        result = YES;
    }
    else {
        result = FALSE;
        [MBProgressHUD showMessage:APP_NOT_INSTALL_QQ_TIP];
    }

    return result;
    
}


+ (BOOL)needUpdate{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString* remoteVersion = [def objectForKey:@"version"];
    NSString* localVersion = GET_VERSION_NUMBER;
    
    remoteVersion = [remoteVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    localVersion = [localVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger remoteVersionInt = [remoteVersion integerValue];
    NSInteger localVersionInt = [localVersion integerValue];
    
    if (remoteVersionInt > localVersionInt) {
        return YES;
    }
    return NO;
}

@end
