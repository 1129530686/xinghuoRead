//
//  JUDIAN_READ_BackgroundSettingItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_BackgroundSettingItem.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_BorderButton.h"
#import "JUDIAN_READ_TextStyleManager.h"

@interface JUDIAN_READ_BackgroundSettingItem ()
@property(nonatomic, strong)UILabel* titleLabel;
@end


@implementation JUDIAN_READ_BackgroundSettingItem

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        [self setTitleStyle];
    }
    
    return self;
}


- (void)addViews {
    
    WeakSelf(that);
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"背景";
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    //13
    CGFloat allButtonsWidth = SCREEN_WIDTH - KBackgroundButtionWidth - kLineSpaceButtonLeft - KBackgroundCircleRight;
    CGFloat space = (allButtonsWidth - 4 * KBackgroundCircleWidth) / 4;
    
    
    
    JUDIAN_READ_BorderButton* eyeButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    eyeButton.tag = kProtectionEyeTag;
    eyeButton.isClicked = TRUE;
    [eyeButton changeButtonStyle:FALSE];
    
    [eyeButton setTitle:@"护眼模式" forState:(UIControlStateNormal)];
    eyeButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:eyeButton];
    [eyeButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceButtonLeft);
        make.width.equalTo(@(KBackgroundButtionWidth));
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.top.equalTo(that.mas_top);
    }];
    
    

    NSInteger radius = KBackgroundCircleWidth / 2;
    
    JUDIAN_READ_BorderButton* circleGrayButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    circleGrayButton.tag = kLightGrayTag;
    circleGrayButton.isClicked = FALSE;
    [circleGrayButton changeButtonStyle:TRUE];
    
    circleGrayButton.layer.cornerRadius = radius;
    circleGrayButton.layer.masksToBounds = YES;
    circleGrayButton.layer.backgroundColor = READER_BG_LIGHT_GRAY_COLOR.CGColor;
    [self addSubview:circleGrayButton];
    [circleGrayButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* circlelightYellowButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    circlelightYellowButton.tag = kLightYellowTag;
    circlelightYellowButton.isClicked = FALSE;
    [circlelightYellowButton changeButtonStyle:TRUE];
    
    circlelightYellowButton.layer.cornerRadius = radius;
    circlelightYellowButton.layer.masksToBounds = YES;
    circlelightYellowButton.layer.backgroundColor = READER_BG_LIGHT_YELLOW_COLOR.CGColor;
    [self addSubview:circlelightYellowButton];
    [circlelightYellowButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* circlelightGreenButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    circlelightGreenButton.tag = kLightGreenTag;
    circlelightGreenButton.isClicked = FALSE;
    [circlelightGreenButton changeButtonStyle:TRUE];
    
    circlelightGreenButton.layer.cornerRadius = radius;
    circlelightGreenButton.layer.masksToBounds = YES;
    circlelightGreenButton.layer.backgroundColor = READER_BG_LIGHT_GREEN_COLOR.CGColor;
    [self addSubview:circlelightGreenButton];
    [circlelightGreenButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* circlelightBlackButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    circlelightBlackButton.tag = kLightBlackTag;
    circlelightBlackButton.isClicked = FALSE;
    [circlelightBlackButton changeButtonStyle:TRUE];
    
    circlelightBlackButton.layer.cornerRadius = radius;
    circlelightBlackButton.layer.masksToBounds = YES;
    circlelightBlackButton.layer.backgroundColor = READER_BG_LIGHT_BLACK_COLOR.CGColor;
    [self addSubview:circlelightBlackButton];
    [circlelightBlackButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [circleGrayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eyeButton.mas_right).offset(space);
        make.width.equalTo(@(KBackgroundCircleWidth));
        make.height.equalTo(@(KBackgroundCircleWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [circlelightYellowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleGrayButton.mas_right).offset(space);
        make.width.equalTo(@(KBackgroundCircleWidth));
        make.height.equalTo(@(KBackgroundCircleWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [circlelightGreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circlelightYellowButton.mas_right).offset(space);
        make.width.equalTo(@(KBackgroundCircleWidth));
        make.height.equalTo(@(KBackgroundCircleWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [circlelightBlackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circlelightGreenButton.mas_right).offset(space);
        make.width.equalTo(@(KBackgroundCircleWidth));
        make.height.equalTo(@(KBackgroundCircleWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    CGFloat width = [titleLabel getTextWidth:kTitleFontSize];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceTitleLeft);
        make.height.equalTo(@(kTitleFontSize));
        make.centerY.equalTo(circleGrayButton.mas_centerY);
        make.width.equalTo(@(width));
    }];
}




- (void)clearBgColorStyle {
    
    for (NSInteger index = kLightGrayTag; index <= kLightBlackTag; index++) {
        JUDIAN_READ_BorderButton* button = [self viewWithTag:index];
        button.isClicked = FALSE;
        [button changeButtonStyle:TRUE];
    }
    
}




- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*)model {
    
    if ([model getEyeMode]) {
        JUDIAN_READ_BorderButton* eyeButton = [self viewWithTag:kProtectionEyeTag];
        eyeButton.isClicked = TRUE;
        [eyeButton changeButtonStyle:FALSE];
    }
    else {
        JUDIAN_READ_BorderButton* eyeButton = [self viewWithTag:kProtectionEyeTag];
        eyeButton.isClicked = FALSE;
        [eyeButton changeButtonStyle:FALSE];
    }
    
    [self clearBgColorStyle];
    
    JUDIAN_READ_BorderButton* eyeButton = [self viewWithTag:[model getBgColorLevel]];
    eyeButton.isClicked = TRUE;
    [eyeButton changeButtonStyle:TRUE];
}



- (void)setButtonStyle {
    JUDIAN_READ_BorderButton* eyeButton = [self viewWithTag:kProtectionEyeTag];
    [eyeButton changeButtonStyle:FALSE];
}

- (void)setTitleStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0xbb, 0xbb, 0xbb);
    }
    else {
        _titleLabel.textColor = READER_TAB_BAR_TEXT_COLOR;
    }
}



- (void)handleTouchEvent:(JUDIAN_READ_BorderButton*)sender {

    if (sender.tag == kProtectionEyeTag) {
        sender.isClicked = !sender.isClicked;
        [sender changeButtonStyle:FALSE];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                             @"cmd":@(kBackgroudColorCmd),
                                                                                             @"value":@(sender.tag),
                                                                                             @"isClicked":@(sender.isClicked),
                                                                                             }];
        
        return;
    }
    

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kBackgroudColorCmd),
                                                                                         @"value":@(sender.tag)
                                                                                         }];
    
    [self clearBgColorStyle];
    
    sender.isClicked = TRUE;
    [sender changeButtonStyle:TRUE];
}


@end
