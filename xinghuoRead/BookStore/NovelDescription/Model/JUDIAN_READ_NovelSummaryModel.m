//
//  JUDIAN_READ_NovelSummaryModel.m
//  xinghuoRead
//
//  Created by judian on 2019/5/6.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_NovelSummaryModel.h"
#import "JUDIAN_READ_APIRequest.h"
#import "NSString+JUDIAN_READ_Url.h"
#import "JUDIAN_READ_NovelThumbModel.h"
#import "JUDIAN_READ_CoreTextManager.h"
#import "JUDIAN_READ_NovelManager.h"
#import <AdSupport/AdSupport.h>

@interface JUDIAN_READ_NovelSummaryModel ()
@property(nonatomic, assign)CGFloat minCellHeight;
@property(nonatomic, assign)CGFloat maxCellHeight;
@property(nonatomic, assign)NSInteger renderStepIndex;
@property(nonatomic, assign)NSInteger renderStepCount;
@end




@implementation JUDIAN_READ_NovelSummaryModel


+ (void)buildSummaryModel:(NSString*)novelId block:(summaryBlock)block failure:(summaryBlock)failureBlock {
    
    if (!novelId) {
        return;
    }
    
    NSDictionary* dictionary = @{@"id" : novelId};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/book-detail" params:dictionary isNeedNotification:YES completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        NSDictionary* dictionary = nil;
        dictionary = response[@"data"][@"info"];
        if (response) {
            JUDIAN_READ_NovelSummaryModel* model = [JUDIAN_READ_NovelSummaryModel yy_modelWithJSON:dictionary];
            model.brief = [model.brief removeAllWhitespace];
            model.bookname = [model.bookname stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
            model.author = [model.author stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
            model.arrowState = NOVEL_BRIEF_ARROW_DOWN;
            model.attributedString = [model buildAttributedString];
            
            if ([model.nid isKindOfClass:[NSNumber class]]) {
                model.nid = [NSString stringWithFormat:@"%ld", (long)model.nid.integerValue];
            }
            
            if (block) {
                block(model);
            }
        }
        else {
            if (failureBlock) {
                failureBlock(@"error");
            }
        }
    }];
    
    
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"author_books" : JUDIAN_READ_NovelThumbModel.class,
             @"related_books" : JUDIAN_READ_NovelThumbModel.class
             };
}



+ (void)buildCertainChapterModel:(NSString*)novelId block:(modelBlock)block failure:(modelBlock)failureBlock {
    
    if (!novelId) {
        return;
    }
    
    NSDictionary* dictionary = @{@"book_id" : novelId};
    [JUDIAN_READ_APIRequest POST:@"/appprogram/fiction/v2/book-detail" params:dictionary isNeedNotification:NO completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        
        if (response) {
            NSDictionary* responseDictionary = response[@"data"][@"info"];
            JUDIAN_READ_NovelSummaryModel* model = [JUDIAN_READ_NovelSummaryModel yy_modelWithJSON:responseDictionary];
            
            model.brief = [model.brief removeAllWhitespace];
            model.bookname = [model.bookname stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
            model.author = [model.author stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
            model.arrowState = NOVEL_BRIEF_ARROW_DOWN;
            model.attributedString = [model buildAttributedString];
            model.first_chapter_content = [[JUDIAN_READ_NovelManager shareInstance] cleanContent:model.first_chapter_content];
            model.attributedFirstChapterContent = [[JUDIAN_READ_CoreTextManager shareInstance] createChapterString:model.first_chapter_content];
            model.renderStepIndex = 0;
            model.renderStepCount = 0;
            
            [model computeRenderStepCount];
            
            if ([model.nid isKindOfClass:[NSNumber class]]) {
                model.nid = [NSString stringWithFormat:@"%ld", model.nid.integerValue];
            }
            
            if (block) {
                block(model);
            }
        }
        else if (failureBlock) {
            failureBlock(@"error");
        }
    }];
    
}




+ (JUDIAN_READ_NovelSummaryModel*)buildDefaultSummary {
    
    JUDIAN_READ_NovelSummaryModel* model = [[JUDIAN_READ_NovelSummaryModel alloc] init];
    model.star = @"";
    model.nid = @"";
    model.bookname = @"";
    model.cover = @"";
    model.update_status = @"";
    model.words_number = @"";
    model.tag = @"";
    model.author = @"";
    model.editorid = @"";
    model.brief = @"";
    model.chapter_name = @"";
    model.update_time = @"";
    model.chapters_total = @"";
    model.chapter_update = @"";
    
    model.unread = @"";
    model.read_chapter = @"";
    model.total = @"";
    model.arrowState = NOVEL_BRIEF_ARROW_NONE;
    return model;
}


+ (void)buildExpecialBookModel:(modelBlock)block {
    
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (idfa.length <= 0) {
        return;
    }
    
    NSDictionary* parameter = @{@"idfa" : idfa,
                                @"channel" : @"appStore",
                                @"book" : @""
                                };
    
    [JUDIAN_READ_APIRequest POST:@"/appprogram/channel-active/book" params:parameter
              isNeedNotification:NO
                      completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
                          
                          if (response) {
                              NSDictionary* responseDictionary = response[@"data"][@"info"];
                              JUDIAN_READ_NovelSummaryModel* model = [JUDIAN_READ_NovelSummaryModel yy_modelWithJSON:responseDictionary];
                              
                              if (block) {
                                  block(model);
                              }
                          }
                          
                      }];

}




