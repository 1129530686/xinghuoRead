//
//  JUDIAN_READ_ChapterTitleModel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/23.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ChapterTitleModel.h"

@implementation JUDIAN_READ_ChapterTitleModel



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.chapter_id = [aDecoder decodeObjectForKey:@"chapter_id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.chapnum = [aDecoder decodeObjectForKey:@"chapnum"];
    }
    return self;
}





-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.chapter_id forKey:@"chapter_id"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.chapnum forKey:@"chapnum"];
    
}









@end
