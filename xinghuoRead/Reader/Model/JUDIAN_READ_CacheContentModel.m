//
//  JUDIAN_READ_CacheContentModel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/18.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CacheContentModel.h"

@implementation JUDIAN_READ_CacheContentModel


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.chapnum = [aDecoder decodeObjectForKey:@"chapnum"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.next_chapter = [aDecoder decodeObjectForKey:@"next_chapter"];
        self.prev_chapter = [aDecoder decodeObjectForKey:@"prev_chapter"];
        self.totalChap = [aDecoder decodeObjectForKey:@"totalChap"];
        //self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
    }
    return self;
}





-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.chapnum forKey:@"chapnum"];
    
    [aCoder encodeObject:self.next_chapter forKey:@"next_chapter"];
    [aCoder encodeObject:self.prev_chapter forKey:@"prev_chapter"];
    [aCoder encodeObject:self.totalChap forKey:@"totalChap"];
    //[aCoder encodeObject:self.pageArray forKey:@"pageArray"];

}





@end
