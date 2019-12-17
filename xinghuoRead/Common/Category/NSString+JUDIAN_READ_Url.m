//
//  NSString+JUDIAN_READ_Url.m
//  xinghuoRead
//
//  Created by judian on 2019/4/17.
//  Copyright © 2019 judian. All rights reserved.
//

#import "NSString+JUDIAN_READ_Url.h"

@implementation NSString (JUDIAN_READ_Url)

-(NSString *)encodeUrl {
    NSString *string = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)string,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


- (NSString *) removeAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, [self length])];
    
}


@end
