//
//  NSUserDefaults+JUDIAN_READ_UserDefaults.m
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "NSUserDefaults+JUDIAN_READ_UserDefaults.h"

@implementation NSUserDefaults (JUDIAN_READ_UserDefaults)


+ (id)getUserDefaults:(NSString*)key {
    if (!key) {
        return nil;
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+ (void)saveUserDefaults:(NSString*)key value:(id)value {
    
    if (!key) {
        return;
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:value forKey:key];
    [def synchronize];
    
}



+ (void)removeUserDefaults:(NSString*)key {
    
    if (!key) {
        return;
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:key];
    [def synchronize];
}



@end
