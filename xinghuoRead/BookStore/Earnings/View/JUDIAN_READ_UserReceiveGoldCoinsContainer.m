//
//  JUDIAN_READ_UserReceiveGoldCoins.m
//  xinghuoRead
//
//  Created by judian on 2019/6/20.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_UserReceiveGoldCoinsContainer.h"
#import "JUDIAN_READ_GoldCoinCountView.h"


typedef enum : NSUInteger {
    SEGMENT4_LINE = 1,
    SEGMENT4_ARC,
} Segment4DrawEnum;


typedef enum : NSUInteger {
    SEGMENT1 = 1,
    SEGMENT2,
    SEGMENT3,
    SEGMENT4,
    SEGMENT5,
    SEGMENT6,
    SEGMENT7,
    SEGMENT8
} SegmentStateEnum;



#define _ROUTE_LINE_X_ 14
#define _ROUTE_LINE_Y_ (39 + 9)
#define _ARC_RADIUS_ 46.5f

#define GET_EARNINGS_COLOR RGB(0xff, 0xa0, 0x30)
#define UN_GET_EARNINGS_COLOR RGB(0xee, 0xee, 0xee)

CGFloat ANGLE_RATE[] = {1.5f, 1.6f, 1.7f,1.8f,1.9f, 0.0f, 0.1f,0.2f,0.3f,0.4f, 0.5f};




@interface JUDIAN_READ_UserReceiveGoldCoinsContainer ()
@property(nonatomic, assign)NSInteger angleIndex;
@property(nonatomic, assign)CGFloat segmentLineX;
@property(nonatomic, strong)dispatch_source_t timer;


@property(nonatomic, assign)CGFloat lineX;
@property(nonatomic, assign)CGFloat lineY;

@property(nonatomic, assign)CGFloat arcX;
@property(nonatomic, assign)CGFloat arcY;
@property(nonatomic, assign)CGFloat radius;

@property(nonatomic, assign)NSInteger drawState;
@property(nonatomic, assign)NSInteger currentSegment;

@property(nonatomic, assign)BOOL circleHightLightColor;

@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count10View;
@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count50View;
@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count100View;
@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count200View;
@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count500View;
@property(nonatomic, weak)JUDIAN_READ_GoldCoinCountView* count1000View;



@end



@implementation JUDIAN_READ_UserReceiveGoldCoinsContainer


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _angleIndex = 0;
        _currentSegment = SEGMENT4;
    
        _radius = _ARC_RADIUS_;
        _lineX = 0;
        _lineY = _ROUTE_LINE_Y_;
        _arcY = _ROUTE_LINE_Y_ + _radius;
        
         _segmentLineX = _lineX;

        _drawState = SEGMENT4_LINE;
        _circleHightLightColor = FALSE;
        
        [self addGoldCoinViews];
        [self addTimeSpanLabel];
        
        [self startTimer];
    }
    
    return self;
}



- (void)addGoldCoinViews {
    
    JUDIAN_READ_GoldCoinCountView* count10View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count10View = count10View;
    [self addSubview:count10View];
    
    JUDIAN_READ_GoldCoinCountView* count50View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count50View = count50View;
    [self addSubview:count50View];
    
    
    JUDIAN_READ_GoldCoinCountView* count100View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count100View = count100View;
    [self addSubview:count100View];
    
    
    JUDIAN_READ_GoldCoinCountView* count1000View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count1000View = count1000View;
    [self addSubview:count1000View];
    
    
    JUDIAN_READ_GoldCoinCountView* count500View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count500View = count500View;
    [self addSubview:count500View];
    
    
    JUDIAN_READ_GoldCoinCountView* count200View = [[JUDIAN_READ_GoldCoinCountView alloc] init];
    _count200View = count200View;
    [self addSubview:count200View];
    
    
    

    CGFloat width = 63;
    CGFloat height = 39;
    
    WeakSelf(that);
    [count10View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(26);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(that.mas_top).offset(0);
    }];
    
    
    [count50View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(count10View.mas_right).offset(23);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(that.mas_top).offset(0);
    }];
    
    
    [count100View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-84);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(that.mas_top).offset(0);
    }];
    
    
    
    [count1000View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(count10View.mas_bottom).offset(53);
    }];
    
    
    
    [count500View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(count1000View.mas_right).offset(72);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(count10View.mas_bottom).offset(53);
    }];
    
    
    
    [count200View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-34);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(count10View.mas_bottom).offset(53);
    }];
    
    


}


