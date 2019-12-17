//
//  TCCircleProgressView.h
//
//
//  Created by hu on 8/10/18.
//  Copyright © 2018 hu. All rights reserved.
//
#import "JUDIAN_READ_CircleProgressView.h"
@interface JUDIAN_READ_CircleProgressView()

///进度圆
@property (nonatomic, strong) CAShapeLayer * circleLayer;
//
@property (nonatomic, strong) UIButton * imageView;

@property (nonatomic, assign) CGPoint customCenter;
///起点偏离角度 本来是以最右边为0开始顺时针到2PI的 如果startOffsetAngle=-0.5PI 则为从顶端开始 依次类推
@property (nonatomic, assign) CGFloat startOffsetAngle;
///三角形指示箭头的半径
@property (nonatomic, assign) CGFloat trangleRadius;

@end

@implementation JUDIAN_READ_CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpUI];
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    _startOffsetAngle = -0.5* M_PI;
    //圆的大小
    CGFloat rectWidth = 23;
    CGFloat centerX =  11.5;
    CGFloat centerY = self.bounds.size.height/2;
    _customCenter = CGPointMake(centerX, centerY);
    CGFloat lineWidth = 1.2;
    

    _imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageView addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    [_imageView setImage:[UIImage imageNamed:@"cache_list_suspended"] forState:UIControlStateNormal];
    _imageView.contentMode = UIViewContentModeLeft;
    [self addSubview:_imageView];
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:2 constant:-self.width+centerX]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:self.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:self.height]];


    
    // 创建弧线路径对象
    UIBezierPath *fullCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, self.bounds.size.height/2) radius:rectWidth/2 startAngle:_startOffsetAngle endAngle:_startOffsetAngle+2*M_PI  clockwise:YES];
    fullCirclePath.lineCapStyle  = kCGLineCapRound;
    fullCirclePath.lineJoinStyle = kCGLineCapRound;
    
    //整个圆 底部半透明白圆
    CAShapeLayer * fullCirclelayer = [CAShapeLayer layer];
    fullCirclelayer.lineCap = kCALineCapButt;
    fullCirclelayer.fillColor = [UIColor clearColor].CGColor;
    fullCirclelayer.lineWidth = lineWidth;
    fullCirclelayer.strokeColor = kColor204.CGColor;
    fullCirclelayer.path = fullCirclePath.CGPath;
    [self.layer addSublayer:fullCirclelayer];

    //全白进度展示圆
    CAShapeLayer * progressLayer = [CAShapeLayer layer];
    progressLayer.lineCap = kCALineCapButt;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = lineWidth;
    progressLayer.strokeColor = kThemeColor.CGColor;
    progressLayer.path = fullCirclePath.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0.1;
    [self.layer addSublayer:progressLayer];
    self.circleLayer = progressLayer;

    

}

- (void)setProgress:(CGFloat)progress {
    _progress  = progress;
    self.circleLayer.strokeEnd = progress;
}

- (void)touchBtn{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
