//
//  JUDIAN_READ_FontSizeSettingItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_FontSizeSettingItem.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_TextStyleManager.h"
#import "JUDIAN_READ_BorderButton.h"


@interface JUDIAN_READ_FontSizeSettingItem ()
@property(nonatomic, strong)UILabel* titleLabel;
@end

@implementation JUDIAN_READ_FontSizeSettingItem


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
    titleLabel.text = @"字体";
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    
    CGFloat allButtonsWidth = SCREEN_WIDTH - kLineSpaceButtonLeft - kLineSpaceTitleLeft;
    //CGFloat space = (allButtonsWidth - 2 * KFontSizeButtionWidth);
    
    CGFloat buttonWidth = (allButtonsWidth - 13) / 2;
    
    
    UIButton* smallFontButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    smallFontButton.layer.cornerRadius = 3;
    smallFontButton.layer.masksToBounds = YES;
    smallFontButton.tag = kSmallFontSizeTag;

    
    [smallFontButton setTitle:@"A-" forState:(UIControlStateNormal)];
    smallFontButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:smallFontButton];
    [smallFontButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    

    UIButton* bigFontButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bigFontButton.tag = kBigFontSizeTag;
    bigFontButton.layer.cornerRadius = 3;
    bigFontButton.layer.masksToBounds = YES;
    
    [bigFontButton setTitle:@"A+" forState:(UIControlStateNormal)];
    bigFontButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:bigFontButton];
    [bigFontButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:(UIControlEventTouchUpInside)];

    
    [smallFontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceButtonLeft);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [bigFontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(smallFontButton.mas_right).offset(space);
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    CGFloat width = [titleLabel getTextWidth:kTitleFontSize];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceTitleLeft);
        make.height.equalTo(@(kTitleFontSize));
        make.centerY.equalTo(smallFontButton.mas_centerY);
        make.width.equalTo(@(width));
    }];
}




- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*) model {

    UIButton* smallButton = [self viewWithTag:kSmallFontSizeTag];
    smallButton.enabled = TRUE;

    UIButton* bigButton = [self viewWithTag:kBigFontSizeTag];
    bigButton.enabled = TRUE;
    
    bigButton.layer.borderWidth = 0;
    smallButton.layer.borderWidth = 0;
    
    BOOL nightMode =  [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        smallButton.backgroundColor = RGB(0xcc, 0xcc, 0xcc);
        bigButton.backgroundColor = RGB(0xcc, 0xcc, 0xcc);
        
        [bigButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
        [smallButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    }
    else {
        smallButton.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
        bigButton.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
        
        [bigButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
        [smallButton setTitleColor:RGB(0x33, 0x33, 0x33) forState:(UIControlStateNormal)];
    }
    
    
    if ([model isMaxFontSize]) {
        bigButton.enabled = FALSE;
        
        if (nightMode) {
            [bigButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:(UIControlStateNormal)];
        }
        else {
            [bigButton setTitleColor:RGB(0xcc, 0xcc, 0xcc) forState:(UIControlStateNormal)];
        }

    }
    
    
    if ([model isMinFontSize]) {
        smallButton.enabled = FALSE;
        
        if (nightMode) {
            [smallButton setTitleColor:RGB(0x99, 0x99, 0x99) forState:(UIControlStateNormal)];
        }
        else {
            [smallButton setTitleColor:RGB(0xcc, 0xcc, 0xcc) forState:(UIControlStateNormal)];
        }
    }
    
}

- (void)setDefaultStyle {
    [self setButtonStyle:nil];
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



- (void)handleTouchEvent:(UIButton*)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kFontSizeCmd),
                                                                                         @"value":@(sender.tag),
                                                                                         @"sender":sender
                                                                                        }];
}





@end


@interface JUDIAN_READ_TurnPageStyleSettingItem ()
@property(nonatomic, weak)UILabel* titleLabel;
@end


