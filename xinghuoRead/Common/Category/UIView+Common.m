//
//  UIView+Common.m
//
//  Created by apple on 2017-06-01.
//  Copyright © 2019 hu. All rights reserved.
//

#import "UIView+Common.h"

#define kColorDDD [UIColor getColor:@"#DDDDDD"]

@implementation UIView (Common)

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    [self layoutIfNeeded];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = kColorDDD.CGColor;
    }else {
        self.layer.borderColor = color.CGColor;
    }
}

- (void)doCircleFrameWithBorderColor:(UIColor *)borderColor{
    [self layoutIfNeeded];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = borderColor.CGColor;
}


- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


- (void)setText:(NSString *)text textFontSize:(UIFont *)font textColot:(UIColor *)color attFontSie:(UIFont *)attFont attTextColor:(UIColor *)attColor attRange:(NSRange)range needIndent:(BOOL)need{
    if (!text.length) {
        return;
    }
    color = color ? color : kColor63;
    font = font ? font : kFontSize13;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : font}];
    if (attFont || attColor) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:attColor forKey:NSForegroundColorAttributeName];
        [dic setObject:attFont forKey:NSFontAttributeName];
        [att addAttributes:dic range:range];
    }
    if (need) {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.headIndent = 0.0f;//行首缩进
        CGFloat emptylen = font.pointSize * 1.5;
        paraStyle.firstLineHeadIndent = emptylen;//首行缩进
        paraStyle.tailIndent = 0.0f;//行尾缩进
        paraStyle.lineSpacing = 2.0f;//行间距
        [dic1 setObject:paraStyle forKey:NSParagraphStyleAttributeName];
        [att addAttributes:dic1 range:NSMakeRange(0, text.length)];
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self;
        [btn setAttributedTitle:att forState:UIControlStateNormal];
    }
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)self;
        lab.attributedText = att;
    }
}

- (void)setText:(NSString *)text titleFontSize:(CGFloat)font titleColot:(UIColor *)color{
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton*)self;
        [btn setTitle:text forState:UIControlStateNormal];
        if (color) {
            [btn setTitleColor:color forState:UIControlStateNormal];
        }
        if (font != 0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:font];
        }
    }
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UITextView class]]) {
        UILabel *lab = (UILabel*)self;
        lab.text = text;
        if (color) {
            lab.textColor = color;
        }
        if (font != 0) {
            lab.font = [UIFont systemFontOfSize:font];
        }
    }
}



- (void)clipCorner:(CGSize)size corners:(NSInteger)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)clipCorner:(CGSize)size corners:(NSInteger)corners frame:(CGRect)frame {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
