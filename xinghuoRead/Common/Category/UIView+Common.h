#import <UIKit/UIKit.h>

@interface UIView (Common)

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (void)doCircleFrameWithBorderColor:(UIColor *)borderColor;

/**
 *
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

/*
    设置lab、btn富文本，
 textFontSize:字体大小 默认13
 textColot :字体颜色 默认63
 attFontSie:富文本颜色
 attTextColor:富文本字体大小
 attRange：范围
need表示是否需要首行缩进
 
 */
- (void)setText:(NSString *)text textFontSize:(UIFont *)font textColot:(UIColor *)color attFontSie:(UIFont *)attFont attTextColor:(UIColor *)attColor attRange:(NSRange)range needIndent:(BOOL)need;

//设置lab或者btn字体以及颜色
- (void)setText:(NSString *)text titleFontSize:(CGFloat)font titleColot:(UIColor *)color;

- (void)clipCorner:(CGSize)size corners:(NSInteger)corners;
- (void)clipCorner:(CGSize)size corners:(NSInteger)corners frame:(CGRect)frame;

@end
