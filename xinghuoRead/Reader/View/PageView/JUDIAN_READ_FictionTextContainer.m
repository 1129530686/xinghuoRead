//
//  JUDIAN_READ_FictionTextContainer.m
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionTextContainer.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_TextStyleManager.h"

@implementation JUDIAN_READ_FictionTextContainer


- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    UIColor* color = nil;
    
    if (_bgColor) {
        color = _bgColor;
    }
    else {
        JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
        color = [style getBgColor];
    }
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    
    CTFrameRef frameRef = [[JUDIAN_READ_CoreTextManager shareInstance] getChapterFrameRef:_attributedString frame:rect];
    
    if (frameRef) {
        CTFrameDraw(frameRef, ctx);
        CFRelease(frameRef);
    }
}

@end
