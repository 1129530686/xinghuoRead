//
//  JUDIAN_READ_CornerLabel.m
//  xinghuoRead
//
//  Created by judian on 2019/7/16.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CornerLabel.h"

@implementation JUDIAN_READ_CornerLabel


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
#if 0
    [RGB(0xcc, 0xcc, 0xcc) setStroke];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(3, 3)];
    
    maskPath.lineWidth = 0.5;
    [maskPath stroke];
#endif
}




@end
