//
//  JUDIAN_READ_TextStyleModel.m
//  xinghuoRead
//
//  Created by judian on 2019/4/28.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_TextStyleModel.h"

@implementation JUDIAN_READ_TextStyleModel


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.textSize = [aDecoder decodeIntegerForKey:@"textSize"];
        self.textColorIndex = [aDecoder decodeIntegerForKey:@"textColorIndex"];
        self.textSpacing = [aDecoder decodeIntegerForKey:@"textSpacing"];
        
        self.LineSpacing = [aDecoder decodeIntegerForKey:@"LineSpacing"];
        self.bgColorIndex = [aDecoder decodeIntegerForKey:@"bgColorIndex"];
        self.eyeMode = [aDecoder decodeIntegerForKey:@"eyeMode"];
        
        self.brightness = [aDecoder decodeDoubleForKey:@"brightness"];
        self.nightMode = [aDecoder decodeDoubleForKey:@"nightMode"];
        self.paragraphSpacing = [aDecoder decodeDoubleForKey:@"paragraphSpacing"];
        if (self.paragraphSpacing <= 0) {
            self.paragraphSpacing = [self getDefaultParagraphGap];
        }
        self.pageStyle = [aDecoder decodeDoubleForKey:@"pageStyle"];
    }
    return self;
}


- (void)initStyle {
    _textSize = [self getDefaultFontSize];
    _paragraphSpacing = [self getDefaultParagraphGap];
    _textColorIndex = 0;
    _textSpacing = 0;
    _LineSpacing = [self getDefaultLineSpace];
    _bgColorIndex = 0;

    _brightness = 1;//[UIScreen mainScreen].brightness;

    _eyeMode = FALSE;
    _nightMode = FALSE;
    
    _pageStyle = kStylePageCurlIndex;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.textSize forKey:@"textSize"];
    [aCoder encodeInteger:self.textColorIndex forKey:(@"textColorIndex")];
    [aCoder encodeInteger:self.textSpacing forKey:@"textSpacing"];
    [aCoder encodeInteger:self.LineSpacing forKey:@"LineSpacing"];
    [aCoder encodeInteger:self.bgColorIndex forKey:@"bgColorIndex"];
    
    [aCoder encodeInteger:self.eyeMode forKey:@"eyeMode"];
    [aCoder encodeDouble:self.brightness forKey:@"brightness"];
    
    [aCoder encodeDouble:self.nightMode forKey:@"nightMode"];
    [aCoder encodeDouble:self.paragraphSpacing forKey:@"paragraphSpacing"];
    [aCoder encodeDouble:self.pageStyle forKey:@"pageStyle"];

}



- (UIColor*)getTextColor {
    if (_nightMode) {
        return READER_TEXT_NIGHT_COLOR;
    }
    
    return READER_TEXT_COLOR;
}



- (UIColor*)getBgColor {
    
    if (_nightMode) {
        return READER_BG_LIGHT_BLACK_COLOR;
    }
    
    
    if (_bgColorIndex == kLightGrayIndex) {
        return READER_BG_LIGHT_GRAY_COLOR;
    }
    
    if (_bgColorIndex == kLightYellowIndex) {
        return READER_BG_LIGHT_YELLOW_COLOR;
    }
    
    if (_bgColorIndex == kLightGreenIndex) {
        return READER_BG_LIGHT_GREEN_COLOR;
    }
    
    return READER_BG_LIGHT_GRAY_COLOR;
}

- (BOOL)isNightMode {
    if (_nightMode) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)getEyeMode {
    return _eyeMode;
}


- (NSInteger)getParagraphSpacing {
    return _paragraphSpacing;
}



- (void)decreaseFontSize {
    
    if ([self isMinFontSize]) {
        return;
    }
    
    _textSize -= [self getFontStep];
    _paragraphSpacing -= [self getParagraphStep];
}

- (void)increaseFontSize {
    
    if ([self isMaxFontSize]) {
        return;
    }
    
    _textSize += [self getFontStep];
    _paragraphSpacing += [self getParagraphStep];
}


- (NSInteger)getChapterTitleFontSize {
    NSInteger defaultFontSize = [self getDefaultFontSize];
    NSInteger increaseFont = (self.textSize - defaultFontSize);
    NSInteger fontSize = [self getDefaultTitleFontSize] + increaseFont;
    return fontSize;
}


- (NSInteger)getParagraphStep {
    return 1;
}


- (NSInteger)getFontStep {
    return 3;
}


- (NSInteger)getDefaultTitleFontSize {
    
    if (iPhone5 || iPhone6) {
        return 15;
    }
    
    if (iPhone6Plus) {
        return 19;
    }
    
    return 17;
}


