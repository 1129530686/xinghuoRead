

#import "JUDIAN_READ_CircleProgress.h"
#import "NSTimer+Addition.h"

// 角度转换为弧度
#define CircleDegreeToRadian(d) ((d)*M_PI)/180.0
// 255进制颜色转换
#define CircleRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CircleColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]// rgb颜色转换（16进制->10进制）
// 宽高定义
#define CircleSelfWidth self.frame.size.width
#define CircleSelfHeight self.frame.size.height

@implementation JUDIAN_READ_CircleProgress
{
    CGFloat fakeProgress;
    NSTimer *timer;// 定时器用作动画
}
#pragma mark - 页面初始化
- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                pathBackColor:(UIColor *)pathBackColor
                pathFillColor:(UIColor *)pathFillColor
                   startAngle:(CGFloat)startAngle
                  strokeWidth:(CGFloat)strokeWidth {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        if (pathBackColor) {
            _pathBackColor = pathBackColor;
        }
        if (pathFillColor) {
            _pathFillColor = pathFillColor;
        }
        _startAngle = CircleDegreeToRadian(startAngle);
        _strokeWidth = strokeWidth;
    }
    return self;
}
// 初始化数据
- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    _pathBackColor = CircleRGB(204, 204, 204);
    _pathFillColor = CircleRGB(219, 184, 102);
    _strokeWidth = 10;//线宽默认为10
    _startAngle = -CircleDegreeToRadian(90);//圆起点位置
    _reduceValue = CircleDegreeToRadian(0);//整个圆缺少的角度
    _animationModel = CircleIncreaseByProgress;//根据进度来
    fakeProgress = 0.0;//用来逐渐增加直到等于progress的值
    _showPoint = YES;//小圆点
    _showProgressText = YES;//文字
}

#pragma mark - Setter
- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != CircleDegreeToRadian(startAngle)) {
        _startAngle = CircleDegreeToRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setReduceValue:(CGFloat)reduceValue {
    if (_reduceValue != CircleDegreeToRadian(reduceValue)) {
        if (reduceValue>=360) {
            return;
        }
        _reduceValue = CircleDegreeToRadian(reduceValue);
        [self setNeedsDisplay];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self setNeedsDisplay];
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor {
    if (_pathBackColor != pathBackColor) {
        _pathBackColor = pathBackColor;
        [self setNeedsDisplay];
    }
}

- (void)setPathFillColor:(UIColor *)pathFillColor {
    if (_pathFillColor != pathFillColor) {
        _pathFillColor = pathFillColor;
        [self setNeedsDisplay];
    }
}

- (void)setShowPoint:(BOOL)showPoint {
    if (_showPoint != showPoint) {
        _showPoint = showPoint;
        [self setNeedsDisplay];
    }
}

-(void)setShowProgressText:(BOOL)showProgressText {
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}

#pragma mark - 画背景线、填充线、小圆点、文字
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置中心点 半径 起点及终点
    CGFloat maxWidth = self.frame.size.width<self.frame.size.height?self.frame.size.width:self.frame.size.height;
    CGPoint center = CGPointMake(maxWidth/2.0, maxWidth/2.0);
    CGFloat radius = maxWidth/2.0-_strokeWidth/2.0 - 4;//留出一像素，防止与边界相切的地方被切平
    CGFloat endA = _startAngle + (CircleDegreeToRadian(360) - _reduceValue);//圆终点位置
    CGFloat valueEndA = _startAngle + (CircleDegreeToRadian(360)-_reduceValue)*fakeProgress;  //数值终点位置
    
    //背景线
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:endA clockwise:YES];
    //线条宽度
    CGContextSetLineWidth(ctx, _strokeWidth);
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_pathBackColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, basePath.CGPath);
    //渲染背景线
    CGContextStrokePath(ctx);
    

    //路径线
    UIBezierPath *valuePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:_startAngle endAngle:valueEndA clockwise:YES];
    valuePath.lineWidth = _strokeWidth+1;
    //设置线条顶端
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //线条颜色
    [_pathFillColor setStroke];
    //把路径添加到上下文
    CGContextAddPath(ctx, valuePath.CGPath);
    //渲染数值线
    CGContextStrokePath(ctx);
    
    //画小圆点
    //(CGRectGetWidth(self.bounds)-_strokeWidth)/2.f   (CGRectGetWidth(self.bounds)-_strokeWidth)/2.f
    if (_showPoint) {
        CGContextDrawImage(ctx, CGRectMake(CircleSelfWidth/2 + (radius)*cosf(valueEndA)-_strokeWidth*7/2.0, CircleSelfWidth/2 + (radius)*sinf(valueEndA)-_strokeWidth*7/2.0, _strokeWidth*7, _strokeWidth*7), [UIImage imageNamed:@"white_dot"].CGImage);
    }
    
    //画虚线圈
    if (_showDotLine) {
        [_pathBackColor setStroke];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius- 5 startAngle:_startAngle endAngle:endA  clockwise:YES];
        CGFloat lengths[2] = { 2, 5 };
        [path setLineDash:lengths count:2 phase:0];
        path.lineWidth = _strokeWidth;
        [path stroke];
        
    }
    
    
    UIFont *fonts = [UIFont systemFontOfSize:24.0 weight:UIFontWeightMedium];
    if (_sortLabStr.length ) {
        CGFloat yy = (CircleSelfHeight - 15)/-3.0;
        if ([_sortLabStr containsString:@"未上榜"]) {
            [self drawText:_sortLabStr font:kFontSize12 color:KSepColor offsetX:0 offsetY:yy];
        }else{
            CGSize size = [self drawText:_sortLabStr font:fonts color:kColorWhite offsetX:0 offsetY:yy];
            [self drawText:@"第" font:kFontSize12 color:KSepColor offsetX:-size.width offsetY:yy];
            [self drawText:@"名" font:kFontSize12 color:KSepColor offsetX:size.width offsetY:yy];
        }
    }
    
    if (_showProgressText) {
        //字体
        NSString *text = [NSString stringWithFormat:@" %.0f%% ",_progress*100];
        CGSize size = [self drawText:text font:fonts color:kColorWhite offsetX:0 offsetY:0];
        [self drawText:@"超越" font:kFontSize12 color:KSepColor offsetX:-size.width offsetY:0];
        [self drawText:@"读者" font:kFontSize12 color:KSepColor offsetX:size.width offsetY:0];
    }
}

