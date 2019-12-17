//
//  JUDIAN_READ_CoreTextManager.m
//  xinghuoRead
//
//  Created by judian on 2019/5/14.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_TextStyleModel.h"
#import "JUDIAN_READ_TextStyleManager.h"

@implementation JUDIAN_READ_CoreTextManager


+ (instancetype)shareInstance {
    static JUDIAN_READ_CoreTextManager* _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JUDIAN_READ_CoreTextManager alloc]init];
    });
    
    return _instance;
}




- (CGPathRef)createRectanglePathRef:(CGRect)layoutFrame {
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layoutFrame.size.width, layoutFrame.size.height)];
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}




- (NSMutableAttributedString*)createAttributedString:(NSString*)text {
    
    if(!text) {
        return [[NSMutableAttributedString alloc] initWithString:@""];;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    JUDIAN_READ_TextStyleModel*style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;

    //字体颜色
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:[style getTextColor] range:NSMakeRange(0, text.length)];
    
    //字体大小
    CGFloat fontSize = style.textSize;
    //[UIFont systemFontOfSize:fontSize].fontName
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)FONT_ALIBABA_PUHUITI_LIGHT, fontSize, NULL);
    [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, text.length)];
    CFRelease(fontRef);
    
    //下划线
    //[attributedString addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInteger:kCTUnderlineStyleDouble] range:NSMakeRange(0, text.length)];

    //字体间距
    long number = 0;
    CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)numberRef range:NSMakeRange(0, text.length)];
    CFRelease(numberRef);
    
    //行间距
    CGFloat lineSpacing = style.LineSpacing;
    
#if 0
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)paragraphRef range:NSMakeRange(0, [attributedString length])];
    CFRelease(paragraphRef);
#else
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraphStyle.lineSpacing = lineSpacing;
    //段落间距
    paragraphStyle.paragraphSpacing = [style getParagraphSpacing];
    //对齐方式
    paragraphStyle.alignment = NSTextAlignmentJustified;
    //指定段落开始的缩进像素
    paragraphStyle.firstLineHeadIndent = 0;
    //调整全部文字的缩进像素
    //paragraphStyle.headIndent = 10;
    //paragraphStyle.tailIndent = 10;
    //添加段落设置
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
#endif
    
    return attributedString;
}



- (NSMutableAttributedString*)createChapterString:(NSString*)text {
    
    if(!text) {
        return [[NSMutableAttributedString alloc] initWithString:@""];;
    }
    
#if 0
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames ){
        
        printf("FontRes11: %s \n",[familyName UTF8String] );
        
        NSArray*fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames ){
            
            printf("\tFontRes22: %s \n",[fontName UTF8String] );
        }
    }
#endif
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor* textColor = RGB(0x11, 0x11, 0x11);
    
    //字体颜色
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    
    //字体大小
    CGFloat fontSize = 17;
    //行间距
    CGFloat lineSpacing = 11;
    //段间距
    CGFloat paragraphGap = 16;
    
    if (iPhone5 || iPhone6) {
        fontSize = 16;
        lineSpacing = 10;
        paragraphGap = 14;
    }
    else if (iPhone6Plus) {
        fontSize = 19;
        lineSpacing = 12;
        paragraphGap = 18;
    }
    
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)FONT_ALIBABA_PUHUITI_LIGHT, fontSize, NULL);
    [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, text.length)];
    CFRelease(fontRef);
    
    //下划线
    //[attributedString addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInteger:kCTUnderlineStyleDouble] range:NSMakeRange(0, text.length)];
    
    //字体间距
    long number = 0;
    CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)numberRef range:NSMakeRange(0, text.length)];
    CFRelease(numberRef);
    

    
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraphStyle.lineSpacing = lineSpacing;
    //段落间距
    paragraphStyle.paragraphSpacing = paragraphGap;
    //对齐方式
    paragraphStyle.alignment = NSTextAlignmentJustified;
    //指定段落开始的缩进像素
    paragraphStyle.firstLineHeadIndent = 0;
    //调整全部文字的缩进像素
    //paragraphStyle.headIndent = 10;
    //paragraphStyle.tailIndent = 10;
    //添加段落设置
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    

    
    return attributedString;
}