- (void)addTimeSpanLabel {

    UIColor* textColor = RGB(0x66, 0x66, 0x66);
    CGFloat fontSize = 12;
    
    UILabel* minute5Label = [[UILabel alloc] init];
    minute5Label.font = [UIFont systemFontOfSize:fontSize];
    minute5Label.textColor = textColor;
    minute5Label.textAlignment = NSTextAlignmentCenter;
    minute5Label.text = @"5分钟";
    [self addSubview:minute5Label];
    
    UILabel* minute30Label = [[UILabel alloc] init];
    minute30Label.font = [UIFont systemFontOfSize:fontSize];
    minute30Label.textColor = textColor;
    minute30Label.textAlignment = NSTextAlignmentCenter;
    minute30Label.text = @"30分钟";
    [self addSubview:minute30Label];
    
    
    UILabel* minute90Label = [[UILabel alloc] init];
    minute90Label.font = [UIFont systemFontOfSize:fontSize];
    minute90Label.textColor = textColor;
    minute90Label.textAlignment = NSTextAlignmentCenter;
    minute90Label.text = @"90分钟";
    [self addSubview:minute90Label];
    

    UILabel* minute180Label = [[UILabel alloc] init];
    minute180Label.font = [UIFont systemFontOfSize:fontSize];
    minute180Label.textColor = textColor;
    minute180Label.textAlignment = NSTextAlignmentCenter;
    minute180Label.text = @"180分钟";
    [self addSubview:minute180Label];
    
    UILabel* minute360Label = [[UILabel alloc] init];
    minute360Label.font = [UIFont systemFontOfSize:fontSize];
    minute360Label.textColor = textColor;
    minute360Label.textAlignment = NSTextAlignmentCenter;
    minute360Label.text = @"360分钟";
    [self addSubview:minute360Label];
    
    
    
    UILabel* minute600Label = [[UILabel alloc] init];
    minute600Label.font = [UIFont systemFontOfSize:fontSize];
    minute600Label.textColor = textColor;
    minute600Label.textAlignment = NSTextAlignmentCenter;
    minute600Label.text = @"600分钟";
    [self addSubview:minute600Label];
    
    NSInteger yOffset = 24;

    WeakSelf(that);
    
    //第一行
    [minute5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count10View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count10View.mas_bottom).offset(yOffset);
    }];
    
    
    
    [minute30Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count50View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count50View.mas_bottom).offset(yOffset);
    }];
    
    
    
    [minute90Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count100View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count100View.mas_bottom).offset(yOffset);
    }];
    
    //第二行
    [minute180Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count200View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count200View.mas_bottom).offset(yOffset);
    }];
    
    
    [minute360Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count500View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count500View.mas_bottom).offset(yOffset);
    }];
    
    
    [minute600Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(that.count1000View.mas_centerX);
        make.width.equalTo(@(63));
        make.height.equalTo(@(12));
        make.top.equalTo(that.count1000View.mas_bottom).offset(yOffset);
    }];
    
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_count10View.width <= 0) {
        return;
    }
    
    _arcX = _count200View.centerX;
    
    if (_currentSegment == SEGMENT1) {
        _lineX = _ROUTE_LINE_X_;
        _segmentLineX = _lineX;
        return;
    }
    
    if (_currentSegment == SEGMENT2) {
        _lineX = _count10View.centerX;
        _segmentLineX = _lineX;
        return;
    }
    
    if (_currentSegment == SEGMENT3) {
        _lineX = _count50View.centerX;
        _segmentLineX = _lineX;
        return;
    }
    
    if (_currentSegment == SEGMENT4) {
        _lineX = _count100View.centerX;
        _segmentLineX = _lineX;
        return;
    }

    
    if (_currentSegment == SEGMENT5) {
        _lineX = _count200View.centerX;
        _segmentLineX = _lineX;
        return;
    }
    
    if (_currentSegment == SEGMENT6) {
        _lineX = _count500View.centerX;
        _segmentLineX = _lineX;
        return;
    }
    
    if (_currentSegment == SEGMENT7) {
        _lineX = _count1000View.centerX;
        _segmentLineX = _lineX;
        return;
    }
    
}


