//
//  JUDIAN_READ_ContentView.m
//  xinghuoRead
//
//  Created by judian on 2019/4/12.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_ContentView.h"
#import "JUDIAN_READ_NovelManager.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_UserAppreciatedChapterModel.h"
#import "JUDIAN_READ_CoreTextManager.h"

@interface JUDIAN_READ_ContentView ()
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, weak)JUDIAN_READ_ChapterContentModel* model;
@end


@implementation JUDIAN_READ_ContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWith:(NSInteger)index model:(JUDIAN_READ_ChapterContentModel*)model {
    self = [super init];
    if(self != nil) {
        _pageIndex = index;
        _model = model;
    }
    
    return self;
}



- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CTFrameRef frameRef = [[JUDIAN_READ_NovelManager shareInstance] getFrameRef:_pageIndex model:_model];
    if (frameRef) {
        CTFrameDraw(frameRef, ctx);
        CFRelease(frameRef);
    }
}



- (void)dealloc {
    //NSLog(@"dealloc===%@===", NSStringFromClass([self class]));
    
}

@end


#pragma mark 赞赏界面
#define START_TAG  1330

@interface JUDIAN_READ_PlainAppreciateView ()
@property(nonatomic, weak)UILabel* appreciateLabel;
@property(nonatomic, weak)UILabel* countLabel;
@property(nonatomic, weak)UIButton* touchControl;
@end


@implementation JUDIAN_READ_PlainAppreciateView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addAppreciateView];
    }
    
    return self;
}


- (void)addAppreciateView {
    
    UIButton* appreciateButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    appreciateButton.tag = kAppreciateMoneyCmd;
    appreciateButton.layer.cornerRadius = 13;
    appreciateButton.layer.masksToBounds = YES;
    
    [appreciateButton setTitle:@"赞赏" forState:(UIControlStateNormal)];
    [appreciateButton setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
    [appreciateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appreciateButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [appreciateButton setBackgroundImage:[UIImage imageNamed:@"reader_appreciate_bg_tip"] forState:UIControlStateNormal];
    [appreciateButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:appreciateButton];
    
    
    UILabel* appreciateLabel = [[UILabel alloc]init];
    _appreciateLabel = appreciateLabel;
    appreciateLabel.textColor = RGB(0x66, 0x66, 0x66);
    appreciateLabel.font = [UIFont systemFontOfSize:12];
    appreciateLabel.text = APP_USER_APPRECIATE_TIP;
    appreciateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:appreciateLabel];
    
    
    WeakSelf(that);
    [appreciateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110));
        make.height.equalTo(@(52));
        make.top.equalTo(that.mas_top).offset(20);
        make.centerX.equalTo(that.mas_centerX);
    }];
    
    
    [appreciateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.top.equalTo(appreciateButton.mas_bottom).offset(5);
        make.height.equalTo(@(12));
    }];
    
}



- (void)addAvatarView:(NSInteger)count {
    
    NSInteger startTag = START_TAG;
    for (NSInteger index = 0; index < 8; index++) {
       UIImageView* avatarImageView = [self viewWithTag:startTag + index];
        if(!avatarImageView) {
            break;
        }
        [avatarImageView removeFromSuperview];
    }
    
    
    WeakSelf(that);
    UIView* view = nil;
    
    for (NSInteger index = 0; index < count; index++) {
        UIImageView* avatarImageView = [[UIImageView alloc]init];
        avatarImageView.image = [UIImage imageNamed:@"head_small"];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        avatarImageView.clipsToBounds = YES;
        avatarImageView.layer.cornerRadius = 13;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        avatarImageView.layer.borderWidth = 0.5;
        avatarImageView.tag = startTag + index;
        [self addSubview:avatarImageView];
        
        avatarImageView.hidden = YES;
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(26));
            make.height.equalTo(@(26));
            
            
            if (index == 0) {
                make.left.equalTo(that.mas_left).offset(0);
            }
            else {
                make.left.equalTo(view.mas_right).offset(-5);
            }
            
            make.top.equalTo(that.appreciateLabel.mas_bottom).offset(20);
        }];
        
        view = avatarImageView;
        
    }
    

    [_touchControl removeFromSuperview];
    
    UIButton* touchControl = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _touchControl = touchControl;
    touchControl.tag = kAppreciateChapterListCmd;
    [touchControl addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:touchControl];
    
    [touchControl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(that.mas_left);
        make.right.equalTo(that.mas_right);
        make.height.equalTo(@(26));
        make.top.equalTo(that.appreciateLabel.mas_bottom).offset(20);
    }];
    
    
}