- (void)adjustSamllLineSpace {
    _LineSpacing = [self getMinLineSpace];;
}

- (void)adjustMiddleLineSpace {
    _LineSpacing = [self getDefaultLineSpace];
}


- (void)adjustBigLineSpace {
    _LineSpacing = [self getMaxLineSpace];
}


#pragma mark 返回对应的视图标识
- (BOOL)isMinFontSize {
    
    if (_textSize <= [self getMinFontSize]) {
        return TRUE;
    }
    
    return FALSE;
}

- (BOOL)isMaxFontSize {
    
    if (_textSize >= [self getMaxFontSize]) {
        return TRUE;
    }
    
    return FALSE;
}

#if 0
//字体大小
CGFloat fontSize = 17;
//行间距
CGFloat lineSpacing = 11;
//段间距
CGFloat paragraphGap = 16;

if (iPhone5 || iPhone6) {
    fontSize = 15;
    lineSpacing = 10;
    paragraphGap = 14;
}
else if (iPhone6Plus) {
    fontSize = 19;
    lineSpacing = 12;
    paragraphGap = 18;
}
#endif


- (NSInteger)getDefaultFontSize {
    CGFloat fontSize = 17;
    if (iPhone5 || iPhone6) {
        fontSize = 16;
    }
    else if (iPhone6Plus) {
        fontSize = 19;
    }
    
    return fontSize;
}



- (NSInteger)getMinFontSize {
    CGFloat fontSize = 11;
    if (iPhone5 || iPhone6) {
        fontSize = 10;
    }
    else if (iPhone6Plus) {
        fontSize = 13;
    }
    
    return fontSize;
}



- (NSInteger)getMaxFontSize {
    CGFloat fontSize = 29;
    if (iPhone5 || iPhone6) {
        fontSize = 37;
    }
    else if (iPhone6Plus) {
        fontSize = 40;
    }
    
    return fontSize;
}



- (NSInteger)getDefaultParagraphGap {
    //段间距
    CGFloat paragraphGap = 16;
    if (iPhone5 || iPhone6) {
        paragraphGap = 14;
    }
    else if (iPhone6Plus) {
        paragraphGap = 18;
    }
    
    return paragraphGap;
}



- (NSInteger)getDefaultLineSpace {
    CGFloat lineSpacing = 11;
    if (iPhone5 || iPhone6) {
        lineSpacing = 10;
    }
    else if (iPhone6Plus) {
        lineSpacing = 11;
    }
    
    return lineSpacing;
}


- (NSInteger)getMinLineSpace {
    CGFloat lineSpacing = 3;
    if (iPhone5 || iPhone6) {
        lineSpacing = 2;
    }
    else if (iPhone6Plus) {
        lineSpacing = 4;
    }

    return lineSpacing;
}



- (NSInteger)getMaxLineSpace {
    CGFloat lineSpacing = 17;
    if (iPhone5 || iPhone6) {
        lineSpacing = 16;
    }
    else if (iPhone6Plus) {
        lineSpacing = 18;
    }
    
    return lineSpacing;
}




- (NSInteger)getLineSpaceLevel {
    
    if (_LineSpacing >= [self getMaxLineSpace]) {
        return kLineSpaceBigTag;
    }
    
    if (_LineSpacing >= [self getDefaultLineSpace]) {
        return kLineSpaceMiddleTag;
    }
    
    if (_LineSpacing >= [self getMinLineSpace]) {
        return kLineSpaceSmallTag;
    }
    
    return 0;
}



- (NSInteger)getPageScrollLevel {
    
    if (_pageStyle == kStylePageCurlIndex) {
        return kStylePageCurlTag;
    }
    
    if (_pageStyle == kStylePageScrollIndex) {
        return kStylePageScrollTag;
    }
    
    if (_pageStyle == kStylePageVerticalIndex) {
        return kStylePageVerticalTag;
    }
    
    if (_pageStyle == kStylePageCoverIndex) {
        return kStylePageCoverTag;
    }
    
    return kStylePageCurlTag;
}


- (NSInteger)getBgColorLevel {
    
    if (_nightMode) {
        return kLightBlackTag;
    }
    
    if (_bgColorIndex == kLightGrayIndex) {
        return kLightGrayTag;
    }
    
    if (_bgColorIndex == kLightYellowIndex) {
        return kLightYellowTag;
    }
    
    if (_bgColorIndex == kLightGreenIndex) {
        return kLightGreenTag;
    }
    
    return 0;
}





@end
