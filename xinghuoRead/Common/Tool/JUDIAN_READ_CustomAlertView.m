
//  Created by hu on 05/01/2018.
//  Copyright © 2018 epro. All rights reserved.
//

#import "JUDIAN_READ_CustomAlertView.h"

#define MCA_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MCA_ScreenHeight [UIScreen mainScreen].bounds.size.height

#define gMCColorWithHex(hexValue, alphaValue) ([UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f green:((hexValue >> 8) & 0x000000FF)/255.0f blue:((hexValue) & 0x000000FF)/255.0 alpha:alphaValue])


static const CGFloat margin = 50.0; //边距
static const CGFloat buttonHeight = 48.0; //按钮高度
static const CGFloat buttonTopLine = 0.0; //按钮高度


@interface JUDIAN_READ_CustomAlertView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong)  UILabel *messageLabel;
@property (nonatomic,strong)  UIView *bottomView;


@end

@implementation JUDIAN_READ_CustomAlertView

+ (instancetype)popAlertViewWithTitle:(NSString *)title
                              message:(NSString *)message
                      leftButtonTitle:(NSString *)leftButtonTitle
                     rightButtonTitle:(NSString *)rightButtonTitle {
    JUDIAN_READ_CustomAlertView *view = [[JUDIAN_READ_CustomAlertView alloc] initWithTitle:title
                                                   message:message
                                           leftButtonTitle:leftButtonTitle
                                          rightButtonTitle:rightButtonTitle];
    return view;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle
             rightButtonTitle:(NSString *)rightButtonTitle {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, MCA_ScreenWidth, MCA_ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [[self fetchWindow] addSubview:self];
        
        //有标题和没标题分两种布局
        CGFloat contentViewHeight = 0.0;
        UIColor *titleColor = nil;
        UIColor *messageColor = nil;
        UIFont *titleFont = nil;
        UIFont *messageFont = nil;
        if ([self isExistString:title]) {
            contentViewHeight = 180.0;
            titleColor = kColor51;
            titleFont = [UIFont systemFontOfSize:16.0];
            messageFont = kFontSize14;
            messageColor = kColor100;
        }else {
            contentViewHeight = 140.0;
            messageColor = kColor51;
            messageFont = kFontSize16;
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(margin, (MCA_ScreenHeight - contentViewHeight) / 2, CGRectGetWidth(self.frame) - margin * 2, contentViewHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5.0;
        [self addSubview:contentView];
        self.contentView = contentView;
        
        CGFloat messageLabelY = 30.0;
        
        if ([self isExistString:title]) {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20.0, CGRectGetWidth(contentView.frame) - 2*20, titleFont.lineHeight*2)];
            self.titleLabel = titleLabel;
            titleLabel.font = titleFont;
            titleLabel.textColor = titleColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = title;
            titleLabel.numberOfLines = 2;
            [contentView addSubview:titleLabel];
            
            messageLabelY = CGRectGetMaxY(titleLabel.frame) + 12.0;
        }
        
       
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, messageLabelY, CGRectGetWidth(contentView.frame) - 2 * 20.0, messageFont.lineHeight * 2)];
        self.messageLabel = messageLabel;
        messageLabel.font = messageFont;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.numberOfLines = 3;
        messageLabel.textColor = messageColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        [contentView addSubview:messageLabel];
        messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        UIView *buttonsView = [self createButtonViewWithLeftTitle:leftButtonTitle rightTitle:rightButtonTitle];
        self.bottomView = buttonsView;
        if (buttonsView) {
            [contentView addSubview:buttonsView];
        }
    }
    return self;
}

#pragma mark - UI
/**
 *  1.存在两个button, 两个buton的宽度均分contentView的宽度。
 *  2.只存在一个button, 则占整个contentView的宽度。
 *  3.按钮标题颜色默认为主题蓝
 */
