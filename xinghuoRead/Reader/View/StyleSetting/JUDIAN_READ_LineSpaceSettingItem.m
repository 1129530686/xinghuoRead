//
//  JUDIAN_READ_StyleSettingItem.m
//  xinghuoRead
//
//  Created by judian on 2019/4/26.
//  Copyright © 2019 judian. All rights reserved.
//

#import "JUDIAN_READ_LineSpaceSettingItem.h"
#import "UILabel+JUDIAN_READ_Label.h"
#import "JUDIAN_READ_BorderButton.h"
#import "JUDIAN_READ_TextStyleManager.h"


@interface JUDIAN_READ_LineSpaceSettingItem ()
@property(nonatomic, strong)UILabel* titleLabel;
@end




@implementation JUDIAN_READ_LineSpaceSettingItem


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
    titleLabel.text = @"间距";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    

    CGFloat allButtonsWidth = SCREEN_WIDTH - kLineSpaceTitleLeft - kLineSpaceButtonLeft;
    CGFloat space = 13;//(allButtonsWidth - 3 * KLineSpaceButtionWidth) / 2;
    
    CGFloat buttonWidth = (allButtonsWidth - 2 * space) / 3;
    
    
    JUDIAN_READ_BorderButton* smallLineSpaceButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    smallLineSpaceButton.tag = kLineSpaceSmallTag;
    smallLineSpaceButton.isClicked = TRUE;
    [smallLineSpaceButton changeButtonStyle:FALSE];
    [smallLineSpaceButton setTitle:@"小" forState:(UIControlStateNormal)];
    smallLineSpaceButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:smallLineSpaceButton];
    [smallLineSpaceButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    JUDIAN_READ_BorderButton* middleLineSpaceButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    middleLineSpaceButton.tag = kLineSpaceMiddleTag;
    middleLineSpaceButton.isClicked = FALSE;
    [middleLineSpaceButton changeButtonStyle:FALSE];
    [middleLineSpaceButton setTitle:@"正常" forState:(UIControlStateNormal)];
    middleLineSpaceButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:middleLineSpaceButton];
    [middleLineSpaceButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    JUDIAN_READ_BorderButton* bigLineSpaceButton = [JUDIAN_READ_BorderButton buttonWithType:(UIButtonTypeCustom)];
    bigLineSpaceButton.tag = kLineSpaceBigTag;
    bigLineSpaceButton.isClicked = FALSE;
    [bigLineSpaceButton changeButtonStyle:FALSE];
    [bigLineSpaceButton setTitle:@"大" forState:(UIControlStateNormal)];
    bigLineSpaceButton.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    [self addSubview:bigLineSpaceButton];
    [bigLineSpaceButton addTarget:self action:@selector(handleTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [smallLineSpaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceButtonLeft);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [middleLineSpaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(smallLineSpaceButton.mas_right).offset(space);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    
    [bigLineSpaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(that.mas_right).offset(-14);
        make.height.equalTo(@(KLineSpaceButtionHeight));
        make.width.equalTo(@(buttonWidth));
        make.top.equalTo(that.mas_top);
    }];
    
    CGFloat width = [titleLabel getTextWidth:kTitleFontSize];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(that.mas_left).offset(kLineSpaceTitleLeft);
        make.height.equalTo(@(kTitleFontSize));
        make.centerY.equalTo(smallLineSpaceButton.mas_centerY);
        make.width.equalTo(@(width));
    }];
}




- (void)clearButtonStyle {
    for (NSInteger index = kLineSpaceSmallTag; index <= kLineSpaceBigTag; index++) {
        JUDIAN_READ_BorderButton* button = [self viewWithTag:index];
        button.isClicked = FALSE;
        [button changeButtonStyle:FALSE];
    }
}




- (void)setButtonStyle:(JUDIAN_READ_TextStyleModel*)model {
    
    [self clearButtonStyle];
    
    JUDIAN_READ_BorderButton* sender = [self viewWithTag:[model getLineSpaceLevel]];
    sender.isClicked = TRUE;
    [sender changeButtonStyle:FALSE];
    
}


- (void)setButtonStyle {
    JUDIAN_READ_BorderButton* smallLineSpaceButton = [self viewWithTag:kLineSpaceSmallTag];
    [smallLineSpaceButton changeButtonStyle:FALSE];
    
    JUDIAN_READ_BorderButton* middleLineSpaceButton = [self viewWithTag:kLineSpaceMiddleTag];
    [middleLineSpaceButton changeButtonStyle:FALSE];
    
    JUDIAN_READ_BorderButton* bigLineSpaceButton = [self viewWithTag:kLineSpaceBigTag];
    [bigLineSpaceButton changeButtonStyle:FALSE];
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
                                                                                         @"cmd":@(kLineSpaceCmd),
                                                                                         @"value":@(sender.tag)
                                                                                         }];
}



@end