- (NSInteger)computeAttributedTextHeight:(NSAttributedString*)attributedString width:(CGFloat)width lineCount: (NSInteger* _Nullable)lineCount endLine:(NSInteger)endLine {

    if(attributedString.length <= 0) {
        return 0;
    }
    
    
    NSInteger maxHeight = 1000000;
    NSInteger height = 0;
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGRect frame = CGRectMake(0, 0, width, maxHeight);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, frame);
    CTFrameRef textFrameRef = CTFramesetterCreateFrame(framesetterRef,CFRangeMake(0,0), pathRef, NULL);
    CGPathRelease(pathRef);
    CFRelease(framesetterRef);
    
    NSArray *linesArray = (NSArray*) CTFrameGetLines(textFrameRef);
    
    CGPoint origins[linesArray.count];
    CTFrameGetLineOrigins(textFrameRef, CFRangeMake(0, 0), origins);
    
    NSInteger yPosition = 0;
    if (endLine < 0) {
        yPosition = (NSInteger)origins[linesArray.count - 1].y;
    }
    else {
        NSInteger lastIndex = endLine;
        if (lastIndex > linesArray.count) {
            lastIndex = linesArray.count;
        }
        
        yPosition = (NSInteger)origins[lastIndex - 1].y;
    }
    
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:linesArray.count - 1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CFRelease(textFrameRef);

    height = frame.size.height - yPosition + (NSInteger)descent + 1;
    
    if (lineCount) {
        *lineCount = linesArray.count;
    }
    
    return height;

}



- (CGPathRef)createRegionPathRef:(CGRect)region {
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, region.size.width, region.size.height)];
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}



- (NSArray*)splitContent:(NSAttributedString*)attributedString frame:(CGRect)frame {
    
    NSInteger pos = 0;
    
    NSInteger paragraphPosition = 0;
    
    NSUInteger length = [attributedString length];
    NSMutableArray *pageArray = [NSMutableArray array];
    CFAttributedStringRef strRef = (__bridge CFAttributedStringRef)attributedString;
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString(strRef);
    
  
    if (pos < length)  {
        
        CGPathRef pathRef = [self createRegionPathRef:frame];

        CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        CTFrameRef frameRef = NULL;
        
        frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(pos, 0), pathRef, NULL);

        CFRange stringRange = CTFrameGetVisibleStringRange(frameRef);
        //NSRange pageRange = NSMakeRange(stringRange.location, stringRange.length);
        pos += stringRange.length;
        CFRelease(frameRef);
        //[pageArray addObject:[NSValue valueWithRange:pageRange]];
        
        paragraphPosition = [self getNearParagraphPosition:pos attributedText:attributedString];
    }
    
    CFRelease(framesetterRef);
    
    NSRange pageRange = NSMakeRange(0, paragraphPosition);
    [pageArray addObject:[NSValue valueWithRange:pageRange]];
    if (paragraphPosition < attributedString.length) {
        NSInteger nextPosition = paragraphPosition + 1;
        pageRange = NSMakeRange(nextPosition, length - nextPosition);
        [pageArray addObject:[NSValue valueWithRange:pageRange]];
    }
    else {
        pageRange = NSMakeRange(0, 0);
        [pageArray addObject:[NSValue valueWithRange:pageRange]];
    }
    
    return pageArray;
    
}