@implementation JUDIAN_READ_TurnPageStyleSettingItem


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
    titleLabel.text = @"翻页";
    titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    
    CGFloat allButtonsWidth = SCREEN_WIDTH - kLineSpaceButtonLeft - kLineSpaceTitleLeft;
    //CGFloat space = (allButtonsWidth - 2 * KFontSizeButtionWidth);
    CGFloat space = 13;
    CGFloat buttonWidth = (allButtonsWidth - 3 * space) / 4;
    
    
    JUDIAN_READ_BorderButton* pageCurlButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    pageCurlButton.tag = kStylePageCurlTag;
    pageCurlButton.isClicked = TRUE;
    [pageCurlButton changeButtonStyle:FALSE];
    [pageCurlButton setTitle:@"仿真" forState:(UIControlStateNormal)];
    pageCurlButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:pageCurlButton];
    [pageCurlButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    

    JUDIAN_READ_BorderButton* pageScrollButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    pageScrollButton.tag = kStylePageScrollTag;
    pageScrollButton.isClicked = FALSE;
    [pageScrollButton changeButtonStyle:FALSE];
    [pageScrollButton setTitle:@"平滑" forState:(UIControlStateNormal)];
    pageScrollButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:pageScrollButton];
    [pageScrollButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* pageVerticalButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    pageVerticalButton.tag = kStylePageVerticalTag;
    pageVerticalButton.isClicked = FALSE;
    [pageVerticalButton changeButtonStyle:FALSE];
    [pageVerticalButton setTitle:@"上下" forState:(UIControlStateNormal)];
    pageVerticalButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:pageVerticalButton];
    [pageVerticalButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* pageCoverButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    pageCoverButton.tag = kStylePageCoverTag;
    pageCoverButton.isClicked = FALSE;
    [pageCoverButton changeButtonStyle:FALSE];
    [pageCoverButton setTitle:@"覆盖" forState:(UIControlStateNormal)];
    pageCoverButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:pageCoverButton];
    [pageCoverButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pageCurlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceButtonLeft);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [pageScrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pageCurlButton.mas_right).offset(space);
        //make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [pageVerticalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pageScrollButton.mas_right).offset(space);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    
    [pageCoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pageVerticalButton.mas_right).offset(space);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    CGFloat width = [titleLabel getTextWidth:kTitleFontSize];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceTitleLeft);
        make.height.equalTo(@(kTitleFontSize));
        make.centerY.equalTo(pageCurlButton.mas_centerY);
        make.width.equalTo(@(width));
    }];
}


- (void)clearButtonStyle {
    for (NSInteger index = kStylePageCurlTag; index <= kStylePageCoverTag; index++) {
        JUDIAN_READ_BorderButton* button = [self viewWithTag:index];
        button.isClicked = FALSE;
        [button changeButtonStyle:FALSE];
    }
}




- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*)model {
    
    [self clearButtonStyle];
    
    JUDIAN_READ_BorderButton* sender = [self viewWithTag:[model getPageScrollLevel]];
    sender.isClicked = TRUE;
    [sender changeButtonStyle:FALSE];
    
}


- (void)setButtonStyle {
    
    JUDIAN_READ_BorderButton* pageCurlButton = [self viewWithTag:kStylePageCurlTag];
    [pageCurlButton changeButtonStyle:FALSE];
    
    JUDIAN_READ_BorderButton* pageScrollButton = [self viewWithTag:kStylePageScrollTag];
    [pageScrollButton changeButtonStyle:FALSE];
    
    JUDIAN_READ_BorderButton* pageVerticalButton = [self viewWithTag:kStylePageVerticalTag];
    [pageVerticalButton changeButtonStyle:FALSE];
    
    JUDIAN_READ_BorderButton* pageCoverButton = [self viewWithTag:kStylePageCoverTag];
    [pageCoverButton changeButtonStyle:FALSE];
}




- (void)setTitleStyle {
    
    BOOL nightMode = [[JUDIAN_READ_TextStyleManager shareInstance].textStyleModel isNightMode];
    if (nightMode) {
        _titleLabel.textColor = RGB(0x99, 0x99, 0x99);
    }
    else {
        _titleLabel.textColor = READER_TAB_BAR_TEXT_COLOR;
    }
}




- (void)handleTouchEvent:(JUDIAN_READ_BorderButton*)sender {
    
    [self clearButtonStyle];
    
    sender.isClicked = TRUE;
    [sender changeButtonStyle:FALSE];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonHandler" object: @{
                                                                                         @"cmd":@(kPageStyleCmd),
                                                                                         @"value":@(sender.tag)
                                                                                         }];
}
@end