- (void)addCountView:(NSInteger)count {

    [_countLabel removeFromSuperview];
    
    UILabel* countLabel = [[UILabel alloc]init];
    countLabel.hidden = YES;
    _countLabel = countLabel;
    countLabel.textColor = RGB(0x66, 0x66, 0x66);
    countLabel.font = [UIFont systemFontOfSize:13];
    countLabel.text = @"";
    countLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:countLabel];
    
    UIView* rightView = [self viewWithTag:START_TAG + count - 1];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView.mas_right).offset(8);
        make.height.equalTo(@(13));
        make.centerY.equalTo(rightView.mas_centerY);
        make.width.equalTo(@(0));
    }];
    
}



- (void)handleTouchEvent:(UIControl*)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object:@{@"cmd":@(sender.tag)}];
}



- (void)setViewStyle {
    
    JUDIAN_READ_TextStyleModel* style = [JUDIAN_READ_TextStyleManager shareInstance].textStyleModel;
    self.backgroundColor = [style getBgColor];
    
    _appreciateLabel.textColor = RGB(0x66, 0x66, 0x66);
    if ([style isNightMode]) {
        _appreciateLabel.textColor = RGB(0x88, 0x88, 0x88);
    }
    
}



- (void)updateAvatarList:(NSArray*)array total:(NSString*)total {

    if (array.count <= 0) {
        return;
    }
    
    NSInteger count = array.count;
    NSInteger maxCount = 8;
    if (count > maxCount) {
        count = maxCount;
    }
    
    [self addAvatarView:count];
    [self addCountView:count];
    
    UIImage* image = [UIImage imageNamed:@"head_small"];
    for (NSInteger index = 0; index < count; index++) {
        JUDIAN_READ_UserAppreciatedChapterModel* model = array[index];
        UIImageView* avatarImageView = [self viewWithTag:(START_TAG + index)];
        avatarImageView.hidden = NO;
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:image];
    }
    
    if (total.integerValue > maxCount) {
        _countLabel.text = [NSString stringWithFormat:APP_APPRECIATE_MORE_COUNT_TIP, total];
    }
    else {
        _countLabel.text = [NSString stringWithFormat:APP_APPRECIATE_COUNT_TIP, total];
    }
    
    _countLabel.hidden = NO;
    
    NSInteger textWidth = [_countLabel getTextWidth:13];
    textWidth = ceil(textWidth);
    
    NSInteger totalWidth = (count * 26 - (count - 1) * 5) + textWidth + 8;
    
    CGRect contentViewFrame = [[JUDIAN_READ_CoreTextManager shareInstance] getContentViewFrame];
    CGFloat xOffset = (contentViewFrame.size.width - totalWidth) / 2;

    
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(textWidth));
    }];
    
    
    UIImageView* avatarImageView = [self viewWithTag:(START_TAG)];
    WeakSelf(that);
    [avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(xOffset);
    }];
    
}

@end


@interface JUDIAN_READ_SystemTimeView ()
@property(nonatomic, weak)UILabel* electricityLabel;
@property(nonatomic, weak)UILabel* timeLabel;
@property(nonatomic, weak)UILabel* progressLabel;
@property(nonatomic, copy)NSString* pageInfoString;
@end


@implementation JUDIAN_READ_SystemTimeView

- (instancetype)initWithPageInfo:(NSString*)pageInfo {
    self = [super init];
    if (self) {
        _pageInfoString = pageInfo;
        [self addViews];
    }
    
    return self;
}