- (CGSize)drawText:(NSString *)text font:(UIFont *)font color:(UIColor *)color offsetX:(CGFloat)offsetX offsetY:(CGFloat)offY{
    //画文字
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:kColorWhite, NSParagraphStyleAttributeName:textStyle};
    //获得size
    CGSize stringSize = [text sizeWithAttributes:attributes];
    //垂直居中
    CGFloat y = (CircleSelfHeight - stringSize.height)/2.0 + offY;
    if (_sortLabStr.length) {
        y = 2*(CircleSelfHeight - stringSize.height)/3.0 + offY;
    }
    CGFloat x = (CircleSelfWidth-stringSize.width)/2.0 + offsetX/2.0;
    if (offsetX < 0) {
        x = (CircleSelfWidth-stringSize.width)/2.0 + offsetX/2.0 - stringSize.width/2.0;
    }
    if (offsetX > 0) {
        x = (CircleSelfWidth-stringSize.width)/2.0 + offsetX/2.0 + stringSize.width/2.0;
    }
    
    CGRect r = CGRectMake(x, y,stringSize.width, stringSize.height);
    [text drawInRect:r withAttributes:attributes];
    return stringSize;
}




#pragma mark - 设置时间 + 进度
- (void)setSortLab:(NSString *)sortLab{
    _sortLabStr = sortLab;
    [self setNeedsDisplay];
}


// 设置时间
- (void)setAlltime:(CGFloat)alltime {
    _alltime = alltime;
    self.faketime = _alltime;
}

// 设置进度
- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    fakeProgress = 0.0;
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    //如果为0则直接刷新
    if (_progress == 0.0) {
        [self setNeedsDisplay];
        return;
    }
    
    __block NSInteger teninteger = 0; //每秒更新
    __weak typeof(self) weakSelf = self;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 block:^{
        
        if (fakeProgress >= _progress || fakeProgress >= 1.0f) {
            //最后一次赋准确值
            fakeProgress = _progress;
            [weakSelf setNeedsDisplay];
            
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            return;
        } else {
            //进度条动画
            [weakSelf setNeedsDisplay];
        }
        
        //数值增加
        if (_animationModel == CircleIncreaseSameTime) {
            fakeProgress += (0.1/10) * (_progress);//不同进度动画时间基本相同
            teninteger = teninteger + 1;
            if (teninteger % 10 == 0) {
                self.faketime--;
                if (self.faketime == 0) {
                    if (self.endTime) {
                        self.endTime();
                    }
                }
            }
        } else {
            fakeProgress += (0.1/10);//进度越大动画时间越长。
            teninteger = teninteger + 1;
            if (teninteger % 10 == 0) {
                self.faketime--;
            }
            if (self.faketime == 0) {
                if (self.endTime) {
                    self.endTime();
                }
            }
        }
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

@end
