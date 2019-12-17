//
//  JUDIAN_READ_Account.m
//  xinghuoRead
//
//  Created by 胡建波 on 2019/4/22.
//  Copyright © 2019年 judian. All rights reserved.
//

#import "JUDIAN_READ_Account.h"

@implementation JUDIAN_READ_Account


- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }


#pragma mark -得到系统帐号
+ (JUDIAN_READ_Account *)currentAccount{
    
    NSData *accountData = [NSUserDefaults getUserDefaults:@"account"];
    if (!accountData) {
        return nil;
    }
    
    JUDIAN_READ_Account* account =(JUDIAN_READ_Account *)[NSKeyedUnarchiver unarchiveObjectWithData:accountData];
    NSString* memberState = [NSUserDefaults getUserDefaults:_IS_PERMANENT_MEMBER_];
    if ([memberState isEqualToString:@"YES"]) {
        account.vip_type = @"5";
        account.vip_status = @"1";
    }
    return account;
    
}
#pragma mark -保存系统帐号
+ (void)saveCurrentAccount:(JUDIAN_READ_Account *)account{
    
    [NSUserDefaults saveUserDefaults:@"account" value:nil];
    
    if (account) {
        NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
        [NSUserDefaults saveUserDefaults:@"account" value:accountData];
    }
}


#pragma mark -  删除系统账号
+ (void)deleteCurrentAccount{
    [NSUserDefaults saveUserDefaults:@"account" value:nil];
    
}


@end