- (void) drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if (rect.size.width <= 0) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    //CGContextTranslateCTM(ctx, 0, rect.size.height);
    //CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect);
    
    [self drawRouter];
    
    if (_currentSegment == SEGMENT1) {
        [self drawLineSegment:_lineY];
    }
    else if(_currentSegment == SEGMENT2) {
        [self drawLineSegment:_lineY];
    }
    else if(_currentSegment == SEGMENT3) {
        [self drawLineSegment:_lineY];
    }
    else if (_currentSegment == SEGMENT4) {
        [self drawSegment4];
    }
    else if (_currentSegment == SEGMENT5 || _currentSegment == SEGMENT6 || _currentSegment == SEGMENT7) {
        CGFloat nextLineY = _arcY + _radius;
        [self drawLineSegment:nextLineY];
    }
    
    [self drawCircle];
}



- (void)drawRouter {
    
    NSInteger segment = (_currentSegment - 1);
    
    CGFloat dashSetting[] = {10,5};
    
    UIBezierPath *line1Path = [UIBezierPath bezierPath];
    [line1Path moveToPoint:CGPointMake(_ROUTE_LINE_X_, _lineY)];
    [line1Path addLineToPoint:CGPointMake(_count10View.centerX, _lineY)];
    [line1Path setLineWidth:2];
    
    if (segment >= SEGMENT1) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line1Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    
    [line1Path stroke];
    
    
    
    UIBezierPath *line2Path = [UIBezierPath bezierPath];
    [line2Path moveToPoint:CGPointMake(_count10View.centerX, _lineY)];
    [line2Path addLineToPoint:CGPointMake(_count50View.centerX, _lineY)];
    [line2Path setLineWidth:2];
    if (segment >= SEGMENT2) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line2Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line2Path stroke];
    
    
    
    UIBezierPath *line3Path = [UIBezierPath bezierPath];
    [line3Path moveToPoint:CGPointMake(_count50View.centerX, _lineY)];
    [line3Path addLineToPoint:CGPointMake(_count100View.centerX, _lineY)];
    [line3Path setLineWidth:2];
    if (segment >= SEGMENT3) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line3Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line3Path stroke];
    
    
    UIBezierPath *line4Path = [UIBezierPath bezierPath];
    [line4Path moveToPoint:CGPointMake(_count100View.centerX, _lineY)];
    [line4Path addLineToPoint:CGPointMake(_arcX, _lineY)];
    [line4Path setLineWidth:2];
    if (segment >= SEGMENT4) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line4Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line4Path stroke];
    

    CGPoint centerPoint = CGPointMake(_arcX, _arcY);
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_radius startAngle:(1.5*M_PI) endAngle:0.5f*M_PI clockwise:YES];
    arcPath.lineWidth = 2;

    if (segment >= SEGMENT4) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [arcPath setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [arcPath stroke];
    
    
    //第二行线
    CGFloat nextLineY = _arcY + _radius;
    
    UIBezierPath *line5Path = [UIBezierPath bezierPath];
    [line5Path moveToPoint:CGPointMake(_arcX, nextLineY)];
    [line5Path addLineToPoint:CGPointMake(_count500View.centerX, nextLineY)];
    [line5Path setLineWidth:2];
    if (segment >= SEGMENT5) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line5Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line5Path stroke];
    
    
    
    UIBezierPath *line6Path = [UIBezierPath bezierPath];
    [line6Path moveToPoint:CGPointMake(_count500View.centerX, nextLineY)];
    [line6Path addLineToPoint:CGPointMake(_count1000View.centerX, nextLineY)];
    [line6Path setLineWidth:2];
    if (segment >= SEGMENT6) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line6Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line6Path stroke];
    
    

    UIBezierPath *line7Path = [UIBezierPath bezierPath];
    [line7Path moveToPoint:CGPointMake(_count1000View.centerX, nextLineY)];
    [line7Path addLineToPoint:CGPointMake(_ROUTE_LINE_X_, nextLineY)];
    [line7Path setLineWidth:2];
    if (segment >= SEGMENT7) {
        [GET_EARNINGS_COLOR setStroke];
    }
    else {
        [line7Path setLineDash:dashSetting count:2 phase:0];
        [UN_GET_EARNINGS_COLOR setStroke];
    }
    [line7Path stroke];
    
    
}