- (void)addViews {
    
    UIColor* textColor = RGB(0xcc, 0xcc, 0xcc);
    UIColor* borderColor = RGB(0xcc, 0xcc, 0xcc);
    
    self.backgroundColor = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColor];
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        borderColor = RGB(0x33, 0x33, 0x33);
        textColor = RGB(0x66, 0x66, 0x66);
    }
    else {
        
        if (kLightYellowTag == [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColorLevel]) {
            borderColor = RGB(0xd2, 0xc8, 0xae);
            textColor = borderColor;
            //##DCD3BC
        }
        else if (kLightGreenTag == [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColorLevel]) {
            borderColor = RGB(0xBA, 0xD9, 0xB5);
            textColor = borderColor;
            //#BAD9B5
        }
        
    }

    NSInteger level = [JUDIAN_READ_DeviceUtils getBatteryLevel];
    NSString* levelString = [NSString stringWithFormat:@"%ld", level];
    
    JUDIAN_READ_DeviceElectricityView* electricityLabel = [[JUDIAN_READ_DeviceElectricityView alloc] initWithLevel:level];
    electricityLabel.layer.cornerRadius = 5;
    electricityLabel.layer.borderWidth = 0.5;
    electricityLabel.layer.borderColor = borderColor.CGColor;
    _electricityLabel = electricityLabel;
    
    electricityLabel.textColor = textColor;
    electricityLabel.font = [UIFont systemFontOfSize:9];
    electricityLabel.text = levelString;
    electricityLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:electricityLabel];
    
    NSString* dateString = [JUDIAN_READ_TestHelper getCurrentDate];
    NSInteger position = 11;
    if ((dateString.length - position) >= 0) {
        dateString = [dateString substringWithRange:NSMakeRange(position, 5)];
    }
    else {
        dateString = @"";
    }
    
    UILabel* timeLabel = [[UILabel alloc] init];
    _timeLabel = electricityLabel;
    timeLabel.textColor = textColor;
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.text = dateString;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    
    
    UILabel* progressLabel = [[UILabel alloc] init];
    _progressLabel = electricityLabel;
    progressLabel.textColor = textColor;
    progressLabel.font = [UIFont systemFontOfSize:10];
    progressLabel.text = _pageInfoString;
    progressLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:progressLabel];
    
    
    WeakSelf(that);
    [electricityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(14);
        make.bottom.equalTo(that.mas_bottom);
        make.height.equalTo(@(11));
        make.width.equalTo(@(30));
    }];
    
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(electricityLabel.mas_right).offset(7);
        make.bottom.equalTo(that.mas_bottom);
        make.height.equalTo(@(11));
        make.width.equalTo(@(100));
    }];
    
    
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.bottom.equalTo(that.mas_bottom);
        make.height.equalTo(@(11));
        make.width.equalTo(@(200));
    }];
    
}
    
    

@end



@interface JUDIAN_READ_DeviceElectricityView ()
@property(nonatomic, assign)NSInteger batteryLevel;
@end



@implementation JUDIAN_READ_DeviceElectricityView

- (instancetype)initWithLevel:(NSInteger)level {
    self = [super init];
    if (self) {
        _batteryLevel = level;
    }
    return self;
}




- (void)drawRect:(CGRect)rect {
   
#if 0
    UIColor * borderColor = RGB(0xcc, 0xcc, 0xcc);
    [borderColor set];
    UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5];
    borderPath.lineWidth = 0.5;
   // borderPath.lineCapStyle = kCGLineCapRound;
    //borderPath.lineJoinStyle = kCGLineJoinRound;
    [borderPath stroke];
#endif

    CGFloat width = rect.size.width - 3;
    width = width * _batteryLevel / 100;
    
    CGRect fillRect = CGRectMake(rect.origin.x + 1.5, rect.origin.y + 1.5, width, rect.size.height - 3);
    UIColor * fillColor = RGB(0xee, 0xee, 0xee);
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        fillColor = RGB(0x33, 0x33, 0x33);;
    }
    else {
        
        if (kLightYellowTag == [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColorLevel]) {
            fillColor = RGB(0xdc, 0xd3, 0xbc);
            //##DCD3BC
        }
        else if (kLightGreenTag == [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel getBgColorLevel]) {
            fillColor = RGB(0xc7, 0xe4, 0xc3);
            //#BAD9B5
        }
    }
    
    [fillColor set];
    
    //UIBezierPath* fillPath = [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:4];
    NSInteger rectCorner = 0;
    if (_batteryLevel >= 100) {
        rectCorner = UIRectCornerAllCorners;
    }
    else {
        rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    }
    
    UIBezierPath* fillPath = [UIBezierPath bezierPathWithRoundedRect:fillRect byRoundingCorners:(rectCorner) cornerRadii:CGSizeMake(4, 4)];
    
    //fillPath.lineWidth = 0.5;
    //fillPath.lineCapStyle = kCGLineCapRound;
    //fillPath.lineJoinStyle = kCGLineJoinRound;
    [fillPath fill];
    
     [super drawRect:rect];

}



@end
