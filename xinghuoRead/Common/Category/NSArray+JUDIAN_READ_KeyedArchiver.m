//
//  NSArray+JUDIAN_READ_KeyedArchiver.m
//  xinghuoRead
//
//  Created by judian on 2019/5/8.
//  Copyright © 2019 judian. All rights reserved.
//

#import "NSArray+JUDIAN_READ_KeyedArchiver.h"

@implementation NSArray (JUDIAN_READ_KeyedArchiver)

-(BOOL) archiveFile:(NSString*)path {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL didWriteSuccessfull = [data writeToFile:path atomically:YES];
    return didWriteSuccessfull;
}


+ (NSArray*)unarchiveFile:(NSString*)path {
    NSData * data = [NSData dataWithContentsOfFile:path];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


@end