- (void)drawCircle {

    //第一条线上的圆点
    UIBezierPath *path = nil;
    CGRect frame = CGRectZero;
    CGFloat width = 8;
    
    CGFloat startX = 14;
    
    CGFloat xPos = startX - 4;
    CGFloat yPos = _lineY - 4;
    
    NSInteger segment = _currentSegment;
    
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT1) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT1) {
        xPos = startX - 5;
        yPos = _lineY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    

    
    xPos = _count10View.centerX - 4;
    yPos = _lineY - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT2) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT2) {
        xPos = _count10View.centerX - 5;
        yPos = _lineY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    
    
    xPos = _count50View.centerX - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT3) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT3) {
        xPos = _count50View.centerX - 5;
        yPos = _lineY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    xPos = _count100View.centerX - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT4) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    
    if (_currentSegment == SEGMENT4) {
        xPos = _count100View.centerX - 5;
        yPos = _lineY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    
    
    //第二条线上的圆点
    CGFloat nextY = _arcY + _radius;
    yPos = nextY - 4;
    
    xPos = _count200View.centerX - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT5) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT5) {
        xPos = _count200View.centerX - 5;
        yPos = nextY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    

    xPos = _count500View.centerX - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT6) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT6) {
        xPos = _count500View.centerX - 5;
        yPos = nextY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    
    xPos = _count1000View.centerX - 4;
    frame = CGRectMake(xPos, yPos, width, width);
    path= [UIBezierPath bezierPathWithOvalInRect:frame];
    if (segment >= SEGMENT7) {
        [GET_EARNINGS_COLOR set];
    }
    else {
        [UN_GET_EARNINGS_COLOR set];
    }
    [path fill];
    if (_currentSegment == SEGMENT7) {
        xPos = _count1000View.centerX - 5;
        yPos = nextY - 5;
        [self drawBigCircle:xPos y:yPos];
    }
    
    
    _circleHightLightColor = !_circleHightLightColor;
}



- (void)drawBigCircle:(CGFloat)xPos y:(CGFloat)yPos {
    
    if (_circleHightLightColor) {
        CGRect frame = CGRectMake(xPos, yPos, 10, 10);
        UIBezierPath* path= [UIBezierPath bezierPathWithOvalInRect:frame];
        [RGBA(0xff, 0xa0, 0x30, 0.3) setStroke];
        [path stroke];
    }

}




- (void)drawLineSegment:(CGFloat)yPosition {
    
    if (_lineX <= 0) {
        return;
    }
    
    
    CGFloat dashSetting[] = {10,5};

    UIBezierPath *segment4HightLinePath = [UIBezierPath bezierPath];
    [segment4HightLinePath moveToPoint:CGPointMake(_lineX, yPosition)];
    [segment4HightLinePath addLineToPoint:CGPointMake(_segmentLineX, yPosition)];
    [segment4HightLinePath setLineWidth:2];
    [segment4HightLinePath setLineDash:dashSetting count:2 phase:0];
    [GET_EARNINGS_COLOR setStroke];
    [segment4HightLinePath stroke];
    
}