- (NSInteger)getNearParagraphPosition:(NSInteger)position attributedText:(NSAttributedString*)attributedText {
    
    NSInteger forward = position;
    NSInteger backOff = position;
    
    BOOL isNoFrontReturn = FALSE;
    BOOL isNoBackReturn = FALSE;
    
    while (TRUE) {
        
        if (forward < 0) {
            isNoFrontReturn = TRUE;
            break;
        }
        
        NSRange pageRange = NSMakeRange(forward, 1);
        NSAttributedString* text = [attributedText attributedSubstringFromRange:pageRange];
        if ([text.string rangeOfString:@"[\n]" options:NSRegularExpressionSearch].location != NSNotFound){
            break;
        }
        forward--;
    }


    while (TRUE) {
        
        if (backOff >= attributedText.length) {
            isNoBackReturn = TRUE;
            break;
        }
        
        NSRange pageRange = NSMakeRange(backOff, 1);
        NSAttributedString* text = [attributedText attributedSubstringFromRange:pageRange];
        if ([text.string rangeOfString:@"[\n]" options:NSRegularExpressionSearch].location != NSNotFound){
            break;
        }
        backOff++;
    }
    
    
    if (isNoBackReturn || isNoFrontReturn) {
        return attributedText.length;
    }
    
    
    //判断当前位置是靠近前一个段结尾近，还是后一个段落结尾近
    if((position - forward) < (backOff - position) ) {
        return (forward);
    }
    else {
        return (backOff);
    }
    
    return 0;
}




- (CTFrameRef)getChapterFrameRef:(NSAttributedString*)attributedString frame:(CGRect)frame {
    
    if (!attributedString) {
        return NULL;
    }
    
    CGPathRef pathRef = [self createRectanglePathRef:frame];
    
    //CGRect exclusionRegion = CGRectZero;
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frameRef = NULL;
    frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [attributedString length]), pathRef, NULL);
    CFRelease(frameSetterRef);
    
    return frameRef;
}



#pragma mark 仿真页面排版相关

- (CTFrameRef)createFrameRef:(NSMutableAttributedString*)attributedString range:(NSRange)range page:(NSInteger)index model:(JUDIAN_READ_ChapterContentModel*)model{
    NSAttributedString* pageText = [attributedString attributedSubstringFromRange:range];
    return [self getFrameRef:pageText page:index model:model];
}


- (void)pagination:(JUDIAN_READ_ChapterContentModel*)model {
    
    if (model.content.length <= 0) {
        return;
    }
    
    NSAttributedString* attributedString = [[JUDIAN_READ_CoreTextManager shareInstance] createAttributedString:model.content];
    
    int pos = 0;
    NSUInteger length = [attributedString length];
    
    NSMutableArray *pageArray = [NSMutableArray array];
    NSMutableArray* adFrameArray  = [NSMutableArray array];
    
    CFAttributedStringRef strRef = (__bridge CFAttributedStringRef)attributedString;
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString(strRef);
    NSInteger count = 1;
    
    NSRange pageRange = NSMakeRange(0, 0);
    CFRange stringRange = CFRangeMake(0, 0);
    
    while (pos < length)  {
        
        CGPathRef pathRef = [self getRegionPathRef];
        
        BOOL isSurrounding = [self isWrapText:count];
        CGRect exclusionRegion = CGRectZero;
        
        CTFrameRef frameRef = NULL;
        frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(pos, 0), pathRef, NULL);
        stringRange = CTFrameGetVisibleStringRange(frameRef);
        pageRange = NSMakeRange(stringRange.location, stringRange.length);
        CFRelease(frameRef);
        
        if ((pos + stringRange.length) >= length) {//最后一页没有广告
            exclusionRegion = [self computeAdViewRegion:frameSetterRef start:pos lastPage:TRUE];
            isSurrounding = FALSE;
        }
        
        if (isSurrounding) {
            exclusionRegion = [self computeAdViewRegion:frameSetterRef start:pos lastPage:FALSE];
            NSDictionary *optionsDict = [self createWrapTextRegion:exclusionRegion];
            frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(pos, 0), pathRef, (__bridge CFDictionaryRef)optionsDict);
            
            stringRange = CTFrameGetVisibleStringRange(frameRef);
            pageRange = NSMakeRange(stringRange.location, stringRange.length);
            pos += stringRange.length;
            CFRelease(frameRef);
        }
        else {
            pos += stringRange.length;
        }
        
        
        if (exclusionRegion.origin.x == -2) {//最后一页放不下“赞赏”,需要增加一页
            [pageArray addObject:[NSValue valueWithRange:pageRange]];
            [adFrameArray addObject:[NSValue valueWithCGRect:CGRectZero]];
            
            [pageArray addObject:[NSValue valueWithRange:NSMakeRange(0, 0)]];
            [adFrameArray addObject:[NSValue valueWithCGRect:exclusionRegion]];
        }
        else {
            [pageArray addObject:[NSValue valueWithRange:pageRange]];
            [adFrameArray addObject:[NSValue valueWithCGRect:exclusionRegion]];
        }
        
        count++;
    }
    
    CFRelease(frameSetterRef);
    
    model.pageArray = pageArray;
    model.adViewFrameArray = adFrameArray;
    
}


