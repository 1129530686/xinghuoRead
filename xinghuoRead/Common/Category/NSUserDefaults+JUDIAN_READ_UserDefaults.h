//
//  NSUserDefaults+JUDIAN_READ_UserDefaults.h
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (JUDIAN_READ_UserDefaults)

+ (id)getUserDefaults:(NSString*)key;
+ (void)saveUserDefaults:(NSString*)key value:(_Nullable id)value;
+ (void)removeUserDefaults:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
