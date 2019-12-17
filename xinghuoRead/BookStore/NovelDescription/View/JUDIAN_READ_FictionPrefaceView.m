//
//  JUDIAN_READ_FictionPrefaceView.m
//  xinghuoRead
//
//  Created by judian on 2019/6/13.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FictionPrefaceView.h"

@interface JUDIAN_READ_FictionPrefaceView ()
@property(nonatomic, assign)CGRect arrowImageRect;
@end



@implementation JUDIAN_READ_FictionPrefaceView

- (instancetype)init {
    self = [super init];
    if (self) {
        _arrowImageRect = CGRectZero;
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
#if 0
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    
    CTFrameRef frameRef = [_model getTextFrameRef:rect];
    
    if (frameRef) {
        CTFrameDraw(frameRef, ctx);
        CFRelease(frameRef);
    }
#else
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    NSAttributedString *string = _model.attributedString;
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFAttributedStringRef attributedString = (__bridge CFTypeRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    BOOL needsTruncation = CTFrameGetVisibleStringRange(frame).length < string.length;
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSUInteger lineCount = CFArrayGetCount(lines);
    CGPoint *origins = malloc(sizeof(CGPoint) * lineCount);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    for (NSUInteger i = 0; i < lineCount; i++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint point = origins[i];
        CGContextSetTextPosition(context, point.x, point.y);
        
        BOOL truncate = (needsTruncation && (i == lineCount - 1));
        if (!truncate) {
            CTLineDraw(line, context);
            if ((i == lineCount - 1) && (_arrowImageRect.size.width > 0)) {
                UIImage *image = [UIImage imageNamed:@"novel_extra_up_arrow"];
                CGContextDrawImage(context, _arrowImageRect, image.CGImage);
            }
        }
        else {
            NSDictionary *attributes = [string attributesAtIndex:string.length-1 effectiveRange:NULL];
            NSAttributedString *token = [[NSAttributedString alloc] initWithString:@"\u2026\u2026" attributes:attributes];
            CFAttributedStringRef tokenRef = (__bridge CFAttributedStringRef)token;
            CTLineRef truncationToken = CTLineCreateWithAttributedString(tokenRef);
            double width = CTLineGetTypographicBounds(line, NULL, NULL, NULL) - CTLineGetTrailingWhitespaceWidth(line) - 12;
            CTLineRef truncatedLine = CTLineCreateTruncatedLine(line, width-1, kCTLineTruncationEnd, truncationToken);

            if (_model.arrowState != NOVEL_BRIEF_ARROW_NONE) {
                _arrowImageRect = CGRectMake(point.x + width, point.y, 12, 7);
                UIImage *image = [UIImage imageNamed:@"novel_extra_down_arrow"];
                CGContextDrawImage(context, _arrowImageRect, image.CGImage);
            }


            if (truncatedLine) {
                CTLineDraw(truncatedLine, context);
            }
            else {
                CTLineDraw(line, context);
            }
            
            if (truncationToken) {
                CFRelease(truncationToken);
            }
            
            if (truncatedLine) {
                CFRelease(truncatedLine);
            }
        }
    }
    
    free(origins);
    CGPathRelease(path);
    CFRelease(frame);
    CFRelease(framesetter);
    
#endif
}

@end