- (CGRect)getAdViewRect:(NSInteger)pageIndex model:(JUDIAN_READ_ChapterContentModel*)model {
    
    if (pageIndex < 0) {
        return CGRectZero;
    }
    
    if (pageIndex >= model.adViewFrameArray.count) {
        return CGRectZero;
    }
    
    
    NSValue* value = model.adViewFrameArray[pageIndex];
    CGRect rect = [value CGRectValue];
    return rect;
}


- (BOOL)isWrapText:(NSInteger)index {
    
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    if (!showAdView) {
        return FALSE;
    }
    
    return (index > 0 && (index % 4 == 0));
}


- (CGPathRef)getRegionPathRef {
    CGRect layoutFrame = [self getLayoutFrame];
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layoutFrame.size.width, layoutFrame.size.height)];
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}


- (CGPathRef)getAdRegionPathRef {
    CGRect layoutFrame = [self getLayoutFrame];
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layoutFrame.size.width, 200)];
    
    
    UIBezierPath* nextPartPath = nil;
    nextPartPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 450, layoutFrame.size.width, layoutFrame.size.height - 450)];
    
    [path appendPath:nextPartPath];
    
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}


- (CGRect)getLayoutFrame {
    CGRect layoutFrame = [self getContentViewFrame];
    return CGRectMake(0, 0, layoutFrame.size.width, layoutFrame.size.height);
}




- (CTFrameRef)getFrameRef:(NSAttributedString*)attributedString page:(NSInteger)index model:(JUDIAN_READ_ChapterContentModel*)model {
    
    CGPathRef pathRef = [self getRegionPathRef];
    
    CGRect exclusionRegion = CGRectZero;
    
    NSValue* value = model.adViewFrameArray[index];
    exclusionRegion = [value CGRectValue];
    
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frameRef = NULL;
    
    if (exclusionRegion.size.width > 0) {
        
#if 1
        NSDictionary *optionsDict = [self createWrapTextRegion:exclusionRegion];
        frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [attributedString length]), pathRef, (__bridge CFDictionaryRef)optionsDict);
#else
        pathRef = [self getAdRegionPathRef];
        frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [attributedString length]), pathRef, NULL);
#endif
        
    }
    else {
        frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [attributedString length]), pathRef, NULL);
    }
    
    CFRelease(frameSetterRef);
    
    return frameRef;
}