- (void)drawSegment4 {
    
    if (_lineX <= 0) {
        return;
    }
    
    
    CGFloat dashSetting[] = {10,5};
    
    CGPoint centerPoint = CGPointMake(_arcX, _arcY);
    
    UIBezierPath *segment4HightLinePath = [UIBezierPath bezierPath];
    [segment4HightLinePath moveToPoint:CGPointMake(_lineX, _lineY)];
    [segment4HightLinePath addLineToPoint:CGPointMake(_segmentLineX, _lineY)];
    [segment4HightLinePath setLineWidth:2];
    [segment4HightLinePath setLineDash:dashSetting count:2 phase:0];
    [GET_EARNINGS_COLOR setStroke];
    [segment4HightLinePath stroke];
    
    
    
    UIBezierPath* hightlightPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_radius startAngle:(1.5*M_PI) endAngle:ANGLE_RATE[_angleIndex] * M_PI clockwise:YES];
    
    hightlightPath.lineWidth = 2;
    [hightlightPath setLineDash:dashSetting count:2 phase:0];
    [GET_EARNINGS_COLOR setStroke];
    [hightlightPath stroke];
    
    
}


#pragma mark 动画控制
- (void)animateSegment1 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) < ((NSInteger)_count10View.centerX)) {
        self.segmentLineX += 10;
        
        if (self.segmentLineX > _count10View.centerX) {
            self.segmentLineX = _count10View.centerX;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}


- (void)animateSegment2 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) < ((NSInteger)_count50View.centerX)) {
        self.segmentLineX += 10;
        
        if (self.segmentLineX > _count50View.centerX) {
            self.segmentLineX = _count50View.centerX;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}





- (void)animateSegment3 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) < ((NSInteger)_count100View.centerX)) {
        self.segmentLineX += 10;
        
        if (self.segmentLineX > _count100View.centerX) {
            self.segmentLineX = _count100View.centerX;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}



- (void)animateSegment4 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (self.drawState == SEGMENT4_LINE) {
        if (self.segmentLineX < self.arcX) {
            self.segmentLineX += 10;
        }
        else {
            self.segmentLineX = self.arcX;
            self.drawState = SEGMENT4_ARC;
        }
    }
    else {
        
        if (self.angleIndex > 9) {
            self.angleIndex = 0;
            self.segmentLineX = self.lineX;
            self.drawState = SEGMENT4_LINE;
        }
        else {
            self.angleIndex++;
        }
    }
    
    [self setNeedsDisplay];

}



- (void)animateSegment5 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) > ((NSInteger)_count500View.centerX)) {
        self.segmentLineX -= 10;
        
        if (self.segmentLineX < _count500View.centerX) {
            self.segmentLineX = _count200View.centerX;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}




- (void)animateSegment6 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) > ((NSInteger)_count1000View.centerX)) {
        self.segmentLineX -= 10;
        
        if (self.segmentLineX < _count1000View.centerX) {
            self.segmentLineX = _count500View.centerX;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}





- (void)animateSegment7 {
    
    if (_lineX <= 0) {
        return;
    }
    
    if (((NSInteger)self.segmentLineX) > _ROUTE_LINE_X_) {
        self.segmentLineX -= 10;
        
        if (self.segmentLineX < _ROUTE_LINE_X_) {
            //self.segment4LineX = _ROUTE_LINE_X_;
        }
    }
    else {
        self.segmentLineX = _lineX;
    }
    
    [self setNeedsDisplay];
}


#pragma mark 定时器

- (void)startTimer {
    
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.2 * NSEC_PER_SEC, 0);
    
    WeakSelf(that);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (that.currentSegment == SEGMENT1) {
            [that animateSegment1];
        }
        else if (that.currentSegment == SEGMENT2) {
            [that animateSegment2];
        }
        else if (that.currentSegment == SEGMENT3) {
            [that animateSegment3];
        }
        else if (that.currentSegment == SEGMENT4) {
            [that animateSegment4];
        }
        else if (that.currentSegment == SEGMENT5) {
            [that animateSegment5];
        }
        else if (that.currentSegment == SEGMENT6) {
            [that animateSegment6];
        }
        else if (that.currentSegment == SEGMENT7) {
            [that animateSegment7];
        }
    });
    
    dispatch_resume(_timer);
    
}




#pragma mark 更新数据
- (void)updateGoldCoin {
    
    
    
    
    
    
    
}






- (void)dealloc {
    
    dispatch_cancel(_timer);
    _timer = nil;
}



@end
