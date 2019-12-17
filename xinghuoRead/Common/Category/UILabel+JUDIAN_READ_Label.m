//
//  UILabel+JUDIAN_READ_Label.m
//  xinghuoRead
//
//  Created by judian on 2019/4/22.
//  Copyright © 2019 judian. All rights reserved.
//

#import "UILabel+JUDIAN_READ_Label.h"

@implementation UILabel (JUDIAN_READ_Label)

- (CGFloat)getTextWidth:(CGFloat)height {
    CGRect frame = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName:self.font}
                                  context:nil];
    return ceil(frame.size.width);
}


- (CGFloat)getTextWidth:(CGFloat)height count:(NSInteger)count {
    NSString* text = self.text;
    if (text.length > count) {
        text = [text substringToIndex:count - 1];
    }
    
    CGRect frame = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:self.font}
                                           context:nil];
    return ceil(frame.size.width);
}




- (CGFloat)getTextHeight:(CGFloat)width {
    CGRect frame = [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:self.font}
                                           context:nil];
    return ceil(frame.size.height);
}




- (CGSize)sizeWithAttributes:(CGSize)size {
    CGSize textSize = [self.attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return  textSize;
}



- (void)computeAttributedTextHeight:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount {
    
    if (self.attributedText.length <= 0) {
        return;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGFloat maxHeight = 10000;
    CGRect pathRect = CGRectMake(0, 0, width, maxHeight);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pathRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(textFrame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), lineOrigins);
    
    *lineCount = count;
    
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    
    if (count >= 2) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, 1);;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);

        *height = ceil(maxHeight - lineOrigins[1].y + (NSInteger)descent + 1);
    }
    
    
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(textFrame);

}




#if 0

/* 3.实际编程时，有时需要计算一段文字最后一个字符的位置，并在其后添加图片或其他控件（如info图标），下面代码为计算label中最后一个字符后面一位的位置的方法。
 CGSize sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];CGSize linesSz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];if(sz.width <= linesSz.width)
 //判断是否折行
 { lastPoint = CGPointMake(label.frame.origin.x + sz.width, label.frame.origin.y); }else { lastPoint = CGPointMake(label.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height); }
 */



#endif


@end