- (NSDictionary*)createWrapTextRegion:(CGRect)exclusionRegion {
    
    CGMutablePathRef exclusionPathRef = CGPathCreateMutable();
    CGPathAddRect(exclusionPathRef, NULL, exclusionRegion);
    
    CFStringRef keys[] = { kCTFramePathClippingPathAttributeName };
    CFTypeRef values[] = { exclusionPathRef };
    
    CFDictionaryRef exclusionPathDictionary = CFDictionaryCreate(NULL,
                                                                 (const void **)&keys, (const void **)&values,
                                                                 sizeof(keys) / sizeof(keys[0]),
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);
    
    NSArray *exclusionPaths = [NSArray arrayWithObject:(__bridge_transfer id)exclusionPathDictionary];
    
    NSDictionary *optionsDictioary = [NSDictionary dictionaryWithObject:exclusionPaths forKey:(NSString*)kCTFrameClippingPathsAttributeName];
    
    CFRelease(exclusionPathRef);
    return optionsDictioary;
}




- (CGRect)computeAdViewRegion:(CTFramesetterRef)frameSetterRef start:(NSInteger)start lastPage:(BOOL)lastPage{
    
    CGPathRef pathRef = [self getRegionPathRef];
    CTFrameRef frameRef = NULL;
    frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(start, 0), pathRef, NULL);
    
    CGRect layoutFrame = [self getLayoutFrame];
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frameRef);
    NSInteger lineCount = lines.count;
    
    if (lineCount <= 0) {
        return CGRectZero;
    }
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    CFRelease(frameRef);
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    NSInteger startIndex = 0;
    
    startIndex = lineCount - 4;
    
    NSInteger endIndex = lineCount - 1;
    CGPoint point = lineOrigins[endIndex];
    CTLineRef line = (__bridge CTLineRef)lines[endIndex];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    if (lastPage) {
        NSInteger yPos = point.y - ceil(ascent);
        if(yPos >= (PAGE_APPRECIATE_VIEW_HEIGH + 30)) {
            CGRect contentViewFrame = [self getContentViewFrame];
            return CGRectMake(0, contentViewFrame.size.height - yPos, -1, -1);
        }
        
        return CGRectMake(-2, -2, -2, -2);;
    }
    
    
    
    if (startIndex >= 0) {
        
        CTLineRef line = (__bridge CTLineRef)lines[startIndex];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        NSInteger adHeight = [self getEmbeddedAdHeight];
        
        NSInteger yPos = lineOrigins[startIndex].y;//lineOrigins[startIndex].y + ceil(descent);
        
        CGRect contentViewFrame = [self getContentViewFrame];
        yPos = (contentViewFrame.size.height - adHeight) / 2;
        CGRect rect = CGRectMake(0, yPos, layoutFrame.size.width, adHeight);
        
        return rect;
    }
    
    return CGRectZero;
}




- (NSInteger)getEmbeddedAdHeight {
    NSInteger height = ceil(DESCRIPTION_WIDTH * 0.5625);
    NSInteger cellHeight = (34 + height + 34) + 20;
    return cellHeight;
}




- (CGRect)getContentViewFrame {

    CGRect frame = CGRectZero;
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];

    //NSInteger offset = 57;
    NSInteger offset = 39;
    
    if (showAdView) {
        frame = CGRectMake(20, offset + TOP_OFFSET, [UIScreen mainScreen].bounds.size.width - 2 * 20, [UIScreen mainScreen].bounds.size.height - offset - 105 - TOP_OFFSET - BOTTOM_OFFSET);
    }
    else {
        frame = CGRectMake(20, offset + TOP_OFFSET, [UIScreen mainScreen].bounds.size.width - 2 * 20, [UIScreen mainScreen].bounds.size.height - offset - 20 - TOP_OFFSET - BOTTOM_OFFSET);
    }
    return frame;
}

- (CGRect)getFrameOutOfAd {
    CGRect frame = CGRectZero;
    BOOL showAdView = [JUDIAN_READ_TestHelper needAdView:GUANG_DIAN_TONG_SWITCH];
    if (showAdView) {
        frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 63 - BOTTOM_OFFSET);
    }
    else {
        frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - BOTTOM_OFFSET);
    }
    return frame;
}


@end
