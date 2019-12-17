//
//  NSArray+JUDIAN_READ_KeyedArchiver.h
//  xinghuoRead
//
//  Created by judian on 2019/5/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (JUDIAN_READ_KeyedArchiver)


-(BOOL) archiveFile:(NSString*)path;
+ (NSArray*)unarchiveFile:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