- (NSMutableAttributedString*)buildAttributedString {
    
    NSString* text = [NSString stringWithFormat:@"简介: %@", self.brief];
    
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// NSLineBreakByTruncatingTail;
    
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [text length])];
    [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(0x66, 0x66, 0x66) range:NSMakeRange(0, [text length])];
    
    return attributedText;
}


- (void)computeAttributedTextHeight:(CGFloat)width {
    
    if (!_attributedString) {
        return;
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedString);
    
    CGFloat maxHeight = 10000;
    CGRect pathRect = CGRectMake(0, 0, width - 26, maxHeight);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pathRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);

    CFArrayRef lines = CTFrameGetLines(textFrame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), lineOrigins);
    
    _lineCount = count;
    
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    
    if (count <= 3) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, count - 1);;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
        _maxCellHeight = ceil(maxHeight - lineOrigins[count - 1].y + (NSInteger)descent + 1);
        _minCellHeight = _maxCellHeight;
        _arrowState = NOVEL_BRIEF_ARROW_NONE;
    }
    else {

        CTLineRef line = CFArrayGetValueAtIndex(lines, count - 1);;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        _maxCellHeight = ceil(maxHeight - lineOrigins[count - 1].y + (NSInteger)descent + 1);

        line = CFArrayGetValueAtIndex(lines, 2);
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        _minCellHeight = ceil(maxHeight - lineOrigins[2].y + (NSInteger)descent + 1);
    }
    
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(textFrame);

}


- (CGFloat)getCellHeight {
    
    //return [self sizeWithAttributes:CGSizeMake(width - 26, MAXFLOAT)].height + 16;
    NSInteger edge = 16 + 16;
    if (_arrowState == NOVEL_BRIEF_ARROW_NONE) {
        return _maxCellHeight + edge;
    }
    
    if (_arrowState == NOVEL_BRIEF_ARROW_DOWN) {
        return _minCellHeight + edge;
    }
    
    if (_arrowState == NOVEL_BRIEF_ARROW_UP) {
        return _maxCellHeight + edge;
    }
    
    return 0;
}



- (NSInteger)getMaxLineCount {
    
    if (_arrowState == NOVEL_BRIEF_ARROW_NONE) {
        return 3;
    }
    
    if (_arrowState == NOVEL_BRIEF_ARROW_DOWN) {
        return 3;
    }
    
    if (_arrowState == NOVEL_BRIEF_ARROW_UP) {
        return _lineCount;
    }
    
    return 0;
    
    
}



- (NSString*)getNovelStateStr {
    
    //0（连载中） 1（已完结） 2（弃更）
    if ([self.update_status isEqualToString:@"0"]) {
        return @"连载";
    }
    else if ([self.update_status isEqualToString:@"1"]) {
        return @"完结";
    }
    else if ([self.update_status isEqualToString:@"2"]) {
        return @"弃更";
    }
    
    return @"";
}



- (CTFrameRef)getTextFrameRef:(CGRect)frame {
    
    if (!_attributedString) {
        return NULL;
    }
    
    CGPathRef pathRef = [self createRectanglePathRef:frame];
    
    //CGRect exclusionRegion = CGRectZero;
    CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    CTFrameRef frameRef = NULL;
    frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, [_attributedString length]), pathRef, NULL);
    CFRelease(frameSetterRef);
    
    return frameRef;
}


- (CGPathRef)createRectanglePathRef:(CGRect)layoutFrame {
    UIBezierPath* path = nil;
    path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, layoutFrame.size.width, layoutFrame.size.height)];
    CGPathRef pathRef = path.CGPath;
    return pathRef;
}




- (void)computeRenderStepCount {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 2 * 20, MAXFLOAT);
    NSInteger lineCount = 0;
    [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:_attributedFirstChapterContent width:size.width lineCount:&lineCount endLine:-1];
    
    if (lineCount > 47) {
        _renderStepCount = 3;
    }
    else if (lineCount > 17) {
        _renderStepCount = 2;
    }
    else {
        _renderStepCount = 1;
    }
}


- (void)goNextRenderStep {
    _renderStepIndex++;
}


- (BOOL)canGoNextRender {
    
    if (_renderStepCount == 1) {
        return NO;
    }
    
    if (_renderStepIndex == 2) {
        return NO;
    }
    
    return YES;
}


- (CGFloat)getNextPartContentHeight {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 2 * 20, MAXFLOAT);
    NSInteger lineCount = 0;
    CGFloat height = 0;
    if (_renderStepIndex == 0) {
       height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:_attributedFirstChapterContent width:size.width lineCount:&lineCount endLine:17];
    }
    else if (_renderStepIndex == 1) {
      height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:_attributedFirstChapterContent width:size.width lineCount:&lineCount endLine:47];
    }
    else {
        height = [[JUDIAN_READ_CoreTextManager shareInstance] computeAttributedTextHeight:_attributedFirstChapterContent width:size.width lineCount:&lineCount endLine:-1];
    }
    
    return height;
}





@end