- (UIView *)createButtonViewWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    if (![self isExistString:leftTitle] && ![self isExistString:rightTitle]) {
        return nil;
    }
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(_contentView.frame) - buttonHeight+buttonTopLine, CGRectGetWidth(_contentView.frame), buttonHeight)];
    self.bottomView = buttonsView;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_contentView.frame), 0.5)];
    topLine.backgroundColor = gMCColorWithHex(0xEEEEEE, 1.0);
    [buttonsView addSubview:topLine];
    
    if ([self isExistString:leftTitle] && [self isExistString:rightTitle]) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(buttonsView.frame) / 2, buttonHeight);
        [leftButton setTitleColor:kColor153 forState:UIControlStateNormal];
        leftButton.titleLabel.font = kFontSize16;
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:leftButton];
        self.leftButton = leftButton;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame), 0.0, CGRectGetWidth(buttonsView.frame) / 2, buttonHeight);
        [rightButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        rightButton.titleLabel.font = kFontSize16;
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:rightButton];
        self.rightButton = rightButton;
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(buttonsView.frame) / 2, 0.0, 0.5, buttonHeight)];
        middleLine.backgroundColor = gMCColorWithHex(0xEEEEEE, 1.0);
        [buttonsView addSubview:middleLine];
    }else {
        NSString *buttonTitle = [self isExistString:leftTitle] ? leftTitle : rightTitle;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(buttonsView.frame), buttonHeight);
        [leftButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        leftButton.titleLabel.font = kFontSize16;
        [leftButton setTitle:buttonTitle forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(singleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:leftButton];
        self.leftButton = leftButton;
    }
    
    return buttonsView;
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - Event Handler
- (void)leftButtonAction:(id)sender {
    [self invokeDelegateWithIndex:0];
    [self dismiss];
}

- (void)rightButtonAction:(id)sender {
    [self invokeDelegateWithIndex:1];
    [self dismiss];
}

- (void)singleButtonAction:(id)sender {
    [self invokeDelegateWithIndex:0];
    [self dismiss];
}

- (void)invokeDelegateWithIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didClickAtIndex:)]) {
        [_delegate alertView:self didClickAtIndex:index];
    }
    if (_strongDelegate && [_strongDelegate respondsToSelector:@selector(alertView:didClickAtIndex:)]) {
        [_strongDelegate alertView:self didClickAtIndex:index];
        _strongDelegate = nil;
    }
}

- (void)setLeftButtonTitleColor:(UIColor *)leftButtonTitleColor {
    _leftButtonTitleColor = leftButtonTitleColor;
    
    if (self.leftButton) {
        [self.leftButton setTitleColor:leftButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor {
    _rightButtonTitleColor = rightButtonTitleColor;
    
    if (self.rightButton) {
        [self.rightButton setTitleColor:rightButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setContentHeight:(CGFloat)contentHeight{
    _contentHeight = contentHeight;
    CGRect frame = self.contentView.frame;
    frame.size.height = contentHeight;
    self.contentView.frame = frame;
    self.bottomView.frame = CGRectMake(0.0, CGRectGetHeight(_contentView.frame) - buttonHeight+buttonTopLine, CGRectGetWidth(_contentView.frame), buttonHeight);
}


#pragma mark - Private
- (UIView *)fetchWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

- (BOOL)isExistString:(NSString *)string {
    return string && string.length > 0;
}

- (void)setTitlefontSize:(UIFont *)titlefontSize{
    _titlefontSize = titlefontSize;
    if (self.titleLabel) {
        self.titleLabel.font = titlefontSize;
    }
}

- (void)setMessageFontSize:(CGFloat)messageFontSize{
    _messageFontSize = messageFontSize;
    if (self.messageLabel) {
        self.messageLabel.font = [UIFont systemFontOfSize:messageFontSize];
    }
}

- (void)setMessageHeight:(CGFloat)messageHeight{
    _messageHeight = messageHeight;
    if (self.messageLabel) {
        self.messageLabel.numberOfLines = 0;
        CGRect frame = self.messageLabel.frame;
        frame.size.height = messageHeight;
        self.messageLabel.frame =  frame;
        frame = self.bottomView.frame;
        frame.origin.y = (CGRectGetMaxY(self.messageLabel.frame) +20);
        self.bottomView.frame = frame;
        frame = self.contentView.frame;
        frame.size.height = CGRectGetMaxY(self.bottomView.frame);
        self.contentView.frame = frame;
    }
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (self.titleLabel) {
        self.titleLabel.textColor = titleColor;
    }
}

- (void)setMessageColor:(UIColor *)messageColor{
    _messageColor = messageColor;
    if (self.messageLabel) {
        self.messageLabel.textColor = messageColor;
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    if (_messageLabel) {
        _messageLabel.textAlignment = textAlignment;
    }
}


- (void)setLineHeight:(CGFloat)lineHeight{
    _lineHeight = lineHeight;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:self.messageLabel.text attributes:dic];
    self.messageLabel.attributedText = attributeStr;
    paraStyle.lineSpacing = lineHeight;
    self.messageLabel.attributedText = attributeStr;
    [self.messageLabel sizeToFit];
    
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    CGRect frame = self.contentView.frame;
//    frame.size.height = self.contentHeight;
//    self.contentView.frame = frame;
//}


@end
