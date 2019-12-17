//
//  UILabel+JUDIAN_READ_Label.h
//  xinghuoRead
//
//  Created by judian on 2019/4/22.
//  Copyright © 2019 judian. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JUDIAN_READ_Label)

- (CGFloat)getTextWidth:(CGFloat)height count:(NSInteger)count;
- (CGFloat)getTextWidth:(CGFloat)height;
- (CGFloat)getTextHeight:(CGFloat)width;

- (CGSize)sizeWithAttributes:(CGSize)size;

- (void)computeAttributedTextHeight:(CGFloat)width height:(NSInteger*)height lineCount:(NSInteger*)lineCount;

@end

NS_ASSUME_NONNULL_END
